DCO = { description = "DCO" }

function DCO:new()
  for i = 1, DroneRecords do
    TweakDB:SetFlat("DCO.Tier1Bombus"..i..".actionMap", "DroneBombusFastArchetype.Map")
    TweakDB:SetFlat("DCO.Tier1Bombus"..i..".primaryEquipment", "DCO.BombusPrimaryEquipment")
    addToList("DCO.Tier1Bombus"..i..".onSpawnGLPs", "DCO.BombusGLP")
    addToList("DCO.Tier1Bombus"..i..".onSpawnGLPs", "DCO.BombusSystemCollapsePackage")
  end
end

return DCO:new()
