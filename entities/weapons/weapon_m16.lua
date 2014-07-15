AddCSLuaFile()
resource.AddFile("materials/vgui/hunted/icon_m16.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName       = "M16"
SWEP.Slot            = 1
SWEP.SlotPos         = 1
if (CLIENT) then
  SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_m16")
end

--- View ---
SWEP.HoldType      = "ar2"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel    = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 64

--- Primary ---
SWEP.Primary.Automatic   = true
SWEP.Primary.Delay       = 0.1
SWEP.Primary.Recoil      = 1.6
SWEP.Primary.Damage      = 18
SWEP.Primary.Cone        = 0.018

SWEP.Primary.Ammo        = "AirboatGun"
SWEP.Primary.ClipSize    = 30
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_M4A1.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector(-7.58, -9.2, 0.55)
SWEP.IronSightsAng = Vector(2.599, -1.3, -3.6)