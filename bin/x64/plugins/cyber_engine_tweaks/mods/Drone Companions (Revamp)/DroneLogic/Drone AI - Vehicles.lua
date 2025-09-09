DCO = {
    description = "DCO"
}

function DCO:new()
    local weapon_types = {"PrecisionRifle","SniperRifle","LightMachineGun","HeavyMachineGun","AssaultRifle","Shotgun","ShotgunDual"}
    local cond_list = {
        "VehicleActions.PassengerSportEquipAnyHandgun",
        "VehicleActions.PassengerSportFailSafeEquipHandgun",
        "VehicleActions.GunnerEquipRifle",
        "VehicleActions.EquipAnyRifleFromInventory"
    }
    for _, v in ipairs(weapon_types) do
        createEquipAI("DCO.Equip"..v, "ItemType.Wea_"..v)
        table.insert(cond_list, "DCO.Equip"..v)
    end
    table.insert(cond_list, "VehicleActions.FailSafeEquipRifle")
    table.insert(cond_list, "VehicleActions.Success")
    TweakDB:SetFlat("VehicleActions.PassengerEquipWeapon.nodes", cond_list)

    TweakDB:SetFlat("DroneActions.ShootDefault_inline1.AND", {"DCO.ShootDefault_inline0","DroneActions.ShootDefault_inline2","DroneActions.ShootDefault_inline3","Condition.OptimalDistance10mTolerance","Condition.NotFriendlyFire"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline0", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline0.OR", {"Condition.TargetBelow15deg","DCO.ShootDefault_inline1"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline1", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline1.AND", {"Condition.FollowerInVehicle","DCO.IsDCO"})

    TweakDB:SetFlat("DroneGriffinActions.ShootDefault_inline1.AND", {"DroneGriffinActions.ShootDefault_inline2","Condition.NotAIMoveCommand","Condition.NotAIUseWorkspotCommand","Condition.NotIsUsingOffMeshLink","Condition.DroneGriffinShootCooldown","DroneGriffinActions.ShootDefault_inline3","DroneGriffinActions.ShootDefault_inline4","DCO.ShootDefault_inline3"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline3", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline3.OR", {"Condition.TargetBelow45deg","DCO.ShootDefault_inline4"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline4", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline4.AND", {"Condition.FollowerInVehicle","DCO.IsDCO"})

    TweakDB:SetFlat("DroneOctantActions.ShootDefault_inline1.AND", {"DCO.ShootDefault_inline6","DroneOctantActions.ShootDefault_inline2","DroneOctantActions.ShootDefault_inline3","Condition.MaxVisibilityToTargetDistance3m","Condition.NotFriendlyFire"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline6", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline6.OR", {"Condition.TargetBelow35deg","DCO.ShootDefault_inline7"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline7", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline7.AND", {"Condition.FollowerInVehicle","DCO.IsDCO"})

    TweakDB:SetFlat("DroneActions.ShootDefault_inline13.OR", {"DroneActions.ShootDefault_inline14","Condition.CombatTargetChanged","Condition.FriendlyFire","DCO.ShootDefault_inline2"})
    TweakDB:SetFlat("DroneActions.ShootDefault_inline6.OR", {"DroneActions.ShootDefault_inline7","Condition.DontShootCombatTarget","Condition.FriendlyFire","DCO.ShootDefault_inline2"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline2", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline2.AND", {"DCO.IsNotDCO","Condition.TargetAbove90deg"})
    TweakDB:SetFlat("DroneGriffinActions.ShootBurstStatic_inline15.OR", {"Condition.NotMinAccuracyValue0dot95","Condition.CombatTargetChanged","DCO.ShootDefault_inline2","Condition.AIMoveCommand","Condition.AIUseWorkspotCommand","Condition.FriendlyFire","DroneGriffinActions.ShootBurstStatic_inline16"})
    TweakDB:SetFlat("DroneGriffinActions.ShootBurstStatic_inline4.OR", {"DCO.ShootDefault_inline2","Condition.DontShootCombatTarget","Condition.FriendlyFire","DroneGriffinActions.ShootBurstStatic_inline5"})
    TweakDB:SetFlat("DroneGriffinActions.ShootBurstStatic_inline8.OR", {"DCO.ShootDefault_inline2","Condition.DontShootCombatTarget","Condition.FriendlyFire","DroneGriffinActions.ShootBurstStatic_inline9"})
    TweakDB:SetFlat("DroneOctantActions.ShootDefault_inline13.OR", {"Condition.NotMinAccuracyValue0dot95","Condition.CombatTargetChanged","DCO.ShootDefault_inline2","Condition.AIMoveCommand","Condition.AIUseWorkspotCommand","Condition.FriendlyFire","DroneOctantActions.ShootDefault_inline14"})
    TweakDB:SetFlat("DroneOctantActions.ShootDefault_inline8.OR", {"DCO.ShootDefault_inline2","Condition.DontShootCombatTarget","Condition.FriendlyFire","DroneOctantActions.ShootDefault_inline9"})

    addToList("DroneActions.TargetUnreachableRepositionActivationCondition_inline0.AND", "DCO.RepositionCond")
    addToList("DroneActions.WaitWhileTargetUnreachable_inline1.AND", "DCO.RepositionCond")
    addToList("DroneActions.CatchUpSharedVisibilityTargetUnreachable_inline8.AND", "DCO.RepositionCond")
    addToList("DroneActions.CatchUpSprintVisibility_inline6.AND", "DCO.RepositionCond")
    TweakDB:CreateRecord("DCO.RepositionCond", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.RepositionCond.OR", {"DCO.RepositionCond_inline0","DCO.IsNotDCO"})
    TweakDB:CreateRecord("DCO.RepositionCond_inline0", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.RepositionCond_inline0.AND", {"Condition.NotFollowerInVehicle","DCO.IsDCO"})
end

return DCO:new()
