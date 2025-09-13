DCO = {
    description = "DCO"
}

function DCO:new()
    createConstantStatModifier("DCO.FlyingDroneHPBonus", "Multiplier", "BaseStats.Health", 1.5 * FlyingHP)
    createConstantStatModifier("DCO.FlyingDroneVisibilityBonus", "Multiplier", "BaseStats.Visibility", 0.5)
    createConstantStatModifier("DCO.FlyingDroneTBHBonus", "Multiplier", "BaseStats.TBHsBaseCoefficient", 2.0)
    createConstantStatModifier("DCO.FlyingDroneDPSBonus", "Multiplier", "BaseStats.NPCDamage", 1.5 * FlyingDPS)
    addListToList("DCO.FlyingStatGroup", "statModifiers", {"DCO.FlyingDroneHPBonus", "DCO.FlyingDroneDPSBonus", "DCO.FlyingDroneVisibilityBonus", "DCO.FlyingDroneTBHBonus"})

    createConstantStatModifier("DCO.AndroidHPBonus", "Multiplier", "BaseStats.Health", 1 * AndroidHP)
    createConstantStatModifier("DCO.AndroidDPSBonus", "Multiplier", "BaseStats.NPCDamage", 1.5 * AndroidDPS)
    createConstantStatModifier("DCO.AndroidStaggerBonus", "Additive", "BaseStats.StaggerDamageThreshold", 31)
    createConstantStatModifier("DCO.AndroidImpactBonus", "Additive", "BaseStats.ImpactDamageThreshold", 21)
    createConstantStatModifier("DCO.AndroidKnockdownBonus", "Additive", "BaseStats.KnockdownDamageThreshold", -60)
    addListToList("DCO.AndroidStatGroup", "statModifiers", {"DCO.AndroidHPBonus", "DCO.AndroidDPSBonus", "DCO.AndroidStaggerBonus", "DCO.AndroidImpactBonus", "DCO.AndroidKnockdownBonus"})

    createConstantStatModifier("DCO.MechHPBonus", "Multiplier", "BaseStats.Health", 1 * MechHP)
    createConstantStatModifier("DCO.MechVisibilityBonus", "Multiplier", "BaseStats.Visibility", 3)
    createConstantStatModifier("DCO.MechDPSBonus", "Multiplier", "BaseStats.NPCDamage", 1.5 * MechDPS)
    addListToList("DCO.MechStatGroup", "statModifiers", {"DCO.MechHPBonus", "DCO.MechDPSBonus", "DCO.MechVisibilityBonus"})

    createConstantStatModifier("DCO.BombusDismembermentBonus", "Additive", "BaseStats.HitDismembermentFactor", 3)
    for i=1, DroneRecords do
        addToList("DCO.Tier1Bombus"..i..".statModifiers", "DCO.BombusDismembermentBonus")
    end

    createConstantStatModifier("DCO.OctantHPBonus", "Multiplier", "BaseStats.Health", 1.2)
    createConstantStatModifier("DCO.OctantDPSBonus", "Multiplier", "BaseStats.NPCDamage", 1)
    createConstantStatModifier("DCO.OctantHitReactionBonus", "Additive", "BaseStats.HitReactionFactor", 0)
    createConstantStatModifier("DCO.OctantVisibilityBonus", "Multiplier", "BaseStats.Visibility", 2)
    for i=1, DroneRecords do
        addListToList("DCO.Tier1OctantArasaka"..i, "statModifiers", {"DCO.OctantHPBonus", "DCO.OctantDPSBonus", "DCO.OctantHitReactionBonus", "DCO.OctantVisibilityBonus"})
        addListToList("DCO.Tier1OctantMilitech"..i, "statModifiers", {"DCO.OctantHPBonus", "DCO.OctantDPSBonus", "DCO.OctantHitReactionBonus", "DCO.OctantVisibilityBonus"})
    end

    createConstantStatModifier("DCO.KnockdownImmunity", "Additive", "BaseStats.KnockdownImmunity", 1)
    addToList("Character.Mech_Primary_Stat_ModGroup.statModifiers", "DCO.KnockdownImmunity")
    addToList("Character.Drone_Primary_Stat_ModGroup.statModifiers", "DCO.KnockdownImmunity")
    addToList("NPCRarity.Boss.statModifiers", "DCO.KnockdownImmunity")

    limb_stats = {"WoundLArmDamageThreshold", "WoundRArmDamageThreshold", "DismLArmDamageThreshold", "DismRArmDamageThreshold"}
    leg_stats = {"DismLLegDamageThreshold", "DismRLegDamageThreshold"}
    head_stats = {"WoundHeadDamageThreshold", "DismHeadDamageThreshold"}
    temp = {}
    for _, v in ipairs(limb_stats) do
        createConstantStatModifier("DCO.Android"..v.."Adjust", "Additive", "BaseStats."..v, 9999)
        table.insert(temp, "DCO.Android"..v.."Adjust")
    end
    for _, v in ipairs(leg_stats) do
        createConstantStatModifier("DCO.Android"..v.."Adjust", "Additive", "BaseStats."..v, -20)
        table.insert(temp, "DCO.Android"..v.."Adjust")
    end
    for _, v in ipairs(head_stats) do
        createConstantStatModifier("DCO.Android"..v.."Adjust", "Additive", "BaseStats."..v, 10)
        table.insert(temp, "DCO.Android"..v.."Adjust")
    end
    addListToList("DCO.AndroidStatGroup", "statModifiers", temp)
end

return DCO:new()
