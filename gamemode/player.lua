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

   --
   -- If the player doesn't have a class
   -- then spawn him as a spectator
   --
   if (ply:Class() == CLASS_UNASSIGNED) then
      ply:KillSilent()
      timer.Simple(0.2, function() ply:ConCommand("hunted_menu_class") end)
      return
   end

   -- Stop observer mode
   ply:UnSpectate()

   player_manager.SetPlayerClass(ply, ply:Class())

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
   if (!team.Valid(newTeam)) then
      ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid Team " .. args[1])
      return
   end
   print(ply:Name() .. " changed to team " .. team.GetName(newTeam))
   ply:SetTeam(newTeam)
   ply:SetClass(CLASS_UNDEFINED)
   ply:KillSilent()
   ply:Spawn()
end
concommand.Add("hunted_change_team", changeTeam)

function GM:ShowTeam(ply)
   ply:ConCommand("hunted_menu_team") -- Show clientside team menu
end

function changeClass(ply, cmd, args)
   local newClass = tostring(args[1])
   if (!CLASS.isValid(newClass)) then
      ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid Class " .. args[1])
      return
   end
   print(ply:Name() .. " changed to class " .. CLASS.GetClassName(newClass))
   ply:SetClass(newClass)
   ply:KillSilent()
   ply:Spawn()
end
concommand.Add("hunted_change_class", changeClass)

function GM:ShowTeam(ply)
   ply:ConCommand("hunted_menu_team") -- Show clientside team menu
end

function GM:ShowSpare1(ply)
   ply:ConCommand("hunted_menu_class") -- Show clientside team menu
end