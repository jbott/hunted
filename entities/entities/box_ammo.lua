AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Ammo Crate"
ENT.Type = "anim"
ENT.Base = "base_anim"

if (CLIENT) then return end

function ENT:Initialize()
	self:SetName(self.PrintName)

	self:SetModel("models/Items/ammocrate_ar2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetHasInventory(true)
	self:SetInventoryMax(0)
	self:InventoryAdd("ammo_pistol")
	self:InventoryAdd("ammo_rifle")
	self:InventoryAdd("ammo_shotgun")
	self:InventoryAdd("ammo_sniper")
	self:SetInventoryFilter(INVENTORY_CAT_AMMO)

	local phys = self:GetPhysicsObject()
	if (phys and phys:IsValid()) then
		phys:EnableMotion(false)
	end
end