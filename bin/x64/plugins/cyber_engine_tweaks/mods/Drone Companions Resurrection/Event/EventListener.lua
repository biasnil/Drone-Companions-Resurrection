-- Event/EventListener.lua
-- All gameplay observers and per-frame logic (handlers only)

local CoreDCO  = require("Core/CoreDCO")       -- config + localization (auto-inits)
local CoreCron = require("Core/CoreCron")      -- timers
local Cron, MenuCron = CoreCron.Cron, CoreCron.MenuCron
local GameUI   = require("Utilities/GameUI")   -- optimized GameUI

local M = {}

-- ========= internal state =========
local inGame, inMenu         = false, false
local startSavePause         = false
local dronesNeedReset        = false
local elevatorPlayerZ        = -1
local exitPos, prevPos       = nil, nil
local QueueingSystemCollapse = false
local smasherVec, smasherTeleportPos
local frameCheck, frameLimit = 0, 30

-- ========= helpers =========
local function sceneTier2OrAbove()
  local defs = Game.GetAllBlackboardDefs()
  local bb   = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), defs.PlayerStateMachine)
  local tier = bb:GetInt(defs.PlayerStateMachine.SceneTier)
  return tier > 1
end

local function setSubcharactersFriendly()
  local entities = Game.GetCompanionSystem():GetSpawnedEntities()
  for _, v in ipairs(entities) do
    if TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
       and not Game.GetStatusEffectSystem():HasStatusEffect(v:GetEntityID(), TweakDBID.new("DCO.RobotSE")) then
      local newRole = AIFollowerRole.new()
      newRole.followerRef = Game.CreateEntityReference("#player", {})
      v:GetAttitudeAgent():SetAttitudeGroup(CName.new("player"))
      newRole.attitudeGroupName = CName.new("player")
      v.isPlayerCompanionCached = true
      v.isPlayerCompanionCachedTimeStamp = 0
      v:GetAIControllerComponent():SetAIRole(newRole)
      v.NPCManager:ScaleToPlayer()
      StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("DCO.RobotSE"))
    end
  end
end

local function QueueDespawn(drone)
  Cron.After(10, function()
    local playerPos = Game.GetPlayer():GetWorldPosition()
    local pos       = drone:GetWorldPosition()
    local dx,dy,dz  = playerPos.x - pos.x, playerPos.y - pos.y, playerPos.z - pos.z
    if math.sqrt(dx*dx + dy*dy + dz*dz) > 200 then
      local rec   = TweakDB:GetFlat(drone:GetRecordID()..'.DCOItem')
      local itemR = TweakDBInterface.GetItemRecord(TweakDBID.new(rec))
      local cost  = CraftingSystem.GetInstance():GetItemCraftingCost(itemR)
      local mult  = sceneTier2OrAbove() and 1 or 0.5
      for _, v in ipairs(cost) do
        Game.GetTransactionSystem():GiveItemByTDBID(Game.GetPlayer(), v.id:GetID(), math.ceil(v.quantity * mult))
      end
      Game.GetCompanionSystem():DespawnSubcharacter(TweakDBID.new(drone:GetRecordID()))
    end
  end)
end

local function installMenuObservers()
  Observe('RadialWheelController', 'OnIsInMenuChanged', function(_, isInMenu) inMenu = isInMenu end)

  GameUI.OnSessionStart(function() inGame = true  end)
  GameUI.OnSessionEnd(function()   inGame = false end)
  GameUI.OnPhotoModeOpen(function()  inMenu = true  end)
  GameUI.OnPhotoModeClose(function() inMenu = false end)

  -- initial
  inGame = not GameUI.IsDetached()
end

