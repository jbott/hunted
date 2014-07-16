util.AddNetworkString("InventoryOpen")
util.AddNetworkString("InventorySendClient")
util.AddNetworkString("InventoryTakeItem")
util.AddNetworkString("InventoryDropItem")
util.AddNetworkString("InventoryPopulatePlayer")
util.AddNetworkString("InventoryPopulatePlayerClient")
util.AddNetworkString("InventoryPopulateOther")
util.AddNetworkString("InventoryPopulateOtherClient")

function getPlayerBySteamID(plyID)
	if (game.SinglePlayer()) then
		return player.GetByID(1)
	else
		for _,pl in pairs(player.GetHumans()) do
			if (pl:SteamID() == plyID) then
				return pl
			end
		end
	end
	return nil
end

function HandleInventoryOpen()
	local ply = getPlayerBySteamID(net.ReadString())
	if ply == nil then return end

	net.Start("InventorySendClient")
		net.WriteInt(INVENTORY_TYPE_SPAWN, 3) -- Inventory type
	net.Send(ply)
end
net.Receive("InventoryOpen", HandleInventoryOpen)

function HandleInventoryPopulatePlayer()
	local ply = getPlayerBySteamID(net.ReadString())
	if ply == nil then return end

	net.Start("InventoryPopulatePlayerClient")
		net.WriteTable(ply:GetInventory())
	net.Send(ply)
end
net.Receive("InventoryPopulatePlayer", HandleInventoryPopulatePlayer)

function HandleInventoryPopulateOther()
	local ply = getPlayerBySteamID(net.ReadString())
	if ply == nil then return end

	net.Start("InventoryPopulateOtherClient")
		net.WriteTable(INVENTORY.GetAllItems())
	net.Send(ply)
end
net.Receive("InventoryPopulateOther", HandleInventoryPopulateOther)

function HandleInventoryTakeItem()
	local ply = getPlayerBySteamID(net.ReadString())
	if ply == nil then return end

	local item = net.ReadString()
	ply:InventoryAdd(item)

	net.Start("InventoryPopulatePlayerClient")
		net.WriteTable(ply:GetInventory()) -- Inventory type
	net.Send(ply)
	net.Start("InventoryPopulateOtherClient")
		net.WriteTable(INVENTORY.GetAllItems())
	net.Send(ply)
end
net.Receive("InventoryTakeItem", HandleInventoryTakeItem)

function HandleInventoryDropItem()
	local ply = getPlayerBySteamID(net.ReadString())
	if ply == nil then return end

	local id = net.ReadString()
	ply:InventoryRemove(tonumber(id))

	net.Start("InventoryPopulatePlayerClient")
		net.WriteTable(ply:GetInventory()) -- Inventory type
	net.Send(ply)
	net.Start("InventoryPopulateOtherClient")
		net.WriteTable(INVENTORY.GetAllItems())
	net.Send(ply)
end
net.Receive("InventoryDropItem", HandleInventoryDropItem)