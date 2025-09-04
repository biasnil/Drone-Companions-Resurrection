SDO = { description = "SDO" }

local function extractBracedText(s)
  if type(s) ~= "string" then return nil end
  local first
  for chunk in string.gmatch(s, "%b{}") do first = chunk; break end
  return first and string.sub(first, 2, #first - 1) or nil
end

local function safeLoc(key, fallback)
  local ok, txt = pcall(GetLocalizedText, key)
  if ok and type(txt) == "string" and #txt > 0 then return txt end
  return fallback or ""
end

function SDO:new()
  Override('UIItemsHelper', 'GetItemName;Item_RecordgameItemData',
  function(itemRecord, itemData, wrapped)
    if not itemRecord then
      return wrapped(itemRecord, itemData)
    end

    local localizedName = itemRecord:LocalizedName()
    if type(localizedName) ~= "string" or string.sub(localizedName, 1, 3) ~= "yyy" then
      return wrapped(itemRecord, itemData)
    end

    local desc = extractBracedText(localizedName)
    if not desc then
      return wrapped(itemRecord, itemData)
    end

    if itemData and itemData:HasTag(CName.new("Recipe")) then
      local prefix = safeLoc("Gameplay-Crafting-GenericRecipe", "Recipe: ")
      return tostring(prefix) .. desc
    end

    return desc
  end)

  Override('CraftingSystem', 'GetRecipeData',
  function(self, itemRecord, wrapped)
    local recipe = wrapped(itemRecord)
    local locName = itemRecord and itemRecord:LocalizedName() or nil

    if type(locName) == "string" and string.sub(locName, 1, 3) == "yyy" then
      local desc = extractBracedText(locName)
      if desc then recipe.label = desc end
    end

    return recipe
  end)

	Override('ItemTooltipCommonController', 'UpdateLayout', function(self, wrapped)
	  wrapped()

	  if not self or not self.data then return end

	  local isMarker =
	    self.data.description == ToCName{ hash_lo = 0xDEEA321B, hash_hi = 0x266B9698 }

	  if not isMarker then return end

	  local tdb = self.data.itemTweakID
	  if not tdb then return end

	  local rec = TweakDBInterface.GetItemRecord(tdb)
	  if not rec then return end

	  local locName = rec:LocalizedName()
	  local first
	  for chunk in string.gmatch(type(locName)=="string" and locName or "", "%b{}") do first = chunk; break end
	  if not first then return end
	  local desc = string.sub(first, 2, #first - 1)

	  if self.descriptionWrapper then inkWidgetRef.SetVisible(self.descriptionWrapper, true) end
	  if self.descriptionText then inkTextRef.SetText(self.descriptionText, desc) end
	  if self.backgroundContainer then
	    inkWidgetRef.SetVisible(self.backgroundContainer,
	      self.data.displayContext ~= InventoryTooltipDisplayContext.Crafting)
	  end
	end)

end

return SDO:new()