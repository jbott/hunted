AddCSLuaFile()
-- This is common to all classes in this file
DEFINE_BASECLASS("player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Commando - Merc"
PLAYER.Desc            = "Weapons: Galil"

PLAYER.Weapons = {
	"weapon_galil"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"AirboatGun", 25*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_commando_merc", PLAYER)
player_manager.RegisterClass("class_hunter_commando_merc", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Commando - Colt"
PLAYER.Desc            = "Weapons: M16"

PLAYER.Weapons = {
	"weapon_m16"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"AirboatGun", 30*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_commando_colt", PLAYER)
player_manager.RegisterClass("class_hunter_commando_colt", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Contender - Bandit"
PLAYER.Desc            = "Weapons: M3"

PLAYER.Weapons = {
	"weapon_m3"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"Buckshot", 8*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_contender_bandit", PLAYER)
player_manager.RegisterClass("class_hunter_contender_bandit", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Contender - Rival"
PLAYER.Desc            = "Weapons: XM1014"

PLAYER.Weapons = {
	"weapon_xm1014"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"Buckshot", 6*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_contender_rival", PLAYER)
player_manager.RegisterClass("class_hunter_contender_rival", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Tracker - Zaroff"
PLAYER.Desc            = "Weapons: AWP"
PLAYER.MaxHealth       = 75
PLAYER.StartHealth     = 75

PLAYER.Weapons = {
	"weapon_awp"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"357", 3*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_tracker_zaroff", PLAYER)
player_manager.RegisterClass("class_hunter_tracker_zaroff", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Tracker - Stalker"
PLAYER.Desc            = "Weapons: G3SG1"
PLAYER.MaxHealth       = 75
PLAYER.StartHealth     = 75

PLAYER.Weapons = {
	"weapon_g3sg1"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"StriderMinigun", 6*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_tracker_stalker", PLAYER)
player_manager.RegisterClass("class_hunter_tracker_stalker", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Specialist - Raptor"
PLAYER.Desc            = "Weapons: Deagle"
PLAYER.Model           = "models/player/Police.mdl"

PLAYER.Weapons = {
	"weapon_deagle"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"CombineCannon", 7*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_specialist_raptor", PLAYER)
player_manager.RegisterClass("class_hunter_specialist_raptor", PLAYER, "player_hunter")

---------------
---- CLASS ----
---------------
local PLAYER = {}
PLAYER.DisplayName     = "Specialist - Officer"
PLAYER.Desc            = "Weapons: P228"
PLAYER.Model           = "models/player/Police.mdl"

PLAYER.Weapons = {
	"weapon_p228"
}
table.Add(PLAYER.Weapons, BaseClass.Weapons)

PLAYER.Ammo = {
	{"Pistol", 12*4}
}
table.Add(PLAYER.Ammo, BaseClass.Ammo)

CLASS.RegisterClass(TEAM_HUNTER, "class_hunter_specialist_officer", PLAYER)
player_manager.RegisterClass("class_hunter_specialist_officer", PLAYER, "player_hunter")