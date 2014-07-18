module("INVENTORY", package.seeall)

local items = items or {}

function GetAllItems()
	local ret = {}
	for k,v in pairs(table.GetKeys(items)) do
		table.insert(ret, { name = v })
	end
	return ret
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