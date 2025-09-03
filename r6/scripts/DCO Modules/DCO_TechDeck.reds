public class DCO_TechDeck_Utils extends IScriptable {
  public static func IsTechdeckRecord(rec: wref<Item_Record>) -> Bool {
    return IsDefined(rec) && rec.TagsContains(n"Robot") && !rec.TagsContains(n"Cyberdeck");
  }

  public static func PlayerHasTechdeck(owner: wref<GameObject>) -> Bool {
    if !IsDefined(owner) { return false; }
    let game: GameInstance = owner.GetGame();
    let player: wref<PlayerPuppet> = GetPlayer(game);
    if !IsDefined(player) { return false; }
    let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(game);
    return stats.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.NPCAnimationTime) > 0.00;
  }
}

@wrapMethod(EquipmentSystem)
public final static func IsCyberdeckEquipped(owner: ref<GameObject>) -> Bool {
  if DCO_TechDeck_Utils.PlayerHasTechdeck(owner) { return true; }
  return wrappedMethod(owner);
}

@wrapMethod(healthbarWidgetGameController)
private final func IsCyberdeckEquipped() -> Bool {
  let owner: wref<GameObject> = this.GetPlayerControlledObject();
  if DCO_TechDeck_Utils.PlayerHasTechdeck(owner) { return true; }
  return wrappedMethod();
}

@wrapMethod(RipperDocGameController)
private final func ShowCWTooltip(item: wref<UIInventoryItem>, equippedItem: wref<UIInventoryItem>, widget: wref<inkWidget>, isVendorItem: Bool, isBuyBack: Bool, opt iconErrorInfo: ref<DEBUG_IconErrorInfo>) -> Void {
  if IsDefined(item) && item.GetItemData().HasTag(n"Robot") && !item.GetItemData().HasTag(n"Cyberdeck") {
    let tooltipData: ref<UIInventoryItemTooltipWrapper> = UIInventoryItemTooltipWrapper.Make(item, isVendorItem ? this.m_vendorItemDisplayContext : this.m_playerItemDisplayContext);
    this.m_TooltipsManager.ShowTooltipAtWidget(n"cyberdeckTooltip", widget, tooltipData, gameuiETooltipPlacement.RightTop, false, new inkMargin(this.m_defaultTooltipGap, 0.00, 0.00, 0.00));
    return;
  };
  wrappedMethod(item, equippedItem, widget, isVendorItem, isBuyBack, iconErrorInfo);
}

@wrapMethod(CyberdeckTooltip)
protected final func UpdateRequirements() -> Void {
  wrappedMethod();
}

@wrapMethod(CyberdeckTooltip)
protected final func GetCyberdeckDeviceQuickhacks(itemRecord: wref<Item_Record>) -> array<CyberdeckDeviceQuickhackData> {
  if !DCO_TechDeck_Utils.IsTechdeckRecord(itemRecord) { return wrappedMethod(itemRecord); }
  let out: array<CyberdeckDeviceQuickhackData>;
  let actions: array<wref<ObjectAction_Record>>;
  let i: Int32 = 0;
  itemRecord.ObjectActions(actions);
  while i < ArraySize(actions) {
    if IsDefined(actions[i]) && IsDefined(actions[i].ObjectActionType()) {
      let ui: wref<InteractionBase_Record> = actions[i].ObjectActionUI();
      let entry: CyberdeckDeviceQuickhackData;
      entry.UIIcon = ui.CaptionIcon().TexturePartID();
      entry.ObjectActionRecord = actions[i];
      ArrayPush(out, entry);
    };
    i += 1;
  };
  return out;
}

