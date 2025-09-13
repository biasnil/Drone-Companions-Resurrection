module DCO

public class DCOCraftingGate extends IScriptable {

  public static func IsDcoItem(item: TweakDBID) -> Bool {
    let rec = TweakDBInterface.GetItemRecord(item);
    return IsDefined(rec) && rec.TagsContains(n"DCOCraftsDrone");
  }

  public static func IsMech(item: TweakDBID) -> Bool {
    let rec = TweakDBInterface.GetItemRecord(item);
    return IsDefined(rec) && rec.TagsContains(n"DCOCraftsMech");
  }

  public static func DroneLimit(player: wref<PlayerPuppet>) -> Float {
    return GameInstance.GetStatsSystem(player.GetGame())
      .GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.NPCAnimationTime);
  }

  public static func CombatDisabled(player: wref<PlayerPuppet>) -> Bool {
    let defs = GetAllBlackboardDefs();
    let bb   = GameInstance.GetBlackboardSystem(player.GetGame())
                 .GetLocalInstanced(player.GetEntityID(), defs.PlayerStateMachine);

    if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoCrafting") { return true; }
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoJump")     { return true; }
    if bb.GetInt(defs.PlayerStateMachine.Zones) == 2                          { return true; }
    if bb.GetBool(defs.PlayerStateMachine.SceneSafeForced)                    { return true; }
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoCombat")   { return true; }
    if bb.GetInt(defs.PlayerStateMachine.UpperBody) == EnumInt(gamePSMUpperBodyStates.ForceEmptyHands) { return true; }
    return false;
  }

  public static func SceneTier3OrAbove(player: wref<PlayerPuppet>) -> Bool {
    let defs = GetAllBlackboardDefs();
    let bb   = GameInstance.GetBlackboardSystem(player.GetGame())
                 .GetLocalInstanced(player.GetEntityID(), defs.PlayerStateMachine);
    return bb.GetInt(defs.PlayerStateMachine.SceneTier) > 2;
  }

  public static func PlayerInVehicle(player: wref<PlayerPuppet>) -> Bool {
    let mf = GameInstance.GetMountingFacility(player.GetGame());
    if !IsDefined(mf) { return false; }
    let info = mf.GetMountingInfoSingleWithObjects(player);
    return EntityID.IsDefined(info.parentId);
  }

  public static func PlayerInElevator(gi: GameInstance) -> Bool {
    return LiftDevice.IsPlayerInsideElevator(gi);
  }

  private static func IsFriendlyToPlayer(npc: wref<GameObject>, playerGO: wref<GameObject>) -> Bool {
    return Equals(GameObject.GetAttitudeBetween(npc, playerGO), EAIAttitude.AIA_Friendly);
  }

  public static func AnyFriendlyMechAlive(gi: GameInstance, playerGO: wref<GameObject>) -> Bool {
    let cs = GameInstance.GetCompanionSystem(gi);
    if !IsDefined(cs) { return false; }

    let ents: array<wref<Entity>>;
    cs.GetSpawnedEntities(ents);

    let i: Int32 = 0;
    while i < ArraySize(ents) {
      let npc = ents[i] as ScriptedPuppet;
      if IsDefined(npc)
        && !npc.IsIncapacitated()
        && EnumInt(npc.GetNPCType()) == EnumInt(gamedataNPCType.Mech)
        && DCOCraftingGate.IsFriendlyToPlayer(npc, playerGO) {
        return true;
      }
      i += 1;
    }
    return false;
  }

  public static func CountAliveFriendlyRobots(gi: GameInstance, playerGO: wref<GameObject>) -> Int32 {
    let cs = GameInstance.GetCompanionSystem(gi);
    if !IsDefined(cs) { return 0; }

    let ents: array<wref<Entity>>;
    cs.GetSpawnedEntities(ents);

    let alive: Int32 = 0;
    let i: Int32 = 0;
    while i < ArraySize(ents) {
      let npc = ents[i] as ScriptedPuppet;
      if IsDefined(npc) && !npc.IsIncapacitated() && DCOCraftingGate.IsFriendlyToPlayer(npc, playerGO) {
        let crec = TweakDBInterface.GetCharacterRecord(npc.GetRecordID());
        if IsDefined(crec) && crec.TagsContains(n"Robot") {
          alive += 1;
        }
      }
      i += 1;
    }
    return alive;
  }

  public static func ShouldBlockWithReason(gi: GameInstance, item: TweakDBID, out reason: String) -> Bool {
    reason = "";
    let player = GameInstance.GetPlayerSystem(gi).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) { return false; }

    let limit: Float = DCOCraftingGate.DroneLimit(player);
    if limit == 0.0 { reason = "Requires a Techdeck installed."; return true; }
    if DCOCraftingGate.CombatDisabled(player)    { reason = "Crafting is currently disabled."; return true; }
    if DCOCraftingGate.SceneTier3OrAbove(player) { reason = "V is busy."; return true; }
    if DCOCraftingGate.PlayerInVehicle(player)   { reason = "Exit the vehicle to craft."; return true; }
    if DCOCraftingGate.PlayerInElevator(player.GetGame()) { reason = "Exit the elevator to craft."; return true; }

    let playerGO: wref<GameObject> = player;
    let aliveFriendly: Int32 = DCOCraftingGate.CountAliveFriendlyRobots(gi, playerGO);
    if Cast<Float>(aliveFriendly) >= limit { reason = "Drone limit reached."; return true; }

    if DCOCraftingGate.IsMech(item) && DCOCraftingGate.AnyFriendlyMechAlive(gi, playerGO) {
      reason = "Only one friendly mech can be active.";
      return true;
    }

    return false;
  }

  public static func ShouldBlock(gi: GameInstance, item: TweakDBID) -> Bool {
    let _r: String;
    return DCOCraftingGate.ShouldBlockWithReason(gi, item, _r);
  }
}

