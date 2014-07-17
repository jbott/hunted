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
INVENTORY_TYPE_PLAYER  = 1
INVENTORY_TYPE_ENTITY  = 2
INVENTORY_TYPE_SPAWN   = 3

INVENTORY_SIDE_RIGHT   = 1
INVENTORY_SIDE_LEFT    = 2

--- Create classes ---
include("player_class/player_base.lua")
include("player_class/player_hunter.lua")
include("player_class/player_hunted.lua")

function GM:CreateTeams()
	team.SetUp(TEAM_HUNTER, "Hunter", Color(200, 0, 0, 255), false)
	team.SetUp(TEAM_HUNTED, "Hunted", Color(0, 0, 200, 255), false)
	team.SetUp(TEAM_SPEC, "Spectator", Color(200, 200, 200, 255), true)
end