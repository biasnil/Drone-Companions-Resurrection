@addField(VehicleObject)
let DCOFrontLeftTaken: Bool;

@addField(VehicleObject)
let DCOFrontRightTaken: Bool;

@addField(VehicleObject)
let DCOBackLeftTaken: Bool;

@addField(VehicleObject)
let DCOBackRightTaken: Bool;

@addField(CompanionSystem)
let DCOPlayerVehicles: array<wref<VehicleObject>>;

@wrapMethod(AISubActionMountVehicle_Record_Implementation)
public final static func MountVehicle(context: ScriptExecutionContext, record: wref<AISubActionMountVehicle_Record>) -> Bool {
  if !TweakDBInterface.GetCharacterRecord(ScriptExecutionContext.GetOwner(context).GetRecordID()).TagsContains(n"Robot") {
    return wrappedMethod(context, record);
  };

  let evt: ref<MountAIEvent>;
  let mountData: ref<MountEventData>;
  let slotName: CName;
  let vehicle: wref<VehicleObject>;
  let gi: GameInstance = ScriptExecutionContext.GetOwner(context).GetGame();

  if GameInstance.GetBlackboardSystem(gi).GetLocalInstanced(GetPlayer(gi).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine).GetInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier) > 1 {
    return false;
  };

  if !AIActionTarget.GetVehicleObject(context, record.Vehicle(), vehicle) {
    return false;
  };

  if vehicle.IsDestroyed() {
    return false;
  };

  let DCOFoundSeat: Bool;
  let seats: array<wref<VehicleSeat_Record>>;
  if !VehicleComponent.GetSeats(vehicle.GetGame(), vehicle, seats) {
    return false;
  };

  let ranOutOfSeats: Bool = false;
  slotName = n"seat_front_right";

  if Equals(slotName, n"seat_front_right") && !DCOFoundSeat {
    if vehicle.DCOFrontRightTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_front_right") {
      slotName = n"seat_back_left";
      if ArraySize(seats) < 3 {
        ranOutOfSeats = true;
      };
    } else {
      vehicle.DCOFrontRightTaken = true;
      vehicle.DCOBackLeftTaken = false;
      DCOFoundSeat = true;
    };
  };

  if Equals(slotName, n"seat_back_left") && !DCOFoundSeat {
    if vehicle.DCOBackLeftTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_back_left") || ranOutOfSeats {
      slotName = n"seat_back_right";
      if ArraySize(seats) < 4 {
        ranOutOfSeats = true;
      };
    } else {
      vehicle.DCOBackLeftTaken = true;
      vehicle.DCOBackRightTaken = false;
      DCOFoundSeat = true;
    };
  };

  if Equals(slotName, n"seat_back_right") && !DCOFoundSeat {
    if vehicle.DCOBackRightTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_back_right") || ranOutOfSeats {
      return false;
    } else {
      vehicle.DCOBackRightTaken = true;
      vehicle.DCOFrontRightTaken = false;
      DCOFoundSeat = true;
    };
  };

  mountData = new MountEventData();
  mountData.slotName = slotName;
  if Equals((ScriptExecutionContext.GetOwner(context) as NPCPuppet).GetNPCType(), gamedataNPCType.Drone) {
    mountData.slotName = TweakDBInterface.GetCName(t"DCO.DroneCarSlot", n"trunk_body");
  };
  mountData.mountParentEntityId = vehicle.GetEntityID();
  mountData.isInstant = false;
  mountData.ignoreHLS = true;
  evt = new MountAIEvent();
  evt.name = n"Mount";
  evt.data = mountData;
  ScriptExecutionContext.GetOwner(context).QueueEvent(evt);
  return true;
}

@addMethod(AISubActionMountVehicle_Record_Implementation)
public static func DCOCheckSlot(vehicle: wref<VehicleObject>, slot: CName) -> Bool {
  let i: Int32 = 0;
  let gi: GameInstance = vehicle.GetGame();
  let mi: MountingInfo;
  let entities: array<wref<Entity>>;
  GameInstance.GetCompanionSystem(gi).GetSpawnedEntities(entities);
  while i < ArraySize(entities) {
    mi = GameInstance.GetMountingFacility(vehicle.GetGame()).GetMountingInfoSingleWithObjects(entities[i] as GameObject);
    if Equals(mi.slotId.id, slot) {
      return false;
    };
    i += 1;
  };
  return true;
}

