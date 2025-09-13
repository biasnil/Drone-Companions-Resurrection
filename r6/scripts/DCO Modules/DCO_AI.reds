module DCO


private static func HasRobotTag(ent: wref<GameObject>) -> Bool {
  let sp: wref<ScriptedPuppet> = ent as ScriptedPuppet;
  if !IsDefined(sp) { return false; }
  let rec = TweakDBInterface.GetCharacterRecord(sp.GetRecordID());
  return IsDefined(rec) && rec.TagsContains(n"Robot");
}

public static func IsFriendlyRobotCompanion(ent: wref<ScriptedPuppet>) -> Bool {
  if !IsDefined(ent) { return false; }

  let rec = TweakDBInterface.GetCharacterRecord(ent.GetRecordID());
  if !IsDefined(rec) || !rec.TagsContains(n"Robot") { return false; }

  let game: GameInstance = ent.GetGame();
  let player: wref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();

  if IsDefined(player) && Equals(GameObject.GetAttitudeTowards(ent, player), EAIAttitude.AIA_Friendly) {
    return true;
  };
  if ScriptedPuppet.IsPlayerCompanion(ent) {
    return true;
  };
  return false;
}

public static func GetDisableCombatFactName() -> CName = n"DCO_DisableCombat";

public class DCO_ClearDisableCombatEvent extends Event {}

@addMethod(PlayerPuppet)
protected cb func OnDCO_ClearDisableCombatEvent(evt: ref<DCO_ClearDisableCombatEvent>) -> Bool {
  let qs = GameInstance.GetQuestsSystem(this.GetGame());
  if IsDefined(qs) {
    qs.SetFact(GetDisableCombatFactName(), 0);
  };
  return true;
}

public class DCO_CombatGate extends IScriptable {
  public static func Kick(game: GameInstance, seconds: Float) -> Void {
    let qs = GameInstance.GetQuestsSystem(game);
    if !IsDefined(qs) { return; }

    qs.SetFact(GetDisableCombatFactName(), 1);

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    if IsDefined(player) {
      let evt: ref<DCO_ClearDisableCombatEvent> = new DCO_ClearDisableCombatEvent();
      GameInstance.GetDelaySystem(game).DelayEvent(player, evt, seconds);
    };
  }
}

@wrapMethod(SenseComponent)
public final static func ShouldIgnoreIfPlayerCompanion(owner: wref<Entity>, target: wref<Entity>) -> Bool {
  let sp: wref<ScriptedPuppet> = target as ScriptedPuppet;
  if IsDefined(sp) && IsFriendlyRobotCompanion(sp) {
    return false;
  };
  return wrappedMethod(owner, target);
}

@wrapMethod(AIActionHelper)
public final static func TryChangingAttitudeToHostile(owner: wref<ScriptedPuppet>, target: wref<GameObject>) -> Bool {
  if !IsDefined(owner) || !IsDefined(target) {
    return wrappedMethod(owner, target);
  };

  let game: GameInstance = owner.GetGame();
  let qs = GameInstance.GetQuestsSystem(game);
  if IsDefined(qs) && qs.GetFact(GetDisableCombatFactName()) > 0 {
    return false; 
  };

  let targetIsRobot: Bool = HasRobotTag(target);
  let ownerIsRobot: Bool = HasRobotTag(owner);

  if targetIsRobot && !ownerIsRobot {
    let ok: Bool = wrappedMethod(owner, target);

    let player: wref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    if IsDefined(player) {
      wrappedMethod(owner, player);
      TargetTrackingExtension.InjectThreat(owner, player, 0.10);
    };
    return ok;
  };

  return wrappedMethod(owner, target);
}

@wrapMethod(ReactionManagerComponent)
protected cb func OnDetectedEvent(evt: ref<OnDetectedEvent>) -> Bool {
  if !IsDefined(evt) || !IsDefined(evt.target) {
    return wrappedMethod(evt);
  };

  if !HasRobotTag(evt.target) {
    return wrappedMethod(evt);
  };

  if evt.isVisible {
    let ownerPuppet: wref<ScriptedPuppet> = this.GetOwnerPuppet();
    if IsDefined(ownerPuppet) {
      TargetTrackingExtension.InjectThreat(ownerPuppet, evt.target);
    };
  };

  return wrappedMethod(evt);
}

@wrapMethod(PreventionSystem)
public func ChangeAttitude(owner: wref<GameObject>, target: wref<GameObject>, desiredAttitude: EAIAttitude) -> Void {
  DCO_CombatGate.Kick(this.GetGameInstance(), 3.00);

  let ownerPuppet: wref<ScriptedPuppet> = owner as ScriptedPuppet;
  if IsDefined(ownerPuppet) {
    let rec = TweakDBInterface.GetCharacterRecord(ownerPuppet.GetRecordID());
    if IsDefined(rec) && rec.TagsContains(n"Robot") {
      return;
    };
  };

  wrappedMethod(owner, target, desiredAttitude);
}
