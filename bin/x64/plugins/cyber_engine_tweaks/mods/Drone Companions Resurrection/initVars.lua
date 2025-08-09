-- initVars.lua (optimized)
-- Initializes global IDs, names, and lookup tables used by DCO.

-- === Core requires ===========================================================
local CoreDCO     = require("Core/CoreDCO")

-- unified scheduler (both names available)
local CoreCron    = require("Core/CoreCron")
local Cron        = CoreCron.Cron         -- available if you need timers here
local MenuCron    = CoreCron.MenuCron     -- alias; same object

-- keep if you use its events elsewhere (safe to leave)
local GameSession = require("Utilities/GameSession")

-- localization helper
local L = function(k) return CoreDCO:L(k) end

-- === Hot globals cached ======================================================
local TweakDB     = TweakDB
local TweakDBID   = TweakDBID
local ToTweakDBID = ToTweakDBID
local CName       = CName

-- === Tunables ================================================================
DroneRecords  = DroneRecords or 3        -- number of record variants per base
Friendly_Time = Friendly_Time or 0.5     -- seconds until friendly after spawn

-- === TweakDBIDs for craftables ==============================================
mechncpd_tdb       = TweakDBID.new("DCO.Tier1MechNCPDItem")
mechmilitech_tdb   = TweakDBID.new("DCO.Tier1MechMilitechItem")
mecharasaka_tdb    = TweakDBID.new("DCO.Tier1MechArasakaItem")
octant_tdb         = ToTweakDBID{ hash = 0x397809FC, length = 19 }
octantarasaka_tdb  = TweakDBID.new("DCO.Tier1OctantArasakaItem")
octantmilitech_tdb = TweakDBID.new("DCO.Tier1OctantMilitechItem")
octanttrauma_tdb   = TweakDBID.new("DCO.Tier1OctantTraumaItem")
octantkangtao_tdb  = TweakDBID.new("DCO.Tier1OctantKangTaoItem")

androidmelee_tdb      = ToTweakDBID{ hash = 0x1F473D15, length = 25 }
androidranged_tdb     = ToTweakDBID{ hash = 0x3C1D4405, length = 26 }
androidshotgunner_tdb = ToTweakDBID{ hash = 0xF4AF643D, length = 30 }
androidnetrunner_tdb  = ToTweakDBID{ hash = 0xD48DB645, length = 29 }
androidheavy_tdb      = ToTweakDBID{ hash = 0x1455132C, length = 25 }
androidsniper_tdb     = ToTweakDBID{ hash = 0x4B7A2991, length = 26 }

bombus_tdb     = ToTweakDBID{ hash = 0xA39F6F8D, length = 19 }
griffin_tdb    = ToTweakDBID{ hash = 0x58EC5CFF, length = 20 }
wyvern_tdb     = ToTweakDBID{ hash = 0xDCC16EA2, length = 19 }
bombusbeam_tdb = TweakDBID.new("DCO.Tier1BombusBeamItem")

possible_tdb = {
  mechncpd_tdb, mechmilitech_tdb, mecharasaka_tdb, octant_tdb,
  octantarasaka_tdb, octantmilitech_tdb, octanttrauma_tdb, octantkangtao_tdb,
  androidmelee_tdb, androidranged_tdb, androidshotgunner_tdb,
  androidnetrunner_tdb, androidheavy_tdb, androidsniper_tdb,
  bombus_tdb, bombusbeam_tdb, griffin_tdb, wyvern_tdb
}

-- === Base lists ==============================================================
Mech_List    = { "DCO.Tier1MechMilitech", "DCO.Tier1MechArasaka", "DCO.Tier1MechNCPD" }
Flying_List  = { "DCO.Tier1OctantArasaka", "DCO.Tier1OctantMilitech", "DCO.Tier1Wyvern", "DCO.Tier1Bombus", "DCO.Tier1Griffin" }
Android_List = {
  "DCO.Tier1AndroidHeavy", "DCO.Tier1AndroidMelee", "DCO.Tier1AndroidNetrunner",
  "DCO.Tier1AndroidRanged", "DCO.Tier1AndroidShotgunner", "DCO.Tier1AndroidSniper"
}

