local GameSession = {
    version = '1.4.2',
    framework = '1.19.0'
}

GameSession.Event = {
    Start = 'Start',
    End = 'End',
    Pause = 'Pause',
    Resume = 'Resume',
    Blur = 'Blur',
    Focus = 'Focus',
    Death = 'Death',
    Load = 'Load',
    Save = 'Save',
    Clean = 'Clean',
    LoadData = 'LoadData',
    SaveData = 'SaveData',
    Update = 'Update',
    Saves = 'Saves',
    Persistence = 'Persistence',
}

local initialized = {}
local listeners = {}

-- === Fast locals + singleton cache (OO-ish inside) ===
local _pairs, _ipairs = pairs, ipairs
local _tostring = tostring

local S = {
  bb_sys = nil,
  bb_def = nil,
  events = {},
  firing = {},
}

function S:getBB()
  local BB = self.bb_sys
  local DEF = self.bb_def
  if not BB then BB = Game.GetBlackboardSystem(); self.bb_sys = BB end
  if not DEF then DEF = Game.GetAllBlackboardDefs(); self.bb_def = DEF end
  return BB, DEF
end

function S:clear(t)
  for k in _pairs(t) do t[k] = nil end
end

local eventScopes = {
    [GameSession.Event.Update] = {},
    [GameSession.Event.Load] = { [GameSession.Event.Saves] = true },
    [GameSession.Event.Save] = { [GameSession.Event.Saves] = true },
    [GameSession.Event.Clean] = { [GameSession.Event.Saves] = true },
    [GameSession.Event.LoadData] = { [GameSession.Event.Saves] = true, [GameSession.Event.Persistence] = true },
    [GameSession.Event.SaveData] = { [GameSession.Event.Saves] = true, [GameSession.Event.Persistence] = true },
}

GameSession.Scope = {
    Session = 'Session',
    Pause = 'Pause',
    Blur = 'Blur',
    Death = 'Death',
    Saves = 'Saves',
    Persistence = 'Persistence',
}

local isLoaded = false
local isPaused = true
local isBlurred = false
local isDead = false
local timestamp = 0
local timestamps = 0
local sessionKey = 0

local stateProps = {
    { current = 'isLoaded', previous = 'wasLoaded', event = { on = GameSession.Event.Start, off = GameSession.Event.End, change = GameSession.Scope.Session, scope = GameSession.Scope.Session } },
    { current = 'isPaused', previous = 'wasPaused', event = { on = GameSession.Event.Pause, off = GameSession.Event.Resume, change = GameSession.Scope.Pause, scope = GameSession.Scope.Pause }, parent = 'isLoaded' },
    { current = 'isBlurred', previous = 'wasBlurred', event = { on = GameSession.Event.Blur, off = GameSession.Event.Focus, change = GameSession.Scope.Blur, scope = GameSession.Scope.Blur }, parent = 'isLoaded' },
    { current = 'isDead', previous = 'wasDead', event = { on = GameSession.Event.Death, scope = GameSession.Scope.Death }, parent = 'isLoaded' },
    { current = 'timestamp' },
    { current = 'timestamps' },
    { current = 'sessionKey' },
}

local previousState = {}

local function updateLoaded(loaded)
    local changed = isLoaded ~= loaded
    isLoaded = loaded
    return changed
end

local function updatePaused(isMenuActive)
    isPaused = not isLoaded or isMenuActive
end

local function updateBlurred(isBlurActive)
    isBlurred = isBlurActive
end

local function updateDead(isPlayerDead)
    isDead = isPlayerDead
end

local function updateTimestamp()
    timestamp = os.time()
    timestamps = timestamps + 1
end

local function isEmptySessionKey(key)
    return (key or sessionKey) == 0
end

local function setSessionKey(key)
    sessionKey = key
end

local function getSessionKey()
    return sessionKey
end

