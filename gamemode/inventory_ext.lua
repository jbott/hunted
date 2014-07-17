-- Inventory extensions
local entmeta = FindMetaTable("Entity")
if not entmeta then return end

local hasInventory = {}
local maxInventory = {}
local filterInventory = {}
local inventoryTable = {}

function entmeta:SetHasInventory(val)
	if val then
		hasInventory[self:EntIndex()] = true
		inventoryTable[self:EntIndex()] = {}
	else
		hasInventory[self:EntIndex()] = false
		table.remove(hasInventory, self:EntIndex())
	end
end

function entmeta:HasInventory()
	return hasInventory[self:EntIndex()] or false
end

function entmeta:GetInventory()
	if (!self:HasInventory()) then return {} end
	return inventoryTable[self:EntIndex()]
end

function entmeta:SetInventoryMax(max)
	if (!self:HasInventory()) then return end
	maxInventory[self:EntIndex()] = max
end

function entmeta:InventoryMax()
	if (!self:HasInventory()) then return 0 end
	return maxInventory[self:EntIndex()] or 0
end

function entmeta:SetInventoryFilter(type)
	if (!self:HasInventory()) then return end
	filterInventory[self:EntIndex()] = type
end

function entmeta:InventoryFilter()
	if (!self:HasInventory()) then return 0 end
	return filterInventory[self:EntIndex()] or INVENTORY_CAT_NONE
end

function entmeta:InventoryWeight()
	if (!self:HasInventory()) then return 0 end
	local weight = 0
	for _,item in pairs(self:GetInventory()) do
		weight = weight + INVENTORY.GetItemData(item).weight
	end
	return weight
end

function entmeta:InventoryAdd(item)
	if (!self:HasInventory()) then return end
	if (self:InventoryMax() == 0 or
		self:InventoryWeight() + INVENTORY.GetItemData(item).weight <= self:InventoryMax()) then
		table.insert(inventoryTable[self:EntIndex()], item)
	end
end

function entmeta:InventoryRemove(id)
	if (!self:HasInventory()) then return end
	table.remove(inventoryTable[self:EntIndex()], id)
end

function entmeta:InventoryHasItem(item)
	if (!self:HasInventory()) then return false end
	return table.HasValue(inventoryTable[self:EntIndex()], item)
end

function entmeta:InventoryTake(ent, id)
	if (!self:HasInventory()) then return end
	if (!ent:HasInventory()) then return end
	local item = ent:GetInventory()[id]
	if (self:InventoryWeight() + INVENTORY.GetItemData(item).weight <= self:InventoryMax()) then
		ent:InventoryRemove(id)
		self:InventoryAdd(item)
	end
end