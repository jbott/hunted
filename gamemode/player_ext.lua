-- server extensions to player table
local plymeta = FindMetaTable("Player")
if not plymeta then return end

local inventoryTable = {}

function plymeta:GetInventory()
	inventoryTable[self:SteamID()] = inventoryTable[self:SteamID()] or {}
	return inventoryTable[self:SteamID()]
end

function plymeta:InventoryAdd(item)
	inventoryTable[self:SteamID()] = inventoryTable[self:SteamID()] or {}
	table.insert(inventoryTable[self:SteamID()], item)
end

function plymeta:InventoryRemove(id)
	inventoryTable[self:SteamID()] = inventoryTable[self:SteamID()] or {}
	table.remove(inventoryTable[self:SteamID()], id)
end

function plymeta:InventoryHasItem(item)
	inventoryTable[self:SteamID()] = inventoryTable[self:SteamID()] or {}
	return table.HasValue(inventoryTable[self:SteamID()], item)
end