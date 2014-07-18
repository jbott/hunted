module("INVENTORY", package.seeall)

local items = items or {}

function GetAllItems()
	local ret = {}
	for k,v in pairs(table.GetKeys(items)) do
		table.insert(ret, { name = v })
	end
	return ret
end

function GetAllItemsSortedByCategory()
	local ret = {}
	for k,v in pairs(table.GetKeys(items)) do
		local category = GetItemData(v).category
		ret[category] = ret[category] or {}
		table.insert(ret[category], { name = v, displayname = GetItemData(v).displayname})
	end
	for _,v in pairs(ret) do
		table.SortByMember(v, "displayname", true)
	end


	local retSorted = {}
	for k,v in pairs(ret) do
		if (k != 1) then
			table.insert(retSorted, {name = "spacer_label"})
		end
		table.insert(retSorted, {name = "category_label", displayname = invCatNames[k]})
		table.Add(retSorted, v)
	end

	return retSorted
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
		return {}
	end

	local data = { name = tostring(item) }
	table.Merge(data, items[tostring(item)])
	
	return data
end