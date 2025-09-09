DCO = {
    description = "DCO"
}

function DCO:new()
    -------------------------------------------------
    -- FLYING DRONE SPECIAL DEFENSES
    -------------------------------------------------

    -- Militech Octant: small self-repair on hit
    createOnHitEffect("DCO.HitRepair", 3)
    TweakDB:SetFlat("DCO.HitRepairOnHitSE.packages", {"DCO.HitRepairOnHitSE_inline2"})
    TweakDB:CreateRecord("DCO.HitRepairOnHitSE_inline2", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline2.effectors", {"DCO.HitRepairOnHitSE_inline3"})
    TweakDB:CloneRecord("DCO.HitRepairOnHitSE_inline3", "DCO.DroneHealEffector")
    TweakDB:SetFlatNoUpdate("DCO.HitRepairOnHitSE_inline3.prereqRecord", "Prereqs.AlwaysTruePrereq")
    TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline3.poolModifier", "DCO.HitRepairOnHitSE_inline4")
    TweakDB:CloneRecord("DCO.HitRepairOnHitSE_inline4", "DCO.DroneHealEffector_inline0")
    TweakDB:SetFlat("DCO.HitRepairOnHitSE_inline4.valuePerSec", 1.67)
    for i = 1, DroneRecords do
        addToList("DCO.Tier1OctantMilitech"..i..".abilities", "DCO.HitRepairOnHit")
    end

    -- Arasaka Octant: tag for armor/tech-deck logic
    createConstantStatModifier("DCO.IsOctantArasaka", "Additive", "DCO.DroneOctantArasakaStat", 1)
    for i = 1, DroneRecords do
        addToList("DCO.Tier1OctantArasaka"..i..".statModifiers", "DCO.IsOctantArasaka")
    end

    -- Griffin: stacking armor on hit (capped stacks)
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
    for i = 1, DroneRecords do
        addToList("DCO.Tier1Griffin"..i..".abilities", "DCO.HitArmorOnHit")
    end

    -- Wyvern: chance to inflict Blind/Stun on ranged attacks
    TweakDB:CreateRecord("DCO.WyvernDisorient", "gamedataGameplayAbility_Record")
    TweakDB:SetFlat("DCO.WyvernDisorient.abilityPackage", "DCO.WyvernDisorient_inline0")
    TweakDB:CreateRecord("DCO.WyvernDisorient_inline0", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline0.effectors", {"DCO.WyvernDisorient_inline1", "DCO.WyvernDisorient_inline2"})
    TweakDB:CreateRecord("DCO.WyvernDisorient_inline1", "gamedataAddStatusEffectToAttackEffector_Record")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline1.isRandom", true)
    TweakDB:SetFlat("DCO.WyvernDisorient_inline1.stacks", 1, "Int32")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline1.effectorClassName", "AddStatusEffectToAttackEffector")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline1.prereqRecord", "Perks.IsAttackRanged")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline1.statusEffect", "BaseStatusEffect.Blind")
    TweakDB:CreateRecord("DCO.WyvernDisorient_inline2", "gamedataAddStatusEffectToAttackEffector_Record")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline2.isRandom", true)
    TweakDB:SetFlat("DCO.WyvernDisorient_inline2.stacks", 1, "Int32")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline2.effectorClassName", "AddStatusEffectToAttackEffector")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline2.prereqRecord", "Perks.IsAttackRanged")
    TweakDB:SetFlat("DCO.WyvernDisorient_inline2.statusEffect", "BaseStatusEffect.Stun")

    local function copyAppChance(dst)
        local candidates = {
            "BaseStatusEffect.Blind_inline1.applicationChance",
            "BaseStatusEffect.Stun_inline1.applicationChance",
            "BaseStatusEffect.Electrocuted_inline23.applicationChance"
        }
        for _, src in ipairs(candidates) do
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
        addToList("DCO.Tier1Wyvern"..i..".abilities", "DCO.WyvernDisorient")
    end

    -------------------------------------------------
    -- OCTANT DRONES SPECIAL EQUIPMENT / WEAPONS
    -------------------------------------------------

    -- Arasaka: extend tech-hack duration
    createConstantStatModifier("DCO.OctantArasakaTechHackDuration", "Additive", "DCO.DroneTechHackDuration", 0.5)
    for i = 1, DroneRecords do
        addToList("DCO.Tier1OctantArasaka"..i..".statModifiers", "DCO.OctantArasakaTechHackDuration")
    end

    -- Militech: custom autocannon with small explosive payloads
    TweakDB:CreateRecord("DCO.OctantMilitechEquipment", "gamedataNPCEquipmentGroup_Record")
    TweakDB:SetFlat("DCO.OctantMilitechEquipment.equipmentItems", {"DCO.OctantMilitechEquipment_inline0"})
    TweakDB:CloneRecord("DCO.OctantMilitechEquipment_inline0", "Character.Drone_Octant_Base_inline1")
    TweakDB:SetFlat("DCO.OctantMilitechEquipment_inline0.item", "DCO.OctantMilitechAutocannon")

    TweakDB:CloneRecord("DCO.OctantMilitechAutocannon", "Items.Octant_Autocannon")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon.rangedAttacks", "DCO.OctantMilitechAutocannon_inline0")
    addListToList("DCO.OctantMilitechAutocannon", "attacks", {"DCO.OctantMilitechAutocannon_inline2", "DCO.OctantMilitechAutocannon_inline3"})
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1OctantMilitech"..i..".primaryEquipment", "DCO.OctantMilitechEquipment")
    end

    TweakDB:CreateRecord("DCO.OctantMilitechAutocannon_inline0", "gamedataRangedAttackPackage_Record")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon_inline0.chargeFire", "DCO.OctantMilitechAutocannon_inline1")
    TweakDB:SetFlat("DCO.OctantMilitechAutocannon_inline0.defaultFire", "DCO.OctantMilitechAutocannon_inline1")
    TweakDB:CreateRecord("DCO.OctantMilitechAutocannon_inline1", "gamedataRangedAttack_Record")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon_inline1.NPCAttack", "DCO.OctantMilitechAutocannon_inline3")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon_inline1.NPCTimeDilated", "DCO.OctantMilitechAutocannon_inline2")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon_inline1.playerAttack", "DCO.OctantMilitechAutocannon_inline3")
    TweakDB:SetFlat("DCO.OctantMilitechAutocannon_inline1.playerTimeDilated", "DCO.OctantMilitechAutocannon_inline2")

    TweakDB:CloneRecord("DCO.OctantMilitechAutocannon_inline2", "Attacks.NPCBulletProjectile")
    TweakDB:SetFlat("DCO.OctantMilitechAutocannon_inline2.explosionAttack", "DCO.OctantMilitechAutocannon_inline4")
    TweakDB:SetFlat("DCO.OctantMilitechAutocannon_inline2.hitCooldown", 0.1, 'Float')
    addToList("DCO.OctantMilitechAutocannon_inline2.statModifiers", "DCO.OctantMilitechAutocannon_inline6")

    TweakDB:CloneRecord("DCO.OctantMilitechAutocannon_inline3", "Attacks.NPCBulletEffect")
    TweakDB:SetFlat("DCO.OctantMilitechAutocannon_inline3.explosionAttack", "DCO.OctantMilitechAutocannon_inline4")
    addToList("DCO.OctantMilitechAutocannon_inline3.statModifiers", "DCO.OctantMilitechAutocannon_inline6")

    TweakDB:CloneRecord("DCO.OctantMilitechAutocannon_inline4", "Attacks.BulletExplosion")
    TweakDB:SetFlatNoUpdate("DCO.OctantMilitechAutocannon_inline4.hitFlags", {})
    addToList("DCO.OctantMilitechAutocannon_inline4.statModifiers", "DCO.OctantMilitechAutocannon_inline5")
    createConstantStatModifier("DCO.OctantMilitechAutocannon_inline5", "Multiplier", "BaseStats.PhysicalDamage", 0.1)
    createConstantStatModifier("DCO.OctantMilitechAutocannon_inline6", "Multiplier", "BaseStats.PhysicalDamage", 0.45)

    -------------------------------------------------
    -- FLYING DRONES: ADVANCED WEAPONRY
    -------------------------------------------------

    -- Griffin: explosive rifles, both hands
    createExplosiveDroneWeapon("DCO.AdvancedGriffinRifleRight", "Items.Griffin_Rifle_Right",
        "Attacks.NPCBulletEffect", "Attacks.NPCBulletProjectile", "Attacks.BulletExplosion", 0.5, 0.5)
    createDroneEquipment("DCO.Griffin", "Items.Griffin_Rifle_Right", "DCO.AdvancedGriffinRifleRight")

    createExplosiveDroneWeapon("DCO.AdvancedGriffinRifleLeft", "Items.Griffin_Rifle_Left",
        "Attacks.NPCBulletEffect", "Attacks.NPCBulletProjectile", "Attacks.BulletExplosion", 0.5, 0.5)
    createDroneEquipment("DCO.GriffinLeft", "Items.Griffin_Rifle_Left", "DCO.AdvancedGriffinRifleLeft")
    addToList("DCO.GriffinPrimaryEquipment.equipmentItems", "DCO.GriffinLeftPrimaryPool")
    TweakDB:SetFlat("DCO.GriffinLeftPrimaryPoolEntryAdvanced_inline1.equipSlot", "AttachmentSlots.WeaponLeft")
    TweakDB:SetFlat("DCO.GriffinLeftPrimaryPoolEntryBasic_inline1.equipSlot", "AttachmentSlots.WeaponLeft")

    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1Griffin"..i..".primaryEquipment", "DCO.GriffinPrimaryEquipment")
    end

    -- Wyvern: smart explosive rifle
    createExplosiveDroneWeapon("DCO.AdvancedWyvernRifle", "Items.Wyvern_Rifle",
        "Attacks.NPCSmartBullet", "Attacks.NPCSmartBullet", "Attacks.BulletSmartBulletHighExplosion", 0.5, 0.5)
    createDroneEquipment("DCO.Wyvern", "Items.Wyvern_Rifle", "DCO.AdvancedWyvernRifle")
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1Wyvern"..i..".primaryEquipment", "DCO.WyvernPrimaryEquipment")
    end

    -- Octant Arasaka: smart autocannon package
    TweakDB:CloneRecord("DCO.OctantArasakaSmartAutocannon", "Items.Octant_Autocannon")
    TweakDB:SetFlatNoUpdate("DCO.OctantArasakaSmartAutocannon.evolution", "WeaponEvolution.Smart")
    TweakDB:SetFlatNoUpdate("DCO.OctantArasakaSmartAutocannon.npcRPGData", "DCO.OctantArasakaSmartAutocannon_inline0")
    TweakDB:SetFlat("DCO.OctantArasakaSmartAutocannon.rangedAttacks", "Attacks.SmartBulletDronePackage")
    TweakDB:CloneRecord("DCO.OctantArasakaSmartAutocannon_inline0", "Items.Octant_Autocannon_inline0")
    TweakDB:SetFlat("DCO.OctantArasakaSmartAutocannon_inline0.statModifierGroups",
        {"Items.Octant_Autocannon_Handling_Stats", "Items.Wyvern_Rifle_SmartGun_Stats", "Items.Wyvern_Rifle_Projectile_Stats"})
    createDroneEquipment("DCO.OctantArasaka", "Items.Octant_Autocannon", "DCO.OctantArasakaSmartAutocannon")
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1OctantArasaka"..i..".primaryEquipment", "DCO.OctantArasakaPrimaryEquipment")
    end

    -- Octant Militech (advanced): smart explosive variant
    createExplosiveDroneWeapon("DCO.AdvancedOctantMilitechAutocannon", "DCO.OctantArasakaSmartAutocannon",
        "Attacks.NPCSmartBullet", "Attacks.NPCSmartBullet", "Attacks.BulletSmartBulletHighExplosion", 0.5, 0.5)
    createDroneEquipment("DCO.OctantMilitech", "DCO.OctantMilitechAutocannon", "DCO.AdvancedOctantMilitechAutocannon")
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1OctantMilitech"..i..".primaryEquipment", "DCO.OctantMilitechPrimaryEquipment")
    end

    -------------------------------------------------
    -- MISC TUNING
    -------------------------------------------------
    -- Wyverns are rare
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1Wyvern"..i..".rarity", "NPCRarity.Rare")
    end
    -- Remove Griffin shoot cooldown
    TweakDB:SetFlat("DroneGriffinActions.ShootCooldown.duration", 0.01)
end

return DCO:new()
