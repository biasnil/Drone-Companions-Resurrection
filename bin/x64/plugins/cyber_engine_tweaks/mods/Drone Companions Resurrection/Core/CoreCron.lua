-- Core/CoreCron.lua
-- Unified Timed Tasks Manager (Cron + MenuCron share the same singleton)

local Cron = { version = '1.0.3' } -- bump version

local timers  = {}
local counter = 0

-- internal: add a timer
local function addTimer(timeout, recurring, callback, args)
  if type(timeout) ~= 'number'  or timeout < 0 then return end
  if type(recurring) ~= 'boolean'                then return end

  if type(callback) ~= 'function' then
    if type(args) == 'function' then
      callback, args = args, callback
    else
      return
    end
  end

  counter = counter + 1
  local t = {
    id        = counter,
    timeout   = timeout,
    delay     = timeout,
    recurring = recurring,
    callback  = callback,
    args      = args,
    active    = true,
  }
  timers[#timers + 1] = t
  return t
end

-- public API
function Cron.After(timeout, callback, data)
  return addTimer(timeout, false, callback, data)
end

function Cron.Every(timeout, callback, data)
  return addTimer(timeout, true, callback, data)
end

function Cron.NextTick(callback, data)
  return addTimer(0, false, callback, data)
end

function Cron.Halt(timerId)
  if type(timerId) == 'table' then timerId = timerId.id end
  for i = #timers, 1, -1 do
    if timers[i].id == timerId then
      table.remove(timers, i)
      break
    end
  end
end

function Cron.Pause(timerId)
  if type(timerId) == 'table' then timerId = timerId.id end
  for i = 1, #timers do
    local timer = timers[i]
    if timer.id == timerId then
      timer.active = false
      break
    end
  end
end

function Cron.Resume(timerId)
  if type(timerId) == 'table' then timerId = timerId.id end
  for i = 1, #timers do
    local timer = timers[i]
    if timer.id == timerId then
      timer.active = true
      break
    end
  end
end

-- IMPORTANT FIX: reverse loop when removing
function Cron.Update(delta)
  if #timers == 0 then return end
  delta = delta or 0
  for i = #timers, 1, -1 do
    local timer = timers[i]
    if timer.active then
      timer.delay = timer.delay - delta
      if timer.delay <= 0 then
        if timer.recurring then
          timer.delay = timer.delay + timer.timeout
        else
          table.remove(timers, i)
        end
        -- run after housekeeping so one-shot timers don't reenter
        timer.callback(timer.args)
      end
    end
  end
end

-- Export BOTH names pointing to the same object
local M = {}
M.Cron     = Cron
M.MenuCron = Cron
return M