local function refreshCurrentState()
    local player = Game.GetPlayer()

    local BB, DEF = S:getBB()
    local blackboardUI = BB:Get(DEF.UI_System)
    local blackboardPM = BB:Get(DEF.PhotoMode)

    local menuActive      = blackboardUI:GetBool(DEF.UI_System.IsInMenu)
    local blurActive      = blackboardUI:GetBool(DEF.UI_System.CircularBlurEnabled)
    local photoModeActive = blackboardPM:GetBool(DEF.PhotoMode.IsActive)
    local tutorialActive  = Game.GetTimeSystem():IsTimeDilationActive('UI_TutorialPopup')

    if not isLoaded then
        updateLoaded(player:IsAttached() and not isPreGame())
    end

    updatePaused(menuActive or photoModeActive or tutorialActive)
    updateBlurred(blurActive)
    updateDead(player:IsDeadNoStatPool())
end

local function getCurrentState()
    return {
        isLoaded = isLoaded,
        isPaused = isPaused,
        isBlurred = isBlurred,
        isDead = isDead,
        timestamp = timestamp,
        timestamps = timestamps,
        sessionKey = sessionKey,
    }
end

local function isPreGame()
    return Game.GetSettingsSystem():GetSystemRequestsHandler():IsPreGame()
end

local function dispatchEvent(event, state)
    if listeners[event] then
        state.event = event
        for _, callback in ipairs(listeners[event]) do
            callback(state)
        end
        state.event = nil
    end
end

-- State Observing --

local function determineEvents(currentState)
  local events, firing = S.events, S.firing
  S:clear(events); S:clear(firing)

  local e = 1
  events[e] = GameSession.Event.Update

  for _, stateProp in _ipairs(stateProps) do
    local currentValue  = currentState[stateProp.current]
    local previousValue = previousState[stateProp.current]

    if stateProp.event and (not stateProp.parent or currentState[stateProp.parent]) then
      local reqOK = true
      if stateProp.event.reqs then
        for reqProp, reqValue in _pairs(stateProp.event.reqs) do
          if _tostring(currentState[reqProp]) ~= _tostring(reqValue) then
            reqOK = false; break
          end
        end
      end

      if reqOK then
        local ev = stateProp.event

        if ev.change and previousValue ~= nil then
          if _tostring(currentValue) ~= _tostring(previousValue) then
            local name = ev.change
            if not firing[name] then e = e + 1; events[e] = name; firing[name] = true end
          end
        end

        if ev.on and currentValue and not previousValue then
          local name = ev.on
          if not firing[name] then e = e + 1; events[e] = name; firing[name] = true end
        elseif ev.off and not currentValue and previousValue then
          local name = ev.off
          if not firing[name] then
            -- ensure OFF fires first
            for j = e, 1, -1 do events[j+1] = events[j] end
            events[1] = name
            e = e + 1
            firing[name] = true
          end
        end
      end
    end
  end

  return events, #events
end

local function notifyObservers()
  local currentState = GameSession.GetState()

  local changed = false
  for _, stateProp in _ipairs(stateProps) do
    if _tostring(currentState[stateProp.current]) ~= _tostring(previousState[stateProp.current]) then
      changed = true; break
    end
  end

  if not changed then return end

  local events, n = determineEvents(currentState)
  for i = 1, n do
    local event = events[i]
    if listeners[event] then
      currentState.event = event
      for _, callback in _ipairs(listeners[event]) do
        callback(currentState)
      end
      currentState.event = nil
    end
  end

  previousState = currentState
end

local function pushCurrentState()
    previousState = getCurrentState()
    updateTimestamp()
end

local function pullCurrentState()
    updateTimestamp()
    return getCurrentState()
end

