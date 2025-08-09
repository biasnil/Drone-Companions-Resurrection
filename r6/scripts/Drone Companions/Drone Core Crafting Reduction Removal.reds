// Drone Core Crafting Reduction Removal — CP2077 v2.3 compatible
@wrapMethod(CraftingSystem)
public final const func GetItemCraftingCost(
  record: wref<Item_Record>,
  craftingData: script_ref<array<wref<RecipeElement_Record>>>
) -> array<IngredientData> {
  let ingredients: array<IngredientData> = wrappedMethod(record, craftingData);

  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
  let tempStat: Float = statsSystem.GetStatValue(
    Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()),
    gamedataStatType.CraftingCostReduction
  );

  if tempStat > 0.00 {
    let i: Int32 = 0;
    while i < ArraySize(ingredients) {
      if ingredients[i].quantity > 1 && Equals(ingredients[i].id.GetID(), t"DCO.DroneCore") {
        let q: Float = Cast<Float>(ingredients[i].quantity);
        let denom: Float = MaxF(0.01, 1.00 - tempStat);
        let baseQ: Int32 = CeilF(q / denom);
        ingredients[i].quantity = baseQ;
      };
      i += 1;
    };
  };

  return ingredients;
}
