local GameUI = {
    version   = '1.2.1',
    framework = '1.19.0',
}

GameUI.Event = {
    Braindance       = 'Braindance',
    BraindancePlay   = 'BraindancePlay',
    BraindanceEdit   = 'BraindanceEdit',
    BraindanceExit   = 'BraindanceExit',
    Camera           = 'Camera',
    Context          = 'Context',
    Cyberspace       = 'Cyberspace',
    CyberspaceEnter  = 'CyberspaceEnter',
    CyberspaceExit   = 'CyberspaceExit',
    Device           = 'Device',
    DeviceEnter      = 'DeviceEnter',
    DeviceExit       = 'DeviceExit',
    FastTravel       = 'FastTravel',
    FastTravelFinish = 'FastTravelFinish',
    FastTravelStart  = 'FastTravelStart',
    Flashback        = 'Flashback',
    FlashbackEnd     = 'FlashbackEnd',
    FlashbackStart   = 'FlashbackStart',
    Johnny           = 'Johnny',
    Loading          = 'Loading',
    LoadingFinish    = 'LoadingFinish',
    LoadingStart     = 'LoadingStart',
    Menu             = 'Menu',
    MenuClose        = 'MenuClose',
    MenuNav          = 'MenuNav',
    MenuOpen         = 'MenuOpen',
    PhotoMode        = 'PhotoMode',
    PhotoModeClose   = 'PhotoModeClose',
    PhotoModeOpen    = 'PhotoModeOpen',
    Popup            = 'Popup',
    PopupClose       = 'PopupClose',
    PopupOpen        = 'PopupOpen',
    Possession       = 'Possession',
    PossessionEnd    = 'PossessionEnd',
    PossessionStart  = 'PossessionStart',
    QuickHack        = 'QuickHack',
    QuickHackClose   = 'QuickHackClose',
    QuickHackOpen    = 'QuickHackOpen',
    Scanner          = 'Scanner',
    ScannerClose     = 'ScannerClose',
    ScannerOpen      = 'ScannerOpen',
    Scene            = 'Scene',
    SceneEnter       = 'SceneEnter',
    SceneExit        = 'SceneExit',
    Session          = 'Session',
    SessionEnd       = 'SessionEnd',
    SessionStart     = 'SessionStart',
    Shard            = 'Shard',
    ShardClose       = 'ShardClose',
    ShardOpen        = 'ShardOpen',
    Tutorial         = 'Tutorial',
    TutorialClose    = 'TutorialClose',
    TutorialOpen     = 'TutorialOpen',
    Update           = 'Update',
    Vehicle          = 'Vehicle',
    VehicleEnter     = 'VehicleEnter',
    VehicleExit      = 'VehicleExit',
    Wheel            = 'Wheel',
    WheelClose       = 'WheelClose',
    WheelOpen        = 'WheelOpen',
}

GameUI.StateEvent = {
    [GameUI.Event.Braindance] = GameUI.Event.Braindance,
    [GameUI.Event.Context]    = GameUI.Event.Context,
    [GameUI.Event.Cyberspace] = GameUI.Event.Cyberspace,
    [GameUI.Event.Device]     = GameUI.Event.Device,
    [GameUI.Event.FastTravel] = GameUI.Event.FastTravel,
    [GameUI.Event.Flashback]  = GameUI.Event.Flashback,
    [GameUI.Event.Johnny]     = GameUI.Event.Johnny,
    [GameUI.Event.Loading]    = GameUI.Event.Loading,
    [GameUI.Event.Menu]       = GameUI.Event.Menu,
    [GameUI.Event.PhotoMode]  = GameUI.Event.PhotoMode,
    [GameUI.Event.Popup]      = GameUI.Event.Popup,
    [GameUI.Event.Possession] = GameUI.Event.Possession,
    [GameUI.Event.QuickHack]  = GameUI.Event.QuickHack,
    [GameUI.Event.Scanner]    = GameUI.Event.Scanner,
    [GameUI.Event.Scene]      = GameUI.Event.Scene,
    [GameUI.Event.Session]    = GameUI.Event.Session,
    [GameUI.Event.Shard]      = GameUI.Event.Shard,
    [GameUI.Event.Tutorial]   = GameUI.Event.Tutorial,
    [GameUI.Event.Update]     = GameUI.Event.Update,
    [GameUI.Event.Vehicle]    = GameUI.Event.Vehicle,
    [GameUI.Event.Wheel]      = GameUI.Event.Wheel,
}

GameUI.Camera = {
    FirstPerson = 'FirstPerson',
    ThirdPerson = 'ThirdPerson',
}

-- === Fast locals + tiny internal singleton cache (OO-ish inside) ===
local _pairs, _ipairs, _tostring = pairs, ipairs, tostring

local S = {
    bb_sys = nil,
    bb_def = nil,
    events = {},  -- scratch reused per notify
    firing = {},  -- scratch reused per notify
}

