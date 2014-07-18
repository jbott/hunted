util.AddNetworkString("InventoryOpen")
util.AddNetworkString("InventoryOpenResponse")
util.AddNetworkString("InventoryClosed")
util.AddNetworkString("InventoryForceClose")
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
	return invPlayer[ply:SteamID()].type or INVENTORY_TYPE_PLAYER
end

function setInventoryEntity(ply, entity)
	invPlayer[ply:SteamID()].entity = entity
end

function getInventoryEntity(ply)
	return invPlayer[ply:SteamID()].entity or nil
end

function HandleInventoryOpen(len, ply)
	setInventoryType(ply, INVENTORY_TYPE_PLAYER)
	ply:UpdateInventory()
	net.Start("InventoryOpenResponse")
		net.WriteInt(getInventoryType(ply), 3)
	net.Send(ply)
end
net.Receive("InventoryOpen", HandleInventoryOpen)

function HandleInventoryClosed(len, ply)
	setInventoryType(ply, INVENTORY_TYPE_PLAYER)
end
net.Receive("InventoryClosed", HandleInventoryClosed)

function invUse(ply, key)
	if (key == IN_USE) then
		local trace = ply:GetEyeTrace()
		if (!trace.Hit or trace.StartPos:Distance(trace.HitPos) > 75) then return true end

		local ent = ply:GetEyeTrace().Entity

		-- No touching other player's inventories
		if (ent:IsPlayer()) then return true end

		if (ent:IsWeapon() && !ply:HasWeapon(ent:GetClass())) then
			local class = ent:GetClass()
			-- Pickup weapons
			ply:InventoryAdd(class)
			if (ent.clip1) then
				ply:GetWeapon(class):SetClip1(ent.clip1)
			end
			if (ent.clip2) then
				ply:GetWeapon(class):SetClip2(ent.clip2)
			end
			ent:Remove()
			--ply:PickupObject(ent)
			return false
		end

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

function invDeath(victim, inflictor, attacker)
	victim:UpdateInventory()
	net.Start("InventoryForceClose")
	net.Send(victim)
end
hook.Add("PlayerDeath", "InventoryDeathHook", invDeath)

function populateList(ply, id)
	local inv = {}

	if (id == INVENTORY_SIDE_RIGHT) then
		inv.name = "Player"
		inv.data = ply:GetInventory()
		inv.max = ply:InventoryMax()
		inv.weight = ply:InventoryWeight()
		inv.action = "Drop"
		inv.actionMessage = "InventoryActionDropItem"
		if (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
			inv.filterType = getInventoryEntity(ply):InventoryFilter()
		elseif (getInventoryType(ply) == INVENTORY_TYPE_SPAWN or
				getInventoryType(ply) == INVENTORY_TYPE_PLAYER) then
			inv.filterType = INVENTORY_CAT_NONE
		end
	else
		if (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
			local ent = getInventoryEntity(ply)
			inv.name = ent:GetName()
			if (inv.name == "") then
				inv.name = ent:GetClass()
			end
			inv.data = ent:GetInventory()
			inv.max = ent:InventoryMax()
			inv.weight = ent:InventoryWeight()
		elseif (getInventoryType(ply) == INVENTORY_TYPE_SPAWN) then
			inv.name = "Spawn"
			inv.data = INVENTORY.GetAllItems()
			inv.max = 0
		end
		inv.action = "Take"
		inv.actionMessage = "InventoryActionTakeItem"
		inv.filterType = INVENTORY_CAT_NONE
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
		if (ent:InventoryMax() == 0) then
			-- Infinite inventory
			ply:InventoryAdd(item)
		else
			ply:InventoryTake(ent, id)
		end
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
	elseif (getInventoryType(ply) == INVENTORY_TYPE_PLAYER) then
		ply:InventoryRemove(id, true)
	elseif (getInventoryType(ply) == INVENTORY_TYPE_ENTITY) then
		local ent = getInventoryEntity(ply)
		if (ent:InventoryMax() == 0) then
			-- Infinite inventory
			ply:InventoryRemove(id)
		else
			ent:InventoryTake(ply, id)
		end
	end

	if (getInventoryType(ply) != INVENTORY_TYPE_PLAYER) then
		populateList(ply, INVENTORY_SIDE_LEFT)
	end
	populateList(ply, INVENTORY_SIDE_RIGHT)
end
net.Receive("InventoryActionDropItem", HandleInventoryActionDropItem)