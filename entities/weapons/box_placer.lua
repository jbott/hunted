AddCSLuaFile()

SWEP.PrintName			= "Box Placer"
SWEP.BounceWeaponIcon   = false
SWEP.DrawWeaponInfoBox  = false

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
		local trace = self.Owner:GetEyeTrace()
                if (trace.Hit) then
                        local box = ents.Create("box_ammo")
                        box:SetPos(trace.HitPos)
                        box:Spawn()
                        box:Activate()
                        box:SetHasInventory(false)
                end
	end

	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
        if (SERVER) then
                local trace = self.Owner:GetEyeTrace()
                if (trace.Hit) then
                        local ent = trace.Entity
                        print("Pos: " .. tostring(ent:GetPos()))
                        print("Angles: " .. tostring(ent:GetAngles()))
                end
        end

        self:SetNextSecondaryFire(CurTime() + 1)
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
