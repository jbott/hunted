GM.Name    = "Hunted"
GM.Author  = "SnowLeopardJB"
GM.Email   = "snowleopardjb@gmail.com"
GM.Website = "N/A"

include("player_class/player_hunted_base.lua")

--- Teams ---
TEAM_HUNTER = 1
TEAM_HUNTED  = 2
TEAM_SPEC    = TEAM_SPECTATOR

function GM:CreateTeams()
	team.SetUp(TEAM_HUNTER, "Hunters", Color(200, 0, 0, 255), false)
	team.SetUp(TEAM_HUNTED, "Hunted", Color(0, 0, 200, 255), false)
	team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 200, 255), true)

	team.SetSpawnPoint(TEAM_HUNTER, "info_player_deathmatch")
	team.SetSpawnPoint(TEAM_HUNTED, "info_player_deathmatch")
	team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end