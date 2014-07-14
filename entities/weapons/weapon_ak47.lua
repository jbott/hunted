AddCSLuaFile()

SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "AK-47"
   SWEP.Slot				= 2
end

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Primary.Delay			= 0.16
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "StriderMinigun"
SWEP.Primary.Damage = 34
SWEP.Primary.Cone = 0.018
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 30

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound = Sound( "Weapon_AK47.Single" )

SWEP.IronSightsPos = Vector(-6.7, -10.2, 1.2)
SWEP.IronSightsAng = Vector(2.3, -0.1, -1)

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetNextSecondaryFire( CurTime() + 0.3 )
end

function SWEP:PreDrop()
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or
        self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetIronsights(false)
end

function SWEP:Holster()
   self:SetIronsights(false)
   return true
end
