AddCSLuaFile()

SWEP.PrintName			= "Night Vision"
SWEP.BounceWeaponIcon   = false
SWEP.DrawWeaponInfoBox  = false

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel			= ""

SWEP.ViewModelFOV		= 52
SWEP.Slot				= 5
SWEP.SlotPos			= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType("slam")

	if (CLIENT) then return end

end

function SWEP:PrimaryAttack()
	self.Owner:NightVision(!self.Owner:NightVisionIsOn())
	self:SetNextPrimaryFire( CurTime() + 0.3 )
end