local function initialize(event)
    if not initialized.data then
        for _, stateProp in ipairs(stateProps) do
            if stateProp.event then
                local eventScope = stateProp.event.scope or stateProp.event.change

                if eventScope then
                    for _, eventKey in ipairs({ 'change', 'on', 'off' }) do
                        local eventName = stateProp.event[eventKey]

                        if eventName then
                            if not eventScopes[eventName] then
                                eventScopes[eventName] = {}
                            end

                            eventScopes[eventName][eventScope] = true
                        end
                    end
                end
            end
        end

        initialized.data = true
    end

    local required = eventScopes[event] or eventScopes[GameSession.Event.Update]

    -- Session State

    if required[GameSession.Scope.Session] and not initialized[GameSession.Scope.Session] then
        Observe('QuestTrackerGameController', 'OnInitialize', function()
            if updateLoaded(true) then
                updatePaused(false)
                updateBlurred(false)
                updateDead(false)
                pushCurrentState()
                dispatchEvent(GameSession.Event.Start, pullCurrentState())
            end
        end)

        Observe('QuestTrackerGameController', 'OnUninitialize', function()
            if Game.GetPlayer() == nil then
                if updateLoaded(false) then
                    updatePaused(true)
                    updateBlurred(false)
                    updateDead(false)
                    notifyObservers()
                end
            end
        end)

        initialized[GameSession.Scope.Session] = true
    end

    -- Pause/Blur/Death

    if (required[GameSession.Scope.Pause] or required[GameSession.Scope.Blur] or required[GameSession.Scope.Death]) and not initialized['StateUpdate'] then
        Observe('PlayerPuppet', 'OnGameAttached', function()
            refreshCurrentState()
            pushCurrentState()
            dispatchEvent(GameSession.Event.Update, pullCurrentState())
        end)

        Observe('PlayerPuppet', 'OnAction', function()
            refreshCurrentState()
            notifyObservers()
        end)

        initialized['StateUpdate'] = true
    end

    -- Saves

    if required[GameSession.Scope.Saves] and not initialized[GameSession.Scope.Saves] then
        Observe('SaveLockController', 'OnSavingEventEnd', function()
            dispatchEvent(GameSession.Event.Save, getSessionMetaForSaving())
        end)

        Observe('SaveSystem', 'OnGameSaved', function()
            dispatchEvent(GameSession.Event.Save, getSessionMetaForSaving(true))
        end)

        Observe('SaveSystem', 'OnBeforeSave', function()
            dispatchEvent(GameSession.Event.SaveData, getSessionMetaForSaving())
        end)

        Observe('SaveSystem', 'OnAfterSave', function()
            dispatchEvent(GameSession.Event.Clean, getSessionMetaForSaving(true))
        end)

        Observe('SaveSystem', 'OnBeforeLoad', function()
            dispatchEvent(GameSession.Event.Load, getSessionMetaForLoading())
        end)

        Observe('SaveSystem', 'OnLoad', function()
            dispatchEvent(GameSession.Event.Load, getSessionMetaForLoading(true))
        end)

        Observe('SaveSystem', 'OnLoadCanceled', function()
            dispatchEvent(GameSession.Event.Clean, getSessionMetaForLoading(true))
        end)

        Observe('SaveSystem', 'RequestLoadLastCheckpoint', function()
            dispatchEvent(GameSession.Event.Load, getSessionMetaForLoading(true))
        end)

        initialized[GameSession.Scope.Saves] = true
    end

    -- Persistence

    if required[GameSession.Scope.Persistence] and not initialized[GameSession.Scope.Persistence] then
        Observe('PlayerPuppet', 'OnGameAttached', function()
            dispatchEvent(GameSession.Event.LoadData, getSessionMetaForLoading())
        end)

        Observe('PlayerPuppet', 'OnDetach', function()
            dispatchEvent(GameSession.Event.SaveData, getSessionMetaForSaving())
        end)

        Observe('PlayerPuppet', 'OnUnload', function()
            dispatchEvent(GameSession.Event.SaveData, getSessionMetaForSaving(true))
        end)

        initialized[GameSession.Scope.Persistence] = true
    end
end

local function addListener(event, callback)
    if not listeners[event] then
        listeners[event] = {}
    end
    table.insert(listeners[event], callback)