-- expand each list with numbered record variants (in-place; no temps)
do
  local lists = { Mech_List, Flying_List, Android_List }
  for _, list in ipairs(lists) do
    local baseCount = #list
    for i = 1, baseCount do
      local base = list[i]
      for n = 1, DroneRecords do
        list[#list + 1] = base .. n
      end
    end
  end
end

-- concatenated convenience list
Full_Drone_List = {}
do
  local dst = Full_Drone_List
  for i = 1, #Android_List do dst[#dst + 1] = Android_List[i] end
  for i = 1, #Flying_List  do dst[#dst + 1] = Flying_List[i]  end
  for i = 1, #Mech_List    do dst[#dst + 1] = Mech_List[i]    end
end

-- === Localized names =========================================================
local function L_or(key, locKey)
  local s = L(key)
  if s ~= key then return s end
  return locKey and GetLocalizedText(locKey) or key
end

bombus_name         = L_or("crafting.drones.bombus_name",    "LocKey#45199")
wyvern_name         = L_or("crafting.drones.wyvern_name",    "LocKey#45200")
griffin_name        = L_or("crafting.drones.griffin_name",   "LocKey#45201")
octantmilitech_name = L_or("crafting.drones.militech_octant_name")
octantarasaka_name  = L_or("crafting.drones.arasaka_octant_name")

mechncpd_name     = L_or("crafting.mechs.ncpd_mech_name")
mecharasaka_name  = L_or("crafting.mechs.arasaka_mech_name")
mechmilitech_name = L_or("crafting.mechs.militech_mech_name")

androidmelee_name       = L_or("crafting.androids.melee_name")
androidranged_name      = L_or("crafting.androids.ranged_name")
androidshotgunner_name  = L_or("crafting.androids.shotgunner_name")
androidsniper_name      = L_or("crafting.androids.sniper_name")
androidnetrunner_name   = L_or("crafting.androids.netrunner_name")
androidtechie_name      = L_or("crafting.androids.techie_name")

drones_list = {
  bombus_name, wyvern_name, griffin_name,
  octantmilitech_name, octantarasaka_name,
  mechncpd_name, mecharasaka_name, mechmilitech_name,
  androidmelee_name, androidranged_name, androidshotgunner_name,
  androidsniper_name, androidnetrunner_name, androidtechie_name
}

-- mapping: localized name -> base record
drone_records = {
  [octantarasaka_name]      = "DCO.Tier1OctantArasaka",
  [octantmilitech_name]     = "DCO.Tier1OctantMilitech",
  [bombus_name]             = "DCO.Tier1Bombus",
  [wyvern_name]             = "DCO.Tier1Wyvern",
  [griffin_name]            = "DCO.Tier1Griffin",
  [mechncpd_name]           = "DCO.Tier1MechNCPD",
  [mechmilitech_name]       = "DCO.Tier1MechMilitech",
  [mecharasaka_name]        = "DCO.Tier1MechArasaka",
  [androidranged_name]      = "DCO.Tier1AndroidRanged",
  [androidmelee_name]       = "DCO.Tier1AndroidMelee",
  [androidshotgunner_name]  = "DCO.Tier1AndroidShotgunner",
  [androidnetrunner_name]   = "DCO.Tier1AndroidNetrunner",
  [androidtechie_name]      = "DCO.Tier1AndroidHeavy",
  [androidsniper_name]      = "DCO.Tier1AndroidSniper",
}

-- === Appearances =============================================================
android_appearances = {
  ["Maelstrom 1"] = "gang__android_ma_maelstrom_droid__lvl2_01",
  ["Maelstrom 2"] = "gang__android_ma_maelstrom_droid__lvl2_02",
  ["Maelstrom 3"] = "gang__android_ma_maelstrom_droid__lvl2_03",
  ["Maelstrom 4"] = "gang__android_ma_maelstrom_droid__lvl2_04",
  ["Wraiths 1"]   = "gang__android_ma_wraith_droid__lvl1_01",
  ["Wraiths 2"]   = "gang__android_ma_wraith_droid__lvl1_02",
  ["Wraiths 3"]   = "gang__android_ma_wraith_droid__lvl1_03",
  ["Wraiths 4"]   = "gang__android_ma_wraith_droid__lvl1_04",
  ["Wraiths 5"]   = "gang__android_ma_wraith_droid__lvl1_05",
  ["Scavengers 1"]= "gang__android_ma_scavenger_droid__lvl2_01",
  ["Scavengers 2"]= "gang__android_ma_scavenger_droid__lvl2_02",
  ["Scavengers 3"]= "gang__android_ma_scavenger_droid__lvl2_03",
  ["Scavengers 4"]= "gang__android_ma_scavenger_droid__lvl2_04",
  ["Scavengers 5"]= "gang__android_ma_scavenger_droid__lvl2_05",
  ["Scavengers 6"]= "gang__android_ma_scavenger_droid__lvl2_06",
  ["Kang Tao 1"]  = "gang__android_ma_kangtao_droid__lvl2_01",
  ["Sixth Street 1"] = "gang__android_ma_6th_street_droid_lvl1_01",
  ["Sixth Street 2"] = "gang__android_ma_6th_street_droid_lvl1_02",
  ["Sixth Street 3"] = "gang__android_ma_6th_street_droid_lvl1_03",
  ["Sixth Street 4"] = "gang__android_ma_6th_street_droid_lvl1_04",
  ["Sixth Street 5"] = "gang__android_ma_6th_street_droid_lvl1_05",
  ["Sixth Street 6"] = "gang__android_ma_6th_street_droid_lvl1_06",
  ["Kerry 1"]     = "corpo__android_ma__sq011__kerry_bodyguard_01",
  ["Kerry 2"]     = "corpo__android_ma__sq011__kerry_bodyguard_02",
  ["Kerry 3"]     = "corpo__android_ma__sq011__kerry_bodyguard_03",
  ["Kerry 4"]     = "corpo__android_ma__sq011__kerry_bodyguard_04",
  ["Kerry 5"]     = "corpo__android_ma__sq011__kerry_bodyguard_05",
  ["Arasaka 1"]   = "corpo__android_ma_arasaka_droid__lvl2_01",
  ["NCPD 1"]      = "corpo__android_ma_ncpd_droid__lvl1_01",
  ["Militech 1"]  = "corpo__android_ma_militech_droid__lvl2_01",
  ["MaxTac 1"]    = "corpo__android_ma_maxtac_droid__lvl2_01",
  ["KangTao 2"]   = "corpo__android_ma_kang_tao_droid__lvl2_01",
  ["Badlands 1"]  = "gang__android_ma_bls_ina_se5_07_droid_01",
  ["Badlands 2"]  = "gang__android_ma_bls_ina_se5_07_droid_02",
  ["Boxing 1"]    = "special__training_dummy_ma_dummy_boxing",
}

bombus_appearances = {
  ["Police"]   = "zetatech_bombus__basic_surveillance_police_01",
  ["Netwatch"] = "zetatech_bombus__basic_surveillance_netwatch_01",
  ["Purple"]   = "zetatech_bombus__basic_nanny_drone_violet",
  ["White"]    = "zetatech_bombus__basic_nanny_drone_white",
  ["Beam"]     = "zetatech_bombus__basic_surveillance_drone_01",
  ["Blue"]     = "zetatech_bombus__basic_nanny_drone_blue",
  ["Service"]  = "zetatech_bombus__basic_surveillance_service_01",
  ["Delamain"] = "zetatech_bombus__basic_delamain_drone_01",
}

-- === Hack list ===============================================================
drone_hack_list = {
  "DCO.Shutdown","DCO.SelfDestruct","DCO.Explode","DCO.OpticalZoom",
  "DCO.AndroidKerenzikov","DCO.EWS","DCO.DroneCloak","DCO.DroneHeal",
  "DCO.Overdrive"
}

-- === Helpers =================================================================
local function has_value(tab, val)
  for i = 1, #tab do if tab[i] == val then return true end end
  return false
end

function createRandomQuantityVendorItem(RecordName, SCReq, item, qmin, qmax)
  TweakDB:CreateRecord(RecordName, "gamedataVendorItem_Record")
  TweakDB:SetFlatNoUpdate(RecordName..".availabilityPrereq", "SCReq"..SCReq)
  TweakDB:SetFlatNoUpdate(RecordName..".item", item)
  TweakDB:SetFlatNoUpdate(RecordName..".quantity", {RecordName.."Quantity"})
  TweakDB:Update(RecordName)

  TweakDB:CreateRecord(RecordName.."Quantity", "gamedataRandomStatModifier_Record")
  TweakDB:SetFlatNoUpdate(RecordName.."Quantity.statType", "BaseStats.Quantity")
  TweakDB:SetFlatNoUpdate(RecordName.."Quantity.modifierType", "Additive")
  TweakDB:SetFlatNoUpdate(RecordName.."Quantity.min", qmin)
  TweakDB:SetFlatNoUpdate(RecordName.."Quantity.max", qmax)
  TweakDB:Update(RecordName.."Quantity")
end

function addToList(list, ability)
  local templist = TweakDB:GetFlat(list)
  if not templist then return end
  if not has_value(templist, ability) then
    templist[#templist + 1] = ability
    TweakDB:SetFlat(list, templist)
  end
end

function addCName(list, cn)
  local templist = TweakDB:GetFlat(list)
  if not templist then return end
  if not has_value(templist, cn) then
    templist[#templist + 1] = cn
    TweakDB:SetFlat(list, templist)
  end
end

function createConstantStatModifier(recordName, modifierType, statType, value)
  TweakDB:CreateRecord(recordName, "gamedataConstantStatModifier_Record")
  TweakDB:SetFlatNoUpdate(recordName..".modifierType", modifierType)
  TweakDB:SetFlatNoUpdate(recordName..".statType",     statType)
  TweakDB:SetFlatNoUpdate(recordName..".value",        value)
  TweakDB:Update(recordName)
end

function createCombinedStatModifier(recordName, modifierType, opSymbol, refObject, refStat, statType, value)
  TweakDB:CreateRecord(recordName, "gamedataCombinedStatModifier_Record")
  TweakDB:SetFlatNoUpdate(recordName..".modifierType", modifierType)
  TweakDB:SetFlatNoUpdate(recordName..".opSymbol",     opSymbol)
  TweakDB:SetFlatNoUpdate(recordName..".refObject",    refObject)
  TweakDB:SetFlatNoUpdate(recordName..".refStat",      refStat)
  TweakDB:SetFlatNoUpdate(recordName..".statType",     statType)
  TweakDB:SetFlatNoUpdate(recordName..".value",        value)
  TweakDB:Update(recordName)
end

function addListToList(recordName, list, list2)
  for i = 1, #list2 do
    addToList(recordName.."."..list, list2[i])
  end
  TweakDB:Update(recordName)
end

function createVendorItem(RecordName, SCReq, item)
  TweakDB:CreateRecord(RecordName, "gamedataVendorItem_Record")
  TweakDB:SetFlatNoUpdate(RecordName..".availabilityPrereq", "SCReq"..SCReq)
  TweakDB:SetFlatNoUpdate(RecordName..".item", item)
  TweakDB:SetFlatNoUpdate(RecordName..".quantity", {"Vendors.IsPresent"})
  TweakDB:Update(RecordName)
end

function createSCRequirement(value)
  TweakDB:CloneRecord("SCReq"..value, "Vendors.GlenCredAvailability")
  TweakDB:SetFlat("SCReq"..value..".valueToCheck", value)
end

return true