@replaceMethod(RPGManager)
public final static func GetPlayerQuickHackListWithQuality(player: wref<PlayerPuppet>) -> array<PlayerQuickhackData> {
    let actions: array<wref<ObjectAction_Record>>;
    let i: Int32;
    let i1: Int32;
    let itemRecord: wref<Item_Record>;
    let parts: array<SPartSlots>;
    let quickhackData: PlayerQuickhackData;
    let quickhackDataEmpty: PlayerQuickhackData;
    let systemReplacementID: ItemID;
    let quickhackDataArray: array<PlayerQuickhackData> = player.GetCachedQuickHackList();
    if ArraySize(quickhackDataArray) > 0 {
      return quickhackDataArray;
    };
	
	let deckIDs: array<ItemID> = EquipmentSystem.GetItemsInArea(player, gamedataEquipmentArea.SystemReplacementCW);
	let myint: Int32 = 0;
	
	while myint < ArraySize(deckIDs) {
		systemReplacementID = deckIDs[myint];
		itemRecord = RPGManager.GetItemRecord(systemReplacementID);
		if EquipmentSystem.IsCyberdeckEquipped(player) {
		  itemRecord.ObjectActions(actions);
		  i = 0;
		  while i < ArraySize(actions) {
			quickhackData = quickhackDataEmpty;
			quickhackData.actionRecord = actions[i];
			quickhackData.quality = itemRecord.Quality().Value();
			ArrayPush(quickhackDataArray, quickhackData);
			i += 1;
		  };
		  parts = ItemModificationSystem.GetAllSlots(player, systemReplacementID);
		  i = 0;
		  while i < ArraySize(parts) {
			ArrayClear(actions);
			itemRecord = RPGManager.GetItemRecord(parts[i].installedPart);
			if IsDefined(itemRecord) {
			  itemRecord.ObjectActions(actions);
			  i1 = 0;
			  while i1 < ArraySize(actions) {
				if Equals(actions[i1].ObjectActionType().Type(), gamedataObjectActionType.DeviceQuickHack) || Equals(actions[i1].ObjectActionType().Type(), gamedataObjectActionType.PuppetQuickHack) {
				  quickhackData = quickhackDataEmpty;
				  quickhackData.actionRecord = actions[i1];
				  quickhackData.quality = itemRecord.Quality().Value();
				  ArrayPush(quickhackDataArray, quickhackData);
				};
				i1 += 1;
			  };
			};
			i += 1;
		  };
		};
		ArrayClear(actions);
		itemRecord = RPGManager.GetItemRecord(EquipmentSystem.GetData(player).GetActiveItem(gamedataEquipmentArea.Splinter));
		if IsDefined(itemRecord) {
		  itemRecord.ObjectActions(actions);
		  i = 0;
		  while i < ArraySize(actions) {
			if Equals(actions[i].ObjectActionType().Type(), gamedataObjectActionType.DeviceQuickHack) || Equals(actions[i].ObjectActionType().Type(), gamedataObjectActionType.PuppetQuickHack) {
			  quickhackData = quickhackDataEmpty;
			  quickhackData.actionRecord = actions[i];
			  ArrayPush(quickhackDataArray, quickhackData);
			};
			i += 1;
		  };
		};
	
		myint+=1;
	}
    RPGManager.RemoveDuplicatedHacks(quickhackDataArray);
    PlayerPuppet.ChacheQuickHackList(player, quickhackDataArray);
    return quickhackDataArray;
}

@wrapMethod(AIActionTransactionSystem)
public final static func CalculateEquipmentItems(
  const puppet: wref<ScriptedPuppet>,
  equipmentGroupRecord: wref<NPCEquipmentGroup_Record>,
  out items: [wref<NPCEquipmentItem_Record>],
  powerLevel: Int32
) -> Void {
  if !IsDefined(equipmentGroupRecord) || !IsDefined(puppet) {
    wrappedMethod(puppet, equipmentGroupRecord, items, powerLevel);
    return;
  };

  let id: EntityID = puppet.GetEntityID();
  let bitsMask: Uint64 = Cast<Uint64>(4294967295u);
  let seed: Uint32 = EntityID.GetHash(id);
  let groupID: Uint32 = Cast<Uint32>(TDBID.ToNumber(equipmentGroupRecord.GetID()) & bitsMask);
  seed = seed ^ groupID;
  if powerLevel < 0 {
    let statSys: ref<StatsSystem> = GameInstance.GetStatsSystem(puppet.GetGame());
    powerLevel = Cast<Int32>(statSys.GetStatValue(Cast<StatsObjectID>(puppet.GetEntityID()), gamedataStatType.PowerLevel));
  };

  let i: Int32 = 0;
  let itemsCount: Int32 = equipmentGroupRecord.GetEquipmentItemsCount();
  while i < itemsCount {
    let entry: wref<NPCEquipmentGroupEntry_Record> = equipmentGroupRecord.GetEquipmentItemsItem(i);
    let asItem: wref<NPCEquipmentItem_Record> = entry as NPCEquipmentItem_Record;
    if IsDefined(asItem) {
      ArrayPush(items, asItem);
    } else {
      let pool: wref<NPCEquipmentItemPool_Record> = entry as NPCEquipmentItemPool_Record;
      let poolSize: Int32 = pool.GetPoolCount();
      let j: Int32 = 0;
      let hasDCO: Bool = false;
      while j < poolSize {
        let tmp: wref<NPCEquipmentItemsPoolEntry_Record> = pool.GetPoolItem(j);
        if tmp.Weight() == 69420.00 {
          hasDCO = true;
          break;
        };
        j += 1;
      };

      if hasDCO {
        let player: wref<PlayerPuppet> = GameInstance.GetPlayerSystem(puppet.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
        let ssys: ref<StatsSystem> = GameInstance.GetStatsSystem(puppet.GetGame());
        let canCatchUp: Float = IsDefined(player) ? ssys.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCatchUp) : 0.00;
        let pickIdx: Int32 = (canCatchUp == 1.00) ? 1 : 0;
        let chosen: [wref<NPCEquipmentItem_Record>];
        pool.GetPoolItem(pickIdx).Items(chosen);
        let k: Int32 = 0;
        while k < ArraySize(chosen) {
          ArrayPush(items, chosen[k]);
          k += 1;
        };
      } else {
        seed += 1u;
        AIActionTransactionSystem.ChooseSingleItemsSetFromPool(powerLevel, seed, pool, items);
      };
    };
    i += 1;
  };
}

