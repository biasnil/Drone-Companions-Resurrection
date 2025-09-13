-- r6/scripts/Drone AI - Flying.lua (shim)
DCO = { description = "DCO" }

function DCO:new()
  if Flying_List then
    for _, v in ipairs(Flying_List) do
      TweakDB:SetFlat(v..".combatDefaultZOffset", -0.2)
    end
  end
end

return DCO:new()
