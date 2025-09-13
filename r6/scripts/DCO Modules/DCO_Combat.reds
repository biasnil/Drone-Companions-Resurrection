module DroneCompanionsRevamp

private static func DCO_IsRobot_Combat(obj: wref<GameObject>) -> Bool {
  let sp = obj as ScriptedPuppet;
  if !IsDefined(sp) { return false; }
  let rec = TweakDBInterface.GetCharacterRecord(sp.GetRecordID());
  return IsDefined(rec) && rec.TagsContains(n"Robot");
}

private static func DCO_IsDCOCompanionRobot_Combat(obj: wref<GameObject>) -> Bool {
  let sp = obj as ScriptedPuppet;
  if !IsDefined(sp) { return false; }
  if !DCO_IsRobot_Combat(sp) { return false; }
  let ses = GameInstance.GetStatusEffectSystem(sp.GetGame());
  return IsDefined(ses) && ses.HasStatusEffect(sp.GetEntityID(), t"DCO.RobotSE");
}

@wrapMethod(DamageDigitsGameController)
protected cb func OnDamageAdded(value: Variant) -> Bool {
  let baseResult = wrappedMethod(value);
  let damageList: array<DamageInfo> = FromVariant<array<DamageInfo>>(value);
  let i: Int32 = 0;
  while i < ArraySize(damageList) {
    let di: DamageInfo = damageList[i];
    if !Equals(this.m_realOwner, di.instigator) {
      let instSP: wref<ScriptedPuppet> = di.instigator as ScriptedPuppet;
      if IsDefined(instSP) {
        let instRec = TweakDBInterface.GetCharacterRecord(instSP.GetRecord().GetID());
        if IsDefined(instRec) && instRec.TagsContains(n"Robot") {
          if this.ShowDamageFloater(di) {
            let isDot: Bool = this.IsDamageOverTime(di);
            let ctrl: wref<DamageDigitLogicController> = this.m_digitsQueue.Dequeue() as DamageDigitLogicController;
            if IsDefined(ctrl) {
              ctrl.Show(di, false, isDot);
            }
          }
        }
      }
    }

    i += 1;
  }

  return baseResult;
}

@wrapMethod(GameObject)
public final func FindAndRewardKiller(killType: gameKillType, opt instigator: wref<GameObject>) -> Void {
  if IsDefined(instigator as NPCPuppet) {
    if DCO_IsRobot_Combat(instigator) {
      instigator = GetPlayer(this.GetGame());
    }
  }

  let i: Int32 = 0;
  while i < ArraySize(this.m_receivedDamageHistory) {
    let srcGO: wref<GameObject> = this.m_receivedDamageHistory[i].source;
    if IsDefined(srcGO as NPCPuppet) && DCO_IsRobot_Combat(srcGO) {
      this.m_receivedDamageHistory[i].source = GetPlayer(this.GetGame());
    }
    i += 1;
  }

  wrappedMethod(killType, instigator);
}

@wrapMethod(AIActionTarget)
private final static func BossThreatCalculation(owner: wref<ScriptedPuppet>, ownerPos: Vector4, targetTrackerComponent: ref<TargetTrackerComponent>, newTargetObject: wref<GameObject>, threat: wref<GameObject>, timeSinceTargetChange: Float, currentTime: Float, out threatValue: Float) -> Void {
  wrappedMethod(owner, ownerPos, targetTrackerComponent, newTargetObject, threat, timeSinceTargetChange, currentTime, threatValue);

  let ownerNPC: wref<NPCPuppet> = owner as NPCPuppet;
  let threatNPC: wref<NPCPuppet> = threat as NPCPuppet;
  if !IsDefined(ownerNPC) || !IsDefined(threatNPC) { return; }

  let threatRec = TweakDBInterface.GetCharacterRecord(threatNPC.GetRecord().GetID());
  if !IsDefined(threatRec) || !threatRec.TagsContains(n"Robot") { return; }

  let SES = GameInstance.GetStatusEffectSystem(owner.GetGame());
  let threatType: gamedataNPCType = threatNPC.GetNPCType();

  switch threatType {
    case gamedataNPCType.Drone:   threatValue *= 1.5; break;
    case gamedataNPCType.Android: threatValue *= 1.5; break;
    case gamedataNPCType.Mech:    threatValue *= 1.5; break;
  }

  let targetHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
  let playerHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(owner.GetGame()).GetEntityID()), gamedataStatPoolType.Health, true);
  if playerHP > 40.0 {
    threatValue *= 2.0 - (targetHP) / 100.0;
  }

  let tID: EntityID = threat.GetEntityID();
  if SES.HasStatusEffect(tID, t"DCO.DroneCloakSE") || SES.HasStatusEffect(tID, t"DCO.DroneCloakSESpread") || SES.HasStatusEffect(tID, t"DCO.DroneCloakOnHitSE") {
    threatValue *= 0.25;
  }

  let distToPlayer: Float = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), owner.GetWorldPosition());
  if distToPlayer > 5.0 {
    let distToTarget: Float = Vector4.Distance(owner.GetWorldPosition(), threat.GetWorldPosition());
    let clamped: Float = distToTarget;
    if clamped > 30.0 { clamped = 30.0; }
    threatValue *= 1.5 - clamped / 60.0;
  }

  if StatusEffectSystem.ObjectHasStatusEffectWithTag(GetPlayer(owner.GetGame()), n"FistFight") {
    threatValue = 0.0;
  }
}

