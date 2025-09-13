DCO = {
    description = "DCO"
}

function DCO:new()
    -------------------------------------------------
    -- REMOVE MECH STRAFING (Royce Exo)
    -------------------------------------------------
    addToList("RoyceExo.StrafeLeft_inline1.AND",  "DCO.IsNotDCO")
    addToList("RoyceExo.StrafeRight_inline1.AND", "DCO.IsNotDCO")

    -------------------------------------------------
    -- FIX STAGGER / IMPACT REACTIONS (mechs & robots)
    -------------------------------------------------
    Override('HitReactionComponent', 'SendDataToAIBehavior', function(self, reactionPlayed, wrappedMethod)
        if reactionPlayed == animHitReactionType.Stagger
        or reactionPlayed == animHitReactionType.Impact
        or reactionPlayed == animHitReactionType.Pain then

            -- Mechs not staggered by our melee androids
            if self.ownerNPC:GetNPCType() == gamedataNPCType.Mech then
                if TweakDBInterface.GetCharacterRecord(self.attackData.instigator:GetRecordID()):TagsContains(CName.new("Robot")) then
                    return
                end
            end

            -- Bosses don't stagger from our bots
            if self.ownerNPC:IsBoss() then
                if TweakDBInterface.GetCharacterRecord(self.attackData.instigator:GetRecordID()):TagsContains(CName.new("Robot")) then
                    return
                end
            end

            -- Our companions (robots) don't forward auto-stagger to AI
            if TweakDBInterface.GetCharacterRecord(self.ownerNPC:GetRecordID()):TagsContains(CName.new("Robot")) then
                return
            end
        end
        wrappedMethod(reactionPlayed)
    end)

    Override('HitReactionComponent', 'SendMechDataToAIBehavior', function(self, reactionPlayed, wrappedMethod)
        if reactionPlayed == animHitReactionType.Stagger
        or reactionPlayed == animHitReactionType.Impact
        or reactionPlayed == animHitReactionType.Pain then

            -- Mechs not staggered by our melee androids (unless attacker is a mech)
            if self.ownerNPC:GetNPCType() == gamedataNPCType.Mech
            and not (self.attackData.instigator:GetNPCType() == gamedataNPCType.Mech) then
                if TweakDBInterface.GetCharacterRecord(self.attackData.instigator:GetRecordID()):TagsContains(CName.new("Robot")) then
                    return
                end
            end

            -- Our companions (robots) ignore auto-stagger unless attacker is a mech
            if TweakDBInterface.GetCharacterRecord(self.ownerNPC:GetRecordID()):TagsContains(CName.new("Robot"))
            and not (self.attackData.instigator:GetNPCType() == gamedataNPCType.Mech) then
                return
            end
        end
        wrappedMethod(reactionPlayed)
    end)

    -------------------------------------------------
    -- FIX MINOTAUR ARM EXPLOSION / STAGGER SEQUENCE
    -------------------------------------------------
    Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, statusEffect)
        if TweakDBInterface.GetCharacterRecord(self:GetRecordID()):TagsContains(CName.new("Robot")) then
            if statusEffect.staticData:GetID() == TweakDBID.new("Minotaur.RightArmDestroyed") then
                StatusEffectHelper.ApplyStatusEffect(self, TweakDBID.new("Minotaur.RightExplosion"))
            elseif statusEffect.staticData:GetID() == TweakDBID.new("Minotaur.LeftArmDestroyed") then
                StatusEffectHelper.ApplyStatusEffect(self, TweakDBID.new("Minotaur.LeftExplosion"))
            end
        end
    end)

    -------------------------------------------------
    -- MECH DEATH EXPLOSION SHOULD DEAL DAMAGE
    -------------------------------------------------
    TweakDB:CreateRecord("DCO.MechGLP", "gamedataGameplayLogicPackage_Record")
    TweakDB:SetFlat("DCO.MechGLP.effectors", {"DCO.MechGLP_inline0"})
    TweakDB:CloneRecord("DCO.MechGLP_inline0", "DCO.FlyingDroneGLP_inline0")
    TweakDB:SetFlat("DCO.MechGLP_inline0.attackRecord", "DCO.MechDeathExplosion")
    TweakDB:SetFlat("DCO.MechGLP_inline0.attackPositionSlotName", CName.new("Chest"))
    for _, v in ipairs(Mech_List) do
        addToList(v..".onSpawnGLPs", "DCO.MechGLP")
    end

    -------------------------------------------------
    -- REDUCE BURST LENGTH SO MECHS DON'T SHOOT CORPSES
    -------------------------------------------------
    TweakDB:SetFlat("MinotaurMech.AimAttackHMG_inline10.numberOfShots",          12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGLeft_inline1.numberOfShots",       12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGOnPlace_inline10.numberOfShots",   12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGOnPlace_inline12.numberOfShots",   12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGOnPlaceLeft_inline12.numberOfShots", 12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGOnPlaceRight_inline12.numberOfShots",12, 'Int32')
    TweakDB:SetFlat("MinotaurMech.AimAttackHMGRight_inline1.numberOfShots",      12, 'Int32')

    -------------------------------------------------
    -- SMASHER "KILLED TARGET" EDGE-CASE FIX
    -------------------------------------------------
    TweakDB:CloneRecord("DCO.TargetHealthBelow1perc", "Condition.HealthBelow1perc")
    TweakDB:SetFlat("DCO.TargetHealthBelow1perc.target", "AIActionTarget.CombatTarget")
    addToList("AdamSmasherBoss.AimAttackLMGCover_inline4.OR", "DCO.TargetHealthBelow1perc")

    -------------------------------------------------
    -- FIX MECH/OCTANT AI PAUSE LOOPS & BOXING ARENAS
    -------------------------------------------------
    local mechcount, mechcount2, octantcount, bombuscount = 0, 0, 0, 0
    Override('TweakAIActionAbstract', 'Update', function(self, context, wrappedMethod)
        local owner = ScriptExecutionContext.GetOwner(context)
        if owner and owner.GetRecordID
           and TweakDBInterface.GetCharacterRecord(owner:GetRecordID()):TagsContains(CName.new("Robot")) then

            -- Skip only in fistfights
            if StatusEffectSystem.ObjectHasStatusEffectWithTag(Game.GetPlayer(), CName.new("FistFight")) then
                return wrappedMethod(context)
            end

            local recordID = (self.actionRecord and self.actionRecord:GetID()) or TweakDBID.new("")
            if recordID == TweakDBID.new("MinotaurMech.AimAttackHMG") then
                mechcount = mechcount + 1
                if mechcount > 50 then mechcount = 0; return AIbehaviorUpdateOutcome.SUCCESS end
                local ret = wrappedMethod(context); if ret == AIbehaviorUpdateOutcome.SUCCESS then mechcount = 0 end; return ret

            elseif recordID == TweakDBID.new("MinotaurMech.RotateToTargetNoLimit") then
                mechcount2 = mechcount2 + 1
                if mechcount2 > 20 then mechcount2 = 0; return AIbehaviorUpdateOutcome.SUCCESS end
                local ret = wrappedMethod(context); if ret == AIbehaviorUpdateOutcome.SUCCESS then mechcount2 = 0 end; return ret

            elseif recordID == TweakDBID.new("DroneOctantActions.ShootDefault") then
                -- keep octant from getting stuck mid-shoot
                octantcount = octantcount + 1
                if octantcount > 50 then octantcount = 0; return AIbehaviorUpdateOutcome.SUCCESS end
                local ret = wrappedMethod(context); if ret == AIbehaviorUpdateOutcome.SUCCESS then octantcount = 0 end; return ret

            elseif recordID == TweakDBID.new("DroneBombusActions.FollowTargetFast") then
                -- prevent bombus follow loop when target is dead
                bombuscount = bombuscount + 1
                if bombuscount > 30 then bombuscount = 0; return AIbehaviorUpdateOutcome.SUCCESS end
                local ret = wrappedMethod(context); if ret == AIbehaviorUpdateOutcome.SUCCESS then bombuscount = 0 end; return ret
            end
        end
        return wrappedMethod(context)
    end)
end

return DCO:new()
