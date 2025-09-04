R = { 
    description = "DCO"
}

function DCO:new()

	--Stop them from getting in vehicle
	TweakDB:CloneRecord("DCO.AndroidOrHuman", "Condition.Human")
	TweakDB:SetFlat("DCO.AndroidOrHuman.allowedNPCTypes", {"NPCType.Android", "NPCType.Human"})
	
	TweakDB:CloneRecord("DCO.NotMechAI", "Condition.Human")
	TweakDB:SetFlat("DCO.NotMechAI.allowedNPCTypes", {"NPCType.Android", "NPCType.Human", "NPCType.Drone"})
	
	addToList("Condition.EnterVehicleAICondition.AND", "DCO.AndroidOrHuman")
	
	--Fix Beast having technically 4 seats
	TweakDB:SetFlat(TweakDB:GetFlat("Vehicle.v_standard3_thorton_mackinaw_ncu_player.vehDataPackage")..'.boneNames', {"seat_front_left", "seat_front_right"})
	TweakDB:SetFlat(TweakDB:GetFlat("Vehicle.v_standard3_thorton_mackinaw_ncu_player.vehDataPackage")..'.vehSeatSet', "Vehicle.Vehicle2SeatSetDefault")

	TweakDB:SetFlat("Condition.FollowerDrivingVehicle.freeSlots", {})

	doTwoSeaterFixCheck = true
	Observe('AISubActionMountVehicle_Record_Implementation', 'MountVehicle;ScriptExecutionContextAISubActionMountVehicle_Record', function(_, _)

		if not doTwoSeaterFixCheck then
			return
		end
		doTwoSeaterFixCheck = false
		
		--We also update the player's vehicle to fix two seaters seating AI
		vehicleID = Game.GetMountingFacility():GetMountingInfoSingleWithIds(Game.GetPlayer():GetEntityID(), _, _).parentId
		vehicle = VehicleObject:new()
		vehicle = Game.FindEntityByID(vehicleID)

		
		if vehicleID == nil then
		
		else
			Cron.After(3.5, function()
				doTwoSeaterFixCheck = true
				fixSeat = true
				for i,v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
					companionVehicleID = Game.GetMountingFacility():GetMountingInfoSingleWithIds(v:GetEntityID(), _, _).parentId
					cfor = v:GetWorldForward()
					playerfor = Game.GetPlayer():GetWorldForward()
					angle = Vector4.GetAngleBetween(cfor, playerfor)
					if Vector4.GetAngleBetween(cfor, playerfor) <0.1 then
						fixSeat = false
						break
					end

				end
				if fixSeat then
					vehicle.DCOFrontRightTaken = false
				end
			end)
		end
	end)
end


return DCO:new()
