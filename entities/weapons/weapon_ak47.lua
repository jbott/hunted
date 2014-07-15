AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_m16.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName = "AK-47"
SWEP.Slot      = 1
SWEP.SlotPos   = 1
if (CLIENT) then
  --SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_m16")
end

--- View ---
SWEP.HoldType      = "ar2"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel    = "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic   = false
SWEP.Primary.Delay       = 0.2
SWEP.Primary.Recoil      = 1.9
SWEP.Primary.Damage      = 30
SWEP.Primary.Cone        = 0.016

SWEP.Primary.Ammo        = "StriderMinigun"
SWEP.Primary.ClipSize    = 10
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_AK47.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector(-6.625, -12.0, 2.65)
SWEP.IronSightsAng = Vector(2.3, 0, 0)