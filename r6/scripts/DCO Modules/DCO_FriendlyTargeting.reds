module DroneCompanionsRevamp

// ---------- Helpers ----------
public static func DCO_IsRobot(obj: wref<GameObject>) -> Bool {
  let sp = obj as ScriptedPuppet;
  if IsDefined(sp) {
    let rec = TweakDBInterface.GetCharacterRecord(sp.GetRecordID());
    return IsDefined(rec) && rec.TagsContains(n"Robot");
  }
  return false;
}

public static func DCO_IsMechWeaponWeakspot(obj: wref<GameObject>) -> Bool {
  let ws = obj as ScriptedWeakspotObject;
  if !IsDefined(ws) { return false; }
  let id: TweakDBID = ws.GetRecord().GetID();
  return id == t"Weakspots.Mech_Weapon_Left_Weakspot"
      || id == t"Weakspots.Mech_Weapon_Right_Weakspot";
}

// ---------- Quickhack exposure on friendly robots ----------
@wrapMethod(ScriptedPuppetPS)
public final const func IsQuickHacksExposed() -> Bool {
  let owner = this.GetOwnerEntity() as ScriptedPuppet; // (no redundant cast to GameObject)
  if DCO_IsRobot(owner) {
    return true;
  }
  return wrappedMethod();
}

// ---------- Allow quickhack cursor on friendly robots ----------
@wrapMethod(ScriptedPuppet)
public final func IsQuickHackAble() -> Bool {
  // Vehicle mount check removed (2.3: no IMountingFacility.GetMountedVehicle)
  if DCO_IsRobot(this) {
    return true;
  }
  return wrappedMethod();
}

// ---------- Nameplate: always allow display distance for friendly robots ----------
@wrapMethod(NpcNameplateGameController)
private final func HelperCheckDistance(entity: ref<Entity>) -> Bool {
  if IsDefined(entity) {
    let obj: wref<GameObject> = entity as GameObject;
    if DCO_IsRobot(obj) {
      return true;
    }
  }
  return wrappedMethod(entity);
}

// ---------- Aiming: don’t trip “aiming at friendly” on our bots / mech weapon weakspots ----------
@wrapMethod(PlayerPuppet)
public final func UpdateLookAtObject(target: ref<GameObject>) -> Void {
  wrappedMethod(target); // (method takes 1 param in 2.3)

  if !IsDefined(target) { return; }

  if DCO_IsRobot(target) || DCO_IsMechWeaponWeakspot(target) {
    // Field name in 2.3 is m_isAimingAtFriendly (not isAimingAtFriendly)
    this.m_isAimingAtFriendly = false;
  }
}

@wrapMethod(DamageSystem)
  private final func Process(hitEvent: ref<gameHitEvent>, cache: ref<CacheData>) -> Void {
		if IsDefined(hitEvent.attackData.GetInstigator() as ScriptedPuppet) && IsDefined(hitEvent.target as ScriptedPuppet){
			if ((hitEvent.attackData.GetInstigator() as ScriptedPuppet).GetRecord().TagsContains(n"Robot")
			&&  (hitEvent.target as ScriptedPuppet).GetRecord().TagsContains(n"Robot"))
			
			||((hitEvent.attackData.GetInstigator() as ScriptedPuppet).IsPlayer()
			&&  (hitEvent.target as ScriptedPuppet).GetRecord().TagsContains(n"Robot"))
			
			
			||((hitEvent.attackData.GetInstigator() as ScriptedPuppet).GetRecord().TagsContains(n"Robot")
			&&  (hitEvent.target as ScriptedPuppet).IsPlayer())
			
			{
				return;
			}
		}
	wrappedMethod(hitEvent, cache);
}