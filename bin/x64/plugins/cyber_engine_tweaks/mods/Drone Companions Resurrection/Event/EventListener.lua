-- Event/EventListener.lua
-- All gameplay observers and per-frame logic (handlers only)

local CoreDCO  = require("Core/CoreDCO")       -- config + localization (auto-inits)
local CoreCron = require("Core/CoreCron")      -- timers
local Cron, MenuCron = CoreCron.Cron, CoreCron.MenuCron

-- Prefer your Utilities/GameUI; fall back to GameUI if path differs
local GameUI
do
  local ok, mod = pcall(require, "Utilities/GameUI")
  if ok then GameUI = mod else
    ok, mod = pcall(require, "GameUI")
    if ok then GameUI = mod end
  end
end

local M = {}

-- ========= internal state =========
local inGame, inMenu         = false, false
local startSavePause         = false
local dronesNeedReset        = false
local elevatorPlayerZ        = -1
local exitPos, prevPos       = nil, nil
local smasherVec, smasherTeleportPos

-- ========= helpers =========
local function setSubcharactersFriendly()
  local comps = Game.GetCompanionSystem():GetSpawnedEntities()
  for _, v in ipairs(comps) do
    if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
      local id = v:GetRecordID()
      Game.GetCompanionSystem():DespawnSubcharacter(id)
      Game.GetCompanionSystem():SpawnSubcharacterOnPosition(id, Vector4.Vector4To3(v:GetWorldPosition()))
    end
  end
  Cron.After(0.5, function()
    local comps2 = Game.GetCompanionSystem():GetSpawnedEntities()
    for _, v in ipairs(comps2) do
      if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
        Game.GetAttitudeSystem():SetAttitudeRelationToPlayer(v:GetEntityID(), EAIAttitude.AIA_Friendly)
      end
    end
  end)
end

local function installMenuObservers()
  if not GameUI then
    -- Conservative defaults if GameUI helper is missing
    inGame = true
    return
  end

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

  -- Build Native Settings UI now
  local ok, NS = pcall(require, "Core/CoreNativeSettingUI")
  if ok and NS and NS.build then NS.build() end

  prevPos            = Vector4:new()
  smasherVec         = ToVector4{ x = -1403.2731, y = 144.23668, z = -26.654015, w = 1 }
  smasherTeleportPos = ToVector4{ x = -1385.7981, y = 132.85963, z = -26.64801,  w = 1 }

  -- observers
  installMenuObservers()

  -- initial friendly pass after load (tiny pause to avoid cutscenes)
  MenuCron.After(1.0, function()
    if inGame then setSubcharactersFriendly() end
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
  if LiftDevice and LiftDevice.IsPlayerInsideElevator and LiftDevice.IsPlayerInsideElevator() then
    local defs = Game.GetAllBlackboardDefs()
    local bb   = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), defs.PlayerStateMachine)
    local elevator = bb and FromVariant(bb:GetVariant(defs.PlayerStateMachine.CurrentElevator)) or nil
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
          if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
            local cmd = AITeleportCommand:new()
            cmd.position = pos; cmd.doNavTest = false
            AIComponent.SendCommand(v, cmd)
          end
        end
      end
    end
  else
    -- Not during restricted scenes
    local defs = Game.GetAllBlackboardDefs()
    local bb   = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), defs.PlayerStateMachine)
    if bb and bb:GetInt(defs.PlayerStateMachine.SceneTier) <= 1 then
      dronesNeedReset = true

      local pos = Game.GetPlayer():GetWorldPosition()
      local tempx, tempy, tempz = pos.x, pos.y, pos.z
      pos.x = pos.x + (pos.x - (prevPos and prevPos.x or pos.x)) * 5
      pos.y = pos.y + (pos.y - (prevPos and prevPos.y or pos.y)) * 5
      if not prevPos then prevPos = Vector4:new() end
      prevPos.x, prevPos.y, prevPos.z = tempx, tempy, tempz
      pos.z = pos.z + 2
      pos.x = pos.x - 10

      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
          local cmd = AITeleportCommand:new()
          cmd.position = pos; cmd.doNavTest = false
          AIComponent.SendCommand(v, cmd)
        end
      end
    end

    if dronesNeedReset then
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v
          and v:GetNPCType() == gamedataNPCType.Drone
          and TweakDBInterface.GetCharacterRecord(v:GetRecordID()):TagsContains(CName.new("Robot"))
          and not v:IsDead()
        then
          local p = v:GetWorldPosition()
          p.z = prevPos and prevPos.z or p.z
          local cmd = AITeleportCommand:new()
          cmd.position = p; cmd.doNavTest = false
          AIComponent.SendCommand(v, cmd)
          if not Game.GetPlayer():IsInCombat() then
            v:QueueEvent(CreateForceRagdollEvent(CName.new("ForceRagdollTask")))
          end
        end
      end
      dronesNeedReset = false
      Cron.After(0.1, function() dronesNeedReset = false end)
    end
  end

  -- auto-respawn broken companions
  for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
    if v and v:GetRecord()
       and v:GetRecord():TagsContains(CName.new("Robot"))
       and v:IsAlive()
       and (v:IsDead() or not v:IsActive())
    then
      local id  = v:GetRecordID()
      local pos = v:GetWorldPosition()
      Game.GetCompanionSystem():DespawnSubcharacter(id)
      Game.GetCompanionSystem():SpawnSubcharacterOnPosition(id, Vector4.Vector4To3(pos))
      Cron.After(0.5, setSubcharactersFriendly)
    end
  end

  -- smasher teleport helper
  if smasherVec and Vector4.Distance(Game.GetPlayer():GetWorldPosition(), smasherVec) < 0.5 then
    for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
      if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
        local cmd = AITeleportCommand:new()
        cmd.position = smasherTeleportPos; cmd.doNavTest = false
        AIComponent.SendCommand(v, cmd)
      end
    end
  end

  -- pulse combat status effect (example of periodic task)
  local function pulseCombatCheck()
    if Game.GetPlayer():IsInCombat() then
      for _, v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v and v:GetRecord() and v:GetRecord():TagsContains(CName.new("Robot")) then
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
