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

   -- Load inventory
   ply:SendLua([[hook.Call("InventoryReload")]])

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

function GM:DoPlayerDeath( ply, attacker, dmginfo )

   local ragdoll = ents.Create("prop_ragdoll")
   if (!IsValid(ragdoll)) then return nil end

   ragdoll:SetModel(ply:GetModel())
   ragdoll:SetPos(ply:GetPos())
   ragdoll:SetAngles(ply:GetAngles())
   ragdoll:SetColor(ply:GetColor())
   ragdoll:SetName(ply:GetName())

   ragdoll:Spawn()
   ragdoll:Activate()

   ragdoll:SetHasInventory(true)
   ragdoll:SetInventoryMax(ply:InventoryMax())
   ply:UpdateInventory()
   ragdoll.Inventory = ply:GetInventory()

   -- nonsolid to players to prevent
   ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

   -- position the bones and apply velocity
   local num = ragdoll:GetPhysicsObjectCount()-1
   local v = ply:GetVelocity()

   -- bullets have a lot of force, which feels better when shooting props,
   -- but makes bodies fly, so dampen that here
   if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_SLASH) then
      v = v / 5
   end

   for i=0, num do
      local bone = ragdoll:GetPhysicsObjectNum(i)
      if IsValid(bone) then
         local bp, ba = ply:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
         if bp and ba then
            bone:SetPos(bp)
            bone:SetAngles(ba)
         end

         -- not sure if this will work:
         bone:SetVelocity(v)
      end
   end

   ply:AddDeaths(1)

   if ( attacker:IsValid() && attacker:IsPlayer() ) then
      if ( attacker == ply ) then
         attacker:AddFrags(-1)
      else
         attacker:AddFrags(1)
      end
   end
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
   ply:KillSilent()
   ply:Spawn()
end
concommand.Add("hunted_change_team", changeTeam)

function GM:ShowTeam(ply)
   ply:ConCommand("hunted_menu_team") -- Show clientside team menu
end

function GM:ShowHelp(ply)
   ply:ConCommand("hunted_inv") -- Show clientside team menu
end

-- Silent Death
function GM:PlayerDeathSound()
   return true
end

-- Don't pick up weapons on the ground automatically
function GM:PlayerCanPickupWeapon(ply, wep)
   return !wep.isDropped
end