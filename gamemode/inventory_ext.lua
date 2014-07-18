-- Inventory extensions
local entmeta = FindMetaTable("Entity")
if not entmeta then return end

function entmeta:SetHasInventory(val)
	if val then
		self.Inventory = {}
	else
		self.Inventory = nil
	end
end

function entmeta:HasInventory()
	return self.Inventory != nil
end

function entmeta:GetInventory()
	if (!self:HasInventory()) then return {} end
	return self.Inventory or nil
end

function entmeta:SetInventoryMax(max)
	if (!self:HasInventory()) then return end
	self.MaxWeight = max
end

function entmeta:InventoryMax()
	if (!self:HasInventory()) then return 0 end
	return self.MaxWeight or 0
end

function entmeta:SetInventoryFilter(type)
	if (!self:HasInventory()) then return end
	self.InvFilter = type
end

function entmeta:InventoryFilter()
	if (!self:HasInventory()) then return 0 end
	return self.InvFilter or INVENTORY_CAT_NONE
end

function entmeta:InventoryWeight()
	if (!self:HasInventory()) then return 0 end
	local weight = 0
	for _,item in pairs(self:GetInventory()) do
		weight = weight + INVENTORY.GetItemData(item.name).weight
	end
	return weight
end

function entmeta:InventoryAdd(item, extraData)
	if (!self:HasInventory()) then return end
	local extraData = extraData or {}
	if (self:InventoryMax() == 0 or
		(self:InventoryWeight() + INVENTORY.GetItemData(item).weight <= self:InventoryMax() and
		(INVENTORY.GetItemData(item).max == 0 or self:InventoryCount(item) < INVENTORY.GetItemData(item).max))) then

		local itemData = { name = item }
		table.Merge(itemData, extraData)

		if (self:IsPlayer()) then
			-- Reflect on player
			if (INVENTORY.GetItemData(item).category == INVENTORY_CAT_PRIMARY or
				INVENTORY.GetItemData(item).category == INVENTORY_CAT_SECONDARY or
				INVENTORY.GetItemData(item).category == INVENTORY_CAT_MISC) then
				-- Weapon
				self:Give(item)
				if (itemData.clip1) then
					self:GetWeapon(item):SetClip1(itemData.clip1)
				end
				if (itemData.clip2) then
					self:GetWeapon(item):SetClip2(itemData.clip2)
				end
			elseif (INVENTORY.GetItemData(item).category == INVENTORY_CAT_AMMO) then
				itemData.ammoquantity = itemData.ammoquantity or INVENTORY.GetItemData(item).ammoquantity
				itemData.ammoname = INVENTORY.GetItemData(item).ammoname
				self:GiveAmmo(itemData.ammoquantity, itemData.ammoname, true)
			end
		end
		table.insert(self:GetInventory(), itemData)
	end
	self:UpdateInventory()
end

function entmeta:InventoryRemove(id, drop)
	local drop = drop or false
	if (!self:HasInventory()) then return end
	self:UpdateInventory()
	local item = self:GetInventory()[id]
	table.remove(self:GetInventory(), id)
	if (self:IsPlayer()) then
		-- Reflect on player
		if (INVENTORY.GetItemData(item.name).category == INVENTORY_CAT_PRIMARY or
			INVENTORY.GetItemData(item.name).category == INVENTORY_CAT_SECONDARY or
			INVENTORY.GetItemData(item.name).category == INVENTORY_CAT_MISC) then
			local weapon = self:GetWeapon(item.name)

			-- Weapon
			if (drop) then
				local weapon = self:GetWeapon(item.name)
				weapon.isDropped = true
				if (item.clip1 != -1) then
					weapon.clip1 = item.clip1
				end
				if (item.clip2 != -1) then
					weapon.clip2 = item.clip2
				end
				if (weapon.PreDrop) then
					weapon:PreDrop()
				end
				self:DropNamedWeapon(item.name)
			else
				if (weapon.PreDrop) then
					weapon:PreDrop()
				end
				self:StripWeapon(item.name)
			end
		elseif (INVENTORY.GetItemData(item.name).category == INVENTORY_CAT_AMMO) then
			self:RemoveAmmo(item.ammoquantity, item.ammoname)
		end
	end
	return item
end

function entmeta:InventoryHasItem(item)
	if (!self:HasInventory()) then return false end
	for _,v in pairs(self:GetInventory()) do
		if (v.name == item) then
			return true
		end
	end
	return false
end

function entmeta:InventoryGetItem(item)
	if (!self:HasInventory()) then return false end
	for _,v in pairs(self:GetInventory()) do
		if (v.name == item) then
			return v
		end
	end
	return nil
end

function entmeta:InventoryCount(item)
	if (!self:HasInventory()) then return false end
	local count = 0
	for _,v in pairs(self:GetInventory()) do
		if (v.name == item) then
			count = count + 1
		end
	end
	return count
end

function entmeta:InventoryTake(ent, id)
	if (!self:HasInventory()) then return end
	if (!ent:HasInventory()) then return end
	local item = ent:GetInventory()[id]
	if (self:InventoryWeight() + INVENTORY.GetItemData(item.name).weight <= self:InventoryMax()) then
		item = ent:InventoryRemove(id) -- Allow for last minute updates to be applied to the data
		self:InventoryAdd(item.name, item)
	end
end

function entmeta:UpdateInventory()
	if (!self:IsPlayer()) then return end
	-- Loop over weapons updating current clip
	for _,wep in pairs(self:GetWeapons()) do
		local item = self:InventoryGetItem(wep:GetClass())
		if (item != nil) then
			if (wep.Clip1) then
				item.clip1 = wep:Clip1()
			else
				item.clip1 = -1
			end
			if (wep.Clip2) then
				item.clip2 = wep:Clip2()
			else
				item.clip2 = -1
			end
		end
	end

	self:UpdateInvAmmo()
end

function entmeta:UpdateInvAmmo()
	if (!self:IsPlayer()) then return end
	local ammoTotals = {}
	for _,item in pairs(self:GetInventory()) do
		if (INVENTORY.GetItemData(item.name).category == INVENTORY_CAT_AMMO) then
			ammoTotals[item.ammoname] = (ammoTotals[item.ammoname] or 0) + item.ammoquantity
		end
	end

	for item,count in pairs(ammoTotals) do
		local diff = self:GetAmmoCount(item) - count
	if (diff > 0) then
			print("ERROR: More ammo than in inventory!")
			return
		end
		if (diff < 0) then
			self:InventoryRemoveAmmo(item, diff)
		end
	end
end

function entmeta:InventoryRemoveAmmo(type, diff)
	if (!self:IsPlayer()) then return end
	while (diff < 0) do
		local leastAmount = 10000
		for _,item in pairs(self:GetInventory()) do
			if (item.ammoname == type && item.ammoquantity < leastAmount) then
				leastAmount = item.ammoquantity
			end
		end

		for k,item in pairs(self:GetInventory()) do
			if (item.ammoname == type && item.ammoquantity == leastAmount) then
				local sub = math.min(item.ammoquantity, -diff)
				item.ammoquantity = item.ammoquantity - sub
				diff = diff + sub
				if (item.ammoquantity == 0) then
					table.remove(self:GetInventory(), k)
				else
					self:GetInventory()[k].ammoquantity = item.ammoquantity
				end
				break
			end
		end
	end
end