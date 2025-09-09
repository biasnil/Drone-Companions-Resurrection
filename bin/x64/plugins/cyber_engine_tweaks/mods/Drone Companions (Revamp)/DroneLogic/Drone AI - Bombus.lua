DCO = {
    description = "DCO"
}

function DCO:new()
    -------------------------------------------------
    -- BOMBUS: More death explosion damage
    -------------------------------------------------
    TweakDB:CreateRecord("DCO.BombusGLP", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.BombusGLP.effectors", {"DCO.BombusGLP_inline0"})
    TweakDB:CloneRecord("DCO.BombusGLP_inline0", "DCO.FlyingDroneGLP_inline0")
    TweakDB:SetFlat("DCO.BombusGLP_inline0.attackRecord", "DCO.BombusDeathExplosion")
    TweakDB:SetFlat("DCO.BombusGLP_inline0.attackPositionSlotName", CName.new("Chest"))
    for i = 1, DroneRecords do
        addToList("DCO.Tier1Bombus"..i..".onSpawnGLPs", "DCO.BombusGLP")
    end

    -------------------------------------------------
    -- BEAM BOMBUS AI
    -------------------------------------------------
    -- Action map
    for i = 1, DroneRecords do
        -- TweakDB:SetFlatNoUpdate("DCO.Tier1Bombus"..i..".primaryEquipment", "Character.sq025_delamain_drone_bombus_suicidal_inline0")
        TweakDB:SetFlat("DCO.Tier1Bombus"..i..".actionMap", "DroneBombusFastArchetype.Map")
    end

    -- Beam attack tuning
    TweakDB:SetFlat("DroneBombusActions.ShootBeam_inline2.attackRange", 20)
    TweakDB:SetFlat("DroneBombusActions.ShootBeam_inline2.attackDuration", 30)
    TweakDB:SetFlat("DroneBombusActions.ShootBeam_inline2.attackTime", 2)
    TweakDB:SetFlat("Attacks.BombusFlame.range", 20)

    -- Damage
    TweakDB:SetFlat("Attacks.BombusFlame.statModifiers",
        {"AttackModifier.PhysicalEnemyDamage", "AttackModifier.NPCAttacksPerSecondFactor", "DCO.BombusFlameDamage"})
    createConstantStatModifier("DCO.BombusFlameDamage", "Multiplier", "BaseStats.PhysicalDamage", 2)

    -- Speed up beams: add look-at while handling weapon
    TweakDB:SetFlat("DroneBombusFastArchetype.WeaponHandlingComposite.nodes",
        {"ItemHandling.SuccessIfEquipping", "DroneBombusActions.CommitSuicide", "DroneBombusActions.ShootBeam", "DCO.BombusLookAtTarget", "GenericArchetype.Success"})
    TweakDB:CloneRecord("DCO.BombusLookAtTarget", "DroneActions.LookAtTargetDuringMoveCommand")
    TweakDB:SetFlatNoUpdate("DCO.BombusLookAtTarget.activationCondition", "")
    TweakDB:SetFlatNoUpdate("DCO.BombusLookAtTarget.loop", "")
    TweakDB:SetFlat("DCO.BombusLookAtTarget.lookats", {"DroneBombusActions.ShootBeam_inline8"})
    TweakDB:Update("DCO.BombusLookAtTarget")

    -- Wider activation window
    TweakDB:SetFlat("DroneBombusActions.ShootBeamActivationCondition.AND",
        {"DroneBombusActions.ShootBeamActivationCondition_inline0", "Condition.TargetBelow15m"})
    TweakDB:SetFlat("DroneBombusActions.ShootBeamDeactivationCondition.OR",
        {"Condition.NotMinAccuracyValue0dot95", "Condition.TargetAbove15m", "Condition.CombatTargetChanged", "Condition.AIUseWorkspotCommand", "Condition.HealthBelow50perc"})

    -- Custom beam equipment
    TweakDB:CreateRecord("DCO.BombusBeamEquipment", "gamedataNPCEquipmentGroup_Record")
    TweakDB:SetFlat("DCO.BombusBeamEquipment.equipmentItems", {"DCO.BombusBeamEquipment_inline0"})
    TweakDB:CloneRecord("DCO.BombusBeamEquipment_inline0", "Character.sq025_delamain_drone_bombus_suicidal_inline1")
    TweakDB:SetFlat("DCO.BombusBeamEquipment_inline0.item", "DCO.BombusTorch")

    TweakDB:CloneRecord("DCO.BombusTorch", "Items.Bombus_Torch")
    TweakDB:SetFlat("DCO.BombusTorch.npcRPGData", "DCO.BombusTorch_inline0")
    TweakDB:CreateRecord("DCO.BombusTorch_inline0", "gamedataRPGDataPackage_Record")
    TweakDB:SetFlat("DCO.BombusTorch_inline0.statModifierGroups", {"Items.Bombus_Torch_Handling_Stats"})

    -- Handling tweaks
    TweakDB:SetFlat("Items.Bombus_Torch_Handling_Stats_inline12.value", 5)       -- physical impulse
    TweakDB:SetFlat("Items.Bombus_Torch_Handling_Stats_inline11.value", 0.12)    -- TBH
    TweakDB:SetFlat("Items.Bombus_Torch_Handling_Stats_inline2.value", 30)       -- Burst shots
    TweakDB:SetFlat("Items.Bombus_Torch_Handling_Stats_inline4.value", 999999)   -- Mag capacity

    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1Bombus"..i..".primaryEquipment", "DCO.BombusBeamEquipment")
    end

    -- Custom movement for beam chase
    TweakDB:SetFlat("DroneBombusFastArchetype.MovementPolicyCompositeDefault.nodes",
        {"DroneActions.LocomotionMalfunction", "DroneBombusActions.FollowTargetFast", "DCO.BombusBeamFollowFast", "DroneBombusActions.HoldPosition", "GenericArchetype.Success"})

    TweakDB:CloneRecord("DCO.BombusBeamFollowFast", "DroneBombusActions.FollowTargetFast")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast.activationCondition", "DCO.BombusBeamFollowFast_inline0")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast.loop", "DCO.BombusBeamFollowFast_inline2")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast.animationWrapperOverrides", {"Sandevistan"})
    TweakDB:SetFlat("DCO.BombusBeamFollowFast.subActions", {"DCO.BombusBeamSlowdown"})
    TweakDB:Update("DCO.BombusBeamFollowFast")


    TweakDB:CreateRecord("DCO.BombusBeamFollowFast_inline0", "gamedataAIActionCondition_Record")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline0.condition", "DCO.BombusBeamFollowFast_inline1")
    TweakDB:CreateRecord("DCO.BombusBeamFollowFast_inline1", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline1.AND",
        {"Condition.TargetAbove15m", "Condition.NotAIMoveCommand", "Condition.NotAIUseWorkspotCommand", "Condition.NotIsUsingOffMeshLink", "Condition.HealthAbove50Perc"})

    TweakDB:CloneRecord("DCO.BombusBeamFollowFast_inline2", "DroneBombusActions.FollowTargetFast_inline2")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast_inline2.movePolicy", "DCO.BombusBeamFollowFast_inline5")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline2.toNextPhaseCondition", {"DCO.BombusBeamFollowFast_inline3"})
    TweakDB:CreateRecord("DCO.BombusBeamFollowFast_inline3", "gamedataAIActionCondition_Record")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline3.condition", "DCO.BombusBeamFollowFast_inline4")
    TweakDB:CreateRecord("DCO.BombusBeamFollowFast_inline4", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline4.OR",
        {"Condition.TargetBelow15m", "Condition.AIMoveCommand", "Condition.AIUseWorkspotCommand", "Condition.PathFindingFailed", "Condition.NotMinAccuracySharedValue1", "Condition.HealthBelow50perc"})
    TweakDB:Update("DCO.BombusBeamFollowFast_inline2")
    
    TweakDB:CloneRecord("DCO.BombusBeamFollowFast_inline5", "DroneBombusActions.FollowTargetFast_inline3")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast_inline5.dontUseStart", true)
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamFollowFast_inline5.movementType", "Walk")
    TweakDB:SetFlat("DCO.BombusBeamFollowFast_inline5.distance", 12)
    TweakDB:Update("DCO.BombusBeamFollowFast_inline5")

    TweakDB:CloneRecord("DCO.BombusBeamSlowdown", "MovementActions.SandevistanCatchUpDistance_inline3")
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamSlowdown.easeOut", CName.new("None"))
    TweakDB:SetFlatNoUpdate("DCO.BombusBeamSlowdown.multiplier", 6)
    TweakDB:SetFlat("DCO.BombusBeamSlowdown.overrideMultiplerWhenPlayerInTimeDilation", 3)
    TweakDB:Update("DCO.BombusBeamSlowdown")

    -- Look-at presets for beam
    TweakDB:CloneRecord("DCO.BombusLookAtWeapons", "DroneBombusActions.ShootBeam_inline8")
    TweakDB:CloneRecord("DCO.BombusLookAtHorizontal", "DroneBombusActions.ShootBeam_inline8")
    TweakDB:CloneRecord("DCO.BombusLookAtVertical", "DroneBombusActions.ShootBeam_inline8")
    TweakDB:SetFlat("DCO.BombusLookAtWeapons.preset", "LookatPreset.DroneHighSpeedWeapons")
    TweakDB:SetFlat("DCO.BombusLookAtHorizontal.preset", "LookatPreset.DroneHighSpeedHorizontal")
    TweakDB:SetFlat("DCO.BombusLookAtVertical.preset", "LookatPreset.DroneHighSpeedVertical")
    TweakDB:SetFlat("DroneBombusActions.ShootBeam.lookats",
        {"DCO.BombusLookAtWeapons", "DCO.BombusLookAtHorizontal", "DCO.BombusLookAtVertical"})

    -------------------------------------------------
    -- SUICIDE BOMBUS AI
    -------------------------------------------------
    TweakDB:SetFlat("DroneBombusSuicideArchetype.MovementPolicyCompositeDefault.nodes",
        {"DroneActions.LocomotionMalfunction", "DroneBombusActions.FollowTargetFast", "GenericArchetype.Success"})
    addToList("DroneBombusActions.FollowTargetFast_inline1.AND", "Condition.HealthBelow50perc")

    TweakDB:SetFlat("DroneBombusActions.FollowTargetFast_inline2.movePolicy", "DCO.BombusSuicideMovePolicy")
    TweakDB:CloneRecord("DCO.BombusSuicideMovePolicy", "DroneBombusActions.FollowTargetFast_inline3")
    TweakDB:SetFlatNoUpdate("DCO.BombusSuicideMovePolicy.distance", 1)
    TweakDB:SetFlatNoUpdate("DCO.BombusSuicideMovePolicy.dontUseStart", true)
    TweakDB:SetFlat("DCO.BombusSuicideMovePolicy.movementType", "Walk")

    TweakDB:SetFlatNoUpdate("DroneBombusActions.FollowTargetFast.animationWrapperOverrides", {"Sandevistan"})
    TweakDB:SetFlat("DroneBombusActions.FollowTargetFast.subActions", {"DCO.BombusSuicideSlowdown"})
    TweakDB:CloneRecord("DCO.BombusSuicideSlowdown", "MovementActions.SandevistanCatchUpDistance_inline3")
    TweakDB:SetFlatNoUpdate("DCO.BombusSuicideSlowdown.easeOut", CName.new("None"))
    TweakDB:SetFlatNoUpdate("DCO.BombusSuicideSlowdown.multiplier", 12)
    TweakDB:SetFlat("DCO.BombusSuicideSlowdown.overrideMultiplerWhenPlayerInTimeDilation", 6)
    TweakDB:Update("DroneBombusActions.FollowTargetFast")
    TweakDB:Update("DCO.BombusSuicideSlowdown")
    TweakDB:Update("DCO.BombusSuicideMovePolicy")

    -- Trigger explosion at close distance/when valid
    TweakDB:SetFlat("DroneBombusActions.FollowTargetFast_inline5.OR",
        {"Condition.TargetBelow1dot5m", "Condition.AIMoveCommand", "Condition.AIUseWorkspotCommand", "Condition.PathFindingFailed", "Condition.NotMinAccuracySharedValue1"})
    TweakDB:SetFlat("DroneBombusActions.CommitSuicide_inline1.AND",
        {"Condition.NotAIMoveCommand", "Condition.NotAIUseWorkspotCommand", "Condition.TargetBelow3dot5m", "Condition.HealthBelow50perc"})

    -------------------------------------------------
    -- BOMBUS GIGA BEAM (advanced weapon path)
    -------------------------------------------------
    -- Status effect gate & conditions
    TweakDB:CreateRecord("DCO.AdvancedWeaponsSE", "gamedataStatusEffect_Record")
    TweakDB:SetFlatNoUpdate("DCO.AdvancedWeaponsSE.duration", "BaseStats.InfiniteDuration")
    TweakDB:SetFlat("DCO.AdvancedWeaponsSE.statusEffectType", "BaseStatusEffectTypes.Misc")
    TweakDB:Update("DCO.AdvancedWeaponsSE")

    TweakDB:CreateRecord("DCO.HasAdvancedWeapons", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.HasAdvancedWeapons.statusEffect", "DCO.EWSSE")
    TweakDB:SetFlatNoUpdate("DCO.HasAdvancedWeapons.invert", false)
    TweakDB:SetFlat("DCO.HasAdvancedWeapons.target", "AIActionTarget.Owner")
    TweakDB:Update("DCO.HasAdvancedWeapons")

    TweakDB:CreateRecord("DCO.NotHasAdvancedWeapons", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.NotHasAdvancedWeapons.statusEffect", "DCO.EWSSE")
    TweakDB:SetFlatNoUpdate("DCO.NotHasAdvancedWeapons.invert", true)
    TweakDB:SetFlat("DCO.NotHasAdvancedWeapons.target", "AIActionTarget.Owner")
    TweakDB:Update("DCO.NotHasAdvancedWeapons")

    -- Giga beam action scaffold
    TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam.activationCondition", "DCO.ShootGigaBeam_inline0")
    -- TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam.cooldowns", {"DCO.ShootGigaBeam_inline3"})
    TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam.loop", "DCO.ShootGigaBeam_inline5")
    TweakDB:SetFlat("DCO.ShootGigaBeam.loopSubActions", {"DCO.ShootGigaBeam_inline2"})

    TweakDB:CloneRecord("DCO.ShootGigaBeam_inline2", "DroneBombusActions.ShootBeam_inline2")
    TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam_inline2.attackDuration", 10)
    TweakDB:SetFlat("DCO.ShootGigaBeam_inline2.attack", "DCO.GigaBeam")

    TweakDB:CreateRecord("DCO.ShootGigaBeam_inline0", "gamedataAIActionCondition_Record")
    TweakDB:SetFlat("DCO.ShootGigaBeam_inline0.condition", "DCO.ShootGigaBeam_inline1")
    TweakDB:CloneRecord("DCO.ShootGigaBeam_inline1", "DroneBombusActions.ShootBeam_inline1")
    addToList("DCO.ShootGigaBeam_inline1.AND", "DCO.HasAdvancedWeapons")
    addToList("DCO.ShootGigaBeam_inline1.AND", "DCO.ShootGigaBeam_inline4")

    TweakDB:CreateRecord("DCO.ShootGigaBeam_inline3", "gamedataAIActionCooldown_Record")
    TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam_inline3.duration", 60)
    TweakDB:SetFlat("DCO.ShootGigaBeam_inline3.name", "HackBuffCamo")
    TweakDB:CreateRecord("DCO.ShootGigaBeam_inline4", "gamedataAICooldownCond_Record")
    TweakDB:SetFlat("DCO.ShootGigaBeam_inline4.cooldowns", {"DCO.ShootGigaBeam_inline3"})

    TweakDB:CloneRecord("DCO.ShootGigaBeam_inline5", "DroneBombusActions.ShootBeam_inline5")
    TweakDB:SetFlatNoUpdate("DCO.ShootGigaBeam_inline5.toNextPhaseCondition", {})
    TweakDB:SetFlat("DCO.ShootGigaBeam_inline5.toNextPhaseConditionCheckInterval", 0)

    TweakDB:Update("DCO.ShootGigaBeam")
    TweakDB:Update("DCO.ShootGigaBeam_inline2")
    TweakDB:Update("DCO.ShootGigaBeam_inline3")
    TweakDB:Update("DCO.ShootGigaBeam_inline5")

    -- Hook up the giga beam to torch & boost damage
    addToList("DCO.BombusTorch.attacks", "DCO.GigaBeam")
    createConstantStatModifier("DCO.GigaBeamDamage", "Multiplier", "BaseStats.PhysicalDamage", 4)

    -- Bombus knockdown beam / advanced torch & equipment pool
    createDroneEquipment("DCO.Bombus", "DCO.BombusTorch", "DCO.AdvancedBombusTorch")
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1Bombus"..i..".primaryEquipment", "DCO.BombusPrimaryEquipment")
    end

    TweakDB:CloneRecord("DCO.AdvancedBombusTorch", "DCO.BombusTorch")
    TweakDB:SetFlat("DCO.AdvancedBombusTorch.npcRPGData", "DCO.AdvancedBombusTorch_inline0")
    TweakDB:CloneRecord("DCO.AdvancedBombusTorch_inline0", "DCO.BombusTorch_inline0")
    addListToList("DCO.AdvancedBombusTorch_inline0", "statModifiers",
        {"DCO.AdvancedBombusTorch_inline1", "DCO.AdvancedBombusTorch_inline2", "DCO.AdvancedBombusTorch_inline3"})
    createConstantStatModifier("DCO.AdvancedBombusTorch_inline1", "Additive", "BaseStats.HitReactionFactor", 3)
    createConstantStatModifier("DCO.AdvancedBombusTorch_inline2", "Additive", "BaseStats.PhysicalImpulse", 25)
    createConstantStatModifier("DCO.AdvancedBombusTorch_inline3", "Additive", "BaseStats.KnockdownImpulse", 30)

    -------------------------------------------------
    -- FIX BOMBUS + SYSTEM COLLAPSE
    -------------------------------------------------
    TweakDB:CreateRecord("DCO.BombusSystemCollapsePackage", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.BombusSystemCollapsePackage.effectors", {"DCO.BombusSystemCollapseEffector"})
    TweakDB:CreateRecord("DCO.BombusSystemCollapseEffector", "gamedataEffector_Record")
    TweakDB:SetFlatNoUpdate("DCO.BombusSystemCollapseEffector.effectorClassName", "ModifyStatPoolValueEffector")
    TweakDB:SetFlatNoUpdate("DCO.BombusSystemCollapseEffector.prereqRecord", "DCO.BombusSystemCollapseEffectorPrereq")
    TweakDB:SetFlat("DCO.BombusSystemCollapseEffector.statPoolUpdates", {"DCO.BombusSystemCollapseEffectorStatPool"})
    TweakDB:SetFlat("DCO.BombusSystemCollapseEffector.usePercent", true)
    TweakDB:CloneRecord("DCO.BombusSystemCollapseEffectorPrereq", "Spawn_glp.DroneGriffin_ExplodeOnDeath_inline3")
    TweakDB:SetFlat("DCO.BombusSystemCollapseEffectorPrereq.prereqClassName", "StatusEffectPrereq")
    TweakDB:CloneRecord("DCO.BombusSystemCollapseEffectorStatPool", "Ability.HasElectricExplosion_inline5")
    TweakDB:Update("DCO.BombusSystemCollapseEffector")
    for i = 1, DroneRecords do
        addToList("DCO.Tier1Bombus"..i..".onSpawnGLPs", "DCO.BombusSystemCollapsePackage")
    end
end

return DCO:new()
