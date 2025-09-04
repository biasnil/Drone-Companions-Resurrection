@replaceMethod(DamageDigitsGameController)
protected cb func OnDamageAdded(value: Variant) -> Bool {
  let controller: wref<DamageDigitLogicController>;
  let controllerFound: Bool;
  let damageInfo: DamageInfo;
  let damageListIndividual: array<DamageInfo>;
  let damageOverTime: Bool;
  let dotControllerFound: Bool;
  let entityDamageEntryList: array<DamageEntry>;
  let entityID: EntityID;
  let entityIDList: array<EntityID>;
  let k: Int32;
  let listPosition: Int32;
  let oneInstance: Bool;
  let showingBothSecondary: Bool;
  let damageList: array<DamageInfo> = FromVariant<array<DamageInfo>>(value);
  let showingBoth: Bool = this.m_showDigitsIndividual && this.m_showDigitsAccumulated && (Equals(this.m_damageDigitsStickingMode, IntEnum<gameuiDamageDigitsStickingMode>(0l)) || Equals(this.m_damageDigitsStickingMode, gameuiDamageDigitsStickingMode.Both));
  let individualDigitsSticking: Bool = Equals(this.m_damageDigitsStickingMode, gameuiDamageDigitsStickingMode.Individual) || Equals(this.m_damageDigitsStickingMode, gameuiDamageDigitsStickingMode.Both);
  let accumulatedDigitsSticking: Bool = Equals(this.m_damageDigitsStickingMode, gameuiDamageDigitsStickingMode.Accumulated) || Equals(this.m_damageDigitsStickingMode, gameuiDamageDigitsStickingMode.Both);
  let i: Int32 = 0;
  while i < ArraySize(damageList) {
    damageInfo = damageList[i];
    if Equals(this.m_realOwner, damageInfo.instigator) || (IsDefined(damageInfo.instigator as NPCPuppet) && (damageInfo.instigator as NPCPuppet).GetRecord().TagsContains(n"Robot")) {
      if this.ShowDamageFloater(damageInfo) {
        damageOverTime = this.IsDamageOverTime(damageInfo);
        if this.m_showDigitsAccumulated {
          if !EntityID.IsDefined(entityID) || entityID != damageInfo.entityHit.GetEntityID() {
            entityID = damageInfo.entityHit.GetEntityID();
            
		  //listPosition = ArrayFindFirst(entityIDList, entityID);
		  
		  let dcoi:Int32 = 0;
		  while dcoi<ArraySize(entityIDList){
			if Equals(entityID, entityIDList[i]){
				break;
			}
			dcoi+=1;
		  }
		  listPosition = dcoi;
		  
            if listPosition == -1 {
              listPosition = ArraySize(entityIDList);
              ArrayPush(entityIDList, entityID);
              ArrayGrow(entityDamageEntryList, 1);
            };
          };
          if damageOverTime && !accumulatedDigitsSticking {
            if entityDamageEntryList[listPosition].m_hasDamageOverTimeInfo {
              entityDamageEntryList[listPosition].m_damageOverTimeInfo.damageValue += damageInfo.damageValue;
              entityDamageEntryList[listPosition].m_damageOverTimeInfo.hitPosition += damageInfo.hitPosition;
              entityDamageEntryList[listPosition].m_damageOverTimeInfo.hitPosition *= 0.50;
              entityDamageEntryList[listPosition].m_oneDotInstance = false;
            } else {
              entityDamageEntryList[listPosition].m_damageOverTimeInfo = damageInfo;
              entityDamageEntryList[listPosition].m_hasDamageOverTimeInfo = true;
              entityDamageEntryList[listPosition].m_oneDotInstance = true;
            };
          } else {
            if entityDamageEntryList[listPosition].m_hasDamageInfo {
              entityDamageEntryList[listPosition].m_damageInfo.damageValue += damageInfo.damageValue;
              entityDamageEntryList[listPosition].m_damageInfo.hitPosition += damageInfo.hitPosition;
              entityDamageEntryList[listPosition].m_damageInfo.hitPosition *= 0.50;
              entityDamageEntryList[listPosition].m_oneInstance = false;
            } else {
              entityDamageEntryList[listPosition].m_damageInfo = damageInfo;
              entityDamageEntryList[listPosition].m_hasDamageInfo = true;
              entityDamageEntryList[listPosition].m_oneInstance = true;
            };
          };
        };
        if this.m_showDigitsIndividual {
          if this.m_showDigitsAccumulated {
            ArrayPush(damageListIndividual, damageInfo);
          } else {
            controller = this.m_digitsQueue.Dequeue() as DamageDigitLogicController;
            controller.Show(damageInfo, false, damageOverTime);
          };
        };
      };
    };
    i += 1;
  };
  if this.m_showDigitsAccumulated {
    i = 0;
    while i < ArraySize(entityIDList) {
      entityID = entityIDList[i];
      controllerFound = !entityDamageEntryList[i].m_hasDamageInfo;
      dotControllerFound = !entityDamageEntryList[i].m_hasDamageOverTimeInfo;
      k = 0;
      while k < this.m_maxAccumulatedVisible {
        if this.m_accumulatedControllerArray[k].m_used && this.m_accumulatedControllerArray[k].m_entityID == entityID {
          if entityDamageEntryList[i].m_hasDamageInfo && (!this.m_accumulatedControllerArray[k].m_isDamageOverTime || accumulatedDigitsSticking) {
            if !controllerFound {
              this.m_accumulatedControllerArray[k].m_controller.UpdateDamageInfo(entityDamageEntryList[i].m_damageInfo, showingBoth);
              entityDamageEntryList[i].m_oneInstance = false;
              controllerFound = true;
            };
          } else {
            if entityDamageEntryList[i].m_hasDamageOverTimeInfo && this.m_accumulatedControllerArray[k].m_isDamageOverTime {
              if !dotControllerFound {
                this.m_accumulatedControllerArray[k].m_controller.UpdateDamageInfo(entityDamageEntryList[i].m_damageOverTimeInfo, this.m_showDigitsIndividual);
                entityDamageEntryList[i].m_oneDotInstance = false;
                dotControllerFound = true;
              };
            };
          };
          if this.m_accumulatedControllerArray[k].m_isDamageOverTime {
            entityDamageEntryList[i].m_hasDotAccumulator = true;
          };
        };
        k += 1;
      };
      if !controllerFound {
        oneInstance = entityDamageEntryList[i].m_oneInstance;
        k = 0;
        while k < this.m_maxAccumulatedVisible {
          if !this.m_accumulatedControllerArray[k].m_used {
            this.m_accumulatedControllerArray[k].m_used = true;
            this.m_accumulatedControllerArray[k].m_entityID = entityID;
            this.m_accumulatedControllerArray[k].m_isDamageOverTime = false;
            this.m_accumulatedControllerArray[k].m_controller.Show(entityDamageEntryList[i].m_damageInfo, showingBoth, oneInstance, false);
          } else {
            k += 1;
          };
        };
      };
      if !dotControllerFound {
        oneInstance = entityDamageEntryList[i].m_oneDotInstance;
        k = 0;
        while k < this.m_maxAccumulatedVisible {
          if !this.m_accumulatedControllerArray[k].m_used {
            this.m_accumulatedControllerArray[k].m_used = true;
            this.m_accumulatedControllerArray[k].m_entityID = entityID;
            this.m_accumulatedControllerArray[k].m_isDamageOverTime = true;
            this.m_accumulatedControllerArray[k].m_controller.Show(entityDamageEntryList[i].m_damageOverTimeInfo, this.m_showDigitsIndividual, oneInstance, true);
            entityDamageEntryList[i].m_hasDotAccumulator = true;
          } else {
            k += 1;
          };
        };
      };
      i += 1;
    };
  };
  if this.m_showDigitsIndividual && this.m_showDigitsAccumulated {
    i = 0;
    while i < ArraySize(damageListIndividual) {
      damageInfo = damageListIndividual[i];
      damageOverTime = this.IsDamageOverTime(damageInfo);
      if i == 0 || !EntityID.IsDefined(entityID) || entityID != damageInfo.entityHit.GetEntityID() {
        entityID = damageInfo.entityHit.GetEntityID();
        //listPosition = ArrayFindFirst(entityIDList, entityID);
	  			  
		  let dcoi:Int32 = 0;
		  while dcoi<ArraySize(entityIDList){
			if Equals(entityID, entityIDList[i]){
				break;
			}
			dcoi+=1;
		  }
		  listPosition = dcoi;
		  
      };
      if damageOverTime && !accumulatedDigitsSticking {
        oneInstance = entityDamageEntryList[listPosition].m_oneDotInstance;
      } else {
        oneInstance = entityDamageEntryList[listPosition].m_oneInstance;
      };
      if !oneInstance {
        if !showingBoth {
          showingBothSecondary = damageOverTime || entityDamageEntryList[listPosition].m_hasDotAccumulator && individualDigitsSticking;
        };
        controller = this.m_digitsQueue.Dequeue() as DamageDigitLogicController;
        controller.Show(damageInfo, showingBoth || showingBothSecondary, damageOverTime);
      };
      i += 1;
    };
  };
  this.WakeUp();
}

@wrapMethod(GameObject)
public final func FindAndRewardKiller(killType: gameKillType, opt instigator: wref<GameObject>) -> Void {
 

	if IsDefined(instigator as NPCPuppet){
		if (instigator as NPCPuppet).GetRecord().TagsContains(n"Robot"){
			instigator= GetPlayer(this.GetGame());
		}
	}
	
	let i:Int32 = 0;		
	while i < ArraySize(this.m_receivedDamageHistory) {
		if IsDefined(this.m_receivedDamageHistory[i].source as NPCPuppet){
			if (this.m_receivedDamageHistory[i].source as NPCPuppet).GetRecord().TagsContains(n"Robot"){
				this.m_receivedDamageHistory[i].source = GetPlayer(this.GetGame());
			}
		}
		i+=1;
	}
	
	wrappedMethod(killType, instigator);
}

@wrapMethod(AIActionTarget)
private final static func BossThreatCalculation(owner: wref<ScriptedPuppet>, ownerPos: Vector4, targetTrackerComponent: ref<TargetTrackerComponent>, newTargetObject: wref<GameObject>, threat: wref<GameObject>, timeSinceTargetChange: Float, currentTime: Float, out threatValue: Float) -> Void {
  wrappedMethod(owner, ownerPos, targetTrackerComponent, newTargetObject, threat, timeSinceTargetChange, currentTime, threatValue);
  let SES: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(owner.GetGame());

  let threatID: TweakDBID = (threat as NPCPuppet).GetRecord().GetID();
  if TweakDBInterface.GetCharacterRecord(threatID).TagsContains(n"Robot") {
    let threatType: gamedataNPCType = (threat as NPCPuppet).GetNPCType();
    let ownerArchetype = TweakDBInterface.GetCharacterRecord((owner as NPCPuppet).GetRecord().GetID()).ArchetypeData().Type();
    switch threatType {
      case gamedataNPCType.Drone:
        threatValue *= 1.5;
        break;
      case gamedataNPCType.Android:
        threatValue *= 1.5;
        break;
      case gamedataNPCType.Mech:
        threatValue *= 1.5;
        break;
    }

    let targetHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
    let playerHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(owner.GetGame()).GetEntityID()), gamedataStatPoolType.Health, true);
    if playerHP > 40.0 {
      threatValue *= 2.0 - (targetHP) / 100.0;
    }

    let threadEntID: EntityID = threat.GetEntityID();
    if SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakSE") || SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakSESpread") || SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakOnHitSE") {
      threatValue *= 0.25;
    }

    let distToTarget: Float;
    let distToPlayer: Float;
    distToPlayer = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), owner.GetWorldPosition());
    if distToPlayer > 5.0 {
      distToTarget = Vector4.Distance(owner.GetWorldPosition(), threat.GetWorldPosition());
      if distToTarget > 30.0 {
        distToTarget = 30.0;
      }
      threatValue *= 1.5 - distToTarget / 60.0;
    }

    if StatusEffectSystem.ObjectHasStatusEffectWithTag(GetPlayer(owner.GetGame()), n"FistFight") {
      threatValue = 0;
    }
  }
}

@wrapMethod(AIActionTarget)
private final static func RegularThreatCalculation(owner: wref<ScriptedPuppet>, ownerPos: Vector4, targetTrackerComponent: ref<TargetTrackerComponent>, newTargetObject: wref<GameObject>, threat: wref<GameObject>, timeSinceTargetChange: Float, currentTime: Float, out threatValue: Float) -> Void {
  wrappedMethod(owner, ownerPos, targetTrackerComponent, newTargetObject, threat, timeSinceTargetChange, currentTime, threatValue);
  let SES: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(owner.GetGame());

  if !IsDefined(threat) || !IsDefined(owner) {
    return;
  }

  if TweakDBInterface.GetCharacterRecord((owner as NPCPuppet).GetRecord().GetID()).TagsContains(n"Robot") {
    if threat.IsTaggedinFocusMode() {
      threatValue *= 10.0;
    };

    let distToPlayer: Float;
    distToPlayer = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), threat.GetWorldPosition());
    if distToPlayer > 30.0 {
      distToPlayer = 30.0;
    }
    threatValue *= 1.5 - distToPlayer / 60.0;

    let targetHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
    threatValue *= 1.5 - (targetHP * 0.5) / 100.0;

    let threadEntID: EntityID = threat.GetEntityID();

    let archetypeType: gamedataArchetypeType = TweakDBInterface.GetCharacterRecord((owner as NPCPuppet).GetRecord().GetID()).ArchetypeData().Type().Type();
    if Equals(archetypeType, gamedataArchetypeType.NetrunnerT3) {
      if SES.HasStatusEffect(threadEntID, t"BaseStatusEffect.Madness") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidContagionSE") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidOverheatSE") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidOverloadSE") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidCrippleSE") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"DCO.AndroidBlindSE") {
        threatValue *= 0.5;
      }
      if SES.HasStatusEffect(threadEntID, t"BaseStatusEffect.WeaponMalfunction") {
        threatValue *= 0.5;
      }

      let threatNPC: wref<NPCPuppet> = threat as NPCPuppet;
      if IsDefined(threatNPC) && threatNPC.IsMechanical() {
        threatValue *= 5.0;
      }
    };
  }

  let threatID: TweakDBID = (threat as NPCPuppet).GetRecord().GetID();
  if TweakDBInterface.GetCharacterRecord(threatID).TagsContains(n"Robot") {
    let threatType: gamedataNPCType = (threat as NPCPuppet).GetNPCType();
    let ownerArchetype: gamedataArchetypeType = TweakDBInterface.GetCharacterRecord((owner as NPCPuppet).GetRecord().GetID()).ArchetypeData().Type().Type();

    if Equals(TweakDBInterface.GetCharacterRecord(threatID).AudioResourceName(), (n"dev_drone_octant_01")) {
    }

    switch threatType {
      case gamedataNPCType.Drone:
        switch ownerArchetype {
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
        switch ownerArchetype {
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
        switch ownerArchetype {
          case gamedataArchetypeType.FastMeleeT2:
          case gamedataArchetypeType.FastMeleeT3:
          case gamedataArchetypeType.FastShotgunnerT2:
          case gamedataArchetypeType.FastShotgunnerT3:
          case gamedataArchetypeType.FastSniperT3:
          case gamedataArchetypeType.GenericMeleeT1:
          case gamedataArchetypeType.GenericMeleeT2:
          case gamedataArchetypeType.HeavyMeleeT2:
          case gamedataArchetypeType.HeavyMeleeT2:
          case gamedataArchetypeType.NetrunnerT1:
          case gamedataArchetypeType.NetrunnerT2:
          case gamedataArchetypeType.NetrunnerT3:
          case gamedataArchetypeType.ShotgunnerT2:
          case gamedataArchetypeType.ShotgunnerT3:
          case gamedataArchetypeType.SniperT2:
            threatValue *= 0.3;
            break;
            threatValue *= 2.0;
        }
        break;
    }

    let threadEntID: EntityID = threat.GetEntityID();
    if SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakSE") || SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakSESpread") || SES.HasStatusEffect(threadEntID, t"DCO.DroneCloakOnHitSE") {
      threatValue *= 0.25;
    }

    let targetHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(threat.GetEntityID()), gamedataStatPoolType.Health, true);
    let playerHP: Float = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(owner.GetGame()).GetEntityID()), gamedataStatPoolType.Health, true);
    if playerHP > 40.0 {
      threatValue *= 2.0 - (targetHP) / 100.0;
    }

    let distToTarget: Float;
    let distToPlayer: Float;
    distToPlayer = Vector4.Distance(GetPlayer(owner.GetGame()).GetWorldPosition(), owner.GetWorldPosition());
    if distToPlayer > 5.0 {
      distToTarget = Vector4.Distance(owner.GetWorldPosition(), threat.GetWorldPosition());
      if distToTarget > 30.0 {
        distToTarget = 30.0;
      }
      threatValue *= 1.5 - distToTarget / 60.0;
    }

    if StatusEffectSystem.ObjectHasStatusEffectWithTag(GetPlayer(owner.GetGame()), n"FistFight") {
      threatValue = 0;
    }
  }
}
