// ------------------------------------------------------------
// Drone Companions — Minimap mappins compat for CP2077 v2.3
//  - Removes continuous pulsing usage
//  - Renames removed prevention API
//  - Adds safe fallbacks & null-guards
//  - Restores shot-attempt change ping (no-op shim to compile)
// ------------------------------------------------------------

// Track previous shot attempts (field was removed in newer game builds)
@addField(MinimapStealthMappinController)
private let dco_prevShotAttempts: Uint32;

// 2.3 no longer exposes Pulse(Int32); keep a no-op so old calls compile.
@addMethod(MinimapStealthMappinController)
protected final func Pulse(count: Int32) -> Void { }

// Pick atlas by NPC archetype (with safe fallbacks).
@addMethod(MinimapStealthMappinController)
public func DCOFindArchetypeResource() -> ResRef {
  let npcPuppet: wref<NPCPuppet> =
    IsDefined(this.m_stealthMappin) ? this.m_stealthMappin.GetGameObject() as NPCPuppet : null;
  if !IsDefined(npcPuppet) {
    return ResRef.FromString("base\\gameplay\\gui\\common\\icons\\quickhacks_icons.inkatlas");
  };

  let recID: TweakDBID = npcPuppet.GetRecordID();
  let atlasPath: String = TweakDBInterface.GetString(recID + t".DCOAtlasResource", "");
  if StrLen(atlasPath) == 0 {
    // Fallback if no per-record override is configured
    atlasPath = "base\\gameplay\\gui\\common\\icons\\quickhacks_icons.inkatlas";
  };
  return ResRef.FromString(atlasPath);
}

// Pick texture part by NPC archetype (with safe fallback).
@addMethod(MinimapStealthMappinController)
public func DCOFindArchetypeName() -> CName {
  let npcPuppet: wref<NPCPuppet> =
    IsDefined(this.m_stealthMappin) ? this.m_stealthMappin.GetGameObject() as NPCPuppet : null;
  if !IsDefined(npcPuppet) { return n"icon_part"; }

  let rec = npcPuppet.GetRecord();
  if !IsDefined(rec) { return n"icon_part"; }

  let audio: CName = rec.AudioResourceName();
  let archetype: gamedataArchetypeType = rec.ArchetypeData().Type().Type();
  let npcType: gamedataNPCType = npcPuppet.GetNPCType();

  switch npcType {
    case gamedataNPCType.Mech:
      return n"archetype_mech";

    case gamedataNPCType.Drone:
      switch audio {
        case n"dev_drone_bombus_01":
        case n"dev_drone_griffin_01":
        case n"dev_drone_wyvern_01":
          return n"archetype_drone";
        case n"dev_drone_octant_01":
          return n"archetype_heavy_drone";
      };
      return n"archetype_drone"; // fallback for unknown drones

    case gamedataNPCType.Android:
      switch archetype {
        case gamedataArchetypeType.FastMeleeT3:
        case gamedataArchetypeType.FastMeleeT2:
        case gamedataArchetypeType.HeavyMeleeT3:
        case gamedataArchetypeType.HeavyMeleeT2:
        case gamedataArchetypeType.GenericMeleeT2:
        case gamedataArchetypeType.GenericMeleeT1:
        case gamedataArchetypeType.AndroidMeleeT2:
        case gamedataArchetypeType.AndroidMeleeT1:
          return n"archetype_melee";

        case gamedataArchetypeType.FastRangedT3:
        case gamedataArchetypeType.FastRangedT2:
        case gamedataArchetypeType.GenericRangedT3:
        case gamedataArchetypeType.GenericRangedT2:
        case gamedataArchetypeType.GenericRangedT1:
        case gamedataArchetypeType.FriendlyGenericRangedT3:
        case gamedataArchetypeType.AndroidRangedT2:
          return n"archetype_ranged";

        case gamedataArchetypeType.FastShotgunnerT3:
        case gamedataArchetypeType.FastShotgunnerT2:
        case gamedataArchetypeType.ShotgunnerT3:
        case gamedataArchetypeType.ShotgunnerT2:
          return n"archetype_shotgun";

        case gamedataArchetypeType.FastSniperT3:
        case gamedataArchetypeType.SniperT2:
          return n"archetype_sniper";

        case gamedataArchetypeType.HeavyRangedT3:
        case gamedataArchetypeType.HeavyRangedT2:
        case gamedataArchetypeType.TechieT3:
        case gamedataArchetypeType.TechieT2:
          return n"archetype_heavy";

        case gamedataArchetypeType.NetrunnerT3:
        case gamedataArchetypeType.NetrunnerT2:
        case gamedataArchetypeType.NetrunnerT1:
          return n"archetype_netrunner";
      };
  };

  return n"icon_part"; // final fallback
}

// Wrap Intro — keep vanilla behavior but adjust for companions/robots.
@wrapMethod(MinimapStealthMappinController)
protected func Intro() -> Void {
  let myPuppet: wref<NPCPuppet> =
    IsDefined(this.m_stealthMappin) ? this.m_stealthMappin.GetGameObject() as NPCPuppet : null;
  if IsDefined(myPuppet) && myPuppet.GetRecord().TagsContains(n"Robot") {

    let npcPuppet: wref<NPCPuppet>;
    this.m_stealthMappin = this.GetMappin() as StealthMappin;

    let gameObject: wref<GameObject> = this.m_stealthMappin.GetGameObject();
    this.m_iconWidgetGlitch = inkWidgetRef.Get(this.iconWidget);
    this.m_visionConeWidgetGlitch = inkWidgetRef.Get(this.visionConeWidget);
    this.m_clampArrowWidgetGlitch = inkWidgetRef.Get(this.clampArrowWidget);

    if gameObject != null {
      this.m_isPrevention = gameObject.IsPrevention();
      this.m_isDevice = gameObject.IsDevice();
      this.m_isCamera = gameObject.IsDevice() && gameObject.IsSensor() && !gameObject.IsTurret();
      this.m_isTurret = gameObject.IsTurret();
      this.m_isNetrunner = this.m_stealthMappin.IsNetrunner();

      // 2.3 API: IsPreventionVehicleEnabled() (no "Prototype")
      this.m_policeChasePrototypeEnabled = GameInstance
        .GetPreventionSpawnSystem(gameObject.GetGame())
        .IsPreventionVehicleEnabled();

      if this.m_isPrevention && this.m_policeChasePrototypeEnabled {
        npcPuppet = gameObject as NPCPuppet;
        if IsDefined(npcPuppet) {
          this.m_puppetStateBlackboard = npcPuppet.GetPuppetStateBlackboard();
          if IsDefined(this.m_puppetStateBlackboard) {
            this.m_isInVehicleStance = this.IsVehicleStance(
              IntEnum<gamedataNPCStanceState>(
                this.m_puppetStateBlackboard.GetInt(GetAllBlackboardDefs().PuppetState.Stance)));
            this.m_stanceStateCb = this.m_puppetStateBlackboard.RegisterListenerInt(
              GetAllBlackboardDefs().PuppetState.Stance, this, n"OnStanceStateChanged");
          };
        };
      };
    };

    this.m_isCrowdNPC = this.m_stealthMappin.IsCrowdNPC();
    if this.m_isCrowdNPC && !this.m_stealthMappin.IsAggressive()
        || gameObject != null && !gameObject.IsDevice() && !this.m_stealthMappin.IsAggressive()
           && NotEquals(this.m_stealthMappin.GetAttitudeTowardsPlayer(), EAIAttitude.AIA_Friendly) {
      this.m_defaultOpacity = 0.50;
    } else {
      this.m_defaultOpacity = 1.00;
    };
    this.m_root.SetOpacity(this.m_defaultOpacity);
    this.m_defaultConeOpacity = 0.80;
    this.m_detectingConeOpacity = 1.00;

    let wasCompanion: Bool = ScriptedPuppet.IsPlayerCompanion(gameObject);
    this.m_wasCompanion = wasCompanion;

    if wasCompanion {
      inkImageRef.SetTexturePart(this.iconWidget, n"friendly_ally15");

      npcPuppet = gameObject as NPCPuppet;
      if IsDefined(npcPuppet) && npcPuppet.GetRecord().TagsContains(n"Robot") {
        inkImageRef.SetAtlasResource(this.iconWidget, this.DCOFindArchetypeResource());
        inkImageRef.SetTexturePart(this.iconWidget, this.DCOFindArchetypeName());
        inkWidgetRef.SetScale(this.iconWidget, new Vector2(0.3, 0.3));

        let tempColor: HDRColor = inkWidgetRef.GetTintColor(this.iconWidget);
        tempColor.Red   = TweakDBInterface.GetFloat(t"DCO.MappinRed",   tempColor.Red);
        tempColor.Green = TweakDBInterface.GetFloat(t"DCO.MappinGreen", tempColor.Green);
        tempColor.Blue  = TweakDBInterface.GetFloat(t"DCO.MappinBlue",  tempColor.Blue);
        tempColor.Alpha = TweakDBInterface.GetFloat(t"DCO.MappinAlpha", tempColor.Alpha);
        inkWidgetRef.SetTintColor(this.iconWidget, tempColor);
      };
    } else {
      if this.m_isCamera {
        inkImageRef.SetTexturePart(this.iconWidget, n"cameraMappin");
        inkImageRef.SetTexturePart(this.visionConeWidget, n"camera_cone");
      };
    };

    inkWidgetRef.SetOpacity(this.visionConeWidget, this.m_defaultConeOpacity);

    if this.m_isNetrunner {
      this.m_iconWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", true);
      this.m_visionConeWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", true);
      this.m_clampArrowWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", true);
    };

    this.m_wasAlive = true;
    this.m_cautious = false;
    this.m_lockLootQuality = false;

    // Call original implementation
    wrappedMethod();

  } else {
    // Non-robot: vanilla
    wrappedMethod();
  };
}

// Wrap Update — keep vanilla behavior; continuous pulsing removed.
@wrapMethod(MinimapStealthMappinController)
protected func Update() -> Void {
  let myPuppet: wref<NPCPuppet> =
    IsDefined(this.m_stealthMappin) ? this.m_stealthMappin.GetGameObject() as NPCPuppet : null;
  if IsDefined(myPuppet) && myPuppet.GetRecord().TagsContains(n"Robot") {

    let npcPuppet: wref<NPCPuppet>;
    let gameDevice: wref<Device>;
    let hasItems: Bool;
    let isOnSameFloor: Bool;
    let shouldShowMappin: Bool;
    let shouldShowVisionCone: Bool;

    let gameObject: wref<GameObject> = this.m_stealthMappin.GetGameObject();
    this.m_isAlive = this.m_stealthMappin.IsAlive();

    let isTagged: Bool = this.m_stealthMappin.IsTagged();
    let hasBeenSeen: Bool = this.m_stealthMappin.HasBeenSeen();
    let isCompanion: Bool = gameObject != null && ScriptedPuppet.IsPlayerCompanion(gameObject);
    let attitude: EAIAttitude = this.m_stealthMappin.GetAttitudeTowardsPlayer();
    let vertRelation: gamemappinsVerticalPositioning = this.GetVerticalRelationToPlayer();
    let shotAttempts: Uint32 = this.m_stealthMappin.GetNumberOfShotAttempts();

    this.m_highLevelState = this.m_stealthMappin.GetHighLevelState();
    let isHighlighted: Bool = this.m_stealthMappin.IsHighlighted();
    this.m_isSquadInCombat = this.m_stealthMappin.IsSquadInCombat();
    let canSeePlayer: Bool = this.m_stealthMappin.CanSeePlayer();
    this.m_detectionAboveZero = this.m_stealthMappin.GetDetectionProgress() > 0.00;
    let wasDetectionAboveZero: Bool = this.m_stealthMappin.WasDetectionAboveZero();
    let numberOfCombatantsAboveZero: Bool = this.m_stealthMappin.GetNumberOfCombatants() > 0u;
    let isUsingSenseCone: Bool = this.m_stealthMappin.IsUsingSenseCone();
    this.m_isHacking = this.m_stealthMappin.HasHackingStatusEffect();

    if this.m_isDevice {
      this.m_isAggressive = NotEquals(attitude, EAIAttitude.AIA_Friendly);
      if this.m_isAggressive {
        gameDevice = gameObject as Device;
        if IsDefined(gameDevice) {
          isUsingSenseCone = gameDevice.GetDevicePS().IsON();
        };
        if this.m_isCamera && numberOfCombatantsAboveZero {
          canSeePlayer = false;
          isUsingSenseCone = false;
        } else {
          if this.m_isTurret {
            isUsingSenseCone = isUsingSenseCone && (Equals(attitude, EAIAttitude.AIA_Hostile) || !this.m_isPrevention);
            if !isUsingSenseCone {
              this.m_isSquadInCombat = false;
            };
          };
        };
        if Equals(this.m_stealthMappin.GetStealthAwarenessState(), gameEnemyStealthAwarenessState.Combat) {
          this.m_isSquadInCombat = true;
        };
      };
    } else {
      this.m_isAggressive = this.m_stealthMappin.IsAggressive() && NotEquals(attitude, EAIAttitude.AIA_Friendly);
    };

    // Keep cautious flag (no visual pulsing tied to it anymore)
    if !this.m_cautious {
      if !this.m_isDevice
          && NotEquals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed)
          && NotEquals(this.m_highLevelState, gamedataNPCHighLevelState.Any)
          && !this.m_isSquadInCombat && this.m_isAlive && this.m_isAggressive {
        this.m_cautious = true;
      };
    } else {
      if Equals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed)
          || Equals(this.m_highLevelState, gamedataNPCHighLevelState.Any)
          || this.m_isSquadInCombat || !this.m_isAlive {
        this.m_cautious = false;
      };
    };

    if this.m_hasBeenLooted || this.m_stealthMappin.IsHiddenByQuestOnMinimap() {
      shouldShowMappin = false;
    } else {
      if this.m_isPrevention && this.m_policeChasePrototypeEnabled {
        shouldShowMappin = !this.m_isInVehicleStance;
      } else {
        if this.m_isDevice && !this.m_isAggressive {
          shouldShowMappin = false;
        } else {
          if !IsMultiplayer() {
            shouldShowMappin = hasBeenSeen || !this.m_isAlive || isCompanion || wasDetectionAboveZero || isHighlighted || isTagged;
          } else {
            shouldShowMappin = (isCompanion || wasDetectionAboveZero || isHighlighted) && this.m_isAlive;
          };
        };
      };
    };
    this.SetForceHide(!shouldShowMappin);

    if shouldShowMappin {
      if !this.m_isAlive {
        if this.m_wasAlive {
          if !this.m_isCamera {
            inkImageRef.SetTexturePart(this.iconWidget, n"enemy_icon_4");
            inkWidgetRef.SetScale(this.iconWidget, new Vector2(0.75, 0.75));
          };
          this.m_defaultOpacity = MinF(this.m_defaultOpacity, 0.50);
          this.m_wasAlive = false;
        };
        let hasItems: Bool = this.m_stealthMappin.HasItems();
        if !hasItems || this.m_isDevice {
          this.FadeOut();
        };
      } else {
        if isCompanion && !this.m_wasCompanion {
          inkImageRef.SetTexturePart(this.iconWidget, n"friendly_ally15");

          npcPuppet = gameObject as NPCPuppet;
          if IsDefined(npcPuppet) && npcPuppet.GetRecord().TagsContains(n"Robot") {
            inkImageRef.SetAtlasResource(this.iconWidget, this.DCOFindArchetypeResource());
            inkImageRef.SetTexturePart(this.iconWidget, this.DCOFindArchetypeName());
            inkWidgetRef.SetScale(this.iconWidget, new Vector2(0.3, 0.3));

            let tempColor2: HDRColor = inkWidgetRef.GetTintColor(this.iconWidget);
            tempColor2.Red   = TweakDBInterface.GetFloat(t"DCO.MappinRed",   tempColor2.Red);
            tempColor2.Green = TweakDBInterface.GetFloat(t"DCO.MappinGreen", tempColor2.Green);
            tempColor2.Blue  = TweakDBInterface.GetFloat(t"DCO.MappinBlue",  tempColor2.Blue);
            tempColor2.Alpha = TweakDBInterface.GetFloat(t"DCO.MappinAlpha", tempColor2.Alpha);
            inkWidgetRef.SetTintColor(this.iconWidget, tempColor2);
          };
        } else {
          if NotEquals(this.m_isTagged, isTagged) && !this.m_isCamera {
            if isTagged {
              inkImageRef.SetTexturePart(this.iconWidget, n"enemyMappinTagged");
            } else {
              inkImageRef.SetTexturePart(this.iconWidget, n"enemyMappin");
            };
          };
        };
      };

      this.m_isTagged = isTagged;

      // Brief attention ping on shot attempts changing (no-op shim in 2.3)
      if this.m_isSquadInCombat && !this.m_wasSquadInCombat || this.dco_prevShotAttempts != shotAttempts {
        this.dco_prevShotAttempts = shotAttempts;
        this.Pulse(2);
      };

      let isOnSameFloor: Bool = Equals(vertRelation, gamemappinsVerticalPositioning.Same);
      this.m_adjustedOpacity = isOnSameFloor ? this.m_defaultOpacity : 0.30 * this.m_defaultOpacity;

      let shouldShowVisionCone: Bool = this.m_isAlive && isUsingSenseCone && this.m_isAggressive;
      if NotEquals(this.m_shouldShowVisionCone, shouldShowVisionCone) {
        this.m_shouldShowVisionCone = shouldShowVisionCone;
        this.m_stealthMappin.UpdateSenseConeAvailable(this.m_shouldShowVisionCone);
        if this.m_shouldShowVisionCone {
          this.m_stealthMappin.UpdateSenseCone();
        };
      };

      if this.m_shouldShowVisionCone {
        if NotEquals(canSeePlayer, this.m_couldSeePlayer) || this.m_isSquadInCombat && !this.m_wasSquadInCombat {
          if canSeePlayer && !this.m_isSquadInCombat {
            inkWidgetRef.SetOpacity(this.visionConeWidget, this.m_detectingConeOpacity);
            inkWidgetRef.SetScale(this.visionConeWidget, new Vector2(1.50, 1.50));
          } else {
            inkWidgetRef.SetOpacity(this.visionConeWidget, this.m_defaultConeOpacity);
            inkWidgetRef.SetScale(this.visionConeWidget, new Vector2(1.00, 1.00));
          };
          this.m_couldSeePlayer = canSeePlayer;
        };
      };

      inkWidgetRef.SetVisible(this.visionConeWidget, this.m_shouldShowVisionCone);

      if !this.m_wasVisible {
        if IsDefined(this.m_showAnim) { this.m_showAnim.Stop(); }
        this.m_showAnim = this.PlayLibraryAnimation(n"Show");
      };
    };

    if this.m_isNetrunner {
      if !this.m_isAlive {
        this.m_iconWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
        this.m_visionConeWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
        this.m_clampArrowWidgetGlitch.SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", false);
      } else {
        if this.m_isHacking {
          this.m_iconWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.70);
          this.m_visionConeWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.80);
          this.m_clampArrowWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.20);
        } else {
          this.m_iconWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
          this.m_visionConeWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
          this.m_clampArrowWidgetGlitch.SetEffectParamValue(inkEffectType.Glitch, n"Glitch_0", n"intensity", 0.05);
        };
      };
    };

    if !this.m_lockLootQuality {
      this.m_highestLootQuality = this.m_stealthMappin.GetHighestLootQuality();
    };

    //this.m_attitudeState = this.GetStateForAttitude(attitude, canSeePlayer);
    this.m_stealthMappin.SetVisibleOnMinimap(shouldShowMappin);
    // (continuous pulsing removed)
    this.m_clampingAvailable = this.m_isTagged || this.m_isAggressive && (this.m_isSquadInCombat || this.m_detectionAboveZero);
    this.OverrideClamp(this.m_clampingAvailable);
    this.m_wasCompanion = isCompanion;
    this.m_wasSquadInCombat = this.m_isSquadInCombat;
    this.m_wasVisible = shouldShowMappin;

    // Call original implementation
    wrappedMethod();

  } else {
    // Non-robot: vanilla
    wrappedMethod();
  };
}
