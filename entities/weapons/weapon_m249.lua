AddCSLuaFile()
resource.AddFile("materials/vgui/hunted/icon_m249.vmt")

SWEP.HoldType			= "crossbow"


if CLIENT then

   SWEP.PrintName			= "M249"

   SWEP.Slot				= 2

   SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_m249")

   SWEP.ViewModelFlip		= false
end


SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M249


SWEP.Primary.Damage = 19
SWEP.Primary.Delay = 0.06
SWEP.Primary.Cone = 0.09
SWEP.Primary.ClipSize = 150
SWEP.Primary.ClipMax = 150
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AirboatGun"
SWEP.AutoSpawnable      = true
SWEP.Primary.Recoil			= 1.3
SWEP.Primary.Sound			= Sound("Weapon_m249.Single")

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.HeadshotMultiplier = 2.2

SWEP.IronSightsPos = Vector(-5.96, -5.119, 2.349)
SWEP.IronSightsAng = Vector(0, 0, 0)