@replaceMethod(CraftingDataView)
public func FilterItem(item: ref<IScriptable>) -> Bool {
  let itemRecord: ref<Item_Record>;
  let itemData: ref<ItemCraftingData> = item as ItemCraftingData;
  let recipeData: ref<RecipeData> = item as RecipeData;
  if IsDefined(itemData) {
    itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(itemData.inventoryItem)));
  } else {
    if IsDefined(recipeData) {
      itemRecord = recipeData.id;
    };
  };
  switch this.m_itemFilterType {
    case ItemFilterCategory.RangedWeapons:
      return itemRecord.TagsContains(WeaponObject.GetRangedWeaponTag());
    case ItemFilterCategory.MeleeWeapons:
      return itemRecord.TagsContains(WeaponObject.GetMeleeWeaponTag());
    case ItemFilterCategory.Clothes:
      return itemRecord.TagsContains(n"Clothing");
    case ItemFilterCategory.Consumables:
      return itemRecord.TagsContains(n"Consumable") || itemRecord.TagsContains(n"Ammo");
    case ItemFilterCategory.Grenades:
      return itemRecord.TagsContains(n"Grenade");
    case ItemFilterCategory.Attachments:
      return itemRecord.TagsContains(n"itemPart") && /*!itemRecord.TagsContains(n"Fragment") &&*/ !itemRecord.TagsContains(n"SoftwareShard");
    case ItemFilterCategory.Programs:
      return itemRecord.TagsContains(n"SoftwareShard");
    case ItemFilterCategory.Cyberware:
	return itemRecord.TagsContains(n"Robot");
      //return itemRecord.TagsContains(n"Cyberware") || itemRecord.TagsContains(n"Fragment");
    case ItemFilterCategory.AllItems:
      return true;
  };
  return true;
}
  
@replaceMethod(ItemCategoryFliter)
public final static func IsOfCategoryType(filter: ItemFilterCategory, data: wref<gameItemData>) -> Bool {
  if !IsDefined(data) {
    return false;
  };
  switch filter {
    case ItemFilterCategory.RangedWeapons:
      return data.HasTag(WeaponObject.GetRangedWeaponTag());
    case ItemFilterCategory.MeleeWeapons:
      return data.HasTag(WeaponObject.GetMeleeWeaponTag());
    case ItemFilterCategory.Clothes:
      return data.HasTag(n"Clothing");
    case ItemFilterCategory.Consumables:
      return data.HasTag(n"Consumable");
    case ItemFilterCategory.Grenades:
      return data.HasTag(n"Grenade");
    case ItemFilterCategory.Attachments:
      return data.HasTag(n"itemPart") && /*!data.HasTag(n"Fragment") &&*/ !data.HasTag(n"SoftwareShard");
    case ItemFilterCategory.Programs:
      return data.HasTag(n"SoftwareShard");
    case ItemFilterCategory.Cyberware:
	return data.HasTag(n"Robot");
      //return data.HasTag(n"Cyberware") || data.HasTag(n"Fragment");
    case ItemFilterCategory.Quest:
      return data.HasTag(n"Quest");
    case ItemFilterCategory.Junk:
      return data.HasTag(n"Junk");
    case ItemFilterCategory.AllItems:
      return true;
  };
  return false;
}

@wrapMethod(CraftingSystem)
public final const func GetItemCraftingCost(record: wref<Item_Record>, const craftingData: script_ref<[wref<RecipeElement_Record>]>) -> [IngredientData] {
  let baseIngredients: array<IngredientData>;
  let tempStat: Float;
  let reducedBy: Int32 = 0;
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
  let i: Int32 = 0;
  while i < ArraySize(Deref(craftingData)) {
    ArrayPush(baseIngredients, this.CreateIngredientData(Deref(craftingData)[i]));
    i += 1;
  };
  tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.CraftingCostReduction);
  if tempStat > 0.00 {
    i = 0;
    while i < ArraySize(baseIngredients) {
      if baseIngredients[i].quantity > 1 {
        if Equals(baseIngredients[i].id.GetID(), t"DCO.DroneCore") || (IsDefined(baseIngredients[i].id) && baseIngredients[i].id.TagsContains(n"DroneCore")) {
          reducedBy = baseIngredients[i].quantity - CeilF(Cast<Float>(baseIngredients[i].quantity) * (1.00 - tempStat));
        };
      };
      i += 1;
    };
  };
  baseIngredients = wrappedMethod(record, craftingData);
  if tempStat > 0.00 && reducedBy > 0 {
    i = 0;
    while i < ArraySize(baseIngredients) {
      if baseIngredients[i].quantity > 1 {
        if Equals(baseIngredients[i].id.GetID(), t"DCO.DroneCore") || (IsDefined(baseIngredients[i].id) && baseIngredients[i].id.TagsContains(n"DroneCore")) {
          baseIngredients[i].quantity += reducedBy;
        };
      };
      i += 1;
    };
  };
  return baseIngredients;
}
