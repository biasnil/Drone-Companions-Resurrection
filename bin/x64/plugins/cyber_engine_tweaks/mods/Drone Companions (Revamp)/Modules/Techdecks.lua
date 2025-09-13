R = { 
    description = "DCO"
}
local filename = "DCO/TechDecks"

local function recordExists(id)
  return TweakDB:GetRecord(id) ~= nil
end

local function createIcon(recordName, icon, atlasname)
  local uiIconId = "UIIcon." .. icon
  if not recordExists(uiIconId) then
    TweakDB:CreateRecord(uiIconId, "gamedataUIIcon_Record")
    TweakDB:SetFlatNoUpdate(uiIconId .. ".atlasPartName", "icon_part")
    TweakDB:SetFlat(uiIconId .. ".atlasResourcePath", "base\\icon\\" .. atlasname .. ".inkatlas")
    TweakDB:Update(uiIconId)
  end
  TweakDB:SetFlat(recordName .. ".iconPath", icon)
  TweakDB:SetFlat(recordName .. ".icon", uiIconId)
end

local function setF(path, val)  TweakDB:SetFlat(path, val, 'Float')  end
local function setI32(path, val) TweakDB:SetFlat(path, val, 'Int32') end

function DCO:new()
  CName.add("Techdeck")

  -- Fix cost bug w/ power levels
  Override('BaseScriptableAction', 'GetPowerLevelDiff', function(self, wrappedMethod)
    local targetID = self:GetRequesterID()
    local target = targetID and Game.FindEntityByID(targetID) or nil
    if target ~= nil then
      local rec = TweakDBInterface.GetCharacterRecord(target:GetRecordID())
      if rec and rec:TagsContains(CName.new("Robot")) then
        return 0
      end
    end
    return wrappedMethod()
  end)

  -- Remove base cost of 1 on robots
  Override('BaseScriptableAction', 'GetCost', function(self, wrappedMethod)
    local ret = wrappedMethod()
    local targetID = self:GetRequesterID()
    local target = targetID and Game.FindEntityByID(targetID) or nil
    if target and target:IsNPC() then
      local rec = TweakDBInterface.GetCharacterRecord(target:GetRecordID())
      if rec and rec:TagsContains(CName.new("Robot")) then
        ret = ret - 1
      end
    end
    return ret
  end)

  Override('BaseScriptableAction', 'GetBaseCost', function(self, wrappedMethod)
    local ret = wrappedMethod()
    local targetID = self:GetRequesterID()
    local target = targetID and Game.FindEntityByID(targetID) or nil
    if target and target:IsNPC() then
      local rec = TweakDBInterface.GetCharacterRecord(target:GetRecordID())
      if rec and rec:TagsContains(CName.new("Robot")) then
        ret = ret - 1
      end
    end
    return ret
  end)

  ----------------------- EXPLODE VFX HOOK (YAML owns records) --------
  Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
    if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot")) then
      if statusEffect.staticData:GetID() == TweakDBID.new("DCO.ExplodeSE") then
        GameObject.StartReplicatedEffectEvent(self, CName.new("explode_death"))
      end
    end
  end)

	local function DCO_EntityHasTag(ent, tag)
	  if not ent or not ent.GetRecordID then return false end
	  local rec = TweakDBInterface.GetCharacterRecord(ent:GetRecordID())
	  return rec and rec:TagsContains(CName.new(tag)) or false
	end

	--Handle Mech text
	Override('QuickhacksListGameController', 'SelectData', function(self, data, wrappedMethod)
	  wrappedMethod(data)

	  local ent = (data and data.actionOwner) and Game.FindEntityByID(data.actionOwner) or nil
	  if not ent or not ent.GetRecordID then return end

	  -- robot gate
	  local rec = TweakDBInterface.GetCharacterRecord(ent:GetRecordID())
	  if not rec or not rec:TagsContains(CName.new("Robot")) then return end

	  -- title safety
	  local titleKey = self.selectedData and self.selectedData.title
	  if not titleKey then return end
	  local title = GetLocalizedText(titleKey)
	  local isInCombat = (Game.GetPlayer() and Game.GetPlayer():IsInCombat()) or false

	  -- mech-specific warning
	  if ent.IsNPC and ent:IsNPC() then
	    local npcType = ent:GetNPCType()
	    if npcType == gamedataNPCType.Mech and title == GetLocalizedText("LocKey#266") then
	      inkTextRef.SetText(self.warningText, Mech_No_Repair_String)
	    end
	    if title == GetLocalizedText("LocKey#3665") and npcType ~= gamedataNPCType.Android then
	      inkTextRef.SetText(self.warningText, Kerenzikov_Not_Android_String)
	    end
	  end

	  -- shutdown/“wait” blocked in combat
	  if isInCombat and (title == GetLocalizedText("LocKey#256") or title == GetLocalizedText("LocKey#10547")) then
	    inkTextRef.SetText(self.warningText, Shutdown_No_Combat_String)
	  end
	end)

  Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
    if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot")) then
      local id = statusEffect.staticData:GetID()
      if id == TweakDBID.new("DCO.OverdriveSE") or id == TweakDBID.new("DCO.OverdriveSESpread") then
        debugPrint(filename, "status effect is overdrive")
        local durationMod = Game.GetStatsSystem():GetStatValue(self:GetEntityID(), gamedataStatType.CanUpgradeToLegendaryQuality)
        local dilation   = 2.0 + Game.GetStatsSystem():GetStatValue(Game.GetPlayer():GetEntityID(), gamedataStatType.CanUseTerrainCamo)
        local duration   = (30 + 30 * durationMod) * (dilation)
        self:SetIndividualTimeDilation(CName.new("Sandevistan"), dilation, duration)
        debugPrint(filename, "set the dilation")
      end
    end
  end)

  -------------------------- EMERGENCY WEAPONS SYSTEM -----------------
  CName.add("DCOEWS")
  TweakDB:SetFlat("DCO.EWSSE.SFX", {"DCO.EWSSESFX1", "DCO.EWSSESFX2"})
  Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
    if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot")) then
      if statusEffect.staticData:GetID() == TweakDBID.new("DCO.EWSSE") then
        for i,v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
          if not StatusEffectSystem.ObjectHasStatusEffect(v, TweakDBID.new("DCO.EWSSE")) and v:GetRecord():TagsContains(CName.new("Robot")) then
            StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("DCO.EWSSESpread"))
          end
        end
      end
    end
  end)

  for _,v in ipairs(Flying_List)  do addToList(v..".abilities",  "DCO.HealOnKillAbility") end
  for _,v in ipairs(Android_List) do addToList(v..".abilities",  "DCO.HealOnKillAbility") end

  setI32("BaseStatusEffect.Electrocuted_inline23.priority", -9)

  for _,v in ipairs(Android_List) do addToList(v..".abilities", "DCO.AndroidSuicideAbility") end

  Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
    if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot"))
       and self:GetNPCType() == gamedataNPCType.Android
       and statusEffect.staticData:GetID() == TweakDBID.new("BaseStatusEffect.SuicideWithWeapon") then
      DismembermentComponent.RequestDismemberment(self, gameDismBodyPart.RIGHT_ARM,  gameDismWoundType.COARSE)
      DismembermentComponent.RequestDismemberment(self, gameDismBodyPart.LEFT_ARM,   gameDismWoundType.COARSE)
      DismembermentComponent.RequestDismemberment(self, gameDismBodyPart.RIGHT_LEG,  gameDismWoundType.COARSE)
      DismembermentComponent.RequestDismemberment(self, gameDismBodyPart.LEFT_LEG,   gameDismWoundType.COARSE)
      DismembermentComponent.RequestDismemberment(self, gameDismBodyPart.HEAD,       gameDismWoundType.CLEAN)
      self:Kill()
    end
  end)

	local function HasTag(rec, tag)
	  return rec:TagsContains(CName.new(tag))
	end
	
	local function DCO_ShouldBlockBackpackClick(evt)
	  if not evt or not evt.itemData or not evt.itemData.ID then return false end
	  local tdb = ItemID.GetTDBID(evt.itemData.ID)
	  if not tdb then return false end
	  local rec = TweakDBInterface.GetItemRecord(tdb)
	  if not rec then return false end
	  if rec:TagsContains(CName.new("DCOMod")) and rec:TagsContains(CName.new("Fragment")) then
	    return true
	  end
	  return false
	end
	
	Override('BackpackMainGameController', 'OnItemDisplayClick', function(self, evt, wrapped)
	  if DCO_ShouldBlockBackpackClick(evt) then
	    return
	  end
	  if wrapped then wrapped(evt) end 
	end)

  ------------------------------ ICONS --------------------------------
  for i=1,9 do
    createIcon("DCO.TechDeckMod"..i, "DCOTechDeckMod"..i, "techdeckmod"..i.."_atlas")
  end
  createIcon("DCO.StreetDeck1", "DCOStreetTechDeck", "streettechdeck_atlas")
  createIcon("DCO.StreetDeck2", "DCOStreetTechDeck", "streettechdeck_atlas")
  createIcon("DCO.StreetDeck3", "DCOStreetTechDeck", "streettechdeck_atlas")
  createIcon("DCO.NomadDeck1",  "DCONomadTechDeck",  "nomadtechdeck_atlas")
  createIcon("DCO.NomadDeck2",  "DCONomadTechDeck",  "nomadtechdeck_atlas")
  createIcon("DCO.NomadDeck3",  "DCONomadTechDeck",  "nomadtechdeck_atlas")
  createIcon("DCO.CorpoDeck1",  "DCOCorpoTechDeck",  "corpotechdeck_atlas")
  createIcon("DCO.CorpoDeck2",  "DCOCorpoTechDeck",  "corpotechdeck_atlas")

  -- Androids
  local Android_Stats = {
    {"AdditiveMultiplier", "DCO.DroneHP",            "BaseStats.Health",       1},
    {"AdditiveMultiplier", "DCO.DroneDamage",        "BaseStats.NPCDamage",    1},
    {"Additive",           "DCO.DroneArmor",         "BaseStats.Armor",        1},
    {"AdditiveMultiplier", "DCO.DroneAccuracy",      "BaseStats.Accuracy",     1},
    {"Additive",           "DCO.DroneAndroidRegen",  "BaseStats.CanCallDrones",1},
    {"Additive",           "DCO.DroneHealMod",       "DCO.DroneHealMod",       1},
    {"Additive",           "DCO.DroneMassCloak",     "DCO.DroneMassCloak",     1},
    {"Additive",           "DCO.DroneOverdriveAll",  "DCO.DroneOverdriveAll",  1},
    {"Additive",           "DCO.DroneHackDamage",    "DCO.DroneHackDamage",    1},
    {"Additive",           "DCO.DroneHealOnKill",    "DCO.DroneHealOnKill",    1},
    {"AdditiveMultiplier", "DCO.DroneAndroidDilation","BaseStats.HasSandevistan",      1},
    {"AdditiveMultiplier", "DCO.DroneAndroidDilation","BaseStats.HasSandevistanTier1", 1},
    {"Additive",           "DCO.DroneCloakHeal",     "DCO.DroneCloakHeal",     1},
    {"Additive",           "DCO.DroneDeathExplosion","DCO.DroneDeathExplosion",1}
  }
  createDroneStatGroup("DCO.AndroidStatGroup", Android_Stats)
  createConstantStatModifier("DCO.AndroidArmorAdjust", "Additive", "BaseStats.Armor", -20)
  addToList("DCO.AndroidStatGroup.statModifiers", "DCO.AndroidArmorAdjust")
  for _,v in ipairs(Android_List) do
    addToList(v..".statModifierGroups", "DCO.AndroidStatGroup")
    addToList(v..".abilities", "DCO.DroneRegenAbility")
  end

  -- Flying
  local Flying_Stats = {
    {"AdditiveMultiplier", "DCO.DroneHP",            "BaseStats.Health",       1},
    {"AdditiveMultiplier", "DCO.DroneDamage",        "BaseStats.NPCDamage",    1},
    {"Additive",           "DCO.DroneArmor",         "BaseStats.Armor",        1},
    {"Additive",           "DCO.DroneHealMod",       "DCO.DroneHealMod",       1},
    {"Additive",           "DCO.DroneMassCloak",     "DCO.DroneMassCloak",     1},
    {"Additive",           "DCO.DroneHackDamage",    "DCO.DroneHackDamage",    1},
    {"Additive",           "DCO.DroneOverdriveAll",  "DCO.DroneOverdriveAll",  1},
    {"AdditiveMultiplier", "DCO.DroneAndroidDilation","BaseStats.HasSandevistan", 1},
    {"Additive",           "DCO.DroneHealOnKill",    "DCO.DroneHealOnKill",    1},
    {"Additive",           "DCO.DroneCloakHeal",     "DCO.DroneCloakHeal",     1},
    {"Additive",           "DCO.DroneAndroidRegen",  "BaseStats.CanCallDrones",1},
    {"AdditiveMultiplier", "DCO.DroneAccuracy",      "BaseStats.Accuracy",     1},
    {"Additive",           "DCO.DroneDeathExplosion","DCO.DroneDeathExplosion",1}
  }
  createDroneStatGroup("DCO.FlyingStatGroup", Flying_Stats)
  createConstantStatModifier("DCO.FlyingArmorAdjust", "Additive", "BaseStats.Armor", -15)
  addToList("DCO.FlyingStatGroup.statModifiers", "DCO.FlyingArmorAdjust")
  for _,v in ipairs(Flying_List) do
    addToList(v..".statModifierGroups", "DCO.FlyingStatGroup")
    addToList(v..".abilities", "DCO.DroneRegenAbility")
  end

  -- Mech
  local Mech_Stats = {
    {"AdditiveMultiplier", "DCO.DroneHP",            "BaseStats.Health",       1},
    {"AdditiveMultiplier", "DCO.DroneDamage",        "BaseStats.NPCDamage",    1},
    {"Additive",           "DCO.DroneArmor",         "BaseStats.Armor",        1},
    {"Additive",           "DCO.DroneHealMod",       "DCO.DroneHealMod",       1},
    {"Additive",           "DCO.DroneHealOnKill",    "DCO.DroneHealOnKill",    1},
    {"Additive",           "DCO.DroneMassCloak",     "DCO.DroneMassCloak",     1},
    {"Additive",           "DCO.DroneHackDamage",    "DCO.DroneHackDamage",    1},
    {"Additive",           "DCO.DroneOverdriveAll",  "DCO.DroneOverdriveAll",  1},
    {"Additive",           "DCO.DroneDeathExplosion","DCO.DroneDeathExplosion",1},
    {"AdditiveMultiplier", "DCO.DroneAccuracy",      "BaseStats.Accuracy",     1},
    {"Additive",           "DCO.TechHackCostReduction","DCO.TechHackCostReduction", 1}
  }
  createDroneStatGroup("DCO.MechStatGroup", Mech_Stats)
  createConstantStatModifier("DCO.MechArmorAdjust", "Additive", "BaseStats.Armor", -20)
  addToList("DCO.MechStatGroup.statModifiers", "DCO.MechArmorAdjust")
  for _,v in ipairs(Mech_List) do
    addToList(v..".statModifierGroups", "DCO.MechStatGroup")
    addToList(v..".abilities", "DCO.MechRegenAbility", "Float")
  end

  for i=1,DroneRecords do
    addToList("DCO.Tier1OctantArasaka"..i..".onSpawnGLPs", "DCO.FlyingDroneGLP")
    addToList("DCO.Tier1OctantMilitech"..i..".onSpawnGLPs", "DCO.FlyingDroneGLP")
    addToList("DCO.Tier1Griffin"..i..".onSpawnGLPs",        "DCO.FlyingDroneGLP")
    addToList("DCO.Tier1Wyvern"..i..".onSpawnGLPs",         "DCO.FlyingDroneGLP")
  end
  TweakDB:CreateRecord("DCO.FlyingDroneGLP", "gamedataGameplayLogicPackage_Record")
  TweakDB:SetFlat("DCO.FlyingDroneGLP.effectors", {"Spawn_glp.Drone_GLP_inline0", "Spawn_glp.Drone_GLP_inline2", "DCO.FlyingDroneGLP_inline0"})
  TweakDB:CloneRecord("DCO.FlyingDroneGLP_inline0", "Spawn_glp.DroneGriffin_ExplodeOnDeath_inline0")
  TweakDB:SetFlat("DCO.FlyingDroneGLP_inline0.attackRecord", "DCO.FlyingDroneDeathExplosion")
  TweakDB:SetFlat("DCO.FlyingDroneGLP_inline0.attackPositionSlotName", CName.new("Chest"))

  ---------------------------------- FLYING EXPLODE HACK --------------
  for _,v in ipairs(Flying_List) do
    if not (TweakDB:GetFlat(v..".audioResourceName") == CName.new("dev_drone_bombus_01")) then
      addToList(v..".abilities", "DCO.FlyingExplodeHackAbility")
    end
  end

  ------------------------ ANDROID DILATION DEFAULTS ------------------
  createConstantStatModifier("DCO.DroneAndroidDilationDefaultSandevistan",       "AdditiveMultiplier", "BaseStats.HasSandevistanTier1", -1)
  createConstantStatModifier("DCO.DroneAndroidDilationDefaultSandevistanTier1",  "AdditiveMultiplier", "BaseStats.HasSandevistan",       -1)
  createConstantStatModifier("DCO.DroneAndroidDilationDefaultKerenzikov",        "AdditiveMultiplier", "BaseStats.HasKerenzikov",        -1)
  addListToList("DCO.AndroidStatGroup", "statModifiers", {
    "DCO.DroneAndroidDilationDefaultSandevistan",
    "DCO.DroneAndroidDilationDefaultSandevistanTier1",
    "DCO.DroneAndroidDilationDefaultKerenzikov"
  })

  TweakDB:Update("DCO.AndroidStatGroup")

  --------------------------- STATUS EFFECT ABILITIES -----------------
  for _,v in ipairs(Full_Drone_List) do
    addListToList(v, "abilities", {"DCO.CanCauseShock", "DCO.CanCauseBurn", "DCO.CanCausePoison"})
  end

  for _,v in ipairs(Full_Drone_List) do
    addToList(v..".abilities", "DCO.ExplodeAbility")
  end
  

  ----------------------------- COST LESS TO CRAFT --------------------
  half_craftables = {"OctantArasaka","OctantMilitech","Griffin","Wyvern","Bombus",
                     "AndroidRanged","AndroidMelee","AndroidShotgunner","AndroidHeavy",
                     "AndroidSniper","AndroidNetrunner"}

  --------------------------------- ARMOR PROCESSING ------------------
  setF("DCO.BossToDroneDamage", 1.0)
  setF("DCO.BossToMechDamage",  4.0)
  setF("DCO.OdaToDroneDamage",  12.0)
  setF("DCO.SasquatchToDroneDamage", 12.0)
  setF("DCO.SmasherToDroneDamage",   1.0)
  setF("DCO.ExoToDroneDamage",       6.0)

  local function DCO_IsRobot(obj)
    if not obj or not obj.GetRecordID then return false end
    local rec = TweakDBInterface.GetCharacterRecord(obj:GetRecordID())
    return rec and rec:TagsContains(CName.new("Robot")) or false
  end

  Override('DamageSystem', 'ProcessArmor', function(self, hitEvent, wrappedMethod)
    local tgt = hitEvent and hitEvent.target or nil
    if tgt and DCO_IsRobot(tgt) then
      local weapon = hitEvent.attackData and hitEvent.attackData:GetWeapon() or nil
      if IsDefined(weapon) and WeaponObject.CanIgnoreArmor and WeaponObject.CanIgnoreArmor(weapon) then return end
      if not IsDefined(weapon) then return end

      local armorPoints = Game.GetStatsSystem():GetStatValue(tgt:GetEntityID(), gamedataStatType.Armor)
      local reduction = 1 - armorPoints / 100.0
      if reduction < 0.5 then reduction = 0.5 end
      if reduction > 1.5 then reduction = 1.5 end

      local vals = hitEvent.attackComputed and hitEvent.attackComputed:GetAttackValues() or nil
      if vals then
        local inst = hitEvent.attackData and hitEvent.attackData:GetInstigator() or nil
        local isBoss = inst and inst.IsBoss and inst:IsBoss() or false
        local instArche = nil
        if inst and inst.GetRecordID then
          local crec = TweakDBInterface.GetCharacterRecord(inst:GetRecordID())
          instArche = crec and crec:ArchetypeName() or nil
        end
        local tgtType = tgt.GetNPCType and tgt:GetNPCType() or nil

        for i=1,#vals do
          vals[i] = vals[i] * reduction
          if isBoss then
            vals[i] = vals[i] * TweakDB:GetFlat("DCO.BossToDroneDamage")
            if instArche == CName.new("oda")         then vals[i] = vals[i] * TweakDB:GetFlat("DCO.OdaToDroneDamage") end
            if instArche == CName.new("adamsmasher") then vals[i] = vals[i] * TweakDB:GetFlat("DCO.SmasherToDroneDamage") end
            if instArche == CName.new("sasquatch")   then vals[i] = vals[i] * TweakDB:GetFlat("DCO.SasquatchToDroneDamage") end
            if instArche == CName.new("exo")         then vals[i] = vals[i] * TweakDB:GetFlat("DCO.ExoToDroneDamage") end
            if tgtType == gamedataNPCType.Mech then
              vals[i] = vals[i] * TweakDB:GetFlat("DCO.BossToMechDamage")
            end
          end
        end
        hitEvent.attackComputed:SetAttackValues(vals)
        return
      end
    end

    local inst2 = hitEvent.attackData and hitEvent.attackData:GetInstigator() or nil
    if DCO_IsRobot(inst2) then
      local vals2 = hitEvent.attackComputed and hitEvent.attackComputed:GetAttackValues() or nil
      if vals2 and hitEvent.target and hitEvent.target.IsBoss and hitEvent.target:IsBoss() then
        for i=1,#vals2 do
          vals2[i] = vals2[i] * 0.5
        end
        hitEvent.attackComputed:SetAttackValues(vals2)
      end
    end

    if wrappedMethod then wrappedMethod(hitEvent) end
  end)

  ------------------------------- ARASAKA MECH HIGHLIGHTING ------------
  CName.add("DCOHighlight")
  for i=1,DroneRecords do
    TweakDB:SetFlat("DCO.Tier1MechArasaka"..i..".tags", {"Robot", "DCOHighlight"})
  end

  Override('ScanningComponent', 'OnRevealStateChanged', function(self, evt, wrappedMethod)
    if not self:GetEntity():IsNPC() or not self:GetEntity():GetRecord():TagsContains(CName.new("Robot")) then
      wrappedMethod(evt)
      return
    end
    if evt.state == ERevealState.STARTED then
      self:SetScannableThroughWalls(true)
    elseif evt.state == ERevealState.STOPPED then
      self:SetScannableThroughWalls(false)
    end
  end)

  Observe('NPCPuppet', 'OnPlayerCompanionCacheData', function(self, evt)
    local selfRec = TweakDBInterface.GetCharacterRecord(self:GetRecordID())
    if not selfRec or not selfRec:TagsContains(CName.new("DCOHighlight")) or not droneAlive(self) then return end
    local spawned = Game.GetCompanionSystem():GetSpawnedEntities() or {}
    local player = Game.GetPlayer()
    local inCombat = player and player:IsInCombat() or false
    for _, v in ipairs(spawned) do
      if IsDefined(v) and v.IsNPC and v:IsNPC() and droneAlive(v) then
        local crec = TweakDBInterface.GetCharacterRecord(v:GetRecordID())
        if crec and crec:TagsContains(CName.new("Robot")) then
          if inCombat then
            StatusEffectHelper.ApplyStatusEffect(v, TweakDBID.new("DCO.HighlightSE"))
          else
            StatusEffectHelper.RemoveStatusEffect(v, TweakDBID.new("DCO.HighlightSE"))
          end
        end
      end
    end
  end)

  Observe('NPCPuppet', 'OnIncapacitated', function(self)
    if self:GetRecord():TagsContains("Robot") then
      StatusEffectHelper.RemoveStatusEffect(v, TweakDBID.new("DCO.HighlightSE"))
    end
    if self:GetRecord():TagsContains(CName.new("DCOHighlight")) then
      for _,v in ipairs(Game.GetCompanionSystem():GetSpawnedEntities()) do
        if v:GetRecord():TagsContains("Robot") then
          StatusEffectHelper.RemoveStatusEffect(v, TweakDBID.new("DCO.HighlightSE"))
        end
      end
    end
  end)

  ----------------------------------- ARASAKA MECH TECHACK DURATION ---
  createCombinedStatModifier("DCO.TechHackDurationModifier", "AdditiveMultiplier", "*", "Self", "DCO.DroneTechHackDuration", "BaseStats.MaxDuration", 1)
  addToList("DCO.DroneCloakDuration.statModifiers", "DCO.TechHackDurationModifier")
  addToList("DCO.OverdriveDuration.statModifiers",  "DCO.TechHackDurationModifier")
  createConstantStatModifier("DCO.MechArasakaTechHackDuration", "Additive", "DCO.DroneTechHackDuration", 0.5)
  for i=1, DroneRecords do
    addToList("DCO.Tier1MechArasaka"..i..".statModifiers", "DCO.MechArasakaTechHackDuration")
  end

  ----------------------------------- NCPD MECH NERFS ------------------
  createConstantStatModifier("DCO.MechNCPDHP",  "Multiplier", "BaseStats.Health",   0.67)
  createConstantStatModifier("DCO.MechNCPDDPS","Multiplier", "BaseStats.NPCDamage", 0.67)
  for i=1, DroneRecords do
    addListToList("DCO.Tier1MechNCPD"..i, "statModifiers", {"DCO.MechNCPDDPS", "DCO.MechNCPDHP"})
  end

  ----------------------------------- MILITECH MECH WEAKSPOT HP BONUS --
  createCombinedStatModifier("DCO.MechWeakspotHPModifier", "AdditiveMultiplier", "*", "Owner", "DCO.DroneWeakspotHP", "BaseStats.Health", 1)
  addToList("Weakspots.Mech_Weapon_Weakspot_Stats.statModifiers", "DCO.MechWeakspotHPModifier")
  createConstantStatModifier("DCO.MechMilitechWeakspotHPBonus", "Additive", "DCO.DroneWeakspotHP", 0.5)
  for i=1, DroneRecords do
    addToList("DCO.Tier1MechMilitech"..i..".statModifiers", "DCO.MechMilitechWeakspotHPBonus")
  end

  ------------------------------------- EXPLOSIVE MILITECH MECH BULLETS
  MechBulletExplosion = TweakDBInterface.GetAttack_GameEffectRecord(TweakDBID.new("Attacks.BulletSmartBulletHighExplosion"))
  Override('sampleSmartBullet' ,'OnCollision', function(self, projectileHitEvent, wrappedMethod)
    local charRecord = TweakDBInterface.GetCharacterRecord(self.owner:GetRecordID())
    if charRecord:TagsContains(CName.new("Robot")) and charRecord:VisualTagsContains(CName.new("Militech")) and self.owner:GetNPCType() == gamedataNPCType.Mech then
      local damageHitEvent = gameprojectileHitEvent:new()
      for i=1, table.getn(projectileHitEvent.hitInstances) do
        local hitInstance = projectileHitEvent.hitInstances[i]
        if self.alive then
          local gameObj = hitInstance.hitObject
          local weaponObj = self.weapon
          local targetHasJammer = IsDefined(gameObj) and gameObj:HasTag(CName.new("jammer"))
          if not targetHasJammer then
            table.insert(damageHitEvent.hitInstances, hitInstance)
          end
          if not gameObj:HasTag(CName.new("bullet_no_destroy")) and self.BulletCollisionEvaluator:HasReportedStopped() and hitInstance.position == self.BulletCollisionEvaluator:GetStoppedPosition() then
            self:BulletRelease()
            if not self.HasExploded and IsDefined(self.attack) then
              self.hasExploded = true
              Attack_GameEffect.SpawnExplosionAttack(MechBulletExplosion, weaponObj, self.owner, self, hitInstance.position, 0.05)
            end
            if not targetHasJammer and not gameObj:HasTag(CName.new("MeatBag")) then
              self.countTime = 0
              self.alive = false
              self.hit = true
            end
          end
        end
      end
      if table.getn(damageHitEvent.hitInstances)>0 then
        self.DealDamage(damageHitEvent)
      end
      return
    end
    wrappedMethod(projectileHitEvent)
  end)

  for _,v in ipairs(Full_Drone_List) do
    addToList(v..".abilities", "DCO.EWSExplosion")
  end
