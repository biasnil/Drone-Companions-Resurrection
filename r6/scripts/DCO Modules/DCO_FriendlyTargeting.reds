module DroneCompanionsRevamp

public static func DCO_IsRobot(obj: wref<GameObject>) -> Bool {
  let sp = obj as ScriptedPuppet;
  if IsDefined(sp) {
    let rec = TweakDBInterface.GetCharacterRecord(sp.GetRecordID());
    return IsDefined(rec) && rec.TagsContains(n"Robot");
  }
  return false;
}

public static func DCO_IsDCOCompanionRobot(obj: wref<GameObject>) -> Bool {
  let sp = obj as ScriptedPuppet;
  if !IsDefined(sp) { return false; }
  if !DCO_IsRobot(sp) { return false; }
  let ses = GameInstance.GetStatusEffectSystem(sp.GetGame());
  if !IsDefined(ses) { return false; }
  return ses.HasStatusEffect(sp.GetEntityID(), t"DCO.RobotSE");
}

public static func DCO_IsMechWeaponWeakspot(obj: wref<GameObject>) -> Bool {
  let ws = obj as ScriptedWeakspotObject;
  if !IsDefined(ws) { return false; }
  let id: TweakDBID = ws.GetRecord().GetID();
  return id == t"Weakspots.Mech_Weapon_Left_Weakspot" || id == t"Weakspots.Mech_Weapon_Right_Weakspot";
}

@wrapMethod(ScriptedPuppetPS)
public final const func IsQuickHacksExposed() -> Bool {
  let owner = this.GetOwnerEntity() as ScriptedPuppet;
  if DCO_IsDCOCompanionRobot(owner) { return true; }
  return wrappedMethod();
}

@wrapMethod(ScriptedPuppet)
public final func IsQuickHackAble() -> Bool {
  if DCO_IsDCOCompanionRobot(this) { return true; }
  return wrappedMethod();
}

@wrapMethod(NpcNameplateGameController)
private final func HelperCheckDistance(entity: ref<Entity>) -> Bool {
  if IsDefined(entity) && DCO_IsDCOCompanionRobot(entity as GameObject) { return true; }
  return wrappedMethod(entity);
}

@wrapMethod(NpcNameplateGameController)
protected cb func OnNameplateDataChanged(value: Variant) -> Bool {
  wrappedMethod(value);
  let d: NPCNextToTheCrosshair = FromVariant<NPCNextToTheCrosshair>(value);
  if IsDefined(d.npc) && DCO_IsDCOCompanionRobot(d.npc) {
    this.m_visualController.UpdateNPCNamesEnabled(true);
  }
}

@wrapMethod(NameplateVisualsLogicController)
public final func SetVisualData(puppet: ref<GameObject>, const incomingData: script_ref<NPCNextToTheCrosshair>, opt isNewNpc: Bool) -> Void {
  wrappedMethod(puppet, incomingData, isNewNpc);
  if IsDefined(puppet) && DCO_IsDCOCompanionRobot(puppet) {
    this.UpdateHealthbarColor(false);
    inkWidgetRef.SetVisible(this.m_healthbarWidget, true);
  } else {
    let hostile = Equals(Deref(incomingData).attitude, EAIAttitude.AIA_Hostile);
    this.UpdateHealthbarColor(hostile);
  }
}

@wrapMethod(NameplateVisualsLogicController)
public final func UpdateHealthbarColor(isHostile: Bool) -> Void {
  if IsDefined(this.m_cachedPuppet) && DCO_IsDCOCompanionRobot(this.m_cachedPuppet) {
    inkWidgetRef.SetState(this.m_healthbarWidget, n"Friendly");
    inkWidgetRef.SetState(this.m_healthBarFull, n"Friendly");
    inkWidgetRef.SetState(this.m_healthBarFrame, n"Friendly");
    return;
  }
  wrappedMethod(isHostile);
}

@wrapMethod(PlayerPuppet)
public final func UpdateLookAtObject(target: ref<GameObject>) -> Void {
  wrappedMethod(target);
  if !IsDefined(target) { return; }
  if DCO_IsDCOCompanionRobot(target) || DCO_IsMechWeaponWeakspot(target) {
    this.m_isAimingAtFriendly = false;
  }
}

@wrapMethod(DamageSystem)
private final func Process(hitEvent: ref<gameHitEvent>, cache: ref<CacheData>) -> Void {
  let instigatorSP = hitEvent.attackData.GetInstigator() as ScriptedPuppet;
  let targetSP = hitEvent.target as ScriptedPuppet;
  if IsDefined(instigatorSP) && IsDefined(targetSP) {
    let instIsDCO = DCO_IsDCOCompanionRobot(instigatorSP);
    let targIsDCO = DCO_IsDCOCompanionRobot(targetSP);
    if (instIsDCO && targIsDCO) || (instigatorSP.IsPlayer() && targIsDCO) || (instIsDCO && targetSP.IsPlayer()) {
      return;
    }
  }
  wrappedMethod(hitEvent, cache);
}
