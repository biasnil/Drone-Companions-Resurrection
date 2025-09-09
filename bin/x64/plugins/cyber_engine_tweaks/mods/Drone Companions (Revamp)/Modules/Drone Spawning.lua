DCO = { 
    description = "DCO"
}

local filename = "DCO/Drone Spawning"
local Cron     = Cron     or require("Utilities/Cron.lua")
local MenuCron = MenuCron or require("Utilities/MenuCron.lua")

local droneSaveData = {
    records = {},
    hp = {},
    position = {},
    statusEffects = {},
}

function DCO:new()
    GameSession.IdentifyAs('_dco_session_key')
    GameSession.StoreInDir('sessions')
    GameSession.Persist(droneSaveData)

    GameSession.OnSaveData(function(state)
        inc = 0
        for i, record in ipairs(Full_Drone_List) do
            entityList = Game.GetCompanionSystem():GetSpawnedEntities(TweakDBID.new(record))
            if table.getn(entityList) == 1 and droneAlive(entityList[1]) then
                inc = inc + 1
                entity = entityList[1]
                droneSaveData.records[inc] = record
                droneSaveData.hp[inc] = Game.GetStatPoolsSystem():GetStatPoolValue(entity:GetEntityID(), gamedataStatPoolType.Health)
                droneSaveData.position[inc] = entity:GetWorldPosition()
                tempSEList = {}
                for _, SE in ipairs(Game.GetStatusEffectSystem():GetAppliedEffects(entity:GetEntityID())) do
                    table.insert(tempSEList, SE:GetRecord():GetID())
                end
                droneSaveData.statusEffects[inc] = tempSEList
            end
        end
    end)

    GameSession.OnStart(function(state)
        startSavePause = true
        MenuCron.After(2, function()
            playerVehicle = Game.GetMountedVehicle(Game.GetPlayer())
            if playerVehicle then
                playerVehicle.DCOBackLeftTaken = false
                playerVehicle.DCOBackRightTaken = false
                playerVehicle.DCOFrontRightTaken = false
            end

            temphptable = {}
            tempSEtable = {}
            numDrones = table.getn(droneSaveData.records)

            for i, record in ipairs(droneSaveData.records) do
                hp = droneSaveData.hp[i]
                position = droneSaveData.position[i]
                statusEffects = droneSaveData.statusEffects[i]
                temphptable[record] = hp
                tempSEtable[record] = statusEffects
                posv3 = Vector3:new()
                posv3.x = position.x
                posv3.y = position.y
                posv3.z = position.z
                Game.GetCompanionSystem():SpawnSubcharacterOnPosition(TweakDBID.new(record), posv3)
            end

            setFriendlyOnLoad(numDrones)
            adjustHPOnLoad(numDrones, temphptable, Full_Drone_List)
            SEAndDismemberOnLoad(numDrones, tempSEtable, Full_Drone_List)

            Cron.After(5, function()
                cleanDroneSaveData()
            end)
        end)
    end)

    local droneFastTravelData = {
        records = {},
        hp = {},
        statusEffects = {},
    }

    tempFastTravel = 0
    Observe('FastTravelSystem', 'OnLoadingScreenFinished', function(_, _)
        tempFastTravel = tempFastTravel + 1
        Cron.After(5, function()
            temphptable = {}
            tempSEtable = {}
            numDrones = table.getn(droneFastTravelData.records)
            for i, record in ipairs(droneFastTravelData.records) do
                hp = droneFastTravelData.hp[i]
                statusEffects = droneFastTravelData.statusEffects[i]
                position = Game.GetPlayer():GetWorldPosition()
                temphptable[record] = hp
                tempSEtable[record] = statusEffects
                posv3 = Vector3:new()
                posv3.x = position.x - 0.5
                posv3.y = position.y
                posv3.z = position.z
                Game.GetCompanionSystem():SpawnSubcharacterOnPosition(TweakDBID.new(record), posv3)
            end
            setFriendlyOnLoad(numDrones)
            adjustHPOnLoad(numDrones, temphptable, Full_Drone_List)
            SEAndDismemberOnLoad(numDrones, tempSEtable, Full_Drone_List)
            droneFastTravelData.records = {}
            droneFastTravelData.hp = {}
            droneFastTravelData.statusEffects = {}
        end)
        tempFastTravel = 0
    end)

    Observe('FastTravelSystem', 'SetFastTravelStarted', function()
        inc = 0
        for i, record in ipairs(Full_Drone_List) do
            entityList = Game.GetCompanionSystem():GetSpawnedEntities(TweakDBID.new(record))
            if table.getn(entityList) == 1 and droneAlive(entityList[1]) then
                inc = inc + 1
                entity = entityList[1]
                droneFastTravelData.records[inc] = record
                droneFastTravelData.hp[inc] = Game.GetStatPoolsSystem():GetStatPoolValue(entity:GetEntityID(), gamedataStatPoolType.Health)
                tempSEList = {}
                for _, SE in ipairs(Game.GetStatusEffectSystem():GetAppliedEffects(entity:GetEntityID())) do
                    table.insert(tempSEList, SE:GetRecord():GetID())
                end
                droneFastTravelData.statusEffects[inc] = tempSEList
                Game.GetCompanionSystem():DespawnSubcharacter(TweakDBID.new(record))
            end
        end
    end)

    canCraftDrone = true
    tempDroneCountIncrement = 0
    canDespawn = true
    tempMechIncrement = {0}
    Mech_TDB = {}
    for i, v in ipairs(Mech_List) do
        table.insert(Mech_TDB, TweakDBID.new(v))
    end

    RemoveFreeCraftingStat = gameConstantStatModifierData:new()
    RemoveFreeCraftingStat.value = 0
    RemoveFreeCraftingStat.statType = gamedataStatType.CraftingMaterialRetrieveChance
    RemoveFreeCraftingStat.modifierType = gameStatModifierType.Multiplier

    Override('CraftingLogicController', 'CraftItem', function(self, selectedRecipe, amount, wrappedMethod)
        local isDcoDrone = has_value(drones_list, selectedRecipe.label)
        if isDcoDrone then
            local statsObjID = StatsObjectID:new()
            statsObjID = Game.GetPlayer():GetEntityID()
            Game.GetStatsSystem():AddModifier(statsObjID, RemoveFreeCraftingStat)
        end

        wrappedMethod(selectedRecipe, amount)

        if isDcoDrone then
            tempDroneCountIncrement = 1
            MenuCron.After(0.5, function()
                tempDroneCountIncrement = 0
                local statsObjID = StatsObjectID:new()
                statsObjID = Game.GetPlayer():GetEntityID()
                Game.GetStatsSystem():RemoveModifier(statsObjID, RemoveFreeCraftingStat)
            end)

            local heading = Game.GetPlayer():GetWorldForward()
            local offsetDir = ToVector3{heading.x, heading.y, heading.z}
            local recordEnt = {}
            local droneDistances = {}

            for i = 1, DroneRecords do
                recordEnt[1] = TweakDBID.new(drone_records[selectedRecipe.label]..i)
                local entityList = Game.GetCompanionSystem():GetSpawnedEntities(recordEnt[1])

                if #entityList == 0 then
                    Game.GetCompanionSystem():DespawnSubcharacter(recordEnt[1])
                    Game.GetCompanionSystem():SpawnSubcharacter(recordEnt[1], 2 + math.random(10,40)/10, offsetDir)
                    prev_spawn = recordEnt[1]
                    break
                else
                    if not droneAlive(entityList[1]) then
                        table.insert(droneDistances, Vector4.Distance(Game.GetPlayer():GetWorldPosition(), entityList[1]:GetWorldPosition()))
                    else
                        table.insert(droneDistances, -1)
                    end
                end

                if i == DroneRecords then
                    local longestDist, longestDistIndex = -1, 1
                    for a, b in ipairs(droneDistances) do
                        if b > longestDist then longestDistIndex, longestDist = a, b end
                    end
                    recordEnt[1] = TweakDBID.new(drone_records[selectedRecipe.label]..longestDistIndex)
                    Game.GetCompanionSystem():DespawnSubcharacter(recordEnt[1])
                    Game.GetCompanionSystem():SpawnSubcharacter(recordEnt[1], 2 + math.random(10,40)/10, offsetDir)
                    prev_spawn = recordEnt[1]
                end
            end

            if has_value(Mech_TDB, recordEnt[1]) then
                tempMechIncrement[1] = 1
                MenuCron.After(0.5, function() tempMechIncrement[1] = 0 end)
            end

            MenuCron.After(Friendly_Time, function() setSubcharactersFriendly() end)
        end
    end)

    Override('ItemFilterToggleController', 'GetLabelKey', function(self, wrappedMethod)
        str = wrappedMethod()
        if str == "Lockey#45229" then
            str = Crafting_Tab_String
        end
        return str
    end)

    Override('ItemFilterCategories', 'GetIcon;ItemFilterCategory', function(filterType, wrappedMethod)
        if filterType == ItemFilterCategory.Cyberware then
            return "UIIcon.DCOCraftingIcon"
        end
        return wrappedMethod(filterType)
    end)

    TweakDB:CreateRecord("UIIcon.DCOCraftingIcon", "gamedataUIIcon_Record")
    TweakDB:SetFlatNoUpdate("UIIcon.DCOCraftingIcon.atlasPartName", "icon_part")
    TweakDB:SetFlat("UIIcon.DCOCraftingIcon.atlasResourcePath", "base\\icon\\dcocraftingicon_atlas.inkatlas")
    TweakDB:Update("UIIcon.DCOCraftingIcon")

    TweakDB:CreateRecord("DCO.RobotSE", "gamedataStatusEffect_Record")
    TweakDB:SetFlatNoUpdate("DCO.RobotSE.duration", "BaseStats.InfiniteDuration")
    TweakDB:SetFlat("DCO.RobotSE.statusEffectType", "BaseStatusEffectTypes.Misc")
    TweakDB:Update("DCO.RobotSE")

    TweakDB:CreateRecord("DCO.IsDCO", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.IsDCO.statusEffect", "DCO.RobotSE")
    TweakDB:SetFlatNoUpdate("DCO.IsDCO.invert", false)
    TweakDB:SetFlat("DCO.IsDCO.target", "AIActionTarget.Owner")
    TweakDB:Update("DCO.IsDCO")

    TweakDB:CreateRecord("DCO.IsNotDCO", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.IsNotDCO.statusEffect", "DCO.RobotSE")
    TweakDB:SetFlatNoUpdate("DCO.IsNotDCO.invert", true)
    TweakDB:SetFlat("DCO.IsNotDCO.target", "AIActionTarget.Owner")
    TweakDB:Update("DCO.IsNotDCO")
end

function droneAlive(drone)
    return not drone:IsIncapacitated()
end

function createSEForAI(name)
    TweakDB:CreateRecord("DCO.RobotSE", "gamedataStatusEffect_Record")
    TweakDB:SetFlatNoUpdate("DCO.RobotSE.duration", "BaseStats.InfiniteDuration")
    TweakDB:SetFlat("DCO.RobotSE.statusEffectType", "BaseStatusEffectTypes.Misc")
    TweakDB:CreateRecord("DCO.IsDCO", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.IsDCO.statusEffect", "DCO.RobotSE")
    TweakDB:SetFlatNoUpdate("DCO.IsDCO.invert", false)
    TweakDB:SetFlat("DCO.IsDCO.target", "AIActionTarget.Owner")
    TweakDB:CreateRecord("DCO.IsNotDCO", "gamedataAIStatusEffectCond_Record")
    TweakDB:SetFlatNoUpdate("DCO.IsNotDCO.statusEffect", "DCO.RobotSE")
    TweakDB:SetFlatNoUpdate("DCO.IsNotDCO.invert", true)
    TweakDB:SetFlat("DCO.IsNotDCO.target", "AIActionTarget.Owner")
    TweakDB:Update("DCO.RobotSE")
    TweakDB:Update("DCO.IsDCO")
    TweakDB:Update("DCO.IsNotDCO")
end

function sceneTier3OrAbove()
    local blackboardDefs = Game.GetAllBlackboardDefs()
    local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
    local tier = blackboardPSM:GetInt(blackboardDefs.PlayerStateMachine.SceneTier)
    return tier > 2
end

function combatDisabled()
    local bbdefs = Game.GetAllBlackboardDefs()
    if Game.GetStatusEffectSystem():HasStatusEffectWithTag(Game.GetPlayer():GetEntityID(), CName.new("NoCrafting"))
    or Game.GetStatusEffectSystem():HasStatusEffectWithTag(Game.GetPlayer():GetEntityID(), CName.new("NoJump"))
    or Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), bbdefs.PlayerStateMachine):GetInt(bbdefs.PlayerStateMachine.Zones) == 2
    or Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), bbdefs.PlayerStateMachine):GetBool(bbdefs.PlayerStateMachine.SceneSafeForced)
    or StatusEffectSystem.ObjectHasStatusEffectWithTag(Game.GetPlayer(), CName.new("NoCombat"))
    or Game.GetPlayer():GetPlayerStateMachineBlackboard():GetInt(bbdefs.PlayerStateMachine.UpperBody) == EnumInt(gamePSMUpperBodyStates.ForceEmptyHands) then
        return true
    end
    return false
end

function playerInVehicle()
    local mf = Game.GetMountingFacility()
    if not mf then return false end
    local info = mf:GetMountingInfoSingleWithObjects(Game.GetPlayer())
    return info and info.parentId and Game.FindEntityByID(info.parentId) ~= nil
end

function cleanDroneSaveData()
    droneSaveData.records = {}
    droneSaveData.hp = {}
    droneSaveData.position = {}
    droneSaveData.statusEffects = {}
end

function SEAndDismemberOnLoad(droneCount, SEtable, Full_Drone_List)
    MenuCron.After(Friendly_Time, function()
        for _, record in ipairs(Full_Drone_List or {}) do
            local entityList = (Game.GetCompanionSystem() and Game.GetCompanionSystem():GetSpawnedEntities(TweakDBID.new(record))) or {}
            if #entityList == 1 then
                local entity = entityList[1]
                for _, SE in ipairs((SEtable and SEtable[record]) or {}) do
                    StatusEffectHelper.ApplyStatusEffect(entity, SE)
                    if SE == TweakDBID.new("BaseStatusEffect.DismemberedArmRight") then
                        DismembermentComponent.RequestDismemberment(entity, gameDismBodyPart.RIGHT_ARM, gameDismWoundType.CLEAN)
                    elseif SE == TweakDBID.new("BaseStatusEffect.DismemberedArmLeft") then
                        DismembermentComponent.RequestDismemberment(entity, gameDismBodyPart.LEFT_ARM, gameDismWoundType.CLEAN)
                    elseif SE == TweakDBID.new("BaseStatusEffect.DismemberedLegLeft") then
                        DismembermentComponent.RequestDismemberment(entity, gameDismBodyPart.LEFT_LEG, gameDismWoundType.CLEAN)
                    elseif SE == TweakDBID.new("BaseStatusEffect.DismemberedLegRight") then
                        DismembermentComponent.RequestDismemberment(entity, gameDismBodyPart.RIGHT_LEG, gameDismWoundType.CLEAN)
                    elseif SE == TweakDBID.new("BaseStatusEffect.AndroidHeadRemovedBlind") then
                        DismembermentComponent.RequestDismemberment(entity, gameDismBodyPart.HEAD, gameDismWoundType.CLEAN)
                    elseif SE == TweakDBID.new("Minotaur.RightArmDestroyed") then
                        local wc = entity:GetWeakspotComponent()
                        if wc then
                            for _, weakspot in ipairs(wc:GetWeakspots() or {}) do
                                if weakspot:GetRecord():GetID() == TweakDBID.new("Weakspots.Mech_Weapon_Right_Weakspot") then
                                    ScriptedWeakspotObject.Kill(weakspot)
                                end
                            end
                        end
                    elseif SE == TweakDBID.new("Minotaur.LeftArmDestroyed") then
                        local wc = entity:GetWeakspotComponent()
                        if wc then
                            for _, weakspot in ipairs(wc:GetWeakspots() or {}) do
                                if weakspot:GetRecord():GetID() == TweakDBID.new("Weakspots.Mech_Weapon_Left_Weakspot") then
                                    ScriptedWeakspotObject.Kill(weakspot)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function adjustHPOnLoad(droneCount, hptable, Full_Drone_List)
    MenuCron.After(Friendly_Time, function()
        local sps = Game.GetStatPoolsSystem()
        for _, record in ipairs(Full_Drone_List or {}) do
            local entityList = (Game.GetCompanionSystem() and Game.GetCompanionSystem():GetSpawnedEntities(TweakDBID.new(record))) or {}
            if #entityList == 1 then
                local entity = entityList[1]
                local hp = hptable and hptable[record] or nil
                if hp then
                    sps:RequestSettingStatPoolValue(entity:GetEntityID(), gamedataStatPoolType.Health, hp, entity)
                end
            end
        end
    end)
end

function setFriendlyOnLoad(droneCount, count)
    MenuCron.After(Friendly_Time, function()
        setSubcharactersFriendly()
    end)
end

function setSubcharactersFriendly()
    local list = (Game.GetCompanionSystem() and Game.GetCompanionSystem():GetSpawnedEntities()) or {}
    for _, v in ipairs(list) do
        if IsDefined(v) and v.IsNPC and v:IsNPC() then
            local crec = TweakDBInterface.GetCharacterRecord(v:GetRecordID())
            if crec and crec:TagsContains(CName.new("Robot")) and not Game.GetStatusEffectSystem():HasStatusEffect(v:GetEntityID(), TweakDBID.new("DCO.RobotSE")) then
                local newRole = AIFollowerRole.new()
                newRole.followerRef = Game.CreateEntityReference("#player", {})
                v:GetAttitudeAgent():SetAttitudeGroup(CName.new("player"))
                newRole.attitudeGroupName = CName.new("player")
                v.isPlayerCompanionCached = true
                v.isPlayerCompanionCachedTimeStamp = 0
                v:GetAIControllerComponent():SetAIRole(newRole)
                StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("DCO.RobotSE"))
            end
        end
    end
end

return DCO:new()
