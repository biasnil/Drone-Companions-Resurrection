local DCO = { description = "DCO" }

function DCO:new()
  TweakDB:SetFlat("DCO.DroneCore.localizedName", "yyy{"..Drone_Core_String.."}")

  TweakDB:SetFlat("DCO.Tier1OctantArasakaItem.localizedName", "yyy{"..Arasaka_Octant_String.."}")
  TweakDB:SetFlat("DCO.Tier1OctantArasakaRecipe.localizedName", "yyy{"..Arasaka_Octant_String.."}")

  TweakDB:SetFlat("DCO.Tier1OctantMilitechItem.localizedName", "yyy{"..Militech_Octant_String.."}")
  TweakDB:SetFlat("DCO.Tier1OctantMilitechRecipe.localizedName", "yyy{"..Militech_Octant_String.."}")

  TweakDB:SetFlat("DCO.Tier1MechNCPDItem.localizedName", "yyy{"..NCPD_Mech_String.."}")
  TweakDB:SetFlat("DCO.Tier1MechNCPDRecipe.localizedName", "yyy{"..NCPD_Mech_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidRangedItem.localizedName", "yyy{"..Android_Ranged_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidRangedRecipe.localizedName", "yyy{"..Android_Ranged_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidMeleeItem.localizedName", "yyy{"..Android_Melee_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidMeleeRecipe.localizedName", "yyy{"..Android_Melee_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidShotgunnerItem.localizedName", "yyy{"..Android_Shotgunner_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidShotgunnerRecipe.localizedName", "yyy{"..Android_Shotgunner_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidNetrunnerItem.localizedName", "yyy{"..Android_Netrunner_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidNetrunnerRecipe.localizedName", "yyy{"..Android_Netrunner_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidHeavyItem.localizedName", "yyy{"..Android_Techie_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidHeavyRecipe.localizedName", "yyy{"..Android_Techie_String.."}")

  TweakDB:SetFlat("DCO.Tier1AndroidSniperItem.localizedName", "yyy{"..Android_Sniper_String.."}")
  TweakDB:SetFlat("DCO.Tier1AndroidSniperRecipe.localizedName", "yyy{"..Android_Sniper_String.."}")

  local rules = TweakDB:GetFlat("ReactionPresets.Mechanical_Aggressive.rules")
  local toremove = {42, 38, 34, 32, 31, 26, 24, 14, 10, 9, 7, 6, 4, 3, 0}
  for _, idx in ipairs(toremove) do
    table.remove(rules, idx + 1)
  end
  TweakDB:SetFlat("DCO.ReactionPreset.rules", rules)

  createSubCharacter("DCO.Tier1MechNCPD",    "Character.Mech_NPC_Base",        "NCPD",     LocKey(48944ull))
  createSubCharacter("DCO.Tier1MechMilitech","Character.Mech_NPC_Base",        "Militech", LocKey(48900ull))
  createSubCharacter("DCO.Tier1MechArasaka", "Character.Mech_NPC_Base",        "Arasaka",  LocKey(48905ull))
  
  createSubCharacter("DCO.Tier1OctantArasaka","Character.Drone_Octant_Base",   "Arasaka",  LocKey(45202ull))
  createSubCharacter("DCO.Tier1OctantMilitech","Character.Drone_Octant_Base",  "Militech", LocKey(45202ull))
  
  createSubCharacter("DCO.Tier1Wyvern",      "Character.Drone_Wyvern_Base",    "Militech", LocKey(45200ull))
  createSubCharacter("DCO.Tier1Griffin",     "Character.Drone_Griffin_Base",   "Militech", LocKey(45201ull))
  
  createSubCharacter("DCO.Tier1Bombus",      "Character.Drone_Bombus_Base",    "Militech", LocKey(45199ull))

  local androidDefs = {
    {rec="DCO.Tier1AndroidRanged",    base="Character.wraiths_base_android", tag="Scavengers", key=42656ull},
    {rec="DCO.Tier1AndroidMelee",     base="Character.wraiths_base_android", tag="Maelstrom",  key=50547ull},
    {rec="DCO.Tier1AndroidShotgunner",base="Character.wraiths_base_android", tag="Wraiths",    key=50544ull},
    {rec="DCO.Tier1AndroidNetrunner", base="Character.wraiths_base_android", tag="Wraiths",    key=50542ull},
    {rec="DCO.Tier1AndroidHeavy",     base="Character.wraiths_base_android", tag="Wraiths",    key=50538ull},
    {rec="DCO.Tier1AndroidSniper",    base="Character.wraiths_base_android", tag="Wraiths",    key=50536ull},
  }

  for _, d in ipairs(androidDefs) do
    augmentExistingSubCharacter(d.rec, d.base, d.tag, LocKey(d.key))
    cloneAndroidVariants(d.rec)
  end

  addToList("ProgressionBuilds.StreetKidStarting.startingItems", "DCO.BombusStartingItem")
  addToList("ProgressionBuilds.NomadStarting.startingItems",     "DCO.BombusStartingItem")
  addToList("ProgressionBuilds.CorpoStarting.startingItems",     "DCO.BombusStartingItem")

  addToList("ProgressionBuilds.StreetKidStarting.startingItems", "DCO.DroneCoreStartingItem")
  addToList("ProgressionBuilds.NomadStarting.startingItems",     "DCO.DroneCoreStartingItem")
  addToList("ProgressionBuilds.CorpoStarting.startingItems",     "DCO.DroneCoreStartingItem")

  for _, v in ipairs(Android_List) do
    TweakDB:SetFlat(v..".entityTemplatePath", "base\\characters\\entities\\gang\\dco_android.ent")
  end

  local tanktop   = CName.new("gang__android_ma_scavenger_droid__lvl2_03") -- Ranged
  local wires     = CName.new("gang__android_ma_maelstrom_droid__lvl2_03") -- Netrunner
  local patriot   = CName.new("gang__android_ma_6th_street_droid_lvl1_06") -- Shotgunner
  local gasmask   = CName.new("gang__android_ma_wraith_droid__lvl1_05")    -- Heavy
  local cleansaka = CName.new("gang__android_ma_maelstrom_droid__lvl2_02") -- Sniper
  local boxeyes   = CName.new("gang__android_ma_maelstrom_droid__lvl2_01") -- Melee

  for i=1, DroneRecords do
    TweakDB:SetFlat("DCO.Tier1AndroidMelee"..i..".appearanceName",     CName.new(android_appearances[MeleeAndroidAppearance]))
    TweakDB:SetFlat("DCO.Tier1AndroidRanged"..i..".appearanceName",    CName.new(android_appearances[RangedAndroidAppearance]))
    TweakDB:SetFlat("DCO.Tier1AndroidShotgunner"..i..".appearanceName",CName.new(android_appearances[ShotgunnerAndroidAppearance]))
    TweakDB:SetFlat("DCO.Tier1AndroidHeavy"..i..".appearanceName",     CName.new(android_appearances[TechieAndroidAppearance]))
    TweakDB:SetFlat("DCO.Tier1AndroidNetrunner"..i..".appearanceName", CName.new(android_appearances[NetrunnerAndroidAppearance]))
    TweakDB:SetFlat("DCO.Tier1AndroidSniper"..i..".appearanceName",    CName.new(android_appearances[SniperAndroidAppearance]))
  end

  for i=1, DroneRecords do
    TweakDB:SetFlat("DCO.Tier1Bombus"..i..".appearanceName", CName.new(bombus_appearances[BombusAppearance]))
  end

end

function augmentExistingSubCharacter(recordName, copiedRecord, visualTag, displayName)
  local copy_stats = {
    "abilities","actionMap","affiliation","alternativeDisplayName","alternativeFullDisplayName",
    "appearanceName","archetypeName","attachmentSlots","audioResourceName","audioMeleeMaterial",
    "baseAttitudeGroup","bountyDrawTable","canHaveGenericTalk","characterType","communitySquad",
    "contentAssignment","crowdAppearanceNames","crowdMemberSettings","defaultCrosshair",
    "defaultEquipment","despawnChildCommunityWhenPlayerInVehicle","devNotes","disableDefeatedState",
    "displayDescription","driving","dropsAmmoOnDeath","dropsMoneyOnDeath","dropsWeaponOnDeath",
    "effectors","enableSensesOnStart","entityTemplatePath","enumComment","enumName","EquipmentAreas",
    "forceCanHaveGenericTalk","forcedTBHZOffset","fullDisplayName","genders","globalSquad",
    "hasDirectionalStarts","holocallInitializerPath","idleActions","isBumpable","isChild","isCrowd",
    "isLightCrowd","isPrevention","itemGroups","items","lootBagEntity","lootDrop","minigameInstance",
    "multiplayerTemplatePaths","objectActions","onSpawnGLPs","persistentName","priority","quest",
    "rarity","reactionPreset","referenceName","savable","scannerModulePreset","securitySquad",
    "sensePreset","skipDisplayArchetype","squadParamsID","startingEquippedItems","stateMachineName",
    "staticCommunityAppearancesDistributionEnabled","statModifierGroups","statModifiers","statPools",
    "tags","threatTrackingPreset","uiNameplate","useForcedTBHZOffset","vendorID","visualTags",
    "voiceTag","weakspots","cpoCharacterBuild","cpoClassName"
  }
  local skip = { archetypeData=true, primaryEquipment=true, secondaryEquipment=true, displayName=true, visualTags=true, tags=true }

  for _, f in ipairs(copy_stats) do
    if not skip[f] then
      local flat = TweakDB:GetFlat(copiedRecord.."."..f)
      if flat ~= nil then
        TweakDB:SetFlatNoUpdate(recordName.."."..f, flat)
      end
    end
  end

  -- Specific DCO overrides
  TweakDB:SetFlatNoUpdate(recordName..".displayName", displayName)
  TweakDB:SetFlatNoUpdate(recordName..".visualTags", {visualTag})
  TweakDB:SetFlatNoUpdate(recordName..".tags", {"Robot"})
  TweakDB:SetFlatNoUpdate(recordName..".objectActions", drone_hack_list)
  TweakDB:SetFlatNoUpdate(recordName..".squadParamsID", "FactionSquads.MilitechSquad")
  TweakDB:SetFlatNoUpdate(recordName..".affiliation", "Factions.Unaffiliated")
  TweakDB:SetFlatNoUpdate(recordName..".baseAttitudeGroup", "player")
  TweakDB:SetFlatNoUpdate(recordName..".lootBagEntity", "None")
  TweakDB:SetFlatNoUpdate(recordName..".disableDefeatedState", true)
  TweakDB:SetFlatNoUpdate(recordName..".dropsWeaponOnDeath", false)
  TweakDB:SetFlatNoUpdate(recordName..".reactionPreset", "DCO.ReactionPreset")
  TweakDB:SetFlatNoUpdate(recordName..".dropsAmmoOnDeath", false)
  TweakDB:SetFlatNoUpdate(recordName..".lootDrop", "LootTables.Empty")
  TweakDB:SetFlatNoUpdate(recordName..".uiNameplate", "UINameplate.CombatSettings")
  addListToList(recordName, "statModifiers", {"DCO.FollowerDefeatedImmunityStat", "Character.ScaleToPlayerLevel"})

  TweakDB:Update(recordName)
end

function cloneAndroidVariants(recordName)
  local flat_stats = {"alertedSensesPreset","combatSensesPreset","keepColliderOnDeath","relaxedSensesPreset","statusEffectParamsPackageName","weaponSlot"}
  local flat_float_stats = {"airDeathRagdollDelay","combatDefaultZOffset","mass","massNormalizedCoefficient","pseudoAcceleration","sizeBack","sizeFront","sizeLeft","sizeRight","speedIdleThreshold","startingRecoveryBalance","tiltAngleOnSpeed","turnInertiaDamping","walkTiltCoefficient"}

  for i=1, DroneRecords do
    TweakDB:CloneRecord(recordName..i, recordName)
    TweakDB:SetFlat(recordName..i..".DCOItem", recordName.."Item")

    for _, v in ipairs(flat_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat ~= nil then TweakDB:SetFlat(recordName..i.."."..v, flat) end
    end
    for _, v in ipairs(flat_float_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat ~= nil then TweakDB:SetFlat(recordName..i.."."..v, flat, 'Float') end
    end
  end
end

function createSubCharacter(recordName, copiedRecord, visualTag, displayName)
  local copy_stats = {"abilities","actionMap","affiliation","alternativeDisplayName","alternativeFullDisplayName","appearanceName","archetypeData","archetypeName","attachmentSlots","audioResourceName","audioMeleeMaterial","baseAttitudeGroup","bountyDrawTable","canHaveGenericTalk","characterType","communitySquad","contentAssignment","crowdAppearanceNames","crowdMemberSettings","defaultCrosshair","defaultEquipment","despawnChildCommunityWhenPlayerInVehicle","devNotes","disableDefeatedState","displayDescription","displayName","driving","dropsAmmoOnDeath","dropsMoneyOnDeath","dropsWeaponOnDeath","effectors","enableSensesOnStart","entityTemplatePath","enumComment","enumName","EquipmentAreas","forceCanHaveGenericTalk","forcedTBHZOffset","fullDisplayName","genders","globalSquad","hasDirectionalStarts","holocallInitializerPath","idleActions","isBumpable","isChild","isCrowd","isLightCrowd","isPrevention","itemGroups","items","lootBagEntity","lootDrop","minigameInstance","multiplayerTemplatePaths","objectActions","onSpawnGLPs","persistentName","primaryEquipment","priority","quest","rarity","reactionPreset","referenceName","savable","scannerModulePreset","secondaryEquipment","securitySquad","sensePreset","skipDisplayArchetype","squadParamsID","startingEquippedItems","stateMachineName","staticCommunityAppearancesDistributionEnabled","statModifierGroups","statModifiers","statPools","tags","threatTrackingPreset","uiNameplate","useForcedTBHZOffset","vendorID","visualTags","voiceTag","weakspots","cpoCharacterBuild","cpoClassName"}
  local flat_stats = {"alertedSensesPreset","combatSensesPreset","keepColliderOnDeath","relaxedSensesPreset","statusEffectParamsPackageName","weaponSlot"}
  local flat_float_stats = {"airDeathRagdollDelay","combatDefaultZOffset","mass","massNormalizedCoefficient","pseudoAcceleration","sizeBack","sizeFront","sizeLeft","sizeRight","speedIdleThreshold","startingRecoveryBalance","tiltAngleOnSpeed","turnInertiaDamping","walkTiltCoefficient"}

  TweakDB:CreateRecord(recordName, "gamedataSubCharacter_Record")

  for _, v in ipairs(copy_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlatNoUpdate(recordName.."."..v, flat) end
  end
  for _, v in ipairs(flat_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlat(recordName.."."..v, flat) end
  end
  for _, v in ipairs(flat_float_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlat(recordName.."."..v, flat, 'Float') end
  end

  TweakDB:SetFlatNoUpdate(recordName..".displayName", displayName)
  TweakDB:SetFlatNoUpdate(recordName..".visualTags", {visualTag})
  TweakDB:SetFlatNoUpdate(recordName..".tags", {"Robot"})
  TweakDB:SetFlatNoUpdate(recordName..".objectActions", drone_hack_list)
  TweakDB:SetFlatNoUpdate(recordName..".squadParamsID", "FactionSquads.MilitechSquad")
  TweakDB:SetFlatNoUpdate(recordName..".affiliation", "Factions.Unaffiliated")
  TweakDB:SetFlatNoUpdate(recordName..".baseAttitudeGroup", "player")
  TweakDB:SetFlatNoUpdate(recordName..".lootBagEntity", "None")
  TweakDB:SetFlatNoUpdate(recordName..".disableDefeatedState", true)
  TweakDB:SetFlatNoUpdate(recordName..".dropsWeaponOnDeath", false)
  TweakDB:SetFlatNoUpdate(recordName..".reactionPreset", "DCO.ReactionPreset")
  TweakDB:SetFlatNoUpdate(recordName..".dropsAmmoOnDeath", false)
  TweakDB:SetFlatNoUpdate(recordName..".lootDrop", "LootTables.Empty")
  TweakDB:SetFlatNoUpdate(recordName..".uiNameplate", "UINameplate.CombatSettings")
  addListToList(recordName, "statModifiers", {"DCO.FollowerDefeatedImmunityStat", "Character.ScaleToPlayerLevel"})

  TweakDB:Update(recordName)

  for i=1, DroneRecords do
    TweakDB:CloneRecord(recordName..i, recordName)
    TweakDB:SetFlat(recordName..i..".DCOItem", recordName.."Item")

    for _, v in ipairs(flat_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat then TweakDB:SetFlat(recordName..i.."."..v, flat) end
    end
    for _, v in ipairs(flat_float_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat then TweakDB:SetFlat(recordName..i.."."..v, flat, 'Float') end
    end
  end
end

function createSubCharacterEnemy(recordName, copiedRecord)
  local copy_stats = {"abilities","actionMap","affiliation","alternativeDisplayName","alternativeFullDisplayName","appearanceName","archetypeData","archetypeName","attachmentSlots","audioResourceName","audioMeleeMaterial","baseAttitudeGroup","bountyDrawTable","canHaveGenericTalk","characterType","communitySquad","contentAssignment","crowdAppearanceNames","crowdMemberSettings","defaultCrosshair","defaultEquipment","despawnChildCommunityWhenPlayerInVehicle","devNotes","disableDefeatedState","displayDescription","displayName","driving","dropsAmmoOnDeath","dropsMoneyOnDeath","dropsWeaponOnDeath","effectors","enableSensesOnStart","entityTemplatePath","enumComment","enumName","EquipmentAreas","forceCanHaveGenericTalk","forcedTBHZOffset","fullDisplayName","genders","globalSquad","hasDirectionalStarts","holocallInitializerPath","idleActions","isBumpable","isChild","isCrowd","isLightCrowd","isPrevention","itemGroups","items","lootBagEntity","lootDrop","minigameInstance","multiplayerTemplatePaths","objectActions","onSpawnGLPs","persistentName","primaryEquipment","priority","quest","rarity","reactionPreset","referenceName","savable","scannerModulePreset","secondaryEquipment","securitySquad","sensePreset","skipDisplayArchetype","squadParamsID","startingEquippedItems","stateMachineName","staticCommunityAppearancesDistributionEnabled","statModifierGroups","statModifiers","statPools","tags","threatTrackingPreset","uiNameplate","useForcedTBHZOffset","vendorID","visualTags","voiceTag","weakspots","cpoCharacterBuild","cpoClassName"}
  local flat_stats = {"alertedSensesPreset","combatSensesPreset","keepColliderOnDeath","relaxedSensesPreset","statusEffectParamsPackageName","weaponSlot"}
  local flat_float_stats = {"airDeathRagdollDelay","combatDefaultZOffset","mass","massNormalizedCoefficient","pseudoAcceleration","sizeBack","sizeFront","sizeLeft","sizeRight","speedIdleThreshold","startingRecoveryBalance","tiltAngleOnSpeed","turnInertiaDamping","walkTiltCoefficient"}

  TweakDB:CreateRecord(recordName, "gamedataSubCharacter_Record")

  for _, v in ipairs(copy_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlatNoUpdate(recordName.."."..v, flat) end
  end
  for _, v in ipairs(flat_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlat(recordName.."."..v, flat) end
  end
  for _, v in ipairs(flat_float_stats) do
    local flat = TweakDB:GetFlat(copiedRecord.."."..v)
    if flat then TweakDB:SetFlat(recordName.."."..v, flat, 'Float') end
  end

  TweakDB:SetFlatNoUpdate(recordName..".lootDrop", "LootTables.Empty")
  addListToList(recordName, "statModifiers", {"Character.ScaleToPlayerLevel"})
  TweakDB:Update(recordName)

  for i=1,1000 do
    TweakDB:CloneRecord(recordName..i, recordName)
    for _, v in ipairs(flat_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat then TweakDB:SetFlat(recordName..i.."."..v, flat) end
    end
    for _, v in ipairs(flat_float_stats) do
      local flat = TweakDB:GetFlat(recordName.."."..v)
      if flat then TweakDB:SetFlat(recordName..i.."."..v, flat, 'Float') end
    end
    TweakDB:SetFlat(recordName..i..".rarity", "NPCRarity.Boss")
    TweakDB:SetFlat(recordName..i..".tags", {})
    TweakDB:SetFlat(recordName..i..".reactionPreset", "ReactionPresets.Ganger_Aggressive")
    TweakDB:SetFlat(recordName..i..".baseAttitudeGroup", "hostile")
  end
end

function createLeftHandEquipment(weapon, list, toClone)
  TweakDB:CloneRecord(toClone.."Left", toClone)
  TweakDB:SetFlatNoUpdate(toClone.."Left.item", weapon)
  TweakDB:SetFlat(toClone.."Left.equipSlot", "AttachmentSlots.WeaponLeft")
  addToList(list, toClone.."Left")
end

return DCO:new()
