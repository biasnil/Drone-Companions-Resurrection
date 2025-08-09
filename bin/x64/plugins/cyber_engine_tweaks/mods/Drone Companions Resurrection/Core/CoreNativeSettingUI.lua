-- Core/CoreNativeSettingUI.lua
-- Native Settings UI only. All config + localization come from CoreDCO.

local CoreDCO = require("Core/CoreDCO")
local L       = function(k, vars) return CoreDCO:L(k, vars) end

local CoreNativeSettingUI = {}

-- ---------- helpers (UI-only) ----------
local function addSwitch(NS, path, key, label, desc)
  local def = CoreDCO.DEFAULTS[key]
  NS.addSwitch(path, label, desc or "", CoreDCO:get(key, def), function(state)
    CoreDCO:set(key, state, true)
  end)
end

local function addRangeFloat(NS, path, key, label, desc, min, max, step)
  local def = CoreDCO.DEFAULTS[key]
  NS.addRangeFloat(path, label, desc or "", min, max, step, CoreDCO:get(key, def), function(val)
    CoreDCO:set(key, val, true)
  end)
end

local function addRangeInt(NS, path, key, label, desc, min, max, step)
  local def = CoreDCO.DEFAULTS[key]
  NS.addRangeInt(path, label, desc or "", min, max, step, CoreDCO:get(key, def), function(val)
    CoreDCO:set(key, val, true)
  end)
end

local function addSelectorString(NS, path, key, label, desc, options)
  if not options or #options == 0 then return end
  local cur = CoreDCO:get(key, CoreDCO.DEFAULTS[key])
  local idx = 1
  for i, opt in ipairs(options) do if opt == cur then idx = i break end end
  -- Native Settings signature: (path, label, desc, valuesArray, currentIndex, step, callback)
  NS.addSelectorString(path, label, desc or "", options, idx, 1, function(newIdx)
    CoreDCO:set(key, options[newIdx], true)
  end)
end

-- ---------- build UI ----------
function CoreNativeSettingUI.build()
  -- Resolve NS now (module may be required before CET injects globals)
  local NS = (GetMod and (GetMod("nativeSettings") or GetMod("NativeSettings"))) or nil
  if not NS then
    print("[DCO] Native Settings not found; UI disabled.")
    return
  end

  -- Pull localized option arrays from CoreDCO's current language table
  local strings   = CoreDCO:getStrings()
  local nsStrings = (strings and strings.ns) or {}
  local opts      = nsStrings.options or {}
  local langNames = opts.languages or { "English","中文","Polski","Türkçe","Русский","Français","Bahasa Melayu" }

  local TAB = "/DCO"
  NS.addTab(TAB, L("ns.tab_name"))

  local PATH_LANG   = TAB .. "/Language";    NS.addSubcategory(PATH_LANG,   L("ns.subtabs.language"))
  local PATH_STATS  = TAB .. "/Stats";       NS.addSubcategory(PATH_STATS,  L("ns.subtabs.stats"))
  local PATH_PRICE  = TAB .. "/Pricing";     NS.addSubcategory(PATH_PRICE,  L("ns.subtabs.pricing"))
  local PATH_MISC   = TAB .. "/Misc";        NS.addSubcategory(PATH_MISC,   L("ns.subtabs.misc"))
  local PATH_APP    = TAB .. "/Appearances"; NS.addSubcategory(PATH_APP,    L("ns.subtabs.appearances"))

  -- Language: numeric slider (1..N). Uses CoreDCO:langIndex()/setLang(index)
  do
    local curIdx = (CoreDCO.langIndex and CoreDCO:langIndex()) or 1
    NS.addRangeInt(
      PATH_LANG,
      L("ns.labels.language"),
      L("ns.desc.language"),
      1, #langNames, 1,
      curIdx,
      function(newIdx)
        if CoreDCO.setLang then
          CoreDCO:setLang(newIdx)
        else
          CoreDCO:set("LanguageIndex", newIdx, true)
        end
        if NS.notify then
          NS.notify(L("ns.desc.language_applied", { name = langNames[newIdx] or tostring(newIdx) }))
        end
      end
    )
  end

  -- Stats: HP/DPS multipliers
  addRangeFloat(NS, PATH_STATS, "FlyingHP",   L("ns.labels.flying_hp"),   L("ns.desc.hp_mult"),  0.10, 5.00, 0.05)
  addRangeFloat(NS, PATH_STATS, "AndroidHP",  L("ns.labels.android_hp"),  L("ns.desc.hp_mult"),  0.10, 5.00, 0.05)
  addRangeFloat(NS, PATH_STATS, "MechHP",     L("ns.labels.mech_hp"),     L("ns.desc.hp_mult"),  0.10, 10.0, 0.10)

  addRangeFloat(NS, PATH_STATS, "FlyingDPS",  L("ns.labels.flying_dps"),  L("ns.desc.dps_mult"), 0.10, 5.00, 0.05)
  addRangeFloat(NS, PATH_STATS, "AndroidDPS", L("ns.labels.android_dps"), L("ns.desc.dps_mult"), 0.10, 5.00, 0.05)
  addRangeFloat(NS, PATH_STATS, "MechDPS",    L("ns.labels.mech_dps"),    L("ns.desc.dps_mult"), 0.10, 10.0, 0.10)

  -- Pricing / SystemEx slot
  addRangeInt(NS, PATH_PRICE, "Drone_Core_Price", L("ns.labels.drone_core_price"), L("ns.desc.price_desc"), 1, 100, 1)
  addRangeInt(NS, PATH_PRICE, "SystemExSlot",     L("ns.labels.system_ex_slot"),   L("ns.desc.system_ex_slot"), 0, 4, 1)

  -- Misc toggles
  addSwitch(NS, PATH_MISC, "Disable_Android_Voices", L("ns.labels.disable_android_voices"), L("ns.desc.disable_android_voices"))
  addSwitch(NS, PATH_MISC, "Permanent_Mechs",        L("ns.labels.permanent_mechs"),        L("ns.desc.permanent_mechs"))

  -- Appearances (selectors)
  addSelectorString(NS, PATH_APP, "MeleeAndroidAppearance",      L("ns.labels.melee_android"),    L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(NS, PATH_APP, "RangedAndroidAppearance",     L("ns.labels.ranged_android"),   L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(NS, PATH_APP, "ShotgunnerAndroidAppearance", L("ns.labels.shotgunner"),       L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(NS, PATH_APP, "NetrunnerAndroidAppearance",  L("ns.labels.netrunner"),        L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(NS, PATH_APP, "TechieAndroidAppearance",     L("ns.labels.techie"),           L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(NS, PATH_APP, "SniperAndroidAppearance",     L("ns.labels.sniper"),           L("ns.desc.select_appearance"), opts.android_app_list or {})

  addSelectorString(NS, PATH_APP, "BombusAppearance",            L("ns.labels.bombus"),           L("ns.desc.select_appearance"), opts.bombus_app_list or {})

  print("[DCO] Native Settings UI built.")
end

return CoreNativeSettingUI
