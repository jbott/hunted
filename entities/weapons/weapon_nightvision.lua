AddCSLuaFile()

SWEP.PrintName			= "Night Vision"
SWEP.BounceWeaponIcon   = false
SWEP.DrawWeaponInfoBox  = false

SWEP.InvSpawnable    = true
SWEP.InvWeight       = 2
SWEP.InvMaxItems     = 1

SWEP.Spawnable			= true
SWEP.UseHands			= true
SWEP.DrawAmmo 			= false

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
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	if (SERVER) then
		self.Owner:NightVision(!self.Owner:NightVisionIsOn())
	end

	self:SetNextPrimaryFire(CurTime() + 0.3)
end

function SWEP:PreDrawViewModel( vm, wep, ply )
        vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material
end

function SWEP:OnRemove()
        if ( IsValid( self.Owner ) && CLIENT && self.Owner:IsPlayer() ) then
                local vm = self.Owner:GetViewModel()
                if ( IsValid( vm ) ) then vm:SetMaterial( "" ) end
        end
end

function SWEP:Holster( wep )
        self:OnRemove()
        return true
end

function SWEP:Deploy()
        local vm = self.Owner:GetViewModel()
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
        return true
end
