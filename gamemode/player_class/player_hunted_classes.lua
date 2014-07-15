AddCSLuaFile()
-- This is common to all classes in this file
DEFINE_BASECLASS("player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Guerilla - Tycho"
PLAYER.Desc            = "Weapons: TMP"

PLAYER.Weapons = {
	"weapon_tmp"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"Pistol", 40*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_guerilla_tycho", PLAYER)
player_manager.RegisterClass("class_hunted_guerilla_tycho", PLAYER, "player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Guerilla - Blitz"

PLAYER.Weapons = {
	--"weapon_ump"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	--{"Pistol", 40*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_guerilla_blitz", PLAYER)
player_manager.RegisterClass("class_hunted_guerilla_blitz", PLAYER, "player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Trapper"
PLAYER.Desc            = "Weapons: AK-47, Flaregun"

PLAYER.Weapons = {
	"weapon_ak47",
	"weapon_flaregun"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"StriderMinigun", 20*4},
	{"AR2AltFire", 9}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_trapper", PLAYER)
player_manager.RegisterClass("class_hunted_trapper", PLAYER, "player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Pursuer"
PLAYER.Armor           = 75
PLAYER.WalkSpeed       = BaseClass.WalkSpeed * 1.2
PLAYER.RunSpeed        = BaseClass.RunSpeed * 1.2

PLAYER.Weapons = {}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_pursuer", PLAYER)
player_manager.RegisterClass("class_hunted_pursuer", PLAYER, "player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Skulker - Helsing"

PLAYER.Weapons = {}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_skulker_helsing", PLAYER)
player_manager.RegisterClass("class_hunted_skulker_helsing", PLAYER, "player_hunted")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Skulker - Blackout"

PLAYER.Weapons = {}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTED, "class_hunted_skulker_blackout", PLAYER)
player_manager.RegisterClass("class_hunted_skulker_blackout", PLAYER, "player_hunted")