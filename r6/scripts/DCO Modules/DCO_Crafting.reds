@wrapMethod(CraftingDataView)
public func FilterItem(item: ref<IScriptable>) -> Bool {
  let ok = wrappedMethod(item);
  if ok { return true; }

  let itemRecord: ref<Item_Record>;
  let itemData: ref<ItemCraftingData> = item as ItemCraftingData;
  let recipeData: ref<RecipeData> = item as RecipeData;

  if IsDefined(itemData) {
    itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(itemData.inventoryItem)));
  } else if IsDefined(recipeData) {
    itemRecord = recipeData.id;
  };
  if !IsDefined(itemRecord) { return ok; };

  switch this.m_itemFilterType {
    case ItemFilterCategory.RangedWeapons:
      if itemRecord.TagsContains(WeaponObject.GetRangedWeaponTag()) { return true; };
      break;
    case ItemFilterCategory.MeleeWeapons:
      if itemRecord.TagsContains(WeaponObject.GetMeleeWeaponTag()) { return true; };
      break;
    case ItemFilterCategory.Clothes:
      if itemRecord.TagsContains(n"Clothing") { return true; };
      break;
    case ItemFilterCategory.Consumables:
      if itemRecord.TagsContains(n"Consumable") || itemRecord.TagsContains(n"Ammo") { return true; };
      break;
    case ItemFilterCategory.Grenades:
      if itemRecord.TagsContains(n"Grenade") { return true; };
      break;
    case ItemFilterCategory.Attachments:
      if itemRecord.TagsContains(n"itemPart") && !itemRecord.TagsContains(n"SoftwareShard") { return true; };
      break;
    case ItemFilterCategory.Programs:
      if itemRecord.TagsContains(n"SoftwareShard") { return true; };
      break;
    case ItemFilterCategory.Cyberware:
      if itemRecord.TagsContains(n"Robot") { return true; };
      break;
    case ItemFilterCategory.AllItems:
      return ok;
  };
  return ok;
}

@wrapMethod(ItemCategoryFliter)
public final static func IsOfCategoryType(filter: ItemFilterCategory, data: wref<gameItemData>) -> Bool {
  let ok = wrappedMethod(filter, data);
  if ok { return true; };
  if !IsDefined(data) { return false; };

  switch filter {
    case ItemFilterCategory.RangedWeapons:
      return data.HasTag(WeaponObject.GetRangedWeaponTag());
    case ItemFilterCategory.MeleeWeapons:
      return data.HasTag(WeaponObject.GetMeleeWeaponTag());
    case ItemFilterCategory.Clothes:
      return data.HasTag(n"Clothing");
    case ItemFilterCategory.Consumables:
      return data.HasTag(n"Consumable") || data.HasTag(n"Ammo");
    case ItemFilterCategory.Grenades:
      return data.HasTag(n"Grenade");
    case ItemFilterCategory.Attachments:
      return data.HasTag(n"itemPart") && !data.HasTag(n"SoftwareShard");
    case ItemFilterCategory.Programs:
      return data.HasTag(n"SoftwareShard");
    case ItemFilterCategory.Cyberware:
      return data.HasTag(n"Robot");
    case ItemFilterCategory.Quest:
      return data.HasTag(n"Quest");
    case ItemFilterCategory.Junk:
      return data.HasTag(n"Junk");
    case ItemFilterCategory.AllItems:
      return ok;
  };
  return false;
}

@wrapMethod(CraftingSystem)
public final const func GetItemCraftingCost(record: wref<Item_Record>, const craftingData: script_ref<[wref<RecipeElement_Record>]>) -> [IngredientData] {
  let original: array<IngredientData>;
  let i: Int32 = 0;
  while i < ArraySize(Deref(craftingData)) {
    ArrayPush(original, this.CreateIngredientData(Deref(craftingData)[i]));
    i += 1;
  };

  let result: [IngredientData] = wrappedMethod(record, craftingData);

  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
  let tempStat: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.CraftingCostReduction);
  if tempStat > 0.00 {
    i = 0;
    while i < ArraySize(result) {
      if result[i].quantity > 0 && IsDefined(result[i].id) && (Equals(result[i].id.GetID(), t"DCO.DroneCore") || result[i].id.TagsContains(n"DroneCore")) {
        let j: Int32 = 0;
        while j < ArraySize(original) {
          if IsDefined(original[j].id) && Equals(original[j].id.GetID(), result[i].id.GetID()) {
            let diff: Int32 = original[j].quantity - result[i].quantity;
            if diff > 0 { result[i].quantity += diff; };
            break;
          };
          j += 1;
        };
      };
      i += 1;
    };
  };
  return result;
}

private func DCO_IsDcoPlan(record: wref<Item_Record>) -> Bool {
  return IsDefined(record) && (record.TagsContains(n"Robot") || record.TagsContains(n"DCOPlan") || record.TagsContains(n"DCOBlueprint"));
}

private func DCO_CountAliveBots(game: GameInstance) -> Int32 {
  let count: Int32 = 0;
  let spawned: array<wref<Entity>>;
  let cs = GameInstance.GetCompanionSystem(game);
  if IsDefined(cs) {
    cs.GetSpawnedEntities(spawned);
  }
  let i: Int32 = 0;
  while i < ArraySize(spawned) {
    let go: wref<GameObject> = spawned[i] as GameObject;
    let sp: wref<ScriptedPuppet> = go as ScriptedPuppet;
    if IsDefined(sp) {
      let rec = TweakDBInterface.GetCharacterRecord(sp.GetRecordID());
      if IsDefined(rec) && rec.TagsContains(n"Robot") && !sp.IsDead() {
        count += 1;
      }
    }
    i += 1;
  }
  return count;
}