-- ========= handlers (called from Bus) =========
function M.handleInit()
  -- IDs, names, lists, helpers (globals for legacy modules)
  pcall(require, "initVars")

  -- Build Native Settings UI now (module also self-builds on onInit, but only after require)
  local ok, NS = pcall(require, "Core/CoreNativeSettingUI")
  if ok and NS and NS.build then NS.build() end

  prevPos            = Vector4:new()
  smasherVec         = ToVector4{ x = -1403.2731, y = 144.23668, z = -26.654015, w = 1 }
  smasherTeleportPos = ToVector4{ x = -1385.7981, y = 132.85963, z = -26.64801,  w = 1 }

  -- observers
  installMenuObservers()

  -- elevator exit alignment
  Observe('LiftDevice', 'OnAreaExit', function(_, _trigger)
    Cron.After(0.2, function()
      exitPos   = Game.GetPlayer():GetWorldPosition()
      exitPos.z = elevatorPlayerZ
    end)
    Cron.After(0.35, function()
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v:GetNPCType() ~= gamedataNPCType.Mech
           and TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
           and not v:IsDead() then
          local cmd = AITeleportCommand:new()
          cmd.position = exitPos
          cmd.doNavTest = false
          AIComponent.SendCommand(v, cmd)
          if v:GetNPCType() == gamedataNPCType.Drone and not Game.GetPlayer():IsInCombat() then
            v:QueueEvent(CreateForceRagdollEvent(CName.new("ForceRagdollTask")))
          end
          exitPos.x = exitPos.x + 0.2
        end
      end
    end)
  end)

  print("[DCO] Event listeners ready.")
end

function M.handleTweak()
  -- Run your TweakDB edits when the DB is ready
  pcall(require, "Values/Set Values")
end

