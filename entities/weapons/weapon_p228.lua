AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_deagle.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName          = "P228"
SWEP.Slot               = 3
SWEP.SlotPos            = 1
if (CLIENT) then
  --SWEP.WepSelectIcon    = surface.GetTextureID("vgui/hunted/icon_deagle")
end

SWEP.HeadshotMultiplier = 4

--- View ---
SWEP.HoldType      = "pistol"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel    = "models/weapons/w_pist_p228.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic   = false
SWEP.Primary.Delay       = 0.2
SWEP.Primary.Recoil      = 1.5
SWEP.Primary.Damage      = 29
SWEP.Primary.Cone        = 0.02

SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 12
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_P228.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector(-5.86, -3.701, 3.1)
SWEP.IronSightsAng = Vector(-1.1, 0.6, 0)