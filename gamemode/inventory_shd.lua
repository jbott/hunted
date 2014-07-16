module("INVENTORY", package.seeall)

local items = items or {}

function GetAllItems()
	return table.GetKeys(items)
end

function GetAllItemsWithData()
	local ret = {}
	for k,v in pairs(items) do
		local data = { name = tostring(k) }
		table.Merge(data, items[tostring(k)])
		table.insert(ret, data)
	end
	return ret
end

function AddItem(item, data)
	if (items[tostring(item)] != nil) then
		print("Error! Item with name already registered")
		return
	end
	items[tostring(item)] = {}
	table.Merge(items[tostring(item)], data)
end

function GetItemData(item)
	if (items[tostring(item)] == nil) then
		return nil
	end

	local data = { name = tostring(item) }
	table.Merge(data, items[tostring(item)])
	
	return data
end

local function addSWEPS()
	for _, weapon in pairs(weapons.GetList()) do
		if (weapon.InvSpawnable) then
			-- Add to items
			AddItem(weapon.ClassName, {
				displayname = weapon.PrintName or weapon.ClassName,
				weight = weapon.InvWeight or 0,
				max = weapon.InvMaxItems or 0,
				restrict = weapon.InvRestrict
			})
		end
	end
end
addSWEPS() -- This handles any code reloads that occur
hook.Add("OnGamemodeLoaded", "inventory_addsweps", addSWEPS)