function S:getBB()
    local BB  = self.bb_sys
    local DEF = self.bb_def
    if not BB  then BB  = Game.GetBlackboardSystem();    self.bb_sys = BB  end
    if not DEF then DEF = Game.GetAllBlackboardDefs();   self.bb_def = DEF end
    return BB, DEF
end

function S:clear(t)
    for k in _pairs(t) do t[k] = nil end
end

-- === Internals / state ===
local initialized   = {}
local listeners     = {}
local updateQueue   = {}
local previousState = {
    isDetached = true,
    isMenu     = false,
    menu       = false,
}

local isDetached   = true
local isLoaded     = false
local isLoading    = false
local isMenu       = true
local isVehicle    = false
local isBraindance = false
local isFastTravel = false
local isPhotoMode  = false
local isShard      = false
local isTutorial   = false
local sceneTier    = 4
local isPossessed  = false
local isFlashback  = false
local isCyberspace = false
local currentMenu    = false
local currentSubmenu = false
local currentCamera  = GameUI.Camera.FirstPerson
local contextStack   = {}

local stateProps = {
    { current = 'isLoaded',     previous = nil,            event = { change = GameUI.Event.Session,  on  = GameUI.Event.SessionStart } },
    { current = 'isDetached',   previous = nil,            event = { change = GameUI.Event.Session,  on  = GameUI.Event.SessionEnd } },
    { current = 'isLoading',    previous = 'wasLoading',   event = { change = GameUI.Event.Loading,  on  = GameUI.Event.LoadingStart,   off = GameUI.Event.LoadingFinish } },
    { current = 'isMenu',       previous = 'wasMenu',      event = { change = GameUI.Event.Menu,     on  = GameUI.Event.MenuOpen,       off = GameUI.Event.MenuClose } },
    { current = 'isScene',      previous = 'wasScene',     event = { change = GameUI.Event.Scene,    on  = GameUI.Event.SceneEnter,     off = GameUI.Event.SceneExit,     reqs = { isMenu = false } } },
    { current = 'isVehicle',    previous = 'wasVehicle',   event = { change = GameUI.Event.Vehicle,  on  = GameUI.Event.VehicleEnter,   off = GameUI.Event.VehicleExit } },
    { current = 'isBraindance', previous = 'wasBraindance',event = { change = GameUI.Event.Braindance,on = GameUI.Event.BraindancePlay,  off = GameUI.Event.BraindanceExit } },
    { current = 'isEditor',     previous = 'wasEditor',    event = { change = GameUI.Event.Braindance,on = GameUI.Event.BraindanceEdit,  off = GameUI.Event.BraindancePlay } },
    { current = 'isFastTravel', previous = 'wasFastTravel',event = { change = GameUI.Event.FastTravel,on = GameUI.Event.FastTravelStart, off = GameUI.Event.FastTravelFinish } },
    { current = 'isJohnny',     previous = 'wasJohnny',    event = { change = GameUI.Event.Johnny } },
    { current = 'isPossessed',  previous = 'wasPossessed', event = { change = GameUI.Event.Possession,on = GameUI.Event.PossessionStart, off = GameUI.Event.PossessionEnd, scope = GameUI.Event.Johnny } },
    { current = 'isFlashback',  previous = 'wasFlashback', event = { change = GameUI.Event.Flashback, on = GameUI.Event.FlashbackStart,  off = GameUI.Event.FlashbackEnd,  scope = GameUI.Event.Johnny } },
    { current = 'isCyberspace', previous = 'wasCyberspace',event = { change = GameUI.Event.Cyberspace,on = GameUI.Event.CyberspaceEnter, off = GameUI.Event.CyberspaceExit } },
    { current = 'isDefault',    previous = 'wasDefault' },
    { current = 'isScanner',    previous = 'wasScanner',   event = { change = GameUI.Event.Scanner,  on  = GameUI.Event.ScannerOpen,    off = GameUI.Event.ScannerClose,  scope = GameUI.Event.Context } },
    { current = 'isQuickHack',  previous = 'wasQuickHack', event = { change = GameUI.Event.QuickHack,on  = GameUI.Event.QuickHackOpen,  off = GameUI.Event.QuickHackClose,scope = GameUI.Event.Context } },
    { current = 'isPopup',      previous = 'wasPopup',     event = { change = GameUI.Event.Popup,    on  = GameUI.Event.PopupOpen,      off = GameUI.Event.PopupClose,    scope = GameUI.Event.Context } },
    { current = 'isWheel',      previous = 'wasWheel',     event = { change = GameUI.Event.Wheel,    on  = GameUI.Event.WheelOpen,      off = GameUI.Event.WheelClose,    scope = GameUI.Event.Context } },
    { current = 'isDevice',     previous = 'wasDevice',    event = { change = GameUI.Event.Device,   on  = GameUI.Event.DeviceEnter,    off = GameUI.Event.DeviceExit,    scope = GameUI.Event.Context } },
    { current = 'isPhoto',      previous = 'wasPhoto',     event = { change = GameUI.Event.PhotoMode,on  = GameUI.Event.PhotoModeOpen,  off = GameUI.Event.PhotoModeClose } },
    { current = 'isShard',      previous = 'wasShard',     event = { change = GameUI.Event.Shard,    on  = GameUI.Event.ShardOpen,      off = GameUI.Event.ShardClose } },
    { current = 'isTutorial',   previous = 'wasTutorial',  event = { change = GameUI.Event.Tutorial, on  = GameUI.Event.TutorialOpen,   off = GameUI.Event.TutorialClose } },
    { current = 'menu',         previous = 'lastMenu',     event = { change = GameUI.Event.MenuNav,  reqs = { isMenu = true, wasMenu = true }, scope = GameUI.Event.Menu } },
    { current = 'submenu',      previous = 'lastSubmenu',  event = { change = GameUI.Event.MenuNav,  reqs = { isMenu = true, wasMenu = true }, scope = GameUI.Event.Menu } },
    { current = 'camera',       previous = 'lastCamera',   event = { change = GameUI.Event.Camera,   scope = GameUI.Event.Vehicle }, parent = 'isVehicle' },
    { current = 'context',      previous = 'lastContext',  event = { change = GameUI.Event.Context } },
}

