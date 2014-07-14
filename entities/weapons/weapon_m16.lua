AddCSLuaFile()
resource.AddFile("materials/vgui/hunted/icon_m16.vmt")

SWEP.HoldType			= "ar2"

if CLIENT then
   SWEP.PrintName			= "M16"
   SWEP.Slot				= 2

   SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_m16")
end

SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Delay			= 0.10
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AirboatGun"
SWEP.Primary.Damage = 23
SWEP.Primary.Cone = 0.018
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 30
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 64
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Primary.Sound = Sound( "Weapon_M4A1.Single" )

SWEP.IronSightsPos = Vector(-7.58, -9.2, 0.55)
SWEP.IronSightsAng = Vector(2.599, -1.3, -3.6)

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