@wrapMethod(VehicleComponent)
private final func CreateMappin() -> Void {
  let isBike: Bool;
  let mappinData: MappinData;
  let system: ref<MappinSystem>;
  if this.CanShowMappin() {
    if Equals(this.m_mappinID.value, Cast(0u)) {
      if !this.GetVehicle().IsPrevention() {
        ArrayPush(GameInstance.GetCompanionSystem(this.GetVehicle().GetGame()).DCOPlayerVehicles, this.GetVehicle());
      };
    };
  };
  wrappedMethod();
}

@addMethod(AISubActionMountVehicle_Record_Implementation)
public final static func DCOMountOtherVehicle(context: ScriptExecutionContext, vehicle: wref<VehicleObject>) -> Bool {
  if !IsDefined(vehicle) {
    return false;
  };

  let evt: ref<MountAIEvent>;
  let mountData: ref<MountEventData>;
  let slotName: CName;
  let gi: GameInstance = ScriptExecutionContext.GetOwner(context).GetGame();

  if GameInstance.GetBlackboardSystem(gi).GetLocalInstanced(GetPlayer(gi).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine).GetInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier) > 1 {
    return false;
  };

  if vehicle.IsDestroyed() {
    return false;
  };

  let DCOFoundSeat: Bool;
  slotName = n"seat_front_left";

  if Equals(slotName, n"seat_front_left") && !DCOFoundSeat {
    if vehicle.DCOFrontRightTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_front_left") {
      slotName = n"seat_back_right";
    } else {
      vehicle.DCOFrontLeftTaken = true;
      vehicle.DCOFrontRightTaken = false;
      DCOFoundSeat = true;
    };
  };

  if Equals(slotName, n"seat_front_right") && !DCOFoundSeat {
    if vehicle.DCOFrontRightTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_front_right") {
      slotName = n"seat_back_left";
    } else {
      vehicle.DCOFrontRightTaken = true;
      vehicle.DCOBackLeftTaken = false;
      DCOFoundSeat = true;
    };
  };

  if Equals(slotName, n"seat_back_left") && !DCOFoundSeat {
    if vehicle.DCOBackLeftTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_back_left") {
      slotName = n"seat_back_right";
    } else {
      vehicle.DCOBackLeftTaken = true;
      vehicle.DCOBackRightTaken = false;
      DCOFoundSeat = true;
    };
  };

  if Equals(slotName, n"seat_back_right") && !DCOFoundSeat {
    if vehicle.DCOBackRightTaken || !AISubActionMountVehicle_Record_Implementation.DCOCheckSlot(vehicle, n"seat_back_right") {
      return false;
    } else {
      vehicle.DCOBackRightTaken = true;
      vehicle.DCOFrontLeftTaken = false;
      DCOFoundSeat = true;
    };
  };

  mountData = new MountEventData();
  mountData.slotName = slotName;
  mountData.mountParentEntityId = vehicle.GetEntityID();
  mountData.isInstant = true;
  mountData.ignoreHLS = true;
  evt = new MountAIEvent();
  evt.name = n"Mount";
  evt.data = mountData;
  ScriptExecutionContext.GetOwner(context).QueueEvent(evt);

  if Equals(slotName, n"seat_front_left") {
    let cmd: ref<AIVehicleFollowCommand> = new AIVehicleFollowCommand();
    cmd.target = GetPlayer(gi);
    cmd.stopWhenTargetReached = false;
    cmd.distanceMin = 4;
    cmd.distanceMax = 8;
    cmd.useTraffic = false;
    cmd.needDriver = true;
    let fEvt: ref<AICommandEvent> = new AICommandEvent();
    fEvt.command = cmd;
    vehicle.QueueEvent(fEvt);
  };

  return true;
}
