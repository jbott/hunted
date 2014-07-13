AddCSLuaFile("shared.lua")
include("shared.lua")

include("player.lua")

function GM:Initialize()
	print("Hunted initializing...")
	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
   RunConsoleCommand("mp_friendlyfire", "1")
end