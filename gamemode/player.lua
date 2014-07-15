-- First spawn on the server
function GM:PlayerInitialSpawn( ply )
   ply:SetTeam(TEAM_UNASSIGNED)
   
   -- Broadcast message of player join
   local text = Format("%s Connected\n", ply:GetName())
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) then
         v:PrintMessage(HUD_PRINTTALK, text)
      end
   end

   -- Run team select
   ply:ConCommand("hunted_menu_team")
end

function GM:PlayerSpawn(ply)
   --
   -- If the player doesn't have a team
   -- then spawn him as a spectator
   --
   if (ply:Team() == TEAM_SPECTATOR || ply:Team() == TEAM_UNASSIGNED) then
      GAMEMODE:PlayerSpawnAsSpectator(ply)
      return
   end

   -- Stop observer mode
   ply:UnSpectate()

   -- Set player class
   if (ply:Team() == TEAM_HUNTED) then
      player_manager.SetPlayerClass(ply, "player_hunted")
   elseif (ply:Team() == TEAM_HUNTER) then
      player_manager.SetPlayerClass(ply, "player_hunter")
   else
      player_manager.SetPlayerClass(ply, "player_base")
   end

   player_manager.OnPlayerSpawn(ply)
   player_manager.RunClass(ply, "Spawn")

   -- Call item loadout function
   hook.Call("PlayerLoadout", GAMEMODE, ply)
   
   -- Set player model
   hook.Call("PlayerSetModel", GAMEMODE, ply)

   ply:SetupHands()
end

-- Disable NoClipping
function GM:PlayerNoClip(ply, desiredState)
   if !desiredState then return true end
   return false
end

function GM:PlayerFootstep(ply, pos, foot, snd, volume, filter)
   sound.Play(snd, pos, 130)
   return true
end

function changeTeam(ply, cmd, args)
   local newTeam =  tonumber(args[1])
   if (!team.Valid(newTeam)) then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid Team " .. args[1]) end
   print(ply:Name() .. " changed to team " .. team.GetName(newTeam))
   ply:SetTeam(newTeam)
   ply:KillSilent()
   ply:Spawn()
end
concommand.Add("hunted_change_team", changeTeam)

function GM:ShowTeam(ply)
   ply:ConCommand("hunted_menu_team") -- Show clientside team menu
end