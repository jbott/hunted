AddCSLuaFile()
DEFINE_BASECLASS("player_base")

local PLAYER = {}
PLAYER.DisplayName     = "Hunted"
PLAYER.Model           = "models/player/Group03/Male_02.mdl"
PLAYER.NightVisionSize = 750
PLAYER.MaxHealth       = 200
PLAYER.StartHealth     = 200

player_manager.RegisterClass("player_hunted", PLAYER, "player_base")