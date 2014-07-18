AddCSLuaFile()
DEFINE_BASECLASS("player_default")

---- Config ----
local PLAYER = {}
PLAYER.DisplayName       = "Base Class"

-- Slower walk speeds
PLAYER.WalkSpeed         = 150
PLAYER.RunSpeed          = PLAYER.WalkSpeed * 1.5

-- Colide!
PLAYER.TeammateNoCollide = false
PLAYER.AvoidPlayers      = false

PLAYER.Model             = "models/player/kleiner.mdl"
PLAYER.Color             = Vector(1, 1, 1)
PLAYER.NightVisionSize   = 500

PLAYER.Inventory         = true
PLAYER.InvMaxWeight      = 25

PLAYER.Weapons = {
	"weapon_flaregun"
}

PLAYER.Ammo = {}

---- Functions ----
function PLAYER:GetDisplayName()
	return self.DisplayName
end

function PLAYER:Spawn()
	self.Player:SetHasInventory(self.Inventory)
	self.Player:SetInventoryMax(self.InvMaxWeight)
	self.Player:SetNightVisionSize(self.NightVisionSize)
	-- Adjust player duck height to be more reasonable
	self.Player:SetViewOffsetDucked(Vector(0.0, 0.0, 40.0))
end

-- Load ammo from tables
function PLAYER:Loadout()
	for _,wep in pairs(self.Weapons) do
		self.Player:Give(tostring(wep))
	end

	for _,ammo in pairs(self.Ammo) do
		self.Player:GiveAmmo(tonumber(ammo[2]), tostring(ammo[1]))
	end

	self.Player:SwitchToDefaultWeapon()
end

function PLAYER:SetModel()
	util.PrecacheModel(self.Model)
	self.Player:SetModel(self.Model)
	self.Player:SetPlayerColor(self.Color)
end

function PLAYER:SpeedMultiplier(val)
	self.Player:SetCanWalk(val >= 1)
	self.Player:SetWalkSpeed(self.WalkSpeed * val)
	self.Player:SetRunSpeed(((val < 1) and self.WalkSpeed or self.RunSpeed) * val)
end

--- Taunts - From player_sandbox ---
PLAYER.TauntCam = TauntCamera() -- Creates a Taunt Camera

function PLAYER:ShouldDrawLocal()
	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

function PLAYER:CreateMove( cmd )
	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

function PLAYER:CalcView( view )
	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end
end

--- Reproduces the jump boost from HL2 singleplayer - From player_sandbox ---
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

player_manager.RegisterClass("player_base", PLAYER, "player_default")