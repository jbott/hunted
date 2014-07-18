AddCSLuaFile()
DEFINE_BASECLASS("player_base")

local PLAYER = {}
PLAYER.DisplayName = "Hunter"
PLAYER.Model       = "models/player/Combine_Soldier.mdl"
PLAYER.Color       = Vector(0, 1, 0)

player_manager.RegisterClass("player_hunter", PLAYER, "player_base")