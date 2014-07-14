AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

PLAYER.DisplayName			= "Hunted Base Class"

PLAYER.WalkSpeed 			= 150
PLAYER.RunSpeed				= PLAYER.WalkSpeed * 1.5

PLAYER.TeammateNoCollide 	= false
PLAYER.AvoidPlayers			= false


function PLAYER:SlowSpeed()
	self.Player:SetCanWalk(false)
	self.Player:SetWalkSpeed(PLAYER.WalkSpeed * 0.5)
	self.Player:SetRunSpeed(PLAYER.WalkSpeed * 0.5)
end

function PLAYER:ResetSpeed()
	self.Player:SetCanWalk(true)
	self.Player:SetWalkSpeed(PLAYER.WalkSpeed)
	self.Player:SetRunSpeed(PLAYER.RunSpeed)
end

function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()

	self.Player:Give("weapon_ak47")
	self.Player:Give("weapon_deagle")
	self.Player:Give("weapon_fiveseven")
	self.Player:Give("weapon_m16")
	self.Player:Give("weapon_m249")
	self.Player:Give("weapon_mac10")
	self.Player:Give("weapon_scout")
	self.Player:Give("weapon_xm1014")
	self.Player:Give("weapon_nightvision")

	self.Player:GiveAmmo(256, "CombineCannon", true)
	self.Player:GiveAmmo(256, "Pistol", true)
	self.Player:GiveAmmo(256, "AirboatGun", true)
	self.Player:GiveAmmo(256, "smg1", true)
	self.Player:GiveAmmo(256, "StriderMinigun", true)
	self.Player:GiveAmmo(256, "Buckshot", true)

	self.Player:SwitchToDefaultWeapon()
end

function PLAYER:SetModel()
	BaseClass.SetModel(self)
	self.Player:SetModel("models/player/Combine_Soldier.mdl")
end

--
-- Called when the player spawns
--
function PLAYER:Spawn()
	BaseClass.Spawn(self)

	-- Adjust player duck height to be more reasonable
	self.Player:SetViewOffsetDucked(Vector(0.0, 0.0, 40.0))
	
	--[[local col = self.Player:GetInfo( "cl_playercolor" )
	self.Player:SetPlayerColor( Vector( col ) )

	local col = self.Player:GetInfo( "cl_weaponcolor" )
	self.Player:SetWeaponColor( Vector( col ) )
	--]]
end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

--
-- Reproduces the jump boost from HL2 singleplayer
--
local JUMPING

function PLAYER:StartMove( move )
	
	-- Only apply the jump boost in FinishMove if the player has jumped during this frame
	-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and self.Player:OnGround() then
		JUMPING = true
	end
	
end

function PLAYER:FinishMove( move )
	
	-- If the player has jumped this frame
	if JUMPING then
		-- Get their orientation
		local forward = self.Player:EyeAngles()
		forward.p = 0
		forward = forward:Forward()
		
		-- Compute the speed boost
		
		-- HL2 normally provides a much weaker jump boost when sprinting
		-- For some reason this never applied to GMod, so we won't perform
		-- this check here to preserve the "authentic" feeling
		local speedBoostPerc = ( ( not self.Player:Crouching() ) and 0.5 ) or 0.1
		
		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()
		
		-- Clamp it to make sure they can't bunnyhop to ludicrous speed
		if newSpeed > maxSpeed then
			speedAddition = speedAddition - (newSpeed - maxSpeed)
		end
		
		-- Reverse it if the player is running backwards
		if move:GetForwardSpeed() < 0 then
			speedAddition = -speedAddition
		end
		
		-- Apply the speed boost
		move:SetVelocity(forward * speedAddition + move:GetVelocity())
	end
	
	JUMPING = nil
	
end

player_manager.RegisterClass( "player_hunted_base", PLAYER, "player_default" )