local menuScenarios = {
    ['MenuScenario_BodyTypeSelection']  = { menu = 'NewGame',   submenu = 'BodyType' },
    ['MenuScenario_BoothMode']          = { menu = 'BoothMode', submenu = false },
    ['MenuScenario_CharacterCustomization'] = { menu = 'NewGame', submenu = 'Customization' },
    ['MenuScenario_ClippedMenu']        = { menu = 'ClippedMenu', submenu = false },
    ['MenuScenario_Credits']            = { menu = 'MainMenu',  submenu = 'Credits' },
    ['MenuScenario_DeathMenu']          = { menu = 'DeathMenu', submenu = false },
    ['MenuScenario_Difficulty']         = { menu = 'NewGame',   submenu = 'Difficulty' },
    ['MenuScenario_E3EndMenu']          = { menu = 'E3EndMenu', submenu = false },
    ['MenuScenario_FastTravel']         = { menu = 'FastTravel',submenu = 'Map' },
    ['MenuScenario_FinalBoards']        = { menu = 'FinalBoards', submenu = false },
    ['MenuScenario_FindServers']        = { menu = 'FindServers', submenu = false },
    ['MenuScenario_HubMenu']            = { menu = 'Hub',       submenu = false },
    ['MenuScenario_Idle']               = { menu = false,       submenu = false },
    ['MenuScenario_LifePathSelection']  = { menu = 'NewGame',   submenu = 'LifePath' },
    ['MenuScenario_LoadGame']           = { menu = 'MainMenu',  submenu = 'LoadGame' },
    ['MenuScenario_MultiplayerMenu']    = { menu = 'Multiplayer', submenu = false },
    ['MenuScenario_NetworkBreach']      = { menu = 'NetworkBreach', submenu = false },
    ['MenuScenario_NewGame']            = { menu = 'NewGame',   submenu = false },
    ['MenuScenario_PauseMenu']          = { menu = 'PauseMenu', submenu = false },
    ['MenuScenario_PlayRecordedSession']= { menu = 'PlayRecordedSession', submenu = false },
    ['MenuScenario_Settings']           = { menu = 'MainMenu',  submenu = 'Settings' },
    ['MenuScenario_SingleplayerMenu']   = { menu = 'MainMenu',  submenu = false },
    ['MenuScenario_StatsAdjustment']    = { menu = 'NewGame',   submenu = 'Attributes' },
    ['MenuScenario_Storage']            = { menu = 'Stash',     submenu = false },
    ['MenuScenario_Summary']            = { menu = 'NewGame',   submenu = 'Summary' },
    ['MenuScenario_Vendor']             = { menu = 'Vendor',    submenu = false },
}

local eventScopes = {
    [GameUI.Event.Update] = {},
    [GameUI.Event.Menu]   = { [GameUI.Event.Loading] = true },
}

-- === small helpers ===
local function toStudlyCase(s)
    return (s:lower():gsub('_*(%l)(%w*)', function(first, rest)
        return string.upper(first) .. rest
    end))
end

-- === state mutators ===
local function updateDetached(detached) isDetached = detached; isLoaded = false end
local function updateLoaded(loaded)     isDetached = not loaded; isLoaded = loaded end
local function updateLoading(b)         isLoading  = b end
local function updateMenu(b)            isMenu     = b or GameUI.IsMainMenu() end
local function updateMenuScenario(name)
    local scenario = menuScenarios[name] or menuScenarios['MenuScenario_Idle']
    isMenu = scenario.menu ~= false
    currentMenu    = scenario.menu
    currentSubmenu = scenario.submenu
end
local function updateMenuItem(name) currentSubmenu = name or false end
local function updateVehicle(active, tpp)
    isVehicle    = active
    currentCamera = (tpp and GameUI.Camera.ThirdPerson or GameUI.Camera.FirstPerson)
