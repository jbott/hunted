AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_mac.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName       = "TMP"
SWEP.Slot            = 3
SWEP.SlotPos         = 1
if (CLIENT) then
  --SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_mac")
end
SWEP.Tracer          = 0
SWEP.DeploySpeed     = 3
SWEP.MuzzleFlashSize = 50

--- View ---
SWEP.HoldType      = "pistol"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel    = "models/weapons/w_smg_tmp.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---`
SWEP.Primary.Automatic   = true
SWEP.Primary.Delay       = 0.08
SWEP.Primary.Recoil      = 1.05
SWEP.Primary.Damage      = 12
SWEP.Primary.Cone        = 0.02

SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 40
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize

SWEP.Primary.Sound       = Sound("Weapon_TMP.Single")

--- Iron Sights ---
SWEP.IronSightsPos = Vector (-7.0, -3.271, 2.2)
SWEP.IronSightsAng = Vector (1.3, 0, -0.9)

---- Functions ----
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 2 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 150)

   -- decay from 3.2 to 1.7
   return 1.7 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
end
