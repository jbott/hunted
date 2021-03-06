GM.Name    = "Hunted"
GM.Author  = "SnowLeopardJB"
GM.Email   = "snowleopardjb@gmail.com"
GM.Website = "N/A"

GM.TeamBased = true

include("player_ext_shd.lua")
include("inventory_shd.lua")

--- Teams ---
TEAM_HUNTER  = 1
TEAM_HUNTED  = 2
TEAM_SPEC    = TEAM_SPECTATOR

--- Enums ---
INVENTORY_TYPE_PLAYER   = 1
INVENTORY_TYPE_ENTITY   = 2
INVENTORY_TYPE_SPAWN    = 3

INVENTORY_SIDE_RIGHT    = 1
INVENTORY_SIDE_LEFT     = 2

INVENTORY_CAT_NONE      = 0
INVENTORY_CAT_PRIMARY   = 1
INVENTORY_CAT_SECONDARY = 2
INVENTORY_CAT_MEDICAL   = 3
INVENTORY_CAT_EXPL      = 4
INVENTORY_CAT_MISC      = 5
INVENTORY_CAT_AMMO      = 6

invCatNames = {
	"Primary",
	"Secondary",
	"Medical",
	"Explosive",
	"Miscellaneous",
	"Ammo"
}

include("items.lua")

--- Create classes ---
include("player_class/player_base.lua")
include("player_class/player_hunter.lua")
include("player_class/player_hunted.lua")

function GM:CreateTeams()
	team.SetUp(TEAM_HUNTER, "Hunter", Color(200, 0, 0, 255), false)
	team.SetUp(TEAM_HUNTED, "Hunted", Color(0, 0, 200, 255), false)
	team.SetUp(TEAM_SPEC, "Spectator", Color(200, 200, 200, 255), true)
end