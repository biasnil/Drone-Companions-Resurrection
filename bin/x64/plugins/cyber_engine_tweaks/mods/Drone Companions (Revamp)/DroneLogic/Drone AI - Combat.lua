DCO = {
    description = "DCO"
}

function DCO:new()
    -------------------------------------------------
    -- SMART BULLETS: allow tracking for our bots (no mechs)
    -------------------------------------------------

    Override('AISubActionShootWithWeapon_Record_Implementation', 'ShouldTrackTarget;gamePuppetAISubActionShootWithWeapon_RecordWeaponObject', function(owner, record, weapon, wrappedMethod)
        if not (owner and owner.GetNPCType and owner:GetNPCType() == gamedataNPCType.Mech) then
            if not IsDefined(owner) or not IsDefined(weapon) or not IsDefined(record) then
                return false
            end
            local characterRecord = TweakDBInterface.GetCharacterRecord(owner:GetRecordID())
            if characterRecord and characterRecord:TagsContains(CName.new("Robot")) then
                if StatusEffectSystem.ObjectHasStatusEffectWithTag(owner, CName.new("WeaponJam")) then
                    return false
                end
                local randChance = math.random(1, 100)
                local ownerAccuracy = Game.GetStatsSystem():GetStatValue(owner:GetEntityID(), gamedataStatType.Accuracy)
                ownerAccuracy = 0 -- keep behavior consistent with original script
                local randLimit = 100 - (70 + ownerAccuracy * 4)
                return randChance > randLimit
            end
        end
        return wrappedMethod(owner, record, weapon)
    end)

    -------------------------------------------------
    -- DROP DRONE CORES WHEN SYSTEM COLLAPSED
    -------------------------------------------------

    Override('ScriptedPuppet', 'ProcessLoot', function(self, wrappedMethod)
      if wrappedMethod then wrappedMethod() end

      local rec = TweakDBInterface.GetCharacterRecord(self:GetRecordID())
      if not rec or not rec:TagsContains(CName.new("Robot")) then return end

      local player = Game.GetPlayer()
      local ally = false
      if self.IsPlayerCompanion and self:IsPlayerCompanion() then ally = true end
      if not ally and player and GameObject.GetAttitudeTowards and GameObject.GetAttitudeTowards(self, player) == EAIAttitude.AIA_Friendly then ally = true end
      if not ally and self.GetAttitudeAgent and self:GetAttitudeAgent() and self:GetAttitudeAgent():GetAttitudeGroup() == CName.new("player") then ally = true end
      if not ally then return end
      if self.DCORewarded then return end

      local itemFlat = TweakDB:GetFlat(self:GetRecordID()..'.DCOItem')
      if not itemFlat then return end
      local itemRec = TweakDBInterface.GetItemRecord(TweakDBID.new(itemFlat))
      if not itemRec then return end

      local ingdata = CraftingSystem.GetInstance():GetItemCraftingCost(itemRec)
      if not ingdata or #ingdata == 0 then return end

      local mult = 0.1
      if StatusEffectSystem.ObjectHasStatusEffect(self, TweakDBID.new("BaseStatusEffect.SystemCollapse")) then mult = 0.5 end

      Game.GetTransactionSystem():RemoveAllItems(self)
      for _, v in ipairs(ingdata) do
        local qty = v.quantity or 1
        Game.GetTransactionSystem():GiveItemByTDBID(self, v.id:GetID(), math.ceil(qty * mult))
      end

      if ScriptedPuppet.HasLootableItems(self) then ScriptedPuppet.EvaluateLootQuality(self) end
      if self.CacheLootForDropping then self:CacheLootForDropping() end
      self.DCORewarded = true
    end)

    -------------------------------------------------
    -- PREVENT ROBOTS FROM TRYING TO ENTER STEALTH
    -------------------------------------------------
    TweakDB:SetFlat("FollowerActions.EnterStealth_inline0.condition", "DCO.EnterStealthCondition")
    TweakDB:CloneRecord("DCO.EnterStealthCondition", "Condition.EnterStealthCondition")
    addToList("DCO.EnterStealthCondition.AND", "Condition.Human")

    -------------------------------------------------
    -- OUT OF COMBAT REGEN (flying + androids)
    -------------------------------------------------
    -- base prereqs
    TweakDB:CreateRecord("DCO.InCombatSE", "gamedataStatusEffect_Record")
    TweakDB:SetFlatNoUpdate("DCO.InCombatSE.duration", "BaseStats.InfiniteDuration")
    TweakDB:SetFlat("DCO.InCombatSE.statusEffectType", "BaseStatusEffectTypes.Misc")
    TweakDB:Update("DCO.InCombatSE")

    TweakDB:CreateRecord("DCO.InCombat", "gamedataStatusEffectPrereq_Record")
    TweakDB:SetFlatNoUpdate("DCO.InCombat.statusEffect", "DCO.InCombatSE")
    TweakDB:SetFlat("DCO.InCombat.prereqClassName", "StatusEffectPrereq")
    TweakDB:Update("DCO.InCombat")

    TweakDB:CreateRecord("DCO.NotInCombat", "gamedataStatusEffectPrereq_Record")
    TweakDB:SetFlatNoUpdate("DCO.NotInCombat.statusEffect", "DCO.InCombatSE")
    TweakDB:SetFlat("DCO.NotInCombat.prereqClassName", "StatusEffectAbsentPrereq")
    TweakDB:Update("DCO.NotInCombat")

    -- regen ability
    TweakDB:CreateRecord("DCO.DronePassiveRegenAbility", "gamedataGameplayAbility_Record")
    TweakDB:SetFlat("DCO.DronePassiveRegenAbility.abilityPackage", "DCO.DronePassiveRegenAbility_inline1")

    TweakDB:CreateRecord("DCO.DronePassiveRegenAbility_inline1", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.DronePassiveRegenAbility_inline1.effectors", {"DCO.DronePassiveRegenAbility_inline2"})

    TweakDB:CloneRecord("DCO.DronePassiveRegenAbility_inline2", "Ability.HasPassiveHealthRegeneration_inline1")
    TweakDB:SetFlatNoUpdate("DCO.DronePassiveRegenAbility_inline2.prereqRecord", "DCO.NotInCombat")
    TweakDB:SetFlat("DCO.DronePassiveRegenAbility_inline2.poolModifier", "DCO.DronePassiveRegenAbility_inline3")

    TweakDB:CloneRecord("DCO.DronePassiveRegenAbility_inline3", "Ability.HasPassiveHealthRegeneration_inline2")
    TweakDB:SetFlatNoUpdate("DCO.DronePassiveRegenAbility_inline3.startDelay", 2)
    TweakDB:SetFlatNoUpdate("DCO.DronePassiveRegenAbility_inline3.delayOnChange", true)
    TweakDB:SetFlat("DCO.DronePassiveRegenAbility_inline3.valuePerSec", 2)

    for _, v in ipairs(Flying_List) do
        addToList(v..".abilities", "DCO.DronePassiveRegenAbility")
    end
    for _, v in ipairs(Android_List) do
        addToList(v..".abilities", "DCO.DronePassiveRegenAbility")
    end

    TweakDB:Update("DCO.DronePassiveRegenAbility_inline2")
    TweakDB:Update("DCO.DronePassiveRegenAbility_inline3")

    -------------------------------------------------
    -- PREVENT CYBER ENEMIES FROM USING COMBAT STIMS
    -------------------------------------------------
    addToList("SpecialActions.CoverUseCombatStimConsumable_inline11.AND", "DCO.IsNotDCO")
    addToList("SpecialActions.UseCombatStimConsumable_inline5.AND", "DCO.IsNotDCO")

    -------------------------------------------------
    -- COMBAT MOVEMENT: give followers better spacing
    -------------------------------------------------
    local nodelist = TweakDB:GetFlat("MovementActions.MovementPolicyCompositeDefault.nodes")
    TweakDB:SetFlat("FollowerActions.CombatMovementComposite.nodes", nodelist)

    -------------------------------------------------
    -- FOLLOWER TELEPORT TWEAKS (distance-based)
    -------------------------------------------------
    TweakDB:SetFlat("FollowerActions.TeleportToFollower_inline0.duration", 0.1)
    TweakDB:CreateRecord("DCO.FollowerTeleportDistance", "gamedataAIActionAND_Record")
    TweakDB:SetFlat("DCO.FollowerTeleportDistance.AND", {"Condition.FollowerAbove17m", "DCO.FollowerBelow100m"})
    addToList("FollowerActions.TeleportToTarget_inline2.OR", "DCO.FollowerTeleportDistance")

    addToList("DroneActions.EvaluateTeleportToTarget_inline2.AND", "DCO.FollowerBelow100m")
    TweakDB:CloneRecord("DCO.FollowerBelow100m", "Condition.FollowerBelow10m")
    local vec = Vector2:new(); vec.X = -1; vec.Y = 100
    TweakDB:SetFlat("DCO.FollowerBelow100m.distance", vec)

    -------------------------------------------------
    -- SYSTEM COLLAPSE: infinite duration + safe deaths
    -------------------------------------------------
    TweakDB:SetFlat("BaseStatusEffect.SystemCollapse.duration", "BaseStats.InfiniteDuration")

    Override('DroneComponent', 'OnDeath', function(self, evt, wrappedMethod)
        local owner = self:GetOwner()
        if not (owner and TweakDBInterface.GetCharacterRecord(owner:GetRecordID()):TagsContains(CName.new("Robot"))) then
            return wrappedMethod(evt)
        end
        if StatusEffectSystem.ObjectHasStatusEffect(owner, TweakDBID.new("BaseStatusEffect.SystemCollapse")) then
            GameObject.PlaySound(owner, CName.new("drone_destroyed"))
            GameObject.StartReplicatedEffectEvent(owner, CName.new("hacks_system_collapse"))
            self:RemoveSpawnGLPs(owner)
            if TweakDB:GetFlat(owner:GetRecordID()..'keepColliderOnDeath') then
                local reenableColliderEvent = ReenableColliderEvent:new()
                Game.GetDelaySystem():DelayEvent(owner, reenableColliderEvent, 0.20)
            end
            owner:QueueEvent(CreateForceRagdollEvent(CName.new("ForceRagdollTask")))
        else
            return wrappedMethod(evt)
        end
    end)

    -------------------------------------------------
    -- REMOVE PLAYER MUST BE SPRINTING CONDITION
    -------------------------------------------------

    TweakDB:SetFlat("Condition.FollowFarStopCondition_inline1.AND", {"Condition.IsDistanceToDestinationInMediumRange"})

    -------------------------------------------------
    -- HACKING: allow multiple hacks per target window
    -------------------------------------------------
    
    TweakDB:SetFlat("AIQuickHackStatusEffect.BeingHacked_inline1.value", 5, 'Float')

    -------------------------------------------------
    -- NETLINK FX: hide connection link for robot netrunners
    -------------------------------------------------
    Observe('ScriptedPuppet', 'OnNetworkLinkQuickhackEvent', function(self, evt)
        local runner = Game.FindEntityByID(evt.netrunnerID)
        if runner and TweakDBInterface.GetCharacterRecord(runner:GetRecordID()):TagsContains(CName.new("Robot")) then
            Cron.After(5, function()
                self:GetPS():DrawBetweenEntities(false, true, self:GetFxResourceByKey(CName.new("pingNetworkLink")), evt.to, evt.from, false, false, false, false)
            end)
        end
    end)
end

return DCO:new()
