AddCSLuaFile("class.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_nightvision.lua")
AddCSLuaFile("player_ext_shd.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_hud.lua")
include("class.lua")
include("shared.lua")

include("player.lua")

function GM:Initialize()
	print("Hunted initializing...")
	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
   RunConsoleCommand("mp_friendlyfire", "1")
end

function GM:PlayerSelectSpawn( pl )
	local spawns = ents.FindByClass("info_player_start")

	local sel = nil
	repeat
		sel = table.Random(spawns)
	until Vector(-3504, -3529, 0):Distance(sel:GetPos()) < 1000

	return sel
end