end

------------------------------------- MECH WEAKSPOT EXPLODE ON SELF-DESTRUCT
Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
  if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot")) 
     and self:GetNPCType() == gamedataNPCType.Mech 
     and statusEffect.staticData:GetID() == TweakDBID.new("BaseStatusEffect.SuicideWithWeapon") then
    local weakspots = self:GetWeakspotComponent():GetWeakspots()
    for i,v in ipairs(weakspots) do
      ScriptedWeakspotObject.Kill(v, Game.GetPlayer())
    end
    StatusEffectHelper.ApplyStatusEffect(self, TweakDBID.new("Minotaur.RightArmDestroyed"))
    StatusEffectHelper.ApplyStatusEffect(self, TweakDBID.new("Minotaur.LeftArmDestroyed"))
    self:Kill()
  end
end)

Override('WithoutHitDataDeathTask', 'GetDeathReactionType', function(self, context, wrappedMethod)
  if ScriptExecutionContext.GetOwner(context):GetNPCType() == gamedataNPCType.Mech then
    return EnumInt(animHitReactionType.Death)
  end
  return wrappedMethod(context)
end)

function createDroneStatGroup(recordName, stats)
  TweakDB:CreateRecord(recordName, "gamedataStatModifierGroup_Record")
  local built_stats = {}
  for i,v in ipairs(stats) do
    createCombinedStatModifier(recordName.."_inline"..i, v[1], "*", "Player", v[2], v[3], v[4])
    table.insert(built_stats, recordName.."_inline"..i)
  end
  TweakDB:SetFlatNoUpdate(recordName..".statModsLimit", -1)
  TweakDB:SetFlat(recordName..".statModifiers", built_stats)
  TweakDB:Update(recordName)
end

function createStat(recordName, baseStat)
  TweakDB:CloneRecord(recordName, baseStat)
end

return DCO:new()
