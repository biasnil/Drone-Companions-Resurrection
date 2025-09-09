module DCO

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

public class DCO_SeatCheckCB extends DelayCallback {
  private let sys: wref<DCO_VehicleMounting>;
  public func Call() -> Void {
    if IsDefined(this.sys) {
      this.sys.OnSeatCheck();
    };
  }
  public static func Create(sys: wref<DCO_VehicleMounting>) -> ref<DCO_SeatCheckCB> {
    let c = new DCO_SeatCheckCB();
    c.sys = sys;
    return c;
  }
}

public class DCO_VehicleMounting extends ScriptableSystem {
  private let gate: Bool = true;
  private let gi: GameInstance;

  public static func Get(game: GameInstance) -> ref<DCO_VehicleMounting> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"DCO_VehicleMounting") as DCO_VehicleMounting;
  }

  public func PostMount(game: GameInstance) -> Void {
    if !this.gate { return; }
    this.gi = game;
    this.gate = false;
    GameInstance.GetDelaySystem(game).DelayCallback(DCO_SeatCheckCB.Create(this), 3.5, false);
  }

  public func OnSeatCheck() -> Void {
    this.gate = true;
    let game: GameInstance = this.gi;
    let player: wref<PlayerPuppet> = GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) { return; }
    let entities: array<wref<Entity>>;
    GameInstance.GetCompanionSystem(game).GetSpawnedEntities(entities);
    let pfor: Vector4 = player.GetWorldForward();
    let fixSeat: Bool = true;
    let i: Int32 = 0;
    while i < ArraySize(entities) {
      let go: wref<GameObject> = entities[i] as GameObject;
      if IsDefined(go) {
        let cfor: Vector4 = go.GetWorldForward();
        let ang: Float = Vector4.GetAngleBetween(cfor, pfor);
        if ang < 0.1 {
          fixSeat = false;
          break;
        };
      };
      i += 1;
    }
    if fixSeat {
      let mi: MountingInfo = GameInstance.GetMountingFacility(game).GetMountingInfoSingleWithObjects(player);
      let vehicleID: EntityID = mi.parentId;
      if EntityID.IsDefined(vehicleID) {
        let ent: wref<Entity> = GameInstance.FindEntityByID(game, vehicleID);
        let veh: wref<VehicleObject> = ent as VehicleObject;
        if IsDefined(veh) {
          veh.DCOFrontRightTaken = false;
        }
      }
    }
  }
}

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
  DCO_VehicleMounting.Get(gi).PostMount(gi);
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
    let go: wref<GameObject> = entities[i] as GameObject;
    mi = GameInstance.GetMountingFacility(vehicle.GetGame()).GetMountingInfoSingleWithObjects(go);
    if Equals(mi.slotId.id, slot) {
      return false;
    };
    i += 1;
  };
  return true;
}

@wrapMethod(VehicleComponent)
private final func CreateMappin() -> Void {
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
  DCO_VehicleMounting.Get(gi).PostMount(gi);
  return true;
}