@wrapMethod(InventoryDataManagerV2)
public final func GetAttachmentSlotsForInventory() -> array<TweakDBID> {
  let slots: array<TweakDBID> = wrappedMethod();
  ArrayPush(slots, TDBID.Create("AttachmentSlots.BotCpuSlot1"));
  ArrayPush(slots, TDBID.Create("AttachmentSlots.BotCpuSlot2"));
  ArrayPush(slots, TDBID.Create("AttachmentSlots.BotCpuSlot3"));
  return slots;
}

@wrapMethod(PingSquadEffector)
protected func MarkSquad(mark: Bool, root: wref<GameObject>) -> Void {
  if mark && this.m_quickhackLevel == 69.00 {
    let list: array<wref<Entity>>;
    GameInstance.GetCompanionSystem(this.m_owner.GetGame()).GetSpawnedEntities(list);
    let i: Int32 = 0;
    while i < ArraySize(list) {
      let sp: wref<ScriptedPuppet> = list[i] as ScriptedPuppet;
      if IsDefined(sp) && TweakDBInterface.GetCharacterRecord(sp.GetRecordID()).TagsContains(n"Robot") && !sp.IsDead() && !StatusEffectSystem.ObjectHasStatusEffect(sp, TDBID.Create("DCO.DroneCloakSE")) {
        StatusEffectHelper.ApplyStatusEffect(sp, TDBID.Create("DCO.DroneCloakSESpread"));
      };
      i += 1;
    };
    return;
  };

  if mark && this.m_quickhackLevel == 70.00 {
    let list: array<wref<Entity>>;
    GameInstance.GetCompanionSystem(this.m_owner.GetGame()).GetSpawnedEntities(list);
    let i: Int32 = 0;
    while i < ArraySize(list) {
      let sp: wref<ScriptedPuppet> = list[i] as ScriptedPuppet;
      if IsDefined(sp) && TweakDBInterface.GetCharacterRecord(sp.GetRecordID()).TagsContains(n"Robot") && !sp.IsDead() && !StatusEffectSystem.ObjectHasStatusEffect(sp, TDBID.Create("DCO.OverdriveSE")) {
        StatusEffectHelper.ApplyStatusEffect(sp, TDBID.Create("DCO.OverdriveSESpread"));
      };
      i += 1;
    };
    return;
  };

  if mark && this.m_quickhackLevel == 71.00 {
    let list: array<wref<Entity>>;
    GameInstance.GetCompanionSystem(this.m_owner.GetGame()).GetSpawnedEntities(list);
    let i: Int32 = 0;
    while i < ArraySize(list) {
      let sp: wref<ScriptedPuppet> = list[i] as ScriptedPuppet;
      if IsDefined(sp) && TweakDBInterface.GetCharacterRecord(sp.GetRecordID()).TagsContains(n"Robot") && !sp.IsDead() && Equals(sp.GetNPCType(), gamedataNPCType.Android) && !StatusEffectSystem.ObjectHasStatusEffect(sp, TDBID.Create("DCO.AndroidKerenzikovSE")) {
        StatusEffectHelper.ApplyStatusEffect(sp, TDBID.Create("DCO.AndroidKerenzikovSESpread"));
      };
      i += 1;
    };
    return;
  };

  wrappedMethod(mark, root);
}

@wrapMethod(CraftingSystem)
public final const func GetItemCraftingCost(record: wref<Item_Record>, craftingData: script_ref<array<wref<RecipeElement_Record>>>) -> array<IngredientData> {
  let base: array<IngredientData> = wrappedMethod(record, craftingData);
  let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
  let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
  if !IsDefined(player) { return base; }
  let hasStat: Bool = stats.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.NPCUnequipItemDuration) == 1.00;
  if !hasStat { return base; }
  let recID: TweakDBID = record.GetID();
  let half: Bool = false;
  let names: array<CName> = [n"OctantArasaka", n"OctantMilitech", n"GriffinArasaka", n"GriffinMilitech", n"DragonflyArasaka", n"DragonflyMilitech", n"RavenArasaka", n"RavenMilitech", n"KestrelArasaka", n"KestrelMilitech", n"WaspArasaka", n"WaspMilitech", n"RoachArasaka", n"RoachMilitech", n"AndroidLight", n"AndroidShotgunner", n"AndroidHeavy", n"AndroidSniper", n"AndroidNetrunner"];
  let i: Int32 = 0;
  while i < ArraySize(names) {
    if Equals(recID, TDBID.Create("DCO.Tier1" + NameToString(names[i]) + "Item")) { half = true; break; }
    i += 1;
  };
  if !half { return base; }
  i = 0;
  while i < ArraySize(base) {
    if Equals(base[i].id.GetID(), TDBID.Create("DCO.DroneCore")) {
      let q: Int32 = base[i].quantity;
      let bq: Int32 = base[i].baseQuantity;
      base[i].quantity = q - (bq / 2);
      break;
    };
    i += 1;
  };
  return base;
}
