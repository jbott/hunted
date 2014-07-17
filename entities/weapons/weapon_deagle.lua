AddCSLuaFile()
resource.AddFile("materials/vgui/hunted/icon_deagle.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName          = "Desert Eagle"
SWEP.InvSpawnable       = true
SWEP.InvWeight          = 4
SWEP.InvMaxItems        = 1
SWEP.InvCategory        = "Secondary"
SWEP.Slot               = 3
SWEP.SlotPos            = 1
if (CLIENT) then
  SWEP.WepSelectIcon    = surface.GetTextureID("vgui/hunted/icon_deagle")
end

SWEP.DeploySpeed        = 1.5
SWEP.HeadshotMultiplier = 4

--- View ---
SWEP.HoldType      = "pistol"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel    = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic   = false
SWEP.Primary.Delay       = 0.4
SWEP.Primary.Recoil      = 6
SWEP.Primary.Damage      = 35
SWEP.Primary.Cone        = 0.02

SWEP.Primary.Ammo        = "CombineCannon"
SWEP.Primary.ClipSize    = 7
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_Deagle.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng = Vector(0, 0, 0)