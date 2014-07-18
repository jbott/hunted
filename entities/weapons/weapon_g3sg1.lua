AddCSLuaFile()
--resource.AddFile("materials/vgui/hunted/icon_scout.vmt")
resource.AddFile("materials/sprites/scope.vmt")

---- CONFIG ----
SWEP.Base = "weapon_tttbase"

--- Info ---
SWEP.PrintName       = "G3SG1"
SWEP.InvSpawnable    = true
SWEP.InvWeight       = 12
SWEP.InvMaxItems     = 1
SWEP.InvCategory     = "Primary"
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
SWEP.ViewModel     = "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel    = "models/weapons/w_snip_g3sg1.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV  = 54

--- Primary ---
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay          = 0.7
SWEP.Primary.Recoil         = 4
SWEP.Primary.Damage         = 50
SWEP.Primary.Cone           = 0.2
SWEP.Primary.IronsightsCone = 0.002

SWEP.Primary.Ammo           = "SniperRound"
SWEP.Primary.ClipSize       = 6
SWEP.Primary.DefaultClip    = SWEP.Primary.ClipSize

SWEP.Primary.Sound          = Sound("Weapon_G3SG1.Single")

--- Secondary ---
SWEP.Secondary.Sound = Sound("Default.Zoom")

--- Iron Sights ---
SWEP.ZoomFOV            = 20
SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )

---- Functions ----
function SWEP:GetPrimaryCone()
	return self:GetIronsights() and self.Primary.IronsightsCone or self.Primary.Cone
end


function SWEP:SetZoom(state)
	if CLIENT then return end
	if !IsValid(self.Owner) or !self.Owner:IsPlayer() then return end
	self.Owner:SetFOV(state and self.ZoomFOV or 0, 0.3)
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
	self.BaseClass.SecondaryAttack(self)

	if SERVER then
		self:SetZoom(self:GetIronsights())
	else
		self:EmitSound(self.Secondary.Sound)
	end
end

function SWEP:PreDrop()
	self:SetZoom(false)
	return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	self:SetZoom( false )
	self.BaseClass.Reload(self)
end


function SWEP:Holster()
	self:SetZoom(false)
	return self.BaseClass.Holster(self)
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