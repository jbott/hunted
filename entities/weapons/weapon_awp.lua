AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_scout.vmt")
resource.AddFile("materials/sprites/scope.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName       = "AWP"
SWEP.InvSpawnable    = true
SWEP.InvWeight       = 14
SWEP.InvMaxItems     = 1
SWEP.Slot            = 2
SWEP.SlotPos         = 1
if (CLIENT) then
  --SWEP.WepSelectIcon = surface.GetTextureID("vgui/hunted/icon_scout")
end

SWEP.HeadshotMultiplier = 4
SWEP.Tracer             = 1
SWEP.TracerName         = "AirboatGunTracer"

--- View ---
SWEP.HoldType      = "ar2"
SWEP.UseHands      = true
SWEP.ViewModel     = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel    = "models/weapons/w_snip_awp.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay          = 1
SWEP.Primary.Recoil         = 9
SWEP.Primary.Damage         = 75
SWEP.Primary.Cone           = 0.2
SWEP.Primary.IronsightsCone = 0.002

SWEP.Primary.Ammo           = "357"
SWEP.Primary.ClipSize       = 3
SWEP.Primary.DefaultClip    = SWEP.Primary.ClipSize

SWEP.Primary.Sound          = Sound("Weapon_AWP.Single")

--- Secondary ---
SWEP.Secondary.Sound = Sound("Default.Zoom")

--- Iron Sights ---
SWEP.ZoomFOV            = 10
SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )

---- Functions ----
function SWEP:GetPrimaryCone()
   return self:GetIronsights() and self.Primary.IronsightsCone or self.Primary.Cone
end


function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(self.ZoomFOV, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights( bIronsights )

    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end

    self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    self:DefaultReload( ACT_VM_RELOAD )
    self:SetIronsights( false )
    self:SetZoom( false )
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )

         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end
