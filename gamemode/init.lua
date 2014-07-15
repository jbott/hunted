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