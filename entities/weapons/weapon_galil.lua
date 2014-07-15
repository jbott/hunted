AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_m16.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName = "Galil"
SWEP.Slot      = 1
SWEP.SlotPos   = 1
if (CLIENT) then
  --SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_m16")
end

--- View ---
SWEP.HoldType      = "ar2"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel    = "models/weapons/w_rif_galil.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic   = true
SWEP.Primary.Delay       = 0.2
SWEP.Primary.Recoil      = 1.5
SWEP.Primary.Damage      = 22
SWEP.Primary.Cone        = 0.02

SWEP.Primary.Ammo        = "AirboatGun"
SWEP.Primary.ClipSize    = 20
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_Galil.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector(-6.3, -12.0, 1.65)
SWEP.IronSightsAng = Vector(1, 0, 0)