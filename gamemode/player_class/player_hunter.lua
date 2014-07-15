AddCSLuaFile()
DEFINE_BASECLASS("player_base")

local PLAYER = {}
PLAYER.DisplayName = "Hunter"
PLAYER.Model       = "models/player/Combine_Soldier.mdl"

function PLAYER:Loadout()
	self.Player:Give("weapon_flaregun")
	self.Player:GiveAmmo(9, "AR2AltFire", true)
	-- Stunstick
	self.Player:Give("weapon_galil")
	self.Player:GiveAmmo(25 * 4, "AirboatGun", true)
	self.Player:Give("weapon_deagle")
	self.Player:GiveAmmo(7 * 4, "CombineCannon", true)
	self.Player:Give("weapon_p228")
	self.Player:GiveAmmo(12 * 4, "pistol", true)
	self.Player:Give("weapon_m16")
	self.Player:GiveAmmo(30 * 4, "AirboatGun", true)
	self.Player:Give("weapon_awp")
	self.Player:GiveAmmo(3 * 4,"357", true)
	self.Player:Give("weapon_g3sg1")
	self.Player:GiveAmmo(6 * 4, "StriderMinigun", true)
	self.Player:Give("weapon_xm1014")
	self.Player:GiveAmmo(6 * 4, "Buckshot", true)
	self.Player:Give("weapon_m3")
	self.Player:GiveAmmo(8 * 4, "Buckshot", true)

	self.Player:SwitchToDefaultWeapon()
	BaseClass.Loadout(self)
end

function PLAYER:Spawn()
	BaseClass.Spawn(self)
	self.Player:SetPlayerColor(Vector(0, 255, 0))
end

player_manager.RegisterClass("player_hunter", PLAYER, "player_base")