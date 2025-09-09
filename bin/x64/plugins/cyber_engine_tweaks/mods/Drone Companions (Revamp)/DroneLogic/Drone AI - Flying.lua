DCO = {
    description = "DCO"
}

function DCO:new()
    -- LOWER FLYING DRONES
    for _, v in ipairs(Flying_List) do
        TweakDB:SetFlat(v..".combatDefaultZOffset", -0.2)
    end

    -- MAKE FLYING DRONES ATTACK MORE OFTEN
    -- Wyvern: bypass strict distance/friendly-fire when our followers are present
    TweakDB:SetFlat("DroneActions.ShootDefault_inline1.AND",
        {"DCO.ShootDefault_inline0", "DroneActions.ShootDefault_inline2", "DroneActions.ShootDefault_inline3", "DCO.ShootDefault_inline10"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline10", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline10.OR", {"DCO.IsDCO", "DCO.ShootDefault_inline11"})
    TweakDB:CreateRecord("DCO.ShootDefault_inline11", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ShootDefault_inline11.AND", {"Condition.OptimalDistance10mTolerance", "Condition.NotFriendlyFire"})

    -- Griffin: relax friendly fire gating under DCO
    addToList("DroneGriffinActions.ShootDefault_inline4.OR", "DCO.IsDCO")

    -- Octant: similar relaxation using OR(IsDCO, NotFriendlyFire)
    TweakDB:SetFlat("DroneOctantActions.ShootDefault_inline1.AND",
        {"DCO.ShootDefault_inline6", "DroneOctantActions.ShootDefault_inline2", "DroneOctantActions.ShootDefault_inline3",
         "Condition.MaxVisibilityToTargetDistance3m", "DCO.OctantShootDefault_inline0"})
    TweakDB:CreateRecord("DCO.OctantShootDefault_inline0", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.OctantShootDefault_inline0.OR", {"DCO.IsDCO", "Condition.NotFriendlyFire"})

    -- FLYING DRONE STRAFING: remove not-follower check
    TweakDB:SetFlat("DroneActions.StrafeSelectorActivationCondition.AND",
        {"Condition.NotStatusEffectWhistleLvl3", "Condition.NotIsUsingOffMeshLink", "Condition.NotAIMoveCommand",
         "Condition.NotAIUseWorkspotCommand", "Condition.NotIsNPCUnderLocomotionMalfunctionQuickhack",
         "Condition.CanMoveInRegardsToShooting", "Condition.NotTargetInVehicle"})
end

return DCO:new()
