-- Values/Set Values.lua
-- Applies config-driven TweakDB values for DCO.
-- No globals; safe to require from EventListener after TDB is ready.

local CoreDCO = require("Core/CoreDCO")

-- Try to fetch appearance maps / counts from initVars (if it returns a table)
local Vars = {}
do
  local ok, mod = pcall(require, "initVars")
  if ok and type(mod) == "table" then Vars = mod end
end

local android_appearances = Vars.android_appearances or _G.android_appearances or {}
local bombus_appearances  = Vars.bombus_appearances  or _G.bombus_appearances  or {}
local DroneRecords        = Vars.DroneRecords        or _G.DroneRecords        or 8 -- sensible fallback

local function get(k) return CoreDCO:get(k, CoreDCO.DEFAULTS[k]) end
local function L(k, vars) return CoreDCO:L(k, vars) end

local function setDesc(path, keyBase, permanent)
  local key = permanent and ("crafting.mechs." .. keyBase .. "_desc")
                     or  ("crafting.mechs." .. keyBase .. "_desc_unstable")
  -- Set as raw localized string; adjust if you store LocKeys instead
  TweakDB:SetFlat(path, L(key))
end

local function apply()
  -- --- Scalars / prices -----------------------------------------------
  TweakDB:SetFlat("DCO.DroneCorePrice.value", get("Drone_Core_Price"))

  TweakDB:SetFlat("DCO.FlyingDroneHPBonus.value",  1.8 * get("FlyingHP"))
  TweakDB:SetFlat("DCO.FlyingDroneDPSBonus.value", 1.5 * get("FlyingDPS"))

  TweakDB:SetFlat("DCO.AndroidHPBonus.value",  1.2 * get("AndroidHP"))
  TweakDB:SetFlat("DCO.AndroidDPSBonus.value", 1.5 * get("AndroidDPS"))

  TweakDB:SetFlat("DCO.MechHPBonus.value",  1.2 * get("MechHP"))
  TweakDB:SetFlat("DCO.MechDPSBonus.value", 1.5 * get("MechDPS"))

  -- --- Mech permanence / regen + descriptions -------------------------
  local permanent = get("Permanent_Mechs") == true

  setDesc("DCO.Tier1MechNCPDItemLogicPackageDescription.localizedDescription",   "ncpd_mech",    permanent)
  setDesc("DCO.Tier1MechArasakaItemLogicPackageDescription.localizedDescription","arasaka_mech", permanent)
  setDesc("DCO.Tier1MechMilitechItemLogicPackageDescription.localizedDescription","militech_mech", permanent)

  if permanent then
    TweakDB:SetFlat("DCO.MechRegenAbility_inline2.valuePerSec", 0)
    TweakDB:SetFlat("DCO.MechRegenAbility_inline4.valuePerSec", 0)
  else
    TweakDB:SetFlat("DCO.MechRegenAbility_inline2.valuePerSec", 0.056)
    TweakDB:SetFlat("DCO.MechRegenAbility_inline4.valuePerSec", 0.056)
  end

  -- --- Known missing CNames (bugfix) ----------------------------------
  if CName and CName.add then
    CName.add("gang__android_ma_bls_ina_se5_07_droid_01")
    CName.add("gang__android_ma_bls_ina_se5_07_droid_02")
  end

  -- --- Android appearances --------------------------------------------
  local melee      = android_appearances[get("MeleeAndroidAppearance")]
  local ranged     = android_appearances[get("RangedAndroidAppearance")]
  local shotgunner = android_appearances[get("ShotgunnerAndroidAppearance")]
  local techie     = android_appearances[get("TechieAndroidAppearance")]
  local netrunner  = android_appearances[get("NetrunnerAndroidAppearance")]
  local sniper     = android_appearances[get("SniperAndroidAppearance")]

  for i = 1, DroneRecords do
    if melee      then TweakDB:SetFlat(("DCO.Tier1AndroidMelee%s.appearanceName"):format(i),      CName.new(melee)) end
    if ranged     then TweakDB:SetFlat(("DCO.Tier1AndroidRanged%s.appearanceName"):format(i),     CName.new(ranged)) end
    if shotgunner then TweakDB:SetFlat(("DCO.Tier1AndroidShotgunner%s.appearanceName"):format(i), CName.new(shotgunner)) end
    if techie     then TweakDB:SetFlat(("DCO.Tier1AndroidHeavy%s.appearanceName"):format(i),      CName.new(techie)) end
    if netrunner  then TweakDB:SetFlat(("DCO.Tier1AndroidNetrunner%s.appearanceName"):format(i),  CName.new(netrunner)) end
    if sniper     then TweakDB:SetFlat(("DCO.Tier1AndroidSniper%s.appearanceName"):format(i),     CName.new(sniper)) end
  end

  -- --- Bombus appearance ----------------------------------------------
  local bombus = bombus_appearances[get("BombusAppearance")]
  if bombus then
    for i = 1, DroneRecords do
      TweakDB:SetFlat(("DCO.Tier1Bombus%s.appearanceName"):format(i), CName.new(bombus))
    end
  end

  return true
end

return apply()
