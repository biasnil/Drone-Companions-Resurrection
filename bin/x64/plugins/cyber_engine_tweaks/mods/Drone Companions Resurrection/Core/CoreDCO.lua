-- Core/CoreDCO.lua
-- Unified core for Drone Companions Resurrection

local CoreDCO = {
  _loaded   = false,
  _dirty    = false,
  _saving   = false,
  _watchers = {},
}

----------------------------------------------------------------------
-- Paths & JSON
----------------------------------------------------------------------
CoreDCO.CONFIG_PATH = "Data/config.json"

-- Use CET's global json if present; otherwise try lua-json
local _json = rawget(_G, "json")
if not _json then pcall(function() _json = require("json") end) end

----------------------------------------------------------------------
-- Defaults
----------------------------------------------------------------------
CoreDCO.DEFAULTS = {
  Language                   = "en",

  Immersive_Damage_Effects   = false,
  Immersive_Movement         = false,
  Disable_Enemies_On_Minimap = false,
  Aggro_On_Silenced_Gunshot  = false,
  Disable_Android_Voices     = true,
  Disable_Recoil_Recovery    = false,
  No_Shooting_Delay          = false,
  Permanent_Mechs            = false,
  Powerful_Minibosses        = false,
  Harder_Final_Boss_Fight    = false,
  Cyber_Enemies              = false,

  Drone_Core_Price           = 30,
  SystemExSlot               = 1,

  AndroidHP                  = 1.0,
  AndroidDPS                 = 1.0,
  FlyingHP                   = 1.0,
  FlyingDPS                  = 1.0,
  MechHP                     = 1.0,
  MechDPS                    = 1.0,

  RangedAndroidAppearance    = "Scavengers 3",
  ShotgunnerAndroidAppearance= "Sixth Street 6",
  MeleeAndroidAppearance     = "Maelstrom 1",
  NetrunnerAndroidAppearance = "Maelstrom 3",
  SniperAndroidAppearance    = "Badlands 2",
  TechieAndroidAppearance    = "Wraiths 5",
  BombusAppearance           = "Beam",

  Implement_Break_Hold       = false,
}

----------------------------------------------------------------------
-- Small IO helpers
----------------------------------------------------------------------
local function fileExists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

local function loadJSON(path, fallback)
  local f = io.open(path, "r")
  if not f then return fallback end
  local txt = f:read("*a"); f:close()
  if not _json then return fallback end
  local ok, tbl = pcall(function() return _json.decode(txt) end)
  return ok and tbl or fallback
end

local function saveJSON(path, tbl)
  if not _json then return end
  local f = assert(io.open(path, "w"))
  f:write(_json.encode(tbl))
  f:close()
end

local function mergeMissing(dst, src)
  for k, v in pairs(src) do
    if dst[k] == nil then dst[k] = v end
  end
end

----------------------------------------------------------------------
-- Optional Cron (debounced saves)
----------------------------------------------------------------------
local Cron
do
  local ok, mod = pcall(require, "Core/CoreCron")
  if ok and type(mod) == "table" then Cron = mod.Cron or mod end
  if not Cron then
    ok, mod = pcall(require, "Utilities/Cron")
    if ok then Cron = mod end
  end
end

local SAVE_DEBOUNCE = 0.25 -- seconds

local function scheduleSave(self)
  if not self._dirty or self._saving then return end
  self._saving = true
  if Cron and Cron.After then
    Cron.After(SAVE_DEBOUNCE, function()
      if self._dirty then
        saveJSON(self.CONFIG_PATH, self.cfg)
        self._dirty = false
      end
      self._saving = false
    end)
  else
    saveJSON(self.CONFIG_PATH, self.cfg)
    self._dirty  = false
    self._saving = false
  end
end

----------------------------------------------------------------------
-- Localization embedded (loads Localization/<lang>.lua)
----------------------------------------------------------------------
local function _tryRequire(modname)
  local ok, t = pcall(require, modname)
  return ok and t or nil
end

local function _getByPath(tbl, path)
  local node = tbl
  for seg in string.gmatch(path, "[^%.]+") do
    node = node and node[seg] or nil
    if not node then return nil end
  end
  return node
end

local function _fmt(s, vars)
  if not vars or type(s) ~= "string" then return s end
  s = s:gsub("{([%w_]+)}", function(k)
    local v = vars[k]; return v == nil and ("{"..k.."}") or tostring(v)
  end)
  s = s:gsub("{(%d+)}", function(i)
    local v = vars[tonumber(i)]; return v == nil and ("{"..i.."}") or tostring(v)
  end)
  return s
end

CoreDCO._loc = { lang = "en", tables = {}, current = nil }

function CoreDCO:_loadLangTable(code)
  local t = _tryRequire("Localization/"..code)
  if not t and code:find("-", 1, true) then
    t = _tryRequire("Localization/"..code:match("^[^%-]+"))
  end
  if not t then t = _tryRequire("Localization/en") or {} end
  return t
end

function CoreDCO:_setLangInternal(code)
  code = tostring(code or "en")
  local cache = self._loc.tables
  local t = cache[code]
  if not t then
    t = self:_loadLangTable(code)
    cache[code] = t
  end
  self._loc.lang, self._loc.current = code, t
end

function CoreDCO:setLang(code, autosave)
  self:_setLangInternal(code)
  if self.cfg then
    self:set("Language", self._loc.lang, autosave ~= false)
  end
  return self._loc
end

function CoreDCO:lang() return self._loc.lang end
function CoreDCO:getStrings() return self._loc.current or {} end