@wrapMethod(CraftingSystem)
public func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool {
  let ok = wrappedMethod(itemRecord);
  if !IsDefined(itemRecord) { return ok; }
  let tdb = itemRecord.GetID();
  if !DCOCraftingGate.IsDcoItem(tdb) { return ok; }
  if DCOCraftingGate.ShouldBlock(this.GetGameInstance(), tdb) { return false; }
  return ok;
}

@wrapMethod(CraftingSystem)
public func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
  let ok = wrappedMethod(itemData);
  if !IsDefined(itemData) { return ok; }
  let tdb = ItemID.GetTDBID(itemData.GetID());
  if !DCOCraftingGate.IsDcoItem(tdb) { return ok; }
  if DCOCraftingGate.ShouldBlock(this.GetGameInstance(), tdb) { return false; }
  return ok;
}

@wrapMethod(CraftingLogicController)
public func CraftItem(selectedRecipe: ref<RecipeData>, amount: Int32) -> Void {
  if IsDefined(selectedRecipe) {
    let rec: wref<Item_Record> = selectedRecipe.id;
    if IsDefined(rec) {
      let tdb: TweakDBID = rec.GetID();
      if DCOCraftingGate.IsDcoItem(tdb) {
        let player = this.m_craftingGameController.GetPlayer();
        if IsDefined(player) {
          let reason: String;
          if DCOCraftingGate.ShouldBlockWithReason(player.GetGame(), tdb, reason) {
            this.m_isCraftable = false;
            if IsDefined(this.m_progressButtonController) {
              this.m_progressButtonController.SetAvaibility(EProgressBarState.Blocked);
            }
            inkWidgetRef.SetVisible(this.m_blockedText, true);
            inkTextRef.SetText(this.m_blockedText, reason);
            this.m_notificationType = UIMenuNotificationType.CraftingNoPerks;
            return;
          }
        }
      }
    }
  }
  wrappedMethod(selectedRecipe, amount);
}

@wrapMethod(CraftingLogicController)
protected func SetNotification(isQuickHack: Bool) -> Void {
  if !IsDefined(this.m_selectedRecipe) || !IsDefined(this.m_selectedRecipe.id) {
    wrappedMethod(isQuickHack);
    return;
  }

  let tdb: TweakDBID = this.m_selectedRecipe.id.GetID();
  if !DCOCraftingGate.IsDcoItem(tdb) {
    wrappedMethod(isQuickHack);
    return;
  }

  let player = this.m_craftingGameController.GetPlayer();
  if IsDefined(player) {
    let reason: String;
    if DCOCraftingGate.ShouldBlockWithReason(player.GetGame(), tdb, reason) {
      inkTextRef.SetText(this.m_blockedText, reason);
      this.m_notificationType = UIMenuNotificationType.CraftingNoPerks;
      return;
    }
  }

  wrappedMethod(isQuickHack);
}
