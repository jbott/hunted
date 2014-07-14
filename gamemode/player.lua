-- First spawn on the server
function GM:PlayerInitialSpawn( ply )
   ply:SetTeam(TEAM_HUNTER)
   
   -- Broadcast message of player join
   local text = Format("%s Connected\n", ply:GetName())
   for k, ply in pairs(player.GetAll()) do
      if IsValid(ply) then
         ply:PrintMessage(HUD_PRINTTALK, text)
      end
   end
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
   player_manager.SetPlayerClass(ply, "player_hunted_base")

   player_manager.OnPlayerSpawn(ply)
   player_manager.RunClass(ply, "Spawn")

   -- Call item loadout function
   hook.Call("PlayerLoadout", GAMEMODE, ply)
   
   -- Set player model
   hook.Call("PlayerSetModel", GAMEMODE, ply)

   ply:SetupHands()
end

-- Disable NoClipping
function GM:PlayerNoClip( ply, desiredState )
   if !desiredState then return true end
   return false
end

function GM:PlayerFootstep(ply, pos, foot, snd, volume, filter)
   sound.Play(snd, pos, 130)
   return true
end