function CoreDCO:t(key, vars)
  local cur = self._loc.current or {}
  local val = _getByPath(cur, key)
  if val == nil and self._loc.lang ~= "en" then
    if not self._loc.tables.en then
      self._loc.tables.en = self:_loadLangTable("en")
    end
    val = _getByPath(self._loc.tables.en, key)
  end
  return _fmt(val or key, vars)
end
CoreDCO.L = function(key, vars) return CoreDCO:t(key, vars) end

function CoreDCO:_detectLang()
  local fromCfg = self.cfg and self.cfg.Language
  if fromCfg then return self:_setLangInternal(fromCfg) end
  local ok, mgr = pcall(Game.GetLocalizationManager or function() end)
  if ok and mgr and mgr.GetUntrustedLanguage then
    local code = mgr:GetUntrustedLanguage()
    if code then return self:_setLangInternal(code) end
  end
  self:_setLangInternal("en")
end

----------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------
function CoreDCO.init(pathOverride)
  if CoreDCO._loaded then return CoreDCO end
  if pathOverride then CoreDCO.CONFIG_PATH = pathOverride end

  -- ensure "Data" directory exists if possible (safe no-op otherwise)
  pcall(function()
    local ok, lfs = pcall(require, "lfs")
    if ok and lfs and lfs.mkdir then
      lfs.mkdir("Data")
    end
  end)

  if not fileExists(CoreDCO.CONFIG_PATH) then
    saveJSON(CoreDCO.CONFIG_PATH, CoreDCO.DEFAULTS)
  end

  CoreDCO.cfg = loadJSON(CoreDCO.CONFIG_PATH, {}) or {}
  mergeMissing(CoreDCO.cfg, CoreDCO.DEFAULTS)
  saveJSON(CoreDCO.CONFIG_PATH, CoreDCO.cfg)

  CoreDCO:_detectLang()

  CoreDCO._dirty  = false
  CoreDCO._saving = false
  CoreDCO._loaded = true
  return CoreDCO
end

function CoreDCO:get(key, default)
  if not self._loaded then self.init() end
  local v = self.cfg[key]
  if v == nil then return default end
  return v
end

function CoreDCO:set(key, value, autosave)
  if not self._loaded then self.init() end
  local old = self.cfg[key]
  if old == value then return end
  self.cfg[key] = value
  self._dirty = true

  for i = 1, #self._watchers do
    local fn = self._watchers[i]
    pcall(fn, self.cfg, key, value)
  end

  if autosave ~= false then
    scheduleSave(self)
  end
end

function CoreDCO:save()
  if not self._loaded then self.init() end
  saveJSON(self.CONFIG_PATH, self.cfg)
  self._dirty  = false
  self._saving = false
end

function CoreDCO:reload()
  self._loaded = false
  return self.init()
end

function CoreDCO:onChange(fn)
  self._watchers[#self._watchers + 1] = fn
end

----------------------------------------------------------------------
-- Backwards-compat for old config.lua-style API
----------------------------------------------------------------------
CoreDCO.fileExists = fileExists

function CoreDCO.tryCreateConfig(path, data)
  if not fileExists(path) then
    saveJSON(path, data or CoreDCO.DEFAULTS)
  end
end

function CoreDCO.loadFile(path)
  if not CoreDCO._loaded then CoreDCO.init(path) end
  if path and path ~= CoreDCO.CONFIG_PATH then
    CoreDCO.CONFIG_PATH = path
    CoreDCO.cfg = loadJSON(CoreDCO.CONFIG_PATH, CoreDCO.cfg or {}) or {}
    mergeMissing(CoreDCO.cfg, CoreDCO.DEFAULTS)
    CoreDCO:save()
  end
  return CoreDCO.cfg
end

function CoreDCO.saveFile(path, tbl)
  if path and path ~= CoreDCO.CONFIG_PATH then
    CoreDCO.CONFIG_PATH = path
  end
  if tbl then CoreDCO.cfg = tbl end
  CoreDCO:save()
end

function CoreDCO.backwardComp(path, data)
  if path and path ~= CoreDCO.CONFIG_PATH then
    CoreDCO.CONFIG_PATH = path
  end
  mergeMissing(CoreDCO.cfg or {}, data or CoreDCO.DEFAULTS)
  CoreDCO:save()
end

----------------------------------------------------------------------
-- Helpers + timers
----------------------------------------------------------------------
CoreDCO.util = {}

function CoreDCO.util.clamp(x, lo, hi)
  if x < lo then return lo end
  if x > hi then return hi end
  return x
end
function CoreDCO.util.lerp(a, b, t) return a + (b - a) * t end

function CoreDCO.util.trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
function CoreDCO.util.startswith(s, p) return s:sub(1, #p) == p end
function CoreDCO.util.endswith(s, p) return p == "" or s:sub(-#p) == p end

function CoreDCO.util.shallowCopy(t)
  local out = {}
  for k, v in pairs(t) do out[k] = v end
  return out
end
function CoreDCO.util.mergeMissing(dst, src) return mergeMissing(dst, src) end

function CoreDCO.util.setTimeout(sec, fn)
  if Cron and Cron.After then return Cron.After(sec, fn) end
  if fn then pcall(fn) end
  return nil
end
function CoreDCO.util.setInterval(sec, fn)
  if Cron and Cron.Every then return Cron.Every(sec, fn) end
  return nil
end
function CoreDCO.util.clearTimer(id)
  if Cron and Cron.Halt and id then Cron.Halt(id) end
end

----------------------------------------------------------------------
return CoreDCO.init()
