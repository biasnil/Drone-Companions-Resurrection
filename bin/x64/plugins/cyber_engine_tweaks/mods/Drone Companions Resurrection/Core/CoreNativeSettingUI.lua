-- Core/CoreNativeSettingUI.lua
-- Native Settings UI only. All config + localization come from CoreDCO.

local CoreDCO = require("Core/CoreDCO")
local L       = function(k, vars) return CoreDCO:L(k, vars) end

-- Try both ids for the Native Settings mod
local NS = (GetMod and (GetMod("nativeSettings") or GetMod("NativeSettings"))) or nil

local CoreNativeSettingUI = {}

-- ------------------ helpers (UI-only) ------------------

local function addSwitch(path, key, label, desc)
  if not NS then return end
  local def = CoreDCO.DEFAULTS[key]
  NS.addSwitch(path, label, desc or "", CoreDCO:get(key, def), function(state)
    CoreDCO:set(key, state, true)
  end)
end

local function addRangeFloat(path, key, label, desc, min, max, step)
  if not NS then return end
  local def = CoreDCO.DEFAULTS[key]
  NS.addRangeFloat(path, label, desc or "", min, max, step, CoreDCO:get(key, def), function(val)
    CoreDCO:set(key, val, true)
  end)
end

local function addRangeInt(path, key, label, desc, min, max, step)
  if not NS then return end
  local def = CoreDCO.DEFAULTS[key]
  NS.addRangeInt(path, label, desc or "", min, max, step, CoreDCO:get(key, def), function(val)
    CoreDCO:set(key, val, true)
  end)
end

local function addSelectorString(path, key, label, desc, options)
  if not NS or not options or #options == 0 then return end
  local cur = CoreDCO:get(key, CoreDCO.DEFAULTS[key])
  local idx = 1
  for i, opt in ipairs(options) do if opt == cur then idx = i break end end
  NS.addSelectorString(path, label, desc or "", idx, options, function(newIdx)
    CoreDCO:set(key, options[newIdx], true)
  end)
end

-- ------------------ build UI ------------------

function CoreNativeSettingUI.build()
  if not NS then
    print("[DCO] Native Settings not found; UI disabled.")
    return
  end

  -- Pull localized option arrays from CoreDCO's current language table
  local strings = CoreDCO:getStrings()
  local nsStrings = (strings and strings.ns) or {}
  local opts = nsStrings.options or {}

  -- Keep the path stable; labels are localized
  local TAB = "/DCO"
  NS.addTab(TAB, L("ns.tab_name"))

  local PATH_STATS  = TAB .. "/Stats";       NS.addSubcategory(PATH_STATS,  L("ns.subtabs.stats"))
  local PATH_PRICE  = TAB .. "/Pricing";     NS.addSubcategory(PATH_PRICE,  L("ns.subtabs.pricing"))
  local PATH_MISC   = TAB .. "/Misc";        NS.addSubcategory(PATH_MISC,   L("ns.subtabs.misc"))
  local PATH_APP    = TAB .. "/Appearances"; NS.addSubcategory(PATH_APP,    L("ns.subtabs.appearances"))

  -- Stats: HP/DPS multipliers
  addRangeFloat(PATH_STATS, "FlyingHP",   L("ns.labels.flying_hp"),   L("ns.desc.hp_mult"),  0.10, 5.00, 0.05)
  addRangeFloat(PATH_STATS, "AndroidHP",  L("ns.labels.android_hp"),  L("ns.desc.hp_mult"),  0.10, 5.00, 0.05)
  addRangeFloat(PATH_STATS, "MechHP",     L("ns.labels.mech_hp"),     L("ns.desc.hp_mult"),  0.10, 10.0, 0.10)

  addRangeFloat(PATH_STATS, "FlyingDPS",  L("ns.labels.flying_dps"),  L("ns.desc.dps_mult"), 0.10, 5.00, 0.05)
  addRangeFloat(PATH_STATS, "AndroidDPS", L("ns.labels.android_dps"), L("ns.desc.dps_mult"), 0.10, 5.00, 0.05)
  addRangeFloat(PATH_STATS, "MechDPS",    L("ns.labels.mech_dps"),    L("ns.desc.dps_mult"), 0.10, 10.0, 0.10)

  -- Pricing / SystemEx slot
  addRangeInt(PATH_PRICE, "Drone_Core_Price", L("ns.labels.drone_core_price"), L("ns.desc.price_desc"), 1, 100, 1)
  addRangeInt(PATH_PRICE, "SystemExSlot",     L("ns.labels.system_ex_slot"),   L("ns.desc.system_ex_slot"), 0, 4, 1)

  -- Misc toggles
  addSwitch(PATH_MISC, "Disable_Android_Voices", L("ns.labels.disable_android_voices"), L("ns.desc.disable_android_voices"))
  addSwitch(PATH_MISC, "Permanent_Mechs",        L("ns.labels.permanent_mechs"),        L("ns.desc.permanent_mechs"))

  -- Appearances (selectors)
  addSelectorString(PATH_APP, "MeleeAndroidAppearance",      L("ns.labels.melee_android"),    L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(PATH_APP, "RangedAndroidAppearance",     L("ns.labels.ranged_android"),   L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(PATH_APP, "ShotgunnerAndroidAppearance", L("ns.labels.shotgunner"),       L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(PATH_APP, "NetrunnerAndroidAppearance",  L("ns.labels.netrunner"),        L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(PATH_APP, "TechieAndroidAppearance",     L("ns.labels.techie"),           L("ns.desc.select_appearance"), opts.android_app_list or {})
  addSelectorString(PATH_APP, "SniperAndroidAppearance",     L("ns.labels.sniper"),           L("ns.desc.select_appearance"), opts.android_app_list or {})

  addSelectorString(PATH_APP, "BombusAppearance",            L("ns.labels.bombus"),           L("ns.desc.select_appearance"), opts.bombus_app_list or {})

  print("[DCO] Native Settings UI built.")
end

-- Auto-build on init (no-op if NS missing)
registerForEvent("onInit", function()
  CoreNativeSettingUI.build()
end)

return CoreNativeSettingUI