end
local function updateBraindance(b)  isBraindance  = b end
local function updateFastTravel(b)  isFastTravel  = b end
local function updatePhotoMode(b)   isPhotoMode   = b end
local function updateShard(b)       isShard       = b end
local function updateTutorial(b)    isTutorial    = b end
local function updateSceneTier(v)   sceneTier     = v end
local function updatePossessed(b)   isPossessed   = b end
local function updateFlashback(b)   isFlashback   = b end
local function updateCyberspace(b)  isCyberspace  = b end

local function updateContext(oldContext, newContext)
    if oldContext == nil and newContext == nil then
        contextStack = {}
    elseif oldContext ~= nil then
        for i = #contextStack, 1, -1 do
            if contextStack[i].value == oldContext.value then
                table.remove(contextStack, i)
                break
            end
        end
    elseif newContext ~= nil then
        table.insert(contextStack, newContext)
    else
        if #contextStack > 0 and contextStack[#contextStack].value == oldContext.value then
            contextStack[#contextStack] = newContext
        end
    end
end

-- === core sampling ===
local function refreshCurrentState()
    local player = Game.GetPlayer()
    local BB, DEF = S:getBB()

    local blackboardUI  = BB:Get(DEF.UI_System)
    local blackboardVH  = BB:Get(DEF.UI_ActiveVehicleData)
    local blackboardBD  = BB:Get(DEF.Braindance)
    local blackboardPM  = BB:Get(DEF.PhotoMode)
    local blackboardPSM = BB:GetLocalInstanced(player:GetEntityID(), DEF.PlayerStateMachine)

    if not isLoaded then
        updateDetached(not player:IsAttached() or GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame())
        if isDetached then currentMenu = 'MainMenu' end
    end

    updateMenu(blackboardUI:GetBool(DEF.UI_System.IsInMenu))
    updateTutorial(Game.GetTimeSystem():IsTimeDilationActive('UI_TutorialPopup'))

    updateSceneTier(blackboardPSM:GetInt(DEF.PlayerStateMachine.SceneTier))
    updateVehicle(
        blackboardVH:GetBool(DEF.UI_ActiveVehicleData.IsPlayerMounted),
        blackboardVH:GetBool(DEF.UI_ActiveVehicleData.IsTPPCameraOn)
    )

    updateBraindance(blackboardBD:GetBool(DEF.Braindance.IsActive))
    updatePossessed(Game.GetQuestsSystem():GetFactStr(Game.GetPlayerSystem():GetPossessedByJohnnyFactName()) == 1)
    updateFlashback(player:IsJohnnyReplacer())
    updatePhotoMode(blackboardPM:GetBool(DEF.PhotoMode.IsActive))

    if #contextStack == 0 then
        if isBraindance then
            updateContext(nil, GameUI.Context.BraindancePlayback)
        elseif Game.GetTimeSystem():IsTimeDilationActive('radial') then
            updateContext(nil, GameUI.Context.ModalPopup)
        end
    end
end

local function pushCurrentState()
    previousState = GameUI.GetState()
end

local function applyQueuedChanges()
    if #updateQueue == 0 then return end
    for i = 1, #updateQueue do
        updateQueue[i]()
    end
    for i = #updateQueue, 1, -1 do updateQueue[i] = nil end
end

-- === event calculation (allocation-free) ===
local function determineEvents(currentState)
    local events, firing = S.events, S.firing
    S:clear(events); S:clear(firing)

    local e = 1
    events[e] = GameUI.Event.Update

    for _, stateProp in _ipairs(stateProps) do
        local cur  = currentState[stateProp.current]
        local prev = previousState[stateProp.current]

        if stateProp.event and (not stateProp.parent or currentState[stateProp.parent]) then
            local ev   = stateProp.event
            local reqs = ev.reqs
            local reqOK = true

            if reqs then
                for reqProp, reqValue in _pairs(reqs) do
                    if _tostring(currentState[reqProp]) ~= _tostring(reqValue) then
                        reqOK = false; break
                    end
                end
            end

            if reqOK then
                if ev.change and prev ~= nil and _tostring(cur) ~= _tostring(prev) then
                    local name = ev.change
                    if not firing[name] then e = e + 1; events[e] = name; firing[name] = true end
                end

                if ev.on and cur and not prev then
                    local name = ev.on
                    if not firing[name] then e = e + 1; events[e] = name; firing[name] = true end
                elseif ev.off and not cur and prev then
                    local name = ev.off
                    if not firing[name] then
                        -- ensure OFF fires first
                        for j = e, 1, -1 do events[j + 1] = events[j] end
                        events[1] = name
                        e = e + 1
                        firing[name] = true
                    end
                end
            end
        end
    end

    return events, e
end

local function notifyObservers()
    if not isDetached then applyQueuedChanges() end

    local currentState = GameUI.GetState()

    -- quick diff: bail if nothing changed
    local changed = false
    for _, sp in _ipairs(stateProps) do
        if _tostring(currentState[sp.current]) ~= _tostring(previousState[sp.current]) then
            changed = true; break
        end
    end
    if not changed then return end

    local events, n = determineEvents(currentState)
    for i = 1, n do
        local event = events[i]
        if listeners[event] then
            if event ~= GameUI.Event.Update then
                currentState.event = event
            end
            for _, cb in _ipairs(listeners[event]) do
                cb(currentState)
            end
            currentState.event = nil
        end
    end

    if isLoaded then isLoaded = false end
    previousState = currentState
end

local function notifyAfterStart(updateCallback)
    if not isDetached then
        updateCallback()
        notifyObservers()
    else
        updateQueue[#updateQueue + 1] = updateCallback
    end
end

-- === init / Observe wiring ===
local function initialize(event)
    if not initialized.data then
        GameUI.Context = {
            Default            = Enum.new('UIGameContext', 0),
            QuickHack          = Enum.new('UIGameContext', 1),
            Scanning           = Enum.new('UIGameContext', 2),
            DeviceZoom         = Enum.new('UIGameContext', 3),
            BraindanceEditor   = Enum.new('UIGameContext', 4),
            BraindancePlayback = Enum.new('UIGameContext', 5),
            VehicleMounted     = Enum.new('UIGameContext', 6),
            ModalPopup         = Enum.new('UIGameContext', 7),
            RadialWheel        = Enum.new('UIGameContext', 8),
            VehicleRace        = Enum.new('UIGameContext', 9),
        }

        for _, stateProp in _ipairs(stateProps) do
            if stateProp.event then
                local eventScope = stateProp.event.scope or stateProp.event.change
                if eventScope then
                    for _, eventKey in _ipairs({ 'change', 'on', 'off' }) do
                        local eventName = stateProp.event[eventKey]
                        if eventName then
                            if not eventScopes[eventName] then
                                eventScopes[eventName] = {}
                                eventScopes[eventName][GameUI.Event.Session] = true
                            end
                            eventScopes[eventName][eventScope] = true
                        end
                    end
                    eventScopes[GameUI.Event.Update][eventScope] = true
                end
            end
        end

        initialized.data = true
    end

    local required = eventScopes[event] or eventScopes[GameUI.Event.Update]

    -- Session
    if required[GameUI.Event.Session] and not initialized[GameUI.Event.Session] then
        Observe('QuestTrackerGameController', 'OnInitialize', function()
            if isDetached then
                updateLoading(false)
                updateLoaded(true)
                updateMenuScenario()
                applyQueuedChanges()
                refreshCurrentState()
                notifyObservers()
            end
        end)

        Observe('QuestTrackerGameController', 'OnUninitialize', function()
            if Game.GetPlayer() == nil then
                updateDetached(true)
                updateSceneTier(1)
                updateContext()
                updateVehicle(false, false)
                updateBraindance(false)
                updateCyberspace(false)
                updatePossessed(false)
                updateFlashback(false)
                updatePhotoMode(false)

                if currentMenu ~= 'MainMenu' then
                    notifyObservers()
                else
                    pushCurrentState()
                end
            end
        end)

        initialized[GameUI.Event.Session] = true
    end

    -- Loading
    if required[GameUI.Event.Loading] and not initialized[GameUI.Event.Loading] then
        Observe('LoadingScreenProgressBarController', 'SetProgress', function(_, progress)
            if type(progress) ~= 'number' then progress = _ end
            if not isLoading then
                updateMenuScenario()
                updateLoading(true)
                notifyObservers()
            elseif progress == 1.0 then
                if currentMenu ~= 'MainMenu' then updateMenuScenario() end
                updateLoading(false)
                notifyObservers()
            end
        end)
        initialized[GameUI.Event.Loading] = true
    end

    -- Menu
    if required[GameUI.Event.Menu] and not initialized[GameUI.Event.Menu] then
        local menuOpenListeners = {
            'MenuScenario_Idle',
            'MenuScenario_BaseMenu',
            'MenuScenario_PreGameSubMenu',
            'MenuScenario_SingleplayerMenu',
        }

        for _, menuScenario in _pairs(menuOpenListeners) do
            Observe(menuScenario, 'OnLeaveScenario', function(self, menuName)
                if type(menuName) ~= 'userdata' then menuName = self end
                updateMenuScenario(Game.NameToString(menuName))
                if not isLoading then notifyObservers() end
            end)
        end

        Observe('MenuScenario_HubMenu', 'OnSelectMenuItem', function(self, menuItemData)
            if type(menuItemData) ~= 'userdata' then menuItemData = self end
            updateMenuItem(EnumValueToName('HubMenuItems', menuItemData.menuData.identifier).value)
            -- updateMenuItem(toStudlyCase(menuItemData.menuData.label))
            notifyObservers()
        end)

        Observe('MenuScenario_HubMenu', 'OnCloseHubMenu', function()
            updateMenuItem(false)
            notifyObservers()
        end)

        local menuItemListeners = {
            ['MenuScenario_SingleplayerMenu'] = {
                ['OnLoadGame']       = 'LoadGame',
                ['OnMainMenuBack']   = false,
            },
            ['MenuScenario_Settings'] = {
                ['OnSwitchToControllerPanel']  = 'Controller',
                ['OnSwitchToBrightnessSettings'] = 'Brightness',
                ['OnSwitchToHDRSettings']      = 'HDR',
                ['OnSettingsBack']             = 'Settings',
            },
            ['MenuScenario_PauseMenu'] = {
                ['OnSwitchToBrightnessSettings'] = 'Brightness',
                ['OnSwitchToControllerPanel']    = 'Controller',
                ['OnSwitchToCredits']            = 'Credits',
                ['OnSwitchToHDRSettings']        = 'HDR',
                ['OnSwitchToLoadGame']           = 'LoadGame',
                ['OnSwitchToSaveGame']           = 'SaveGame',
                ['OnSwitchToSettings']           = 'Settings',
            },
            ['MenuScenario_DeathMenu'] = {
                ['OnSwitchToBrightnessSettings'] = 'Brightness',
                ['OnSwitchToControllerPanel']    = 'Controller',
                ['OnSwitchToHDRSettings']        = 'HDR',
                ['OnSwitchToLoadGame']           = 'LoadGame',
                ['OnSwitchToSettings']           = 'Settings',
            },
            ['MenuScenario_Vendor'] = {
                ['OnSwitchToVendor']    = 'Trade',
                ['OnSwitchToRipperDoc'] = 'RipperDoc',
                ['OnSwitchToCrafting']  = 'Crafting',
            },
        }

        for menuScenario, menuItemEvents in _pairs(menuItemListeners) do
            for menuEvent, menuItem in _pairs(menuItemEvents) do
                Observe(menuScenario, menuEvent, function()
                    updateMenuScenario(menuScenario)
                    updateMenuItem(menuItem)
                    notifyObservers()
                end)
            end
        end

        local menuBackListeners = {
            ['MenuScenario_PauseMenu'] = 'GoBack',
            ['MenuScenario_DeathMenu'] = 'GoBack',
        }

        for menuScenario, menuBackEvent in _pairs(menuBackListeners) do
            Observe(menuScenario, menuBackEvent, function(self)
                if Game.NameToString(self.prevMenuName) == 'settings_main' then
                    updateMenuItem('Settings')
                else
                    updateMenuItem(false)
                end
                notifyObservers()
            end)
        end

        Observe('SingleplayerMenuGameController', 'OnSavesForLoadReady', function()
            updateMenuScenario('MenuScenario_SingleplayerMenu')
            if not isLoading then notifyObservers() end
        end)

        initialized[GameUI.Event.Menu] = true
    end

    -- Vehicle
    if required[GameUI.Event.Vehicle] and not initialized[GameUI.Event.Vehicle] then
        Observe('hudCarController', 'OnCameraModeChanged', function(_, mode)
            if type(mode) ~= 'boolean' then mode = _ end
            updateVehicle(true, mode)
            notifyObservers()
        end)
        Observe('hudCarController', 'OnUnmountingEvent', function()
            updateVehicle(false, false)
            notifyObservers()
        end)
        Observe('gameuiPanzerHUDGameController', 'OnUninitialize', function()
            updateVehicle(false, false)
            notifyObservers()
        end)
        Observe('PlayerVisionModeController', 'OnRestrictedSceneChanged', function(_, sceneTierValue)
            if type(sceneTierValue) ~= 'number' then sceneTierValue = _ end
            if isVehicle then
                updateVehicle(true, sceneTierValue < 3)
                notifyObservers()
            end
        end)
        initialized[GameUI.Event.Vehicle] = true
    end

    -- Braindance
    if required[GameUI.Event.Braindance] and not initialized[GameUI.Event.Braindance] then
        Observe('BraindanceGameController', 'OnIsActiveUpdated', function(_, active)
            if type(active) ~= 'boolean' then active = _ end
            updateBraindance(active)
            notifyObservers()
        end)
        initialized[GameUI.Event.Braindance] = true
    end

    -- Scene
    if required[GameUI.Event.Scene] and not initialized[GameUI.Event.Scene] then
        Observe('PlayerVisionModeController', 'OnRestrictedSceneChanged', function(_, sceneTierValue)
            if type(sceneTierValue) ~= 'number' then sceneTierValue = _ end
            notifyAfterStart(function() updateSceneTier(sceneTierValue) end)
        end)
        initialized[GameUI.Event.Scene] = true
    end

    -- Photo Mode
    if required[GameUI.Event.PhotoMode] and not initialized[GameUI.Event.PhotoMode] then
        Observe('gameuiPhotoModeMenuController', 'OnShow', function()
            updatePhotoMode(true);  notifyObservers()
        end)
        Observe('gameuiPhotoModeMenuController', 'OnHide', function()
            updatePhotoMode(false); notifyObservers()
        end)
        initialized[GameUI.Event.PhotoMode] = true
    end

    -- Fast Travel
    if required[GameUI.Event.FastTravel] and not initialized[GameUI.Event.FastTravel] then
        local fastTravelStart
        Observe('FastTravelSystem', 'OnUpdateFastTravelPointRecordRequest', function(_, request)
            if type(request) ~= 'userdata' then request = _ end
            fastTravelStart = request.pointRecord
        end)
        Observe('FastTravelSystem', 'OnPerformFastTravelRequest', function(self, request)
            if type(request) ~= 'userdata' then request = _ end
            if self.isFastTravelEnabledOnMap then
                local dest = request.pointData.pointRecord
                if _tostring(fastTravelStart) ~= _tostring(dest) then
                    updateLoading(true)
                    updateFastTravel(true)
                    notifyObservers()
                end
            end
        end)
        Observe('FastTravelSystem', 'OnLoadingScreenFinished', function(_, finished)
            if type(finished) ~= 'boolean' then finished = _ end
            if isFastTravel and finished then
                updateLoading(false)
                updateFastTravel(false)
                refreshCurrentState()
                notifyObservers()
            end
        end)
        initialized[GameUI.Event.FastTravel] = true
    end

    -- Shard
    if required[GameUI.Event.Shard] and not initialized[GameUI.Event.Shard] then
        Observe('ShardNotificationController', 'SetButtonHints', function()
            updateShard(true);  notifyObservers()
        end)
        Observe('ShardNotificationController', 'Close', function()
            updateShard(false); notifyObservers()
        end)
        initialized[GameUI.Event.Shard] = true
    end

    -- Tutorial
    if required[GameUI.Event.Tutorial] and not initialized[GameUI.Event.Tutorial] then
        Observe('gameuiTutorialPopupGameController', 'PauseGame', function(_, active)
            if type(active) ~= 'boolean' then active = _ end
            updateTutorial(active); notifyObservers()
        end)
        initialized[GameUI.Event.Tutorial] = true
    end

    -- Context
    if required[GameUI.Event.Context] and not initialized[GameUI.Event.Context] then
        Observe('gameuiGameSystemUI', 'PushGameContext', function(_, newContext)
            if isBraindance and newContext.value == GameUI.Context.Scanning.value then return end
            updateContext(nil, newContext)
            notifyObservers()
        end)

        Observe('gameuiGameSystemUI', 'PopGameContext', function(_, oldContext)
            if isBraindance and oldContext.value == GameUI.Context.Scanning.value then return end
            if oldContext.value == GameUI.Context.QuickHack.value then
                oldContext = GameUI.Context.Scanning
            end
            updateContext(oldContext, nil)
            notifyObservers()
        end)

        Observe('HUDManager', 'OnQuickHackUIVisibleChanged', function(_, quickhacking)
            if type(quickhacking) ~= 'boolean' then quickhacking = _ end
            if quickhacking then
                updateContext(GameUI.Context.Scanning, GameUI.Context.QuickHack)
            else
                updateContext(GameUI.Context.QuickHack, GameUI.Context.Scanning)
            end
            notifyObservers()
        end)

        Observe('gameuiGameSystemUI', 'ResetGameContext', function()
            updateContext()
            notifyObservers()
        end)

        initialized[GameUI.Event.Context] = true
    end

    -- initial state
    if not initialized.state then
        refreshCurrentState()
        pushCurrentState()
        initialized.state = true
    end
end

-- === Public API ===
function GameUI.Observe(event, callback)
    if type(event) == 'string' then
        initialize(event)
    elseif type(event) == 'function' then
        callback, event = event, GameUI.Event.Update
        initialize(event)
    else
        if not event then
            initialize(GameUI.Event.Update)
        elseif type(event) == 'table' then
            for _, evt in _ipairs(event) do
                GameUI.Observe(evt, callback)
            end
        end
        return
    end

    if type(callback) == 'function' then
        if not listeners[event] then listeners[event] = {} end
        listeners[event][#listeners[event] + 1] = callback
    end
end

function GameUI.Listen(event, callback)
    if type(event) == 'function' then
        callback = event
        for _, evt in _pairs(GameUI.Event) do
            if not GameUI.StateEvent[evt] then
                GameUI.Observe(evt, callback)
            end
        end
    else
        GameUI.Observe(event, callback)
    end
end

function GameUI.IsDetached()   return isDetached end
function GameUI.IsLoading()    return isLoading end
function GameUI.IsMenu()       return isMenu end
function GameUI.IsMainMenu()   return isMenu and currentMenu == 'MainMenu' end
function GameUI.IsShard()      return isShard end
function GameUI.IsTutorial()   return isTutorial end
function GameUI.IsScene()      return sceneTier >= 3 and not GameUI.IsMainMenu() end

function GameUI.IsScanner()
    local context = GameUI.GetContext()
    return not isMenu and not isLoading and not isFastTravel and (context.value == GameUI.Context.Scanning.value)
end

function GameUI.IsQuickHack()
    local context = GameUI.GetContext()
    return not isMenu and not isLoading and not isFastTravel and (context.value == GameUI.Context.QuickHack.value)
end

function GameUI.IsPopup()
    local context = GameUI.GetContext()
    return not isMenu and (context.value == GameUI.Context.ModalPopup.value)
end

function GameUI.IsWheel()
    local context = GameUI.GetContext()
    return not isMenu and (context.value == GameUI.Context.RadialWheel.value)
end

function GameUI.IsDevice()
    local context = GameUI.GetContext()
    return not isMenu and (context.value == GameUI.Context.DeviceZoom.value)
end

function GameUI.IsVehicle()    return isVehicle end
function GameUI.IsFastTravel() return isFastTravel end
function GameUI.IsBraindance() return isBraindance end
function GameUI.IsCyberspace() return isCyberspace end
function GameUI.IsJohnny()     return isPossessed or isFlashback end
function GameUI.IsPossessed()  return isPossessed end
function GameUI.IsFlashback()  return isFlashback end
function GameUI.IsPhoto()      return isPhotoMode end

function GameUI.IsDefault()
    return not isDetached
        and not isLoading
        and not isMenu
        and not GameUI.IsScene()
        and not isFastTravel
        and not isBraindance
        and not isCyberspace
        and not isPhotoMode
        and GameUI.IsContext(GameUI.Context.Default)
end

function GameUI.GetMenu()     return currentMenu end
function GameUI.GetSubmenu()  return currentSubmenu end
function GameUI.GetCamera()   return currentCamera end
function GameUI.GetContext()  return #contextStack > 0 and contextStack[#contextStack] or GameUI.Context.Default end

function GameUI.IsContext(context)
    return GameUI.GetContext().value == (type(context) == 'userdata' and context.value or context)
end

function GameUI.GetState()
    local currentState = {}

    currentState.isDetached = GameUI.IsDetached()
    currentState.isLoading  = GameUI.IsLoading()
    currentState.isLoaded   = isLoaded

    currentState.isMenu     = GameUI.IsMenu()
    currentState.isShard    = GameUI.IsShard()
    currentState.isTutorial = GameUI.IsTutorial()

    currentState.isScene    = GameUI.IsScene()
    currentState.isScanner  = GameUI.IsScanner()
    currentState.isQuickHack= GameUI.IsQuickHack()
    currentState.isPopup    = GameUI.IsPopup()
    currentState.isWheel    = GameUI.IsWheel()
    currentState.isDevice   = GameUI.IsDevice()
    currentState.isVehicle  = GameUI.IsVehicle()

    currentState.isFastTravel = GameUI.IsFastTravel()

    currentState.isBraindance = GameUI.IsBraindance()
    currentState.isCyberspace = GameUI.IsCyberspace()

    currentState.isJohnny    = GameUI.IsJohnny()
    currentState.isPossessed = GameUI.IsPossessed()
    currentState.isFlashback = GameUI.IsFlashback()

    currentState.isPhoto     = GameUI.IsPhoto()

    currentState.isEditor    = GameUI.IsContext(GameUI.Context.BraindanceEditor)

    currentState.isDefault = not currentState.isDetached
        and not currentState.isLoading
        and not currentState.isMenu
        and not currentState.isScene
        and not currentState.isScanner
        and not currentState.isQuickHack
        and not currentState.isPopup
        and not currentState.isWheel
        and not currentState.isDevice
        and not currentState.isFastTravel
        and not currentState.isBraindance
        and not currentState.isCyberspace
        and not currentState.isPhoto

    currentState.menu     = GameUI.GetMenu()
    currentState.submenu  = GameUI.GetSubmenu()
    currentState.camera   = GameUI.GetCamera()
    currentState.context  = GameUI.GetContext()

    for _, sp in _ipairs(stateProps) do
        if sp.previous then
            currentState[sp.previous] = previousState[sp.current]
        end
    end

    return currentState
end

function GameUI.ExportState(state)
    local export = {}

    if state.event then
        export[#export + 1] = 'event = ' .. string.format('%q', state.event)
    end

    for _, sp in _ipairs(stateProps) do
        local value = state[sp.current]
        if value and (not sp.parent or state[sp.parent]) then
            if type(value) == 'userdata' then
                value = string.format('%q', value.value)
            elseif type(value) == 'string' then
                value = string.format('%q', value)
            else
                value = tostring(value)
            end
            export[#export + 1] = sp.current .. ' = ' .. value
        end
    end

    for _, sp in _ipairs(stateProps) do
        if sp.previous then
            local cur = state[sp.current]
            local prv = state[sp.previous]
            if prv and prv ~= cur then
                if type(prv) == 'userdata' then
                    prv = string.format('%q', prv.value)
                elseif type(prv) == 'string' then
                    prv = string.format('%q', prv)
                else
                    prv = tostring(prv)
                end
                export[#export + 1] = sp.previous .. ' = ' .. prv
            end
        end
    end

    return '{ ' .. table.concat(export, ', ') .. ' }'
end

function GameUI.PrintState(state)
    print('[GameUI] ' .. GameUI.ExportState(state))
end

GameUI.On = GameUI.Listen

setmetatable(GameUI, {
    __index = function(_, key)
        local event = string.match(key, '^On(%w+)$')
        if event and GameUI.Event[event] then
            rawset(GameUI, key, function(callback)
                GameUI.Observe(event, callback)
            end)
            return rawget(GameUI, key)
        end
    end
})

return GameUI
