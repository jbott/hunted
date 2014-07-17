util.AddNetworkString("InventoryOpen")
util.AddNetworkString("InventoryOpenResponse")
util.AddNetworkString("InventoryPopulateList")
util.AddNetworkString("InventoryPopulateListResponse")
util.AddNetworkString("InventoryActionTakeItem")
util.AddNetworkString("InventoryActionDropItem")

local invPlayer = {}

function setInventoryType(ply, type)
	invPlayer[ply:SteamID()] = {}
	invPlayer[ply:SteamID()].type = type
end

function getInventoryType(ply)
	return invPlayer[ply:SteamID()].type or INVENTORY_TYPE_SPAWN
end

function setInventoryEntity(ply, entity)
	invPlayer[ply:SteamID()].entity = entity
end

function getInventoryEntity(ply)
	return invPlayer[ply:SteamID()].entity or nil
end

function HandleInventoryOpen(len, ply)
	setInventoryType(ply, INVENTORY_TYPE_SPAWN)
	net.Start("InventoryOpenResponse")
		net.WriteInt(getInventoryType(ply), 3)
	net.Send(ply)
end
net.Receive("InventoryOpen", HandleInventoryOpen)

function invUse(ply, key)
	if (key == IN_USE) then
		local trace = ply:GetEyeTrace()
		if (!trace.Hit or trace.StartPos:Distance(trace.HitPos) > 75) then return true end

		local ent = ply:GetEyeTrace().Entity

		-- No touching other player's inventories
		if (ent:IsPlayer()) then return true end

		if (ent:HasInventory()) then
			setInventoryType(ply, INVENTORY_TYPE_ENTITY)
			setInventoryEntity(ply, ent)

			net.Start("InventoryOpenResponse")
				net.WriteInt(getInventoryType(ply), 3)
			net.Send(ply)
			return false
		end
	end
end
hook.Add("KeyPress", "InventoryUseHook", invUse)

function populateList(ply, id)
	local inv = {}

	if (id == INVENTORY_SIDE_RIGHT) then
		inv.name = "Player"
		inv.data = ply:GetInventory()
		inv.max = ply:InventoryMax()
		inv.action = "Drop"
		inv.actionMessage = "InventoryActionDropItem"
	else
		if (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
			local ent = getInventoryEntity(ply)
			inv.name = ent:GetName()
			if (inv.name == "") then
				inv.name = ent:GetClass()
			end
			inv.data = ent:GetInventory()
			inv.max = ent:InventoryMax()
		elseif (getInventoryType(ply) == INVENTORY_TYPE_SPAWN) then
			inv.name = "Spawn"
			inv.data = INVENTORY.GetAllItems()
			inv.max = 0
		end
		inv.action = "Take"
		inv.actionMessage = "InventoryActionTakeItem"
	end

	net.Start("InventoryPopulateListResponse")
		net.WriteInt(id, 3)
		net.WriteTable(inv)
	net.Send(ply)
end

function HandleInventoryPopulateList(len, ply)
	local id = net.ReadInt(3)
	populateList(ply, id)
end
net.Receive("InventoryPopulateList", HandleInventoryPopulateList)

function HandleInventoryActionTakeItem(len, ply)
	local id = net.ReadInt(16)
	local item = net.ReadString()

	if (getInventoryType(ply) == INVENTORY_TYPE_SPAWN) then
		ply:InventoryAdd(item)
	elseif (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
		local ent = getInventoryEntity(ply)
		ply:InventoryTake(ent, id)
	end

	if (getInventoryType(ply) != INVENTORY_TYPE_PLAYER) then
		populateList(ply, INVENTORY_SIDE_LEFT)
	end

	populateList(ply, INVENTORY_SIDE_RIGHT)
end
net.Receive("InventoryActionTakeItem", HandleInventoryActionTakeItem)

function HandleInventoryActionDropItem(len, ply)
	local id = net.ReadInt(16)
	local item = net.ReadString()

	if (getInventoryType(ply) == INVENTORY_TYPE_SPAWN) then
		ply:InventoryRemove(id)
	elseif (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
		local ent = getInventoryEntity(ply)
		ent:InventoryTake(ply, id)
	end

	if (getInventoryType(ply) != INVENTORY_TYPE_PLAYER) then
		populateList(ply, INVENTORY_SIDE_LEFT)
	end

	populateList(ply, INVENTORY_SIDE_RIGHT)
end
net.Receive("InventoryActionDropItem", HandleInventoryActionDropItem)