end

-- Persistence (files & meta) --

local modName = 'GameSession'
local dataDir = 'User'
local sessionDataDir

local function getModPrefix()
    return string.format('[%s] ', modName)
end

local function generateSessionKey()
    return math.floor(os.time() + math.random(0, 0x7FFFFFFF)) % 0x7FFFFFFF
end

local function readSessionKey()
    local keyFile = io.open(dataDir .. '/session.key', 'r')
    if keyFile then
        local key = tonumber(keyFile:read('l'))
        keyFile:close()
        return key or 0
    end
    return 0
end

local function writeSessionKey(key)
    local keyFile = io.open(dataDir .. '/session.key', 'w')
    if keyFile then
        keyFile:write(tostring(key))
        keyFile:close()
    end
end

local function initSessionKey()
    local sessionKey = readSessionKey()
    if isEmptySessionKey(sessionKey) then
        sessionKey = generateSessionKey()
        writeSessionKey(sessionKey)
    end
    setSessionKey(sessionKey)
end

local function renewSessionKey()
    local sessionKey = getSessionKey()
    local savedKey = readSessionKey()
    local nextKey = generateSessionKey()
    if sessionKey == savedKey then
        writeSessionKey(nextKey)
        setSessionKey(nextKey)
    end
end

local function findLastSaveFile(pattern, targetKey)
    local savesFolder = io.listfiles('r6/cache/')
    if savesFolder then
        for _, saveDir in ipairs(savesFolder) do
            if saveDir and saveDir.isdir and (saveDir.name == 'backup' or saveDir.name == 'saves') then
                for _, sessionFile in ipairs(io.listfiles(saveDir.path)) do
                    if sessionFile and not sessionFile.isdir and sessionFile.name:match(pattern) then
                        local sessionReader = io.open(sessionDataDir .. '/' .. sessionFile.name, 'r')
                        local sessionHeader = sessionReader:read('l')
                        sessionReader:close()

                        local sessionKeyStr = sessionHeader:match('^-- (%d+)$')
                        if sessionKeyStr then
                            local sessionKey = tonumber(sessionKeyStr)
                            if sessionKey == targetKey then
                                return tonumber((sessionFile.name:match(pattern)))
                            end
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function writeSessionFile(sessionTimestamp, sessionKey, isTemporary, sessionData)
    if not sessionDataDir then
        return
    end

    local state = getModPrefix() .. string.format('Writing session (%s) ...', isTemporary and 'Temp' or 'Auto')

    local sessionPath = string.format('%s/%s_%s_%d.lua',
        sessionDataDir, os.date('%Y-%m-%d_%H-%M-%S', sessionTimestamp), modName, sessionKey)

    local sessionFile = io.open(sessionPath, 'w')
    sessionFile:write(string.format('-- %d\n\n', sessionKey))
    sessionFile:write('return ')
    sessionFile:write(serialize(sessionData, 0))
    sessionFile:close()

    print(state .. ' Done')
end

local function readSessionFile(path)
    local sessionReader = io.open(path, 'r')
    if not sessionReader then
        return nil, 'File not found'
    end

    local header = sessionReader:read('l')
    local content = sessionReader:read('*a')
    sessionReader:close()

    local key = tonumber(header:match('^%-%- (%d+)$'))
    if not key then
        return nil, 'Invalid header'
    end

    local ok, data = pcall(load(content))
    if not ok then
        return nil, 'Load failed'
    end

    return { key = key, data = data }
end

