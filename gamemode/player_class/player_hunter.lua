AddCSLuaFile()
DEFINE_BASECLASS("player_base")

local PLAYER = {}
PLAYER.DisplayName = "Hunter"
PLAYER.Model       = "models/player/Combine_Soldier.mdl"
PLAYER.Color       = Vector(0, 255, 0)

PLAYER.Weapons = {
	"weapon_flaregun"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"AR2AltFire", 4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

player_manager.RegisterClass("player_hunter", PLAYER, "player_base")