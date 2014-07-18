AddCSLuaFile("shared.lua")
AddCSLuaFile("inventory_shd.lua")
AddCSLuaFile("cl_nightvision.lua")
AddCSLuaFile("player_ext_shd.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("items.lua")
include("shared.lua")
include("inventory_ext.lua")
include("inventory.lua")

include("player.lua")

function GM:Initialize()
	print("Hunted initializing...")
	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
   RunConsoleCommand("mp_friendlyfire", "1")
end

function GM:PostGamemodeLoaded()
	hook.Call("InventoryReload")
end

function GM:PlayerSelectSpawn( pl )
	local spawns = ents.FindByClass("info_player_start")

	local sel = nil
	repeat
		sel = table.Random(spawns)
	until Vector(-3504, -3529, 0):Distance(sel:GetPos()) < 1000

	return sel
end

function GM:InitPostEntity()
	-- Create map entities

	-- Flares
	local flare = ents.Create("env_flare")
	flare:SetPos(Vector(-3770.753418,-3429.978027,103.968750))
	flare:SetKeyValue("spawnflags", 4) -- Infinite
	flare:SetKeyValue("scale", 10)
	flare:Spawn()

	local flare = ents.Create("env_flare")
	flare:SetPos(Vector(-3374.827637, -3555.890381, 103.968750))
	flare:SetKeyValue("spawnflags", 4) -- Infinite
	flare:SetKeyValue("scale", 10)
	flare:Spawn()

	-- Outside
	local box = ents.Create("box_ammo")
	box:SetPos(Vector(-3739.175781, -3580.487793, 14.444678))
	box:SetAngles(Angle(0, -90, 0))
	box:Spawn()
	box:Activate()
	box:SetHasInventory(false)
	-- Hack to open the spawn menu
	box.Use = function(activator, caller, useType, value)
		setInventoryType(caller, INVENTORY_TYPE_SPAWN)
		caller:UpdateInventory()
		net.Start("InventoryOpenResponse")
			net.WriteInt(getInventoryType(caller), 3)
		net.Send(caller)
	end

	-- Inside left
	local box = ents.Create("box_ammo")
	box:SetPos(Vector(-3756.624268, -3492, 16.496033))
	box:SetAngles(Angle(0, 0, 0))
	box:Spawn()
	box:Activate()
	-- Clear inventory of base items
	box:SetHasInventory(true)
	box:SetInventoryMax(50)
	box:SetInventoryFilter(INVENTORY_CAT_NONE)

	-- Inside right
	local box = ents.Create("box_ammo")
	box:SetPos(Vector(-3389.521484, -3492, 16.427814))
	box:SetAngles(Angle(0, 180, 0))
	box:Spawn()
	box:Activate()
end