DCO = { description = "DCO" }

function DCO:new()
  createOnHitEffect("DCO.HitRepair", 3)
  TweakDB:SetFlat("DCO.HitRepairOnHitSE.packages", {"DCO.HitRepairOnHitSE_inline2"})
  TweakDB:CreateRecord("DCO.HitRepairOnHitSE_inline2", "gamedataGameplayLogicPackage_Record")
  TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline2.effectors", {"DCO.HitRepairOnHitSE_inline3"})
  TweakDB:CloneRecord("DCO.HitRepairOnHitSE_inline3", "DCO.DroneHealEffector")
  TweakDB:SetFlatNoUpdate("DCO.HitRepairOnHitSE_inline3.prereqRecord", "Prereqs.AlwaysTruePrereq")
  TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline3.poolModifier", "DCO.HitRepairOnHitSE_inline4")
  TweakDB:CloneRecord("DCO.HitRepairOnHitSE_inline4", "DCO.DroneHealEffector_inline0")
  TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline4.valuePerSec", 1.67)

  createOnHitEffect("DCO.HitArmor", 10)
  TweakDB:SetFlat("DCO.HitArmorOnHitSE.packages", {"DCO.HitArmorOnHitSE_inline2"})
  TweakDB:SetFlat("DCO.HitArmorOnHitSE.maxStacks", "DCO.HitArmorOnHitSE_inline4")
  TweakDB:CreateRecord("DCO.HitArmorOnHitSE_inline2", "gamedataGameplayLogicPackage_Record")
  TweakDB:SetFlat("DCO.HitArmorOnHitSE_inline2.stats", {"DCO.HitArmorOnHitSE_inline3"})
  TweakDB:SetFlat("DCO.HitArmorOnHitSE_inline2.stackable", true)
  createConstantStatModifier("DCO.HitArmorOnHitSE_inline3", "Additive", "BaseStats.Armor", 5)
  TweakDB:CreateRecord("DCO.HitArmorOnHitSE_inline4", "gamedataStatModifierGroup_Record")
  TweakDB:SetFlatNoUpdate("DCO.HitArmorOnHitSE_inline4.statModsLimit", -1)
  TweakDB:SetFlat("DCO.HitArmorOnHitSE_inline4.statModifiers", {"DCO.HitArmorOnHitSE_inline5"})
  createConstantStatModifier("DCO.HitArmorOnHitSE_inline5", "Additive", "BaseStats.MaxStacks", 10)

  local function copyAppChance(dst)
    local c = {
      "BaseStatusEffect.Blind_inline1.applicationChance",
      "BaseStatusEffect.Stun_inline1.applicationChance",
      "BaseStatusEffect.Electrocuted_inline23.applicationChance"
    }
    for _, src in ipairs(c) do
      local v = TweakDB:GetFlat(src)
      if v ~= nil then
        TweakDB:SetFlat(dst, v)
        return
      end
    end
    TweakDB:SetFlat(dst, {}, "array:TweakDBID")
  end
  copyAppChance("DCO.WyvernDisorient_inline1.applicationChance")
  copyAppChance("DCO.WyvernDisorient_inline2.applicationChance")

  for i = 1, DroneRecords do
    addToList("DCO.Tier1OctantMilitech"..i..".abilities", "DCO.HitRepairOnHit")
    addToList("DCO.Tier1Griffin"..i..".abilities", "DCO.HitArmorOnHit")
    addToList("DCO.Tier1Wyvern"..i..".abilities", "DCO.WyvernDisorient")

    addToList("DCO.Tier1OctantArasaka"..i..".statModifiers", "DCO.IsOctantArasaka")
    addToList("DCO.Tier1OctantArasaka"..i..".statModifiers", "DCO.OctantArasakaTechHackDuration")

    TweakDB:SetFlat("DCO.Tier1OctantMilitech"..i..".primaryEquipment", "DCO.OctantMilitechPrimaryEquipment")
    TweakDB:SetFlat("DCO.Tier1OctantArasaka"..i..".primaryEquipment", "DCO.OctantArasakaPrimaryEquipment")
    TweakDB:SetFlat("DCO.Tier1Griffin"..i..".primaryEquipment", "DCO.GriffinPrimaryEquipment")
    TweakDB:SetFlat("DCO.Tier1Wyvern"..i..".primaryEquipment", "DCO.WyvernPrimaryEquipment")

    TweakDB:SetFlat("DCO.Tier1Wyvern"..i..".rarity", "NPCRarity.Rare")
  end
end

return DCO:new()
