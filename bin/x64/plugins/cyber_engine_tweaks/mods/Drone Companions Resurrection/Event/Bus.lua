-- Event/Bus.lua
-- Minimal event emitter for DCR (on/once/off/emit/clear/count)

local Bus = { _h = {} }

-- Register a handler
function Bus.on(name, fn)
  if type(name) ~= "string" or type(fn) ~= "function" then return end
  local t = Bus._h[name]; if not t then t = {}; Bus._h[name] = t end
  t[#t + 1] = fn
  return fn
end

-- Register a one-shot handler
function Bus.once(name, fn)
  if type(fn) ~= "function" then return end
  local wrapper
  wrapper = function(...)
    Bus.off(name, wrapper)
    return fn(...)
  end
  return Bus.on(name, wrapper)
end

-- Remove a specific handler
function Bus.off(name, fn)
  local t = Bus._h[name]; if not t then return end
  for i = #t, 1, -1 do
    if t[i] == fn then table.remove(t, i) end
  end
  if #t == 0 then Bus._h[name] = nil end
end

-- Emit an event (safe: each handler runs via pcall)
function Bus.emit(name, ...)
  local t = Bus._h[name]; if not t or #t == 0 then return end
  -- snapshot so handlers can add/remove during emit
  local snap = {}
  for i = 1, #t do snap[i] = t[i] end
  for i = 1, #snap do
    local ok, err = pcall(snap[i], ...)
    if not ok then
      print(("[DCO] Event '%s' handler error: %s"):format(name, err))
    end
  end
end

-- Clear handlers (for one event or all)
function Bus.clear(name)
  if name then Bus._h[name] = nil else Bus._h = {} end
end

-- How many handlers are registered for this event?
function Bus.count(name)
  local t = Bus._h[name]; return t and #t or 0
end

return Bus
