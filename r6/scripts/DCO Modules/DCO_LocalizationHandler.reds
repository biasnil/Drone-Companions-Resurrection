module DCO

public abstract class DCO_LocUtil {
  public static func HasPrefix(str: String, prefix: String) -> Bool {
    let pos: Int32 = StrFindFirst(str, prefix);
    return pos == 0;
  }

  public static func ExtractFirstBraced(src: String) -> String {
    let lb: Int32 = StrFindFirst(src, "{");
    if lb < 0 { return ""; }
    let tail: String = StrMid(src, lb + 1, StrLen(src) - (lb + 1));
    let rbRel: Int32 = StrFindFirst(tail, "}");
    if rbRel < 0 { return ""; }
    return StrMid(tail, 0, rbRel);
  }

  public static func SafeLoc(key: String, fallback: String) -> String {
    let txt: String = GetLocalizedText(key);
    if IsStringValid(txt) { return txt; }
    return fallback;
  }

  public static func ProcessNameFromTDB(id: TweakDBID) -> String {
    let raw: String = TweakDBInterface.GetString(id + t".localizedName", "");
    if !IsStringValid(raw) { return ""; }
    if !DCO_LocUtil.HasPrefix(raw, "yyy") { return ""; }
    let k: String = DCO_LocUtil.ExtractFirstBraced(raw);
    if !IsStringValid(k) { return ""; }
    if StrContains(k, "_Name") || StrContains(k, "_String") {
      let v: String = GetLocalizedText(k);
      if IsStringValid(v) { return v; }
    };
    return k;
  }

  public static func ProcessDescString(desc: String) -> String {
    if !IsStringValid(desc) { return ""; }
    if !DCO_LocUtil.HasPrefix(desc, "ymca") { return ""; }
    let k: String = DCO_LocUtil.ExtractFirstBraced(desc);
    if !IsStringValid(k) { return ""; }
    return DCO_LocUtil.SafeLoc(k, k);
  }

  public static func ProcessAnyRecordName(rec: wref<Item_Record>) -> String {
    if !IsDefined(rec) { return ""; }
    let direct: String = DCO_LocUtil.ProcessNameFromTDB(rec.GetID());
    if IsStringValid(direct) { return direct; }
    let recipe: wref<ItemRecipe_Record> = rec as ItemRecipe_Record;
    if IsDefined(recipe) {
      let cr: wref<CraftingResult_Record> = recipe.CraftingResult();
      if IsDefined(cr) {
        let outItem: wref<Item_Record> = cr.Item();
        if IsDefined(outItem) {
          let fromResult: String = DCO_LocUtil.ProcessNameFromTDB(outItem.GetID());
          if IsStringValid(fromResult) { return fromResult; }
        };
      };
    };
    return "";
  }
}

@wrapMethod(UIItemsHelper)
public final static func GetItemName(itemRecord: ref<Item_Record>, itemData: wref<gameItemData>) -> String {
  let custom: String = DCO_LocUtil.ProcessAnyRecordName(itemRecord);
  if IsStringValid(custom) { return custom; }
  return wrappedMethod(itemRecord, itemData);
}

@wrapMethod(UIItemsHelper)
public final static func GetTooltipItemName(itemID: TweakDBID, itemData: wref<gameItemData>, const fallbackName: script_ref<String>) -> String {
  let rec: wref<Item_Record> = TweakDBInterface.GetItemRecord(itemID);
  let custom: String = DCO_LocUtil.ProcessAnyRecordName(rec);
  if IsStringValid(custom) { return custom; }
  return wrappedMethod(itemID, itemData, fallbackName);
}

@wrapMethod(CraftingSystem)
public final const func GetRecipeData(itemRecord: ref<Item_Record>) -> ref<RecipeData> {
  let r: ref<RecipeData> = wrappedMethod(itemRecord);
  if IsDefined(r) && IsDefined(itemRecord) {
    let custom: String = DCO_LocUtil.ProcessAnyRecordName(itemRecord);
    if IsStringValid(custom) { r.label = custom; }
  };
  return r;
}

@wrapMethod(InventorySlotTooltip)
private final func UpdateDescription() -> Void {
  wrappedMethod();
  if !IsDefined(this.m_data) { return; }
  let raw: String = this.m_data.description;
  if IsStringValid(raw) && DCO_LocUtil.HasPrefix(raw, "ymca") {
    let k: String = DCO_LocUtil.ExtractFirstBraced(raw);
    if IsStringValid(k) {
      let txt: String = DCO_LocUtil.SafeLoc(k, k);
      inkTextRef.SetText(this.m_descriptionText, txt);
      inkWidgetRef.SetVisible(this.m_descriptionText, true);
    };
  };
}

@wrapMethod(InventorySlotTooltip)
private final func UpdateLayout() -> Void {
  wrappedMethod();
  if !IsDefined(this.m_data) { return; }
  let id: ItemID = InventoryItemData.GetID(this.m_data.inventoryItemData);
  if ItemID.IsValid(id) {
    let rec: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
    if IsDefined(rec) {
      let custom: String = DCO_LocUtil.ProcessAnyRecordName(rec);
      if IsStringValid(custom) {
        inkTextRef.SetText(this.m_itemName, custom);
      };
    };
  };
}

@wrapMethod(InventoryItemDisplayController)
protected func UpdateItemName() -> Void {
  wrappedMethod();
  let id: ItemID;
  if IsDefined(this.m_tooltipData) && ItemID.IsValid(this.m_tooltipData.itemID) {
    id = this.m_tooltipData.itemID;
  } else {
    let itemInventory: InventoryItemData = this.GetItemData();
    id = InventoryItemData.GetID(itemInventory);
  };
  if ItemID.IsValid(id) {
    let rec: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
    let custom: String = DCO_LocUtil.ProcessAnyRecordName(rec);
    if IsStringValid(custom) {
      inkTextRef.SetText(this.m_itemName, custom);
    };
  };
}

@wrapMethod(InventoryDataManagerV2)
public final func GetItemStatsByData(itemData: wref<gameItemData>, opt compareWithData: wref<gameItemData>) -> ItemViewData {
  let viewData: ItemViewData = wrappedMethod(itemData, compareWithData);
  if ItemID.IsValid(viewData.id) {
    let rec: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(viewData.id));
    if IsDefined(rec) {
      let customName: String = DCO_LocUtil.ProcessAnyRecordName(rec);
      if IsStringValid(customName) {
        viewData.itemName = customName;
      };
      let rawDesc: String = TweakDBInterface.GetString(rec.GetID() + t".localizedDescription", "");
      let customDesc: String = DCO_LocUtil.ProcessDescString(rawDesc);
      if IsStringValid(customDesc) {
        viewData.description = customDesc;
      };
    };
  };
  return viewData;
}

@wrapMethod(ItemTooltipCommonController)
private final func NEW_UpdateLayout() -> Void {
  wrappedMethod();
  if !IsDefined(this.m_itemData) { return; }
  let desc: String = this.m_itemData.GetDescription();
  let custom: String = DCO_LocUtil.ProcessDescString(desc);
  if IsStringValid(custom) {
    inkTextRef.SetText(this.m_descriptionText, custom);
  };
}
