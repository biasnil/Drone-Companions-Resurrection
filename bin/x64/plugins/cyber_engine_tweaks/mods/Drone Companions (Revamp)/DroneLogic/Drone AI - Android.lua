DCO = {
    description = "DCO"
}

function DCO:new()
    -------------------------------------------------
    -- ANDROID AI: give smarter action maps
    -------------------------------------------------
    local Basic_Android_List  = {"DCO.Tier1AndroidMelee","DCO.Tier1AndroidRanged","DCO.Tier1AndroidShotgunner"}
    local Fancy_Android_List  = {"DCO.Tier1AndroidHeavy","DCO.Tier1AndroidSniper","DCO.Tier1AndroidNetrunner"}
    for a = 1, DroneRecords do
        for _, rec in ipairs(Basic_Android_List) do
            TweakDB:SetFlat(rec..a..".actionMap", "Gang.Map")
        end
        for _, rec in ipairs(Fancy_Android_List) do
            TweakDB:SetFlat(rec..a..".actionMap", "Corpo.Map")
        end
    end

    -------------------------------------------------
    -- PREVENT ROBOTS FROM TRYING TO STEALTH (T-pose fix)
    -------------------------------------------------
    TweakDB:SetFlat("FollowerActions.EnterStealth_inline0.condition", "DCO.EnterStealthCondition")
    TweakDB:CloneRecord("DCO.EnterStealthCondition", "Condition.EnterStealthCondition")
    addToList("DCO.EnterStealthCondition.AND", "Condition.Human")

    -------------------------------------------------
    -- FIX ANDROID "PAUSING FOLLOW" (custom follow Far)
    -------------------------------------------------
    TweakDB:CloneRecord("DCO.AndroidFollowFar", "FollowerActions.FollowFar")
    TweakDB:SetFlatNoUpdate("DCO.AndroidFollowFar.activationCondition", "DCO.AndroidFollowFar_inline0")
    TweakDB:SetFlat("DCO.AndroidFollowFar.loop", "DCO.AndroidFollowFar_inline2")

    TweakDB:CreateRecord("DCO.AndroidFollowFar_inline0", "gamedataAIActionCondition_Record")
    TweakDB:SetFlat("DCO.AndroidFollowFar_inline0.condition", "DCO.AndroidFollowFar_inline1")

    TweakDB:CloneRecord("DCO.AndroidFollowFar_inline1", "FollowerActions.FollowFar_inline1")
    addToList("DCO.AndroidFollowFar_inline1.AND", "Condition.Android")

    TweakDB:CloneRecord("DCO.AndroidFollowFar_inline2", "FollowerActions.FollowFar_inline2")
    TweakDB:SetFlat("DCO.AndroidFollowFar_inline2.movePolicy", "DCO.AndroidFollowFar_inline3")

    TweakDB:CloneRecord("DCO.AndroidFollowFar_inline3", "FollowerActions.FollowSprintMovePolicy")
    TweakDB:SetFlat("DCO.AndroidFollowFar_inline3.movementType", "Walk")

    local followNodes = TweakDB:GetFlat("FollowerActions.FollowComposite.nodes")
    if not has_value(followNodes, TweakDBID.new("DCO.AndroidFollowFar")) then
        table.insert(followNodes, 7, "DCO.AndroidFollowFar")
        TweakDB:SetFlat("FollowerActions.FollowComposite.nodes", followNodes)
    end
    addToList("FollowerActions.FollowComposite.nodes", "DCO.AndroidFollowFar")
    addToList("FollowerActions.FollowFar_inline1.AND", "Condition.NotAndroid")

    -------------------------------------------------
    -- ANDROID THROW GRENADE: enable for robots (not followers)
    -------------------------------------------------
    -- Base OR wrapper for open-field throwing
    TweakDB:CreateRecord("DCO.ThrowGrenadeSelectorCondition", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.ThrowGrenadeSelectorCondition.OR", {"DCO.ThrowGrenadeSelectorConditionOriginal", "DCO.ThrowGrenadeSelectorConditionAndroid"})

    TweakDB:CloneRecord("DCO.ThrowGrenadeSelectorConditionOriginal", "Condition.ThrowGrenadeSelectorCondition")
    TweakDB:SetFlat("DCO.ThrowGrenadeSelectorConditionOriginal.AND",
        {"Condition.InitThrowGrenadeCooldown","Condition.NotAIThrowGrenadeCommand","Condition.NotAIAimAtTargetCommand","Condition.NotTicketCatchUp",
         "Condition.MinAccuracyValue0","Condition.BaseThrowGrenadeSelectorCondition","Condition.NotIsFollower","Condition.NotTargetInSafeZone",
         "Condition.ThrowGrenadeSelectorCondition_inline0","Condition.Human"})

    TweakDB:SetFlat("Condition.ThrowGrenadeSelectorCondition.AND", {"DCO.ThrowGrenadeSelectorCondition"})

    TweakDB:CreateRecord("DCO.ThrowGrenadeSelectorConditionAndroid", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.ThrowGrenadeSelectorConditionAndroid.AND",
        {"DCO.IsDCO","Condition.Android","Condition.InitThrowGrenadeCooldown","Condition.NotAIThrowGrenadeCommand","Condition.NotAIAimAtTargetCommand",
         "Condition.NotTicketCatchUp","Condition.MinAccuracyValue0","DCO.BaseThrowGrenadeSelectorConditionAndroid","DCO.ThrowGrenadeCooldown_inline0"})

    TweakDB:CreateRecord("DCO.BaseThrowGrenadeSelectorConditionAndroid", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.BaseThrowGrenadeSelectorConditionAndroid.AND",
        {"DCO.IsDCO","Condition.Android","Condition.NotHasAnyWeaponLeft","Condition.AbilityCanUseGrenades","Condition.NotIsInWorkspot",
         "Condition.NotIsUsingOffMeshLink","Condition.NotIsEnteringOrLeavingCover","Condition.NotTicketEquip","Condition.HasAnyWeapon",
         "Condition.NotTicketSync","Condition.NotTicketTakeCover","Condition.ThrowCond"})

    -- Cover OR wrapper
    TweakDB:CreateRecord("DCO.CoverThrowGrenadeSelectorCondition", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.CoverThrowGrenadeSelectorCondition.OR", {"DCO.CoverThrowGrenadeSelectorConditionOriginal","DCO.CoverThrowGrenadeSelectorConditionAndroid"})

    TweakDB:CloneRecord("DCO.CoverThrowGrenadeSelectorConditionOriginal", "Condition.CoverThrowGrenadeSelectorCondition")
    TweakDB:SetFlat("DCO.CoverThrowGrenadeSelectorConditionOriginal.AND",
        {"Condition.AbilityCanUseGrenades","Condition.NotHasAnyWeaponLeft","Condition.NotTicketEquip","Condition.NotTicketSync",
         "Condition.ThrowCond","Condition.NotIsFollower","Condition.CheckChosenExposureMethodAll","Condition.NotTargetInSafeZone","Condition.Human"})

    TweakDB:SetFlat("Condition.CoverThrowGrenadeSelectorCondition.AND", {"DCO.CoverThrowGrenadeSelectorCondition"})

    TweakDB:CreateRecord("DCO.CoverThrowGrenadeSelectorConditionAndroid", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.CoverThrowGrenadeSelectorConditionAndroid.AND",
        {"DCO.IsDCO","Condition.Android","Condition.AbilityCanUseGrenades","Condition.NotHasAnyWeaponLeft","Condition.NotTicketEquip",
         "Condition.NotTicketSync","Condition.ThrowCond","DCO.CheckChosenExposureMethodAll","DCO.ThrowGrenadeCooldown_inline0"})

    -- Commanded throw: allow either human base or our android base
    TweakDB:CreateRecord("DCO.CommandThrowGrenadeSelector", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.CommandThrowGrenadeSelector.OR", {"Condition.BaseThrowGrenadeSelectorCondition","DCO.BaseThrowGrenadeSelectorConditionAndroid"})
    TweakDB:SetFlat("ItemHandling.CommandThrowGrenadeSelector_inline1.AND", {"Condition.AIThrowGrenadeCommand","DCO.CommandThrowGrenadeSelector","DCO.ThrowGrenadeCooldown_inline0"})

    -------------------------------------------------
    -- GRENADE AI: cooldowns and actions
    -------------------------------------------------
    TweakDB:CreateRecord("DCO.ThrowGrenadeCooldown", "gamedataAIActionCooldown_Record")
    TweakDB:SetFlatNoUpdate("DCO.ThrowGrenadeCooldown.duration", 8)
    TweakDB:SetFlat("DCO.ThrowGrenadeCooldown.name", "ThrowGrenade")
    TweakDB:CreateRecord("DCO.ThrowGrenadeCooldown_inline0", "gamedataAICooldownCond_Record")
    TweakDB:SetFlat("DCO.ThrowGrenadeCooldown_inline0.cooldowns", {"DCO.ThrowGrenadeCooldown"})

    local near_conditions    = {"Condition.Android","Condition.ThrowGrenadeNearCondition"}
    local regular_conditions = {"Condition.Android","Condition.ThrowGrenadeCondition"}

    -- Cutting
    createAndroidGrenadeAction("DCO.ThrowCuttingGrenadeNear",  "ItemHandling.ThrowGrenadeNearCutting",  "DCO.AndroidGrenadeCutting",           near_conditions,    "HackBuffSturdiness")
    createAndroidGrenadeAction("DCO.ThrowCuttingGrenadeCover", "CoverActions.ThrowGrenadeCoverCutting", "DCO.AndroidGrenadeCutting",           regular_conditions, "HackBuffSturdiness")
    createAndroidGrenadeAction("DCO.ThrowCuttingGrenade",      "ItemHandling.ThrowGrenadeCutting",      "DCO.AndroidGrenadeCutting",           regular_conditions, "HackBuffSturdiness")

    -- EMP (robots only)
    local c = {"Condition.Android","DCO.TargetIsRobot","Condition.ThrowGrenadeNearCondition"}
    createAndroidGrenadeAction("DCO.ThrowEMPGrenadeNear",      "ItemHandling.ThrowGrenadeNearEMP",      "DCO.AndroidGrenadeEMPRegular",        c,                  "HackBuffCamo")
    c = {"Condition.Android","DCO.TargetIsRobot","Condition.ThrowGrenadeCondition"}
    createAndroidGrenadeAction("DCO.ThrowEMPGrenadeCover",     "CoverActions.ThrowGrenadeCoverEMP",     "DCO.AndroidGrenadeEMPHoming",         c,                  "HackBuffCamo")
    createAndroidGrenadeAction("DCO.ThrowEMPGrenade",          "ItemHandling.ThrowGrenadeEMP",          "DCO.AndroidGrenadeEMPHoming",         c,                  "HackBuffCamo")

    -- Biohazard (humans only)
    c = {"Condition.Android","DCO.TargetIsHuman","Condition.ThrowGrenadeNearCondition"}
    createAndroidGrenadeAction("DCO.ThrowBiohazardGrenadeNear","ItemHandling.ThrowGrenadeNearBiohazard", "DCO.AndroidGrenadeBiohazardRegular", c,                  "HackDeath")
    c = {"Condition.Android","DCO.TargetIsHuman","Condition.ThrowGrenadeCondition"}
    createAndroidGrenadeAction("DCO.ThrowBiohazardGrenadeCover","CoverActions.ThrowGrenadeCoverBiohazard","DCO.AndroidGrenadeBiohazardHoming", c,                  "HackDeath")
    createAndroidGrenadeAction("DCO.ThrowBiohazardGrenade",    "ItemHandling.ThrowGrenadeBiohazard",     "DCO.AndroidGrenadeBiohazardHoming", c,                   "HackDeath")

    -- Incendiary
    createAndroidGrenadeAction("DCO.ThrowIncendiaryGrenadeNear","ItemHandling.ThrowGrenadeNearIncendiary","DCO.AndroidGrenadeIncendiaryRegular", near_conditions,    "HackOverload")
    createAndroidGrenadeAction("DCO.ThrowIncendiaryGrenadeCover","CoverActions.ThrowGrenadeCoverIncendiary","DCO.AndroidGrenadeIncendiaryHoming", regular_conditions, "HackOverload")
    createAndroidGrenadeAction("DCO.ThrowIncendiaryGrenade",    "ItemHandling.ThrowGrenadeIncendiary",    "DCO.AndroidGrenadeIncendiaryHoming",  regular_conditions, "HackOverload")

    -- Frag
    createAndroidGrenadeAction("DCO.ThrowFragGrenadeNear",     "ItemHandling.ThrowGrenadeNearFrag",      "DCO.AndroidGrenadeFragRegular",       near_conditions,    "HackOverheat")
    createAndroidGrenadeAction("DCO.ThrowFragGrenadeCover",    "CoverActions.ThrowGrenadeCoverFrag",     "DCO.AndroidGrenadeFragHoming",        regular_conditions, "HackOverheat")
    createAndroidGrenadeAction("DCO.ThrowFragGrenade",         "ItemHandling.ThrowGrenadeFrag",          "DCO.AndroidGrenadeFragHoming",        regular_conditions, "HackOverheat")

    -- Flash
    createAndroidGrenadeAction("DCO.ThrowFlashGrenadeNear",    "ItemHandling.ThrowGrenadeNearFlash",     "Items.GrenadeFlashRegular",           near_conditions,    "HackWeaponMalfunction")
    createAndroidGrenadeAction("DCO.ThrowFlashGrenadeCover",   "CoverActions.ThrowGrenadeCoverFlash",    "Items.GrenadeFlashHoming",            regular_conditions, "HackWeaponMalfunction")
    createAndroidGrenadeAction("DCO.ThrowFlashGrenade",        "ItemHandling.ThrowGrenadeFlash",         "Items.GrenadeFlashHoming",            regular_conditions, "HackWeaponMalfunction")

    -- Hook actions into selectors
    local cover_grenade_actions = {"DCO.ThrowCuttingGrenadeCover","DCO.ThrowEMPGrenadeCover","DCO.ThrowBiohazardGrenadeCover","DCO.ThrowFlashGrenadeCover","DCO.ThrowFragGrenadeCover","DCO.ThrowIncendiaryGrenadeCover"}
    local grenade_actions       = {"DCO.ThrowCuttingGrenade","DCO.ThrowEMPGrenade","DCO.ThrowBiohazardGrenade","DCO.ThrowFlashGrenade","DCO.ThrowFragGrenade","DCO.ThrowIncendiaryGrenade"}
    local near_grenade_actions  = {"DCO.ThrowCuttingGrenadeNear","DCO.ThrowEMPGrenadeNear","DCO.ThrowBiohazardGrenadeNear","DCO.ThrowFlashGrenadeNear","DCO.ThrowFragGrenadeNear","DCO.ThrowIncendiaryGrenadeNear"}

    local tmp = TweakDB:GetFlat("ItemHandling.ThrowGrenadeSelector.actions")
    TweakDB:SetFlat("ItemHandling.ThrowGrenadeSelector.actions", near_grenade_actions)
    addListToList("ItemHandling.ThrowGrenadeSelector","actions", grenade_actions)
    addListToList("ItemHandling.ThrowGrenadeSelector","actions", tmp)

    tmp = TweakDB:GetFlat("ItemHandling.CommandThrowGrenadeSelector.actions")
    TweakDB:SetFlat("ItemHandling.CommandThrowGrenadeSelector.actions", near_grenade_actions)
    addListToList("ItemHandling.CommandThrowGrenadeSelector","actions", grenade_actions)
    addListToList("ItemHandling.CommandThrowGrenadeSelector","actions", tmp)

    tmp = TweakDB:GetFlat("CoverActions.CoverThrowGrenadeSelector.actions")
    TweakDB:SetFlat("CoverActions.CoverThrowGrenadeSelector.actions", cover_grenade_actions)
    addListToList("CoverActions.CoverThrowGrenadeSelector","actions", tmp)

    tmp = TweakDB:GetFlat("CoverActions.CommandCoverThrowGrenadeSelector.actions")
    TweakDB:SetFlat("CoverActions.CommandCoverThrowGrenadeSelector.actions", cover_grenade_actions)
    addListToList("CoverActions.CommandCoverThrowGrenadeSelector","actions", tmp)

    -------------------------------------------------
    -- MAKE OUR ANDROID GRENADES (records + homing)
    -------------------------------------------------
    local function recordExists(id) return TweakDB:GetRecord(id) ~= nil end
    local function ensureHomingGDM()
        if recordExists("DCO.HomingGDM") then return end
        local bases = {"Items.GrenadeBiohazardHoming_inline0","Items.GrenadeFlashHoming_inline0","Items.GrenadeFlash_inline0"}
        for _, b in ipairs(bases) do
            if recordExists(b) then
                TweakDB:CloneRecord("DCO.HomingGDM", b)
                TweakDB:SetFlat("DCO.HomingGDM.freezeDelay", 1.1, "Float")
                return
            end
        end
    end
    ensureHomingGDM()

    if not recordExists("DCO.AndroidGrenadeFragHoming") then
        createAndroidDamageGrenade("DCO.AndroidGrenadeFragHoming",
            recordExists("Items.GrenadeFragHoming") and "Items.GrenadeFragHoming" or "Items.GrenadeFragRegular", 8)
    end
    TweakDB:SetFlat("DCO.AndroidGrenadeFragHoming.deliveryMethod", "DCO.HomingGDM")

    if not recordExists("DCO.AndroidGrenadeBiohazardRegular") then
        createAndroidSEGrenade("DCO.AndroidGrenadeBiohazardRegular", "Items.GrenadeBiohazardRegular", 1.5, "BaseStats.ChemicalDamage", "Attacks.LowChemicalDamageOverTime")
    end
    if not recordExists("DCO.AndroidGrenadeBiohazardHoming") then
        createAndroidSEGrenade("DCO.AndroidGrenadeBiohazardHoming",
            recordExists("Items.GrenadeBiohazardHoming") and "Items.GrenadeBiohazardHoming" or "Items.GrenadeBiohazardRegular",
            1.5, "BaseStats.ChemicalDamage", "Attacks.LowChemicalDamageOverTime")
    end
    TweakDB:SetFlat("DCO.AndroidGrenadeBiohazardHoming.deliveryMethod", "DCO.HomingGDM")

    if not recordExists("DCO.AndroidGrenadeEMPRegular") then
        createAndroidSEGrenade("DCO.AndroidGrenadeEMPRegular", "Items.GrenadeEMPRegular", 1.5, "BaseStats.ElectricDamage", "Attacks.LowElectricDamageOverTime")
    end
    if not recordExists("DCO.AndroidGrenadeEMPHoming") then
        createAndroidSEGrenade("DCO.AndroidGrenadeEMPHoming",
            recordExists("Items.GrenadeEMPHoming") and "Items.GrenadeEMPHoming" or "Items.GrenadeEMPRegular",
            1.5, "BaseStats.ElectricDamage", "Attacks.LowElectricDamageOverTime")
    end
    TweakDB:SetFlat("DCO.AndroidGrenadeEMPHoming.deliveryMethod", "DCO.HomingGDM")

    if not recordExists("DCO.AndroidGrenadeIncendiaryRegular") then
        createAndroidSEGrenade("DCO.AndroidGrenadeIncendiaryRegular", "Items.GrenadeIncendiaryRegular", 1.5, "BaseStats.ThermalDamage", "Attacks.EnemyNetrunnerThermalDamageOverTime")
    end
    if not recordExists("DCO.AndroidGrenadeIncendiaryHoming") then
        createAndroidSEGrenade("DCO.AndroidGrenadeIncendiaryHoming",
            recordExists("Items.GrenadeIncendiaryHoming") and "Items.GrenadeIncendiaryHoming" or "Items.GrenadeIncendiaryRegular",
            1.5, "BaseStats.ThermalDamage", "Attacks.EnemyNetrunnerThermalDamageOverTime")
    end
    TweakDB:SetFlat("DCO.AndroidGrenadeIncendiaryHoming.deliveryMethod", "DCO.HomingGDM")

    if not recordExists("DCO.AndroidGrenadeCutting") then
        createAndroidDamageGrenade("DCO.AndroidGrenadeCutting", "Items.GrenadeCuttingRegular", 0.4)
    end
    TweakDB:SetFlat("DCO.AndroidGrenadeCutting_inline0.hitCooldown", 0.8, "Float")
    TweakDB:SetFlat("DCO.AndroidGrenadeCutting.isContinuousEffect", true)
    TweakDB:SetFlat("DCO.AndroidGrenadeCutting.delayToDetonate", 2.0, "Float")
    TweakDB:SetFlat("DCO.AndroidGrenadeCutting.numberOfHitsForAdditionalAttack", 5, "Int32")
    -- copy free flats from base if present
    for _, f in ipairs({"addAxisRotationDelay","addAxisRotationSpeedMax","addAxisRotationSpeedMin","effectCooldown",
                         "freezeDelayAfterBounce","minimumDistanceFromFloor","stopAttackDelay"}) do
        local src = TweakDB:GetFlat("Items.GrenadeCuttingRegular."..f)
        if src ~= nil then
            if type(src) == "number" then
                local t = (math.type and math.type(src) == "integer") and "Int32" or "Float"
                TweakDB:SetFlat("DCO.AndroidGrenadeCutting."..f, src, t)
            else
                TweakDB:SetFlat("DCO.AndroidGrenadeCutting."..f, src)
            end
        end
    end

    -------------------------------------------------
    -- ANDROID NETRUNNER AI: maps & conditions
    -------------------------------------------------
    for i = 1, DroneRecords do
        TweakDB:SetFlat("DCO.Tier1AndroidNetrunner"..i..".actionMap", "CorpoNetrunner.Map")
    end

    -- Standing hack selector (human vs android split)
    TweakDB:CloneRecord("DCO.HumanHackSelectorCondition", "Condition.HackSelectorCondition")
    addToList("DCO.HumanHackSelectorCondition.AND", "Condition.Human")

    TweakDB:CreateRecord("DCO.AndroidHackSelectorCondition", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.AndroidHackSelectorCondition.AND",
        {"Condition.AbilityCanQuickhack","Condition.CombatTarget","Condition.TargetAbove7m","Condition.NotIsUsingOffMeshLink",
         "Condition.TargetNotPlayerFollower","Condition.Android","DCO.NetrunnerHackCooldownCond","DCO.IsDCO"})

    TweakDB:CreateRecord("DCO.HackSelectorCondition", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.HackSelectorCondition.OR", {"DCO.AndroidHackSelectorCondition","DCO.HumanHackSelectorCondition"})
    TweakDB:SetFlat("Condition.HackSelectorCondition.AND", {"DCO.HackSelectorCondition"})

    -- Cover hack selector (human vs android split)
    TweakDB:CloneRecord("DCO.HumanCoverHackSelectorCondition", "Condition.CoverHackSelectorCondition")
    addToList("DCO.HumanCoverHackSelectorCondition.AND", "Condition.Human")

    TweakDB:CreateRecord("DCO.AndroidCoverHackSelectorCondition", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.AndroidCoverHackSelectorCondition.AND",
        {"Condition.AbilityCanQuickhack","Condition.CombatTarget","Condition.TargetAbove7m","Condition.InCover",
         "Condition.TargetNotPlayerFollower","Condition.Android","DCO.NetrunnerHackCooldownCond","DCO.IsDCO"})

    TweakDB:CreateRecord("DCO.CoverHackSelectorCondition", "gamedataAIActionOR_Record")
    TweakDB:SetFlat("DCO.CoverHackSelectorCondition.OR", {"DCO.AndroidCoverHackSelectorCondition","DCO.HumanCoverHackSelectorCondition"})
    TweakDB:SetFlat("Condition.CoverHackSelectorCondition.AND", {"DCO.CoverHackSelectorCondition"})

    -- Base netrunner cooldowns
    TweakDB:CreateRecord("DCO.NetrunnerHackCooldown", "gamedataAIActionCooldown_Record")
    TweakDB:SetFlatNoUpdate("DCO.NetrunnerHackCooldown.duration", 8)
    TweakDB:SetFlat("DCO.NetrunnerHackCooldown.name", "ThrowGrenade")
    TweakDB:CreateRecord("DCO.NetrunnerHackCooldownCond", "gamedataAICooldownCond_Record")
    TweakDB:SetFlat("DCO.NetrunnerHackCooldownCond.cooldowns", {"DCO.NetrunnerHackCooldown"})

    createHackCooldown("DCO.DamageHackCooldown",        "NetrunnerActions.HackOverheat_inline0",        40)
    createHackCooldown("DCO.ContagionHackCooldown",     "NetrunnerActions.HackOverload_inline0",        40)
    createHackCooldown("DCO.BlindHackCooldown",         "NetrunnerActions.HackBuffCamo_inline0",        40)
    createHackCooldown("DCO.CrippleHackCooldown",       "NetrunnerActions.HackLocomotion_inline0",      40)
    createHackCooldown("DCO.WeaponHackCooldown",        "NetrunnerActions.HackWeaponMalfunction_inline0",40)
    createHackCooldown("DCO.CyberpsychosisHackCooldown","NetrunnerActions.HackDeath_inline0",          180)
    createHackCooldown("DCO.GrenadeHackCooldown",       "NetrunnerActions.HackDeath_inline0",           90)

    -- Hook android hack actions into selectors
    local hacklist      = {"DCO.AndroidMadness","DCO.AndroidOverload","DCO.AndroidSynapseBurnout","DCO.AndroidContagion","DCO.AndroidOverheat","DCO.AndroidWeaponJam","DCO.AndroidBlind","DCO.AndroidCripple"}
    local coverhacklist = {"DCO.AndroidCoverMadness","DCO.AndroidCoverOverload","DCO.AndroidCoverSynapseBurnout","DCO.AndroidCoverContagion","DCO.AndroidCoverOverheat","DCO.AndroidCoverWeaponJam","DCO.AndroidCoverBlind","DCO.AndroidCoverCripple"}
    addListToList("NetrunnerActions.HackActionSelector", "actions", hacklist)
    addListToList("NetrunnerActions.CoverHackSelector", "actions", coverhacklist)
    addListToList("NetrunnerActions.CommandCoverHackSelector", "actions", coverhacklist)

    -------------------------------------------------
    -- VARIOUS CONDITIONS used by hacks
    -------------------------------------------------
    createSEHackCond("DCO.NotTargetHasMadness",                 "BaseStatusEffect.Madness")
    createSEHackCond("DCO.NotTargetHasAndroidOverheatSE",       "DCO.AndroidOverheatSE")
    createSEHackCond("DCO.NotTargetHasAndroidOverloadSE",       "DCO.AndroidOverloadSE")
    createSEHackCond("DCO.NotTargetHasAndroidContagionSE",      "DCO.AndroidContagionSE")
    createSEHackCond("DCO.NotTargetHasWeaponMalfunction",       "BaseStatusEffect.WeaponMalfunction")
    createSEHackCond("DCO.NotTargetHasAndroidBlindSE",          "DCO.AndroidBlindSE")
    createSEHackCond("DCO.NotTargetHasAndroidCrippleSE",        "DCO.AndroidCrippleSE")

    -- Convenience cooldown-cond (sometimes referenced)
    TweakDB:CreateRecord("DCO.NetrunnerHackCooldown_inline0", "gamedataAICooldownCond_Record")
    TweakDB:SetFlat("DCO.NetrunnerHackCooldown_inline0.cooldowns", {"DCO.NetrunnerHackCooldown"})

    -------------------------------------------------
    -- ANDROID HACKS
    -------------------------------------------------
    -- Overheat
    createAndroidHack("DCO.AndroidOverheat", "DCO.AndroidOverheatSE", 5, "DCO.ContagionHackCooldown")
    createHackStatusEffect("DCO.AndroidOverheatSE", "AIQuickHackStatusEffect.HackOverheat", 10)
    createContinuousAttack("DCO.AndroidOverheatSE", "BaseStats.ThermalDamage", "Attacks.EnemyNetrunnerThermalDamageOverTime", 0.1)
    addStatusEffectNotPresentCond("DCO.AndroidOverheat_inline5", "DCO.AndroidOverheatSE")

    -- Overload (robots only)
    createAndroidHack("DCO.AndroidOverload", "DCO.AndroidOverloadSE", 5, "DCO.ContagionHackCooldown")
    createHackStatusEffect("DCO.AndroidOverloadSE", "BaseStatusEffect.OverloadLevel2", 10)
    createContinuousAttack("DCO.AndroidOverloadSE", "BaseStats.ElectricDamage", "Attacks.OverloadQuickHackAttackLevel1", 0.1)
    addStatusEffectNotPresentCond("DCO.AndroidOverload_inline5", "DCO.AndroidOverloadSE")
    TweakDB:CloneRecord("DCO.AndroidOverloadSEUIData", "BaseStatusEffect.Electrocuted_inline0")
    TweakDB:SetFlat("DCO.AndroidOverloadSEUIData.priority", -9, "Int32")
    TweakDB:SetFlat("DCO.AndroidOverloadSE.uiData", "DCO.AndroidOverloadSEUIData")
    TweakDB:CloneRecord("DCO.TargetIsRobot", "Condition.Android")
    TweakDB:SetFlatNoUpdate("DCO.TargetIsRobot.target", "AIActionTarget.CombatTarget")
    TweakDB:SetFlat("DCO.TargetIsRobot.allowedNPCTypes", {"NPCType.Android","NPCType.Drone","NPCType.Mech"})
    addToList("DCO.AndroidOverload_inline5.AND", "DCO.TargetIsRobot")

    -- Synapse Burnout (low HP)
    createAndroidHack("DCO.AndroidSynapseBurnout", "BaseStatusEffect.BrainMeltLevel2", 5, "DCO.DamageHackCooldown")
    addToList("DCO.AndroidSynapseBurnout_inline5.AND", "DCO.AndroidSynapseBurnoutLowHPCond")
    TweakDB:CloneRecord("DCO.AndroidSynapseBurnoutLowHPCond", "Condition.HealthBelow50perc")
    TweakDB:SetFlat("DCO.AndroidSynapseBurnoutLowHPCond.target", "AIActionTarget.CombatTarget")

    -- Contagion (high HP humans)
    createAndroidHack("DCO.AndroidContagion", "DCO.AndroidContagionSE", 5, "DCO.ContagionHackCooldown")
    createHackStatusEffect("DCO.AndroidContagionSE", "BaseStatusEffect.Poisoned", 20)
    createContinuousAttack("DCO.AndroidContagionSE", "BaseStats.ChemicalDamage", "Attacks.ContagionPoisonAttack", 0.05)
    addStatusEffectNotPresentCond("DCO.AndroidContagion_inline5", "DCO.AndroidContagionSE")
    TweakDB:CloneRecord("DCO.TargetIsHuman", "Condition.Android")
    TweakDB:SetFlatNoUpdate("DCO.TargetIsHuman.target", "AIActionTarget.CombatTarget")
    TweakDB:SetFlat("DCO.TargetIsHuman.allowedNPCTypes", {"NPCType.Human"})
    TweakDB:CloneRecord("DCO.AndroidContagionHighHPCond", "Condition.HealthAbove75perc")
    TweakDB:SetFlat("DCO.AndroidContagionHighHPCond.target", "AIActionTarget.CombatTarget")
    addListToList("DCO.AndroidContagion_inline5", "AND", {"DCO.TargetIsHuman","DCO.AndroidContagionHighHPCond"})

    -- Weapon Jam
    createAndroidHack("DCO.AndroidWeaponJam", "DCO.AndroidWeaponJamSE", 5, "DCO.WeaponHackCooldown")
    createHackStatusEffect("DCO.AndroidWeaponJamSE", "BaseStatusEffect.WeaponMalfunction", 12)
    addStatusEffectNotPresentCond("DCO.AndroidWeaponJam_inline5", "BaseStatusEffect.WeaponMalfunction")
    TweakDB:SetFlat("DCO.AndroidWeaponJam_inline3.statusEffect", "BaseStatusEffect.WeaponMalfunction")

    -- Blind
    createAndroidHack("DCO.AndroidBlind", "DCO.AndroidBlindSE", 5, "DCO.BlindHackCooldown")
    createHackStatusEffect("DCO.AndroidBlindSE", "BaseStatusEffect.Blind", 8)
    addStatusEffectNotPresentCond("DCO.AndroidBlind_inline5", "DCO.AndroidBlindSE")

    -- Cripple
    createAndroidHack("DCO.AndroidCripple", "DCO.AndroidCrippleSE", 5, "DCO.CrippleHackCooldown")
    createHackStatusEffect("DCO.AndroidCrippleSE", "BaseStatusEffect.LocomotionMalfunction", 12)
    addStatusEffectNotPresentCond("DCO.AndroidCripple_inline5", "DCO.AndroidCrippleSE")

    -- Madness (actually System Reset) – robots but not mechs
    createAndroidHack("DCO.AndroidMadness", "DCO.AndroidMadnessSE", 5, "DCO.CyberpsychosisHackCooldown")
    createHackStatusEffect("DCO.AndroidMadnessSE", "BaseStatusEffect.Madness", 60)
    TweakDB:SetFlat("DCO.AndroidMadness_inline3.statusEffect", "BaseStatusEffect.SystemCollapse")
    TweakDB:CloneRecord("DCO.TargetIsRobotNoMech", "Condition.Android")
    TweakDB:SetFlatNoUpdate("DCO.TargetIsRobotNoMech.target", "AIActionTarget.CombatTarget")
    TweakDB:SetFlat("DCO.TargetIsRobotNoMech.allowedNPCTypes", {"NPCType.Android","NPCType.Drone"})
    addToList("DCO.AndroidMadness_inline5.AND", "DCO.TargetIsRobotNoMech")

    -- Cover variants
    createAndroidCoverHack("DCO.AndroidCoverOverheat",        "DCO.AndroidOverheat")
    createAndroidCoverHack("DCO.AndroidCoverOverload",        "DCO.AndroidOverload")
    createAndroidCoverHack("DCO.AndroidCoverContagion",       "DCO.AndroidContagion")
    createAndroidCoverHack("DCO.AndroidCoverSynapseBurnout",  "DCO.AndroidSynapseBurnout")
    createAndroidCoverHack("DCO.AndroidCoverWeaponJam",       "DCO.AndroidWeaponJam")
    createAndroidCoverHack("DCO.AndroidCoverCripple",         "DCO.AndroidCripple")
    createAndroidCoverHack("DCO.AndroidCoverBlind",           "DCO.AndroidBlind")
    createAndroidCoverHack("DCO.AndroidCoverMadness",         "DCO.AndroidMadness")

    -------------------------------------------------
    -- VISUAL / RULES TWEAKS FOR HACKING
    -------------------------------------------------
    -- Remove visible network link line for android netrunners
    Observe('ScriptedPuppet', 'OnNetworkLinkQuickhackEvent', function(self, evt)
        local runner = Game.FindEntityByID(evt.netrunnerID)
        if runner and TweakDBInterface.GetCharacterRecord(runner:GetRecordID()):TagsContains(CName.new("Robot")) then
            Cron.After(5, function()
                self:GetPS():DrawBetweenEntities(false, true, self:GetFxResourceByKey(CName.new("pingNetworkLink")),
                    evt.to, evt.from, false, false, false, false)
            end)
        end
    end)

    -- Fix "only one hack can apply" bug
    TweakDB:SetFlat("AIQuickHackStatusEffect.BeingHacked_inline1.value", 5, "Float")

    -- Disable vanilla human-only hack actions for androids
    local disableList = {"Death","Locomotion","Overheat","Overload","WeaponMalfunction"}
    for _, v in ipairs(disableList) do
        addToList("NetrunnerActions.Hack"..v.."_inline2.AND", "Condition.Human")
    end


    TweakDB:Update("DCO.AndroidFollowFar")
    TweakDB:Update("DCO.ThrowGrenadeCooldown")
    TweakDB:Update("DCO.NetrunnerHackCooldown")
    TweakDB:Update("DCO.TargetIsRobot")
    TweakDB:Update("DCO.TargetIsHuman")
    TweakDB:Update("DCO.TargetIsRobotNoMech")
    
    local dco_updates = {
      "DCO.ThrowCuttingGrenadeNear","DCO.ThrowCuttingGrenadeCover","DCO.ThrowCuttingGrenade",
      "DCO.ThrowEMPGrenadeNear","DCO.ThrowEMPGrenadeCover","DCO.ThrowEMPGrenade",
      "DCO.ThrowBiohazardGrenadeNear","DCO.ThrowBiohazardGrenadeCover","DCO.ThrowBiohazardGrenade",
      "DCO.ThrowIncendiaryGrenadeNear","DCO.ThrowIncendiaryGrenadeCover","DCO.ThrowIncendiaryGrenade",
      "DCO.ThrowFragGrenadeNear","DCO.ThrowFragGrenadeCover","DCO.ThrowFragGrenade",
      "DCO.ThrowFlashGrenadeNear","DCO.ThrowFlashGrenadeCover","DCO.ThrowFlashGrenade",
      "DCO.AndroidOverheat","DCO.AndroidOverload","DCO.AndroidSynapseBurnout","DCO.AndroidContagion",
      "DCO.AndroidWeaponJam","DCO.AndroidBlind","DCO.AndroidCripple","DCO.AndroidMadness",
      "DCO.AndroidCoverOverheat","DCO.AndroidCoverOverload","DCO.AndroidCoverContagion",
      "DCO.AndroidCoverSynapseBurnout","DCO.AndroidCoverWeaponJam","DCO.AndroidCoverCripple",
      "DCO.AndroidCoverBlind","DCO.AndroidCoverMadness"
    }
    
    for _, id in ipairs(dco_updates) do
      if TweakDB:GetRecord(id) ~= nil then
        TweakDB:Update(id)
      end
    end

end

return DCO:new()