@wrapMethod(AIActionTarget)
private final static func RegularThreatCalculation(owner: wref<ScriptedPuppet>, ownerPos: Vector4, targetTrackerComponent: ref<TargetTrackerComponent>, newTargetObject: wref<GameObject>, threat: wref<GameObject>, timeSinceTargetChange: Float, currentTime: Float, out threatValue: Float) -> Void {
  wrappedMethod(owner, ownerPos, targetTrackerComponent, newTargetObject, threat, timeSinceTargetChange, currentTime, threatValue);

  if !IsDefined(owner) || !IsDefined(threat) { return; }

  let SES = GameInstance.GetStatusEffectSystem(owner.GetGame());
  let ownerNPC: wref<NPCPuppet> = owner as NPCPuppet;
  let threatNPC: wref<NPCPuppet> = threat as NPCPuppet;
  if !IsDefined(ownerNPC) || !IsDefined(threatNPC) { return; }

  // owner is a robot: value certain targets/debuffs
  if DCO_IsRobot_Combat(ownerNPC) {
    if threat.IsTaggedinFocusMode() { threatValue *= 10.0; }

    let distToPlayer: Float = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), threat.GetWorldPosition());
    let clampedA: Float = distToPlayer;
    if clampedA > 30.0 { clampedA = 30.0; }
    threatValue *= 1.5 - clampedA / 60.0;

    let targetHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
    threatValue *= 1.5 - (targetHP * 0.5) / 100.0;

    let threadEntID: EntityID = threat.GetEntityID();
    let archetypeType: gamedataArchetypeType = TweakDBInterface.GetCharacterRecord(ownerNPC.GetRecord().GetID()).ArchetypeData().Type().Type();
    if Equals(archetypeType, gamedataArchetypeType.NetrunnerT3) {
      if SES.HasStatusEffect(threadEntID, t"BaseStatusEffect.Madness")            { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidContagionSE")             { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidOverheatSE")              { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidOverloadSE")              { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidCrippleSE")               { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidBlindSE")                 { threatValue *= 0.5; }
      if SES.HasStatusEffect(threadEntID, t"BaseStatusEffect.WeaponMalfunction") { threatValue *= 0.5; }

      if IsDefined(threatNPC) && threatNPC.IsMechanical() { threatValue *= 5.0; }
    };
  }

  // threat is a robot: adjust by type + owner archetype
  if DCO_IsRobot_Combat(threatNPC) {
    let threatType: gamedataNPCType = threatNPC.GetNPCType();
    let ownerArch: gamedataArchetypeType = TweakDBInterface.GetCharacterRecord(ownerNPC.GetRecord().GetID()).ArchetypeData().Type().Type();

    switch threatType {
      case gamedataNPCType.Drone:
        switch ownerArch {
          case gamedataArchetypeType.FastSniperT3:
          case gamedataArchetypeType.NetrunnerT1:
          case gamedataArchetypeType.NetrunnerT2:
          case gamedataArchetypeType.NetrunnerT3:
          case gamedataArchetypeType.SniperT2:
            threatValue *= 0.5;
            break;
        }
        threatValue *= 0.7;
        break;

      case gamedataNPCType.Android:
        switch ownerArch {
          case gamedataArchetypeType.FastSniperT3:
          case gamedataArchetypeType.NetrunnerT1:
          case gamedataArchetypeType.NetrunnerT2:
          case gamedataArchetypeType.NetrunnerT3:
          case gamedataArchetypeType.SniperT2:
            threatValue *= 0.5;
            break;
        }
        threatValue *= 1.2;
        break;

      case gamedataNPCType.Mech:
        switch ownerArch {
          case gamedataArchetypeType.FastMeleeT2:
          case gamedataArchetypeType.FastMeleeT3:
          case gamedataArchetypeType.FastShotgunnerT2:
          case gamedataArchetypeType.FastShotgunnerT3:
          case gamedataArchetypeType.FastSniperT3:
          case gamedataArchetypeType.GenericMeleeT1:
          case gamedataArchetypeType.GenericMeleeT2:
          case gamedataArchetypeType.HeavyMeleeT2:
          case gamedataArchetypeType.NetrunnerT1:
          case gamedataArchetypeType.NetrunnerT2:
          case gamedataArchetypeType.NetrunnerT3:
          case gamedataArchetypeType.ShotgunnerT2:
          case gamedataArchetypeType.ShotgunnerT3:
          case gamedataArchetypeType.SniperT2:
            threatValue *= 0.3;
            break;
        }
        threatValue *= 2.0;
        break;
    }

    let tID2: EntityID = threat.GetEntityID();
    if SES.HasStatusEffect(tID2, t"DCO.DroneCloakSE") || SES.HasStatusEffect(tID2, t"DCO.DroneCloakSESpread") || SES.HasStatusEffect(tID2, t"DCO.DroneCloakOnHitSE") {
      threatValue *= 0.25;
    }

    let targetHP2: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
    let playerHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(owner.GetGame()).GetEntityID()), gamedataStatPoolType.Health, true);
    if playerHP > 40.0 {
      threatValue *= 2.0 - (targetHP2) / 100.0;
    }

    let distToPlayer2: Float = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), owner.GetWorldPosition());
    if distToPlayer2 > 5.0 {
      let distToTarget2: Float = Vector4.Distance(owner.GetWorldPosition(), threat.GetWorldPosition());
      let clampedB: Float = distToTarget2;
      if clampedB > 30.0 { clampedB = 30.0; }
      threatValue *= 1.5 - clampedB / 60.0;
    }

    if StatusEffectSystem.ObjectHasStatusEffectWithTag(GetPlayer(owner.GetGame()), n"FistFight") {
      threatValue = 0.0;
    }
  }
}

