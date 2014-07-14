AddCSLuaFile()
resource.AddFile("materials/vgui/hunted/icon_flare.vmt")

SWEP.HoldType = "pistol"

if CLIENT then

   SWEP.PrintName = "Flare Gun"
   SWEP.Slot = 0
   SWEP.SlotPos = 1

   SWEP.ViewModelFOV  = 54
   SWEP.ViewModelFlip = false

   SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_flare")
end

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 4
SWEP.Primary.Damage = 7
SWEP.Primary.Delay = 1.0
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 1
SWEP.Primary.ClipMax = 4

-- if I run out of ammo types, this weapon is one I could move to a custom ammo
-- handling strategy, because you never need to pick up ammo for it
SWEP.Primary.Ammo = "AR2AltFire"

SWEP.UseHands        = true
SWEP.ViewModel       = Model("models/weapons/c_357.mdl")
SWEP.WorldModel      = Model("models/weapons/w_357.mdl")

SWEP.Primary.Sound = Sound( "Weapon_FlareGun.Single" )

SWEP.FlareDuration = 120

function SWEP:ShootFlare()

   if ( CLIENT ) then return end

   flare = ents.Create("env_flare")
   if !IsValid(flare) then return end

   flare:SetPos(self.Owner:EyePos() + ( self.Owner:GetAimVector() * 10 ))
   flare:SetAngles(self.Owner:EyeAngles())
   flare:SetKeyValue("spawnflags", 4) -- Infinite
   flare:SetKeyValue("scale", 10)
   flare:Spawn()
   flare:Fire("Launch", 2000, 0)

   flare:Fire("Kill", nil, self.FlareDuration)
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   if not self:CanPrimaryAttack() then return end

   self:EmitSound(self.Primary.Sound)

   self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

   self:ShootFlare()

   self:TakePrimaryAmmo(1)

   if IsValid(self.Owner) then
      self.Owner:SetAnimation(PLAYER_ATTACK1)

      self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
   end
end

function SWEP:SecondaryAttack()
end