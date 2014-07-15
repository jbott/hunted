-- This handles all class functions
CLASS = {}

CLASS_UNASSIGNED = "NONE"

local team_classes = {}
local class_tables = {}

function CLASS.RegisterClass(tm, class, tbl)
	if (!tm or !class or !tbl) then
		print("Error registering class!")
		return
	end

	team_classes[tm] = team_classes[tm] or {}
	if table.HasValue(team_classes[tm], tostring(class)) then
		print("Class " .. class .. " Already exists!")
		return
	end

	table.insert(team_classes[tm], tostring(class))
	class_tables[tostring(class)] = tbl
end

function CLASS.GetTeamClasses(tm)
	team_classes[tm] = team_classes[tm] or {}
	return team_classes[tm]
end

function CLASS.GetClassName(class)
	if class_tables[tostring(class)] == nil then return "Unassigned" end
	return class_tables[tostring(class)].DisplayName
end

function CLASS.GetClassDesc(class)
	if class_tables[tostring(class)] == nil then return "" end
	return class_tables[tostring(class)].Desc
end

function CLASS.isValid(class)
	if (tostring(class) == CLASS_UNASSIGNED) then return true end
	for k,v in pairs(team_classes) do
		if table.HasValue(v, tostring(class)) then return true	end
	end
	return false
end