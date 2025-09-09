DCO = { description = "DCO" }
local Cron = require("Utilities/Cron.lua")
local MenuCron = require("Utilities/MenuCron.lua")
local GameUI = require("Utilities/GameUI.lua")
local config = require("Utilities/config.lua")


local LanguageSystem = require("Localization/LanguageSystem.lua")

local inGame
local inMenu
local tempKeanuFastTravel = 0

local robotTag
local playerGroup
local forceRagdoll
local trunkBody
local npcDrone
local npcMech
local seInCombat
local seRobot
local seCollapse

local function isRobot(p) return TweakDBInterface.GetCharacterRecord(p:GetRecordID()):TagsContains(robotTag) end
local function teleport(go, pos) local cmd = AITeleportCommand:new(); cmd.position = pos; cmd.doNavTest = false; AIComponent.SendCommand(go, cmd) end
local function companions() return Game.GetCompanionSystem():GetSpawnedEntities() end
local function playerPSM() return Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine) end
local function playerSceneTier() return playerPSM():GetInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier) end

function DCO:new()
  local dronesNeedReset = false
  local elevatorPlayerZ = -1
  local exitPos
  local prevPos
  local QueueingSystemCollapse = false
  local smasherVec
  local smasherTeleportPos
  local startSavePause = false
  local checkCombat = true
  local checkingCombat = false
  local frameCheck = 0
  local frameLimit = 30

  registerForEvent("onInit", function()
    robotTag = CName.new("Robot")
    playerGroup = CName.new("player")
    forceRagdoll = CName.new("ForceRagdollTask")
    trunkBody = CName.new("trunk_body")
    npcDrone = gamedataNPCType.Drone
    npcMech = gamedataNPCType.Mech
    seInCombat = TweakDBID.new("DCO.InCombatSE")
    seRobot = TweakDBID.new("DCO.RobotSE")
    seCollapse = TweakDBID.new("BaseStatusEffect.SystemCollapse")

    prevPos = Vector4:new()
    smasherVec = ToVector4{ x = -1403.2731, y = 144.23668, z = -26.654015, w = 1 }
    smasherTeleportPos = ToVector4{ x = -1385.7981, y = 132.85963, z = -26.64801, w = 1 }

    
    print("DCO: Initializing language system...")
    local curSettings = config.loadFile("Data/config.json")
    local userLanguage = curSettings.Language or "en"
    LanguageSystem:LoadLanguage(userLanguage)
    print("DCO Language System loaded with language: " .. userLanguage)

    print("DCO Language File loaded")
    dofile("Modules/initVars.lua")
    print("DCO vars initialized")
    dofile("Core/DCOUI.lua")
    print("DCO UI loaded")
    
    dofile("Modules/Base Drones.lua")
    print("DCO Base Drones loaded")
    dofile("Modules/Techdecks.lua")
    print("DCO Techdecks loaded")
    
    dofile("DroneLogic/Drone AI - Core.lua")
    print("DCO Drone AI loaded")

    dofile("DroneLogic/Drone AI - Octant_Wyvern_Griffin.lua")
    dofile("DroneLogic/Drone AI - Android.lua")
    dofile("DroneLogic/Drone AI - Mech.lua")
    dofile("DroneLogic/Drone AI - Combat.lua")
    dofile("DroneLogic/Drone AI - Balance.lua")
    dofile("DroneLogic/Drone AI - Vehicles.lua")
    dofile("DroneLogic/Drone AI - Flying.lua")
    dofile("DroneLogic/Drone AI - Bombus.lua")
    print("DCO Drone AI Sub Modules loaded")

    dofile("Modules/Drone Spawning.lua")
    print("DCO Drone Spawning loaded")
    dofile("Modules/Set Values.lua")
    print("DCO Set Values loaded")

    keanuWheezeMenuStuff()
    print("DCO Menu Crons Loaded!")
    print("DCO - Drone Companions fully loaded!")

    Observe('LiftDevice', 'OnAreaExit', function(self, trigger)
      Cron.After(0.2, function()
        exitPos = Game.GetPlayer():GetWorldPosition()
        exitPos.z = elevatorPlayerZ
      end)
      Cron.After(0.35, function()
        local list = companions()
        for i, v in ipairs(list) do
          if v:GetNPCType() ~= npcMech and isRobot(v) and not v:IsDead() then
            teleport(v, exitPos)
            if v:GetNPCType() == npcDrone and not Game.GetPlayer():IsInCombat() then
              v:QueueEvent(CreateForceRagdollEvent(forceRagdoll))
            end
            exitPos.x = exitPos.x + 0.2
          end
        end
      end)
    end)
  end)

  registerForEvent("onUpdate", function(deltaTime)
    MenuCron.Update(deltaTime)
    if startSavePause then
      MenuCron.After(1, function() startSavePause = false end)
    end
    if (not inMenu) and inGame and not startSavePause then
      Cron.Update(deltaTime)
      if LiftDevice.IsPlayerInsideElevator() then
        local bb = playerPSM()
        local elevator = FromVariant(bb:GetVariant(GetAllBlackboardDefs().PlayerStateMachine.CurrentElevator))
        if elevator then
          local playerPos = Game.GetPlayer():GetWorldPosition()
          local elevatorPos = elevator:GetWorldPosition()
          if not (elevatorPos == ToVector4{ x = -1794.691, y = -535.8872, z = 10.113861, w = 1 }) then
            local pos = Vector4:new()
            pos.x = elevatorPos.x
            pos.y = elevatorPos.y
            pos.z = playerPos.z
            pos.x = pos.x - 1
            pos.y = pos.y + 0.5
            local temp = pos.z
            if elevatorPlayerZ > pos.z then
              pos.z = pos.z - (elevatorPlayerZ - pos.z) * 30
            elseif elevatorPlayerZ < pos.z then
              pos.z = pos.z + (pos.z - elevatorPlayerZ) * 30
            end
            elevatorPlayerZ = temp
            local list = companions()
            for i, v in ipairs(list) do
              if v:GetNPCType() ~= npcMech and isRobot(v) and not v:IsDead() then
                teleport(v, pos)
                pos.x = pos.x + 1
              end
            end
          end
        end
      end
      if not Game.GetMountedVehicle(Game.GetPlayer()) then
        if dronesNeedReset then
          local list = companions()
          for i, v in ipairs(list) do
            if v:GetNPCType() == npcDrone and isRobot(v) and not v:IsDead() then
              local pos = v:GetWorldPosition()
              pos.z = prevPos.z
              teleport(v, pos)
              if not Game.GetPlayer():IsInCombat() then
                v:QueueEvent(CreateForceRagdollEvent(forceRagdoll))
              end
            end
          end
          Cron.After(0.1, function() dronesNeedReset = false end)
        end
      else
        if not (playerSceneTier() > 1) then
          dronesNeedReset = true
          local pos = Game.GetPlayer():GetWorldPosition()
          local tempx, tempy, tempz = pos.x, pos.y, pos.z
          pos.x = pos.x + (pos.x - prevPos.x) * 5
          pos.y = pos.y + (pos.y - prevPos.y) * 5
          prevPos.x, prevPos.y, prevPos.z = tempx, tempy, tempz
          pos.z = pos.z + 2
          pos.x = pos.x - 10
          local list = companions()
          for i, v in ipairs(list) do
            if v:GetNPCType() == npcDrone and isRobot(v) and not v:IsDead() then
              pos.x = pos.x + 5
              teleport(v, pos)
            end
          end
        end
      end
      frameCheck = frameCheck + 1
      if frameCheck ~= frameLimit then return end
      frameCheck = 0
      local list = companions()
      for i, v in ipairs(list) do
        if v:GetRecord():TagsContains(robotTag) and v:IsAlive() and (v:IsDead() or not v:IsActive()) then
          local id = v:GetRecordID()
          local pos = v:GetWorldPosition()
          Game.GetCompanionSystem():DespawnSubcharacter(id)
          Game.GetCompanionSystem():SpawnSubcharacterOnPosition(id, Vector4.Vector4To3(pos))
          Cron.After(0.5, function() setSubcharactersFriendly() end)
        end
      end
      if Vector4.Distance(Game.GetPlayer():GetWorldPosition(), smasherVec) < 0.5 then
        for i, v in ipairs(list) do
          if v:GetRecord():TagsContains(robotTag) then
            teleport(v, smasherTeleportPos)
          end
        end
      end
      for i, v in ipairs(list) do
        if v:GetRecord():TagsContains(robotTag) and droneAlive(v) then
          v:GetAttitudeAgent():SetAttitudeGroup(playerGroup)
          v:GetAttitudeAgent():SetAttitudeTowards(Game.GetPlayer():GetAttitudeAgent(), EAIAttitude.AIA_Friendly)
          for a, b in ipairs(list) do
            if b:GetRecord():TagsContains(robotTag) and droneAlive(b) then
              v:GetAttitudeAgent():SetAttitudeTowards(b:GetAttitudeAgent(), EAIAttitude.AIA_Friendly)
            end
          end
        end
      end
      if not QueueingSystemCollapse then
        QueueingSystemCollapse = true
        local aliveDrones = 0
        local playerPos = Game.GetPlayer():GetWorldPosition()
        local statsObjID = StatsObjectID:new()
        statsObjID = Game.GetPlayer():GetEntityID()
        local droneLimit = Game.GetStatsSystem():GetStatValue(statsObjID, gamedataStatType.NPCAnimationTime)
        for i, v in ipairs(list) do
          if isRobot(v) and droneAlive(v) then
            local pos = v:GetWorldPosition()
            local dx, dy, dz = playerPos.x - pos.x, playerPos.y - pos.y, playerPos.z - pos.z
            local myDist = math.sqrt(dx * dx + dy * dy + dz * dz)
            aliveDrones = aliveDrones + 1
            local vertDist = math.abs(playerPos.z - pos.z)
            if aliveDrones > droneLimit then
              StatusEffectHelper.ApplyStatusEffect(v, seCollapse)
            elseif myDist > 200 then
              QueueDespawn(v)
            end
          end
        end
        Cron.After(10.01, function() QueueingSystemCollapse = false end)
      end
      if checkCombat then
        checkCombat = false
        if Game.GetPlayer():IsInCombat() then
          for i, v in ipairs(list) do
            if droneAlive(v) then
              StatusEffectHelper.ApplyStatusEffect(v, seInCombat)
            end
          end
        else
          for i, v in ipairs(list) do
            StatusEffectHelper.RemoveStatusEffect(v, seInCombat)
          end
        end
      else
        if not checkingCombat then
          checkingCombat = true
          Cron.After(1, function()
            checkCombat = true
            checkingCombat = false
          end)
        end
      end
    end
  end)
end

function QueueDespawn(drone)
  Cron.After(10, function()
    local playerPos = Game.GetPlayer():GetWorldPosition()
    local pos = drone:GetWorldPosition()
    local dx, dy, dz = playerPos.x - pos.x, playerPos.y - pos.y, playerPos.z - pos.z
    local myDist = math.sqrt(dx * dx + dy * dy + dz * dz)
    if myDist > 200 then
      local ingdata = CraftingSystem.GetInstance():GetItemCraftingCost(TweakDBInterface.GetItemRecord(TweakDBID.new(TweakDB:GetFlat(drone:GetRecordID() .. '.DCOItem'))))
      local full_loot = sceneTier2OrAbove()
      local quant_mult = full_loot and 1 or 0.5
      for i, v in ipairs(ingdata) do
        Game.GetTransactionSystem():GiveItemByTDBID(Game.GetPlayer(), v.id:GetID(), math.ceil(v.quantity * quant_mult))
      end
      Game.GetCompanionSystem():DespawnSubcharacter(TweakDBID.new(drone:GetRecordID()))
    end
  end)
end

function keanuWheezeMenuStuff()
  inFastTravel = false
  Observe('RadialWheelController', 'OnIsInMenuChanged', function(_, isInMenu) inMenu = isInMenu end)
  GameUI.OnSessionStart(function() inGame = true end)
  GameUI.OnSessionEnd(function() inGame = false end)
  GameUI.OnPhotoModeOpen(function() inMenu = true end)
  GameUI.OnPhotoModeClose(function() inMenu = false end)
  GameUI.IsLoading(function() inMenu = true end)
  inGame = not GameUI.IsDetached()
end

function setSubcharactersFriendly()
  local entitylist = companions()
  for i, v in ipairs(entitylist) do
    if isRobot(v) and not Game.GetStatusEffectSystem():HasStatusEffect(v:GetEntityID(), seRobot) then
      local role = v:GetAIControllerComponent():GetAIRole()
      local newRole = AIFollowerRole.new()
      newRole.followerRef = Game.CreateEntityReference("#player", {})
      v:GetAttitudeAgent():SetAttitudeGroup(playerGroup)
      newRole.attitudeGroupName = playerGroup
      v.isPlayerCompanionCached = true
      v.isPlayerCompanionCachedTimeStamp = 0
      v:GetAIControllerComponent():SetAIRole(newRole)
      v.NPCManager:ScaleToPlayer()
      StatusEffectHelper.ApplyStatusEffect(v, seRobot)
    end
  end
end

function sceneTier2OrAbove()
  local blackboardDefs = Game.GetAllBlackboardDefs()
  local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
  local tier = blackboardPSM:GetInt(blackboardDefs.PlayerStateMachine.SceneTier)
  return tier > 1
end

return DCO:new()