@addField(ScriptedPuppet)
public let dcoLastAggressorBot: wref<ScriptedPuppet>;

@wrapMethod(DamageSystem)
private final func Process(hitEvent: ref<gameHitEvent>, cache: ref<CacheData>) -> Void {
  let i = hitEvent.attackData.GetInstigator() as ScriptedPuppet;
  let t = hitEvent.target as ScriptedPuppet;
  if IsDefined(i) && IsDefined(t) && DCO_IsDCOCompanionRobot_Combat(i) {
    t.dcoLastAggressorBot = i;
  }
  wrappedMethod(hitEvent, cache);
}

@wrapMethod(AIActionHelper)
public final static func TryChangingAttitudeToHostile(owner: ref<ScriptedPuppet>, target: ref<GameObject>) -> Bool {
  if IsDefined(owner) && IsDefined(target) && target.IsPlayer() {
    let PlayerMinDist: Float = 20.0;
    let MaxBotDist:    Float = 30.0;
    let ThreatBoost:   Float = 4.0;

    let player = target as ScriptedPuppet;
    let pd = Vector4.Distance(player.GetWorldPosition(), owner.GetWorldPosition());
    if pd > PlayerMinDist {
      let bot = owner.dcoLastAggressorBot;
      if IsDefined(bot) && DCO_IsDCOCompanionRobot_Combat(bot) {
        let bd = Vector4.Distance(bot.GetWorldPosition(), owner.GetWorldPosition());
        if bd <= MaxBotDist {
          let changed = wrappedMethod(owner, bot);
          if changed {
            TargetTrackingExtension.InjectThreat(owner, bot, ThreatBoost);
            return true;
          }
        }
      }
    }
  }
  return wrappedMethod(owner, target);
}
