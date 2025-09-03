// Mappins.reds (2.3-compatible)

@addMethod(StealthMappinController)
public func DCOFindArchetypeResource() -> ResRef {
  let npc: wref<NPCPuppet> = this.m_ownerNPC;
  if !IsDefined(npc) {
    return ResRef.FromString("");
  };
  return ResRef.FromString(
    TweakDBInterface.GetString(npc.GetRecordID() + t".DCOAtlasResource", "")
  );
}

@addMethod(StealthMappinController)
public func DCOFindArchetypeName() -> CName {
  let npc: wref<NPCPuppet> = this.m_ownerNPC;
  if !IsDefined(npc) {
    return n"";
  };

  let audio: CName = npc.GetRecord().AudioResourceName();
  let archetype: gamedataArchetypeType = npc.GetRecord().ArchetypeData().Type().Type();
  let npcType: gamedataNPCType = npc.GetNPCType();

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
  }
  return n"";
}

// NOTE: 2.3 uses callback versions: OnIntro/OnUpdate. Wrap those.

@wrapMethod(StealthMappinController)
protected cb func OnIntro() -> Bool {
  let ret = wrappedMethod();

  let npc: wref<NPCPuppet> = this.m_ownerNPC;
  if IsDefined(npc) && npc.GetRecord().TagsContains(n"Robot") && ScriptedPuppet.IsPlayerCompanion(npc) {
    // Use the level icon as the texture target in 2.3
    inkImageRef.SetAtlasResource(this.m_levelIcon, this.DCOFindArchetypeResource());
    inkImageRef.SetTexturePart(this.m_levelIcon, this.DCOFindArchetypeName());
    inkWidgetRef.SetScale(this.m_levelIcon, new Vector2(0.30, 0.30));

    let tint: HDRColor = inkWidgetRef.GetTintColor(this.m_levelIcon);
    tint.Red   = TweakDBInterface.GetFloat(t"DCO.MappinRed",   tint.Red);
    tint.Green = TweakDBInterface.GetFloat(t"DCO.MappinGreen", tint.Green);
    tint.Blue  = TweakDBInterface.GetFloat(t"DCO.MappinBlue",  tint.Blue);
    tint.Alpha = TweakDBInterface.GetFloat(t"DCO.MappinAlpha", tint.Alpha);
    inkWidgetRef.SetTintColor(this.m_levelIcon, tint);
  }

  return ret;
}

@wrapMethod(StealthMappinController)
protected cb func OnUpdate() -> Bool {
  let ret = wrappedMethod();

  // Keep icon/tint fresh if the NPC flips to companion mid-mission
  let npc: wref<NPCPuppet> = this.m_ownerNPC;
  if IsDefined(npc) && npc.GetRecord().TagsContains(n"Robot") && ScriptedPuppet.IsPlayerCompanion(npc) {
    inkImageRef.SetAtlasResource(this.m_levelIcon, this.DCOFindArchetypeResource());
    inkImageRef.SetTexturePart(this.m_levelIcon, this.DCOFindArchetypeName());
    inkWidgetRef.SetScale(this.m_levelIcon, new Vector2(0.30, 0.30));

    let tint: HDRColor = inkWidgetRef.GetTintColor(this.m_levelIcon);
    tint.Red   = TweakDBInterface.GetFloat(t"DCO.MappinRed",   tint.Red);
    tint.Green = TweakDBInterface.GetFloat(t"DCO.MappinGreen", tint.Green);
    tint.Blue  = TweakDBInterface.GetFloat(t"DCO.MappinBlue",  tint.Blue);
    tint.Alpha = TweakDBInterface.GetFloat(t"DCO.MappinAlpha", tint.Alpha);
    inkWidgetRef.SetTintColor(this.m_levelIcon, tint);
  }

  return ret;
}