-- (Serialize helper)
function serialize(value, level)
    level = level or 0
    local t = type(value)
    if t == 'nil' then
        return 'nil'
    elseif t == 'number' or t == 'boolean' then
        return tostring(value)
    elseif t == 'string' then
        return string.format('%q', value)
    elseif t == 'table' then
        local indent = string.rep('  ', level)
        local nextIndent = string.rep('  ', level + 1)
        local parts = { '{\n' }
        for k, v in pairs(value) do
            local key
            if type(k) == 'string' then
                key = string.format('%s[%q] = ', nextIndent, k)
            else
                key = string.format('%s[%s] = ', nextIndent, tostring(k))
            end
            parts[#parts+1] = key .. serialize(v, level + 1) .. ',\n'
        end
        parts[#parts+1] = indent .. '}'
        return table.concat(parts)
    else
        return 'nil'
    end
end

-- Public API --

function GameSession.Observe(event, callback)
    if type(event) == 'string' then
        initialize(event)
    elseif type(event) == 'function' then
        callback, event = event, GameSession.Event.Update
        initialize(event)
    else
        if not event then
            initialize(GameSession.Event.Update)
        elseif type(event) == 'table' then
            for _, evt in ipairs(event) do
                GameSession.Observe(evt, callback)
            end
        end
        return
    end

    addListener(event, callback or function() end)
end

function GameSession.Listen(event, callback)
    if not event or event == true then
        for _, evt in pairs(GameSession.Event) do
            if evt ~= GameSession.Event.Update and not eventScopes[evt][GameSession.Scope.Persistence] then
                GameSession.Observe(evt, callback)
            end
        end
    else
        GameSession.Observe(event, callback)
    end
end

GameSession.On = GameSession.Listen

setmetatable(GameSession, {
    __index = function(_, key)
        local event = string.match(key, '^On(%w+)$')

        if event and GameSession.Event[event] then
            return function(callback)
                GameSession.Observe(GameSession.Event[event], callback)
            end
        end

        local scope = string.match(key, '^In(%w+)$')

        if scope and GameSession.Scope[scope] then
            return function()
                initialize(GameSession.Scope[scope])
            end
        end
    end
})

function GameSession.IsLoaded()
    return isLoaded
end

function GameSession.IsPaused()
    return isPaused
end

function GameSession.IsBlurred()
    return isBlurred
end

function GameSession.IsDead()
    return isDead
end

function GameSession.GetKey()
    return getSessionKey()
end

function GameSession.GetState()
    return getCurrentState()
end

function GameSession.ExportState()
    local state = getCurrentState()
    state.mod = modName
    return state
end

function GameSession.PrintState()
    local state = GameSession.ExportState()
    print(string.format('%sLoaded=%s Paused=%s Blurred=%s Dead=%s Key=%d T=%d C=%d',
        getModPrefix(),
        tostring(state.isLoaded), tostring(state.isPaused),
        tostring(state.isBlurred), tostring(state.isDead),
        state.sessionKey, state.timestamp, state.timestamps))
end

function GameSession.IdentifyAs(name)
    modName = name or modName
end

function GameSession.StoreInDir(path)
    dataDir = path or dataDir
    sessionDataDir = dataDir .. '/Session'
    io.mkdir(sessionDataDir)
    initSessionKey()
end

local persistedTables = {}

function GameSession.Persist(tbl)
    if type(tbl) == 'table' then
        table.insert(persistedTables, tbl)
    end
end

local function collectPersistedData()
    local data = {}
    for i = 1, #persistedTables do
        data[i] = persistedTables[i]
    end
    return data
end

local function getSessionMetaForSaving(isTemporary)
    updateTimestamp()
    return {
        mod = modName,
        timestamp = timestamp,
        timestamps = timestamps,
        key = getSessionKey(),
        temporary = isTemporary or false,
        data = collectPersistedData(),
    }
end

local function getSessionMetaForLoading(isLast)
    return {
        mod = modName,
        key = getSessionKey(),
        last = isLast or false,
    }
end

-- External triggers

function GameSession.TrySave()
    if Game.GetSettingsSystem() then
        dispatchEvent(GameSession.Event.Save, getSessionMetaForSaving(true))
    end
end

function GameSession.TryLoad()
    if not isPreGame() and not isEmptySessionKey() then
        dispatchEvent(GameSession.Event.Load, getSessionMetaForLoading(true))
    end
end

return GameSession
