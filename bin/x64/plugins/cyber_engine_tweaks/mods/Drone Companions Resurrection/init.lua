local Event    = require("Event/Bus")
local Listener = require("Event/EventListener")

-- Wire handlers to our internal bus
Event.on("onInit",   Listener.handleInit)
Event.on("onTweak",  Listener.handleTweak)
Event.on("onUpdate", Listener.handleUpdate)

-- Bridge CET → internal bus
registerForEvent("onInit",   function()           Event.emit("onInit") end)
registerForEvent("onTweak",  function()           Event.emit("onTweak") end)
registerForEvent("onUpdate", function(dt)         Event.emit("onUpdate", dt) end)