function M.handleUpdate(deltaTime)
  -- menu-safe timers (UI animations, short delays)
  MenuCron.Update(deltaTime)

  if startSavePause then
    MenuCron.After(1, function() startSavePause = false end)
  end

  -- only tick gameplay in real session
  if inMenu or not inGame or startSavePause then return end

  Cron.Update(deltaTime)

  -- ===== elevator follower =====
  if LiftDevice.IsPlayerInsideElevator() then
    local defs = Game.GetAllBlackboardDefs()
    local bb   = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), defs.PlayerStateMachine)
    local elevator = FromVariant(bb:GetVariant(defs.PlayerStateMachine.CurrentElevator))
    if elevator then
      local playerPos   = Game.GetPlayer():GetWorldPosition()
      local elevatorPos = elevator:GetWorldPosition()
      -- skip Hanako elevator
      if not (elevatorPos == ToVector4{ x = -1794.691, y = -535.8872, z = 10.113861, w = 1 }) then
        local pos = Vector4:new()
        pos.x, pos.y, pos.z = elevatorPos.x - 1, elevatorPos.y + 0.5, playerPos.z

        local temp = pos.z
        if elevatorPlayerZ > pos.z then
          pos.z = pos.z - (elevatorPlayerZ - pos.z) * 30
        elseif elevatorPlayerZ < pos.z then
          pos.z = pos.z + (pos.z - elevatorPlayerZ) * 30
        end
        elevatorPlayerZ = temp

        for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
          if v:GetNPCType() ~= gamedataNPCType.Mech
             and TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
             and not v:IsDead() then
            local cmd = AITeleportCommand:new()
            cmd.position = pos; cmd.doNavTest = false
            AIComponent.SendCommand(v, cmd)
            pos.x = pos.x + 1
          end
        end
      end
    end
  end

  -- ===== vehicle follow / reset =====
  if not Game.GetMountedVehicle(Game.GetPlayer()) then
    if dronesNeedReset then
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v:GetNPCType() == gamedataNPCType.Drone
           and TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
           and not v:IsDead() then
          local pos = v:GetWorldPosition()
          pos.z = prevPos.z
          local cmd = AITeleportCommand:new()
          cmd.position = pos; cmd.doNavTest = false
          AIComponent.SendCommand(v, cmd)
          if not Game.GetPlayer():IsInCombat() then
            v:QueueEvent(CreateForceRagdollEvent(CName.new("ForceRagdollTask")))
          end
        end
      end
      Cron.After(0.1, function() dronesNeedReset = false end)
    end
  else
    -- Not during restricted scenes
    local defs = Game.GetAllBlackboardDefs()
    local bb   = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), defs.PlayerStateMachine)
    if bb:GetInt(defs.PlayerStateMachine.SceneTier) <= 1 then
      dronesNeedReset = true

      local pos = Game.GetPlayer():GetWorldPosition()
      local tempx, tempy, tempz = pos.x, pos.y, pos.z
      pos.x = pos.x + (pos.x - prevPos.x) * 5
      pos.y = pos.y + (pos.y - prevPos.y) * 5
      prevPos.x, prevPos.y, prevPos.z = tempx, tempy, tempz
      pos.z = pos.z + 2
      pos.x = pos.x - 10

      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v:GetNPCType() == gamedataNPCType.Drone
           and TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
           and not v:IsDead() then
          pos.x = pos.x + 5
          local cmd = AITeleportCommand:new()
          cmd.position = pos; cmd.doNavTest = false
          AIComponent.SendCommand(v, cmd)
        end
      end
    end
  end

  -- ===== throttle heavy checks =====
  frameCheck = frameCheck + 1
  if frameCheck ~= frameLimit then return end
  frameCheck = 0

  -- auto-respawn broken companions
  for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
    if v:GetRecord():TagsContains(CName.new("Robot")) and v:IsAlive() and (v:IsDead() or not v:IsActive()) then
      local id  = v:GetRecordID()
      local pos = v:GetWorldPosition()
      Game.GetCompanionSystem():DespawnSubcharacter(id)
      Game.GetCompanionSystem():SpawnSubcharacterOnPosition(id, Vector4.Vector4To3(pos))
      Cron.After(0.5, setSubcharactersFriendly)
    end
  end

  -- smasher teleport helper
  if Vector4.Distance(Game.GetPlayer():GetWorldPosition(), smasherVec) < 0.5 then
    for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
      if v:GetRecord():TagsContains(CName.new("Robot")) then
        local cmd = AITeleportCommand:new()
        cmd.position = smasherTeleportPos; cmd.doNavTest = false
        AIComponent.SendCommand(v, cmd)
      end
    end
  end

  -- keep attitudes in sync
  local ents = Game.GetCompanionSystem():GetSpawnedEntities()
  for i = 1, #ents do
    local v = ents[i]
    if v:GetRecord():TagsContains(CName.new("Robot")) and v:IsAlive() then
      v:GetAttitudeAgent():SetAttitudeGroup(CName.new("player"))
      v:GetAttitudeAgent():SetAttitudeTowards(Game.GetPlayer():GetAttitudeAgent(), EAIAttitude.AIA_Friendly)
      for j = 1, #ents do
        local b = ents[j]
        if b:GetRecord():TagsContains(CName.new("Robot")) and b:IsAlive() then
          v:GetAttitudeAgent():SetAttitudeTowards(b:GetAttitudeAgent(), EAIAttitude.AIA_Friendly)
        end
      end
    end
  end

  -- Despawn far drones / SystemCollapse when over cap
  if not QueueingSystemCollapse then
    QueueingSystemCollapse = true

    local alive = 0
    local playerPos = Game.GetPlayer():GetWorldPosition()

    for _, v in ipairs(ents) do
      if TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot")) and v:IsAlive() then
        local pos  = v:GetWorldPosition()
        local dx,dy,dz = playerPos.x - pos.x, playerPos.y - pos.y, playerPos.z - pos.z
        local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
        local cap  = Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType.NPCAnimationTime)

        alive = alive + 1
        if alive > cap then
          StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("BaseStatusEffect.SystemCollapse"))
        elseif dist > 200 then
          QueueDespawn(v)
        end
      end
    end

    Cron.After(10.01, function() QueueingSystemCollapse = false end)
  end

  -- combat status effect gate (pulse)
  local function pulseCombatCheck()
    if Game.GetPlayer():IsInCombat() then
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v:IsAlive() then
          StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("DCO.InCombatSE"))
        end
      end
    else
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        StatusEffectHelper.RemoveStatusEffect(v, TweakDBID.new("DCO.InCombatSE"))
      end
    end
  end
  pulseCombatCheck()
  Cron.After(1, pulseCombatCheck)
end

return M
