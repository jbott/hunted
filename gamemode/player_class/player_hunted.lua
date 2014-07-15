AddCSLuaFile()
DEFINE_BASECLASS("player_base")

local PLAYER = {}
PLAYER.DisplayName = "Hunted"
PLAYER.Model       = "models/player/Group03/Male_02.mdl"

function PLAYER:Loadout()
	-- Knife
	-- Climb tool
	-- Bandage
	self.Player:Give("weapon_ak47")
	self.Player:GiveAmmo(20 * 4, "StriderMinigun")
	self.Player:Give("weapon_tmp")
	self.Player:GiveAmmo(40 * 4, "Pistol")

	self.Player:SwitchToDefaultWeapon()
	BaseClass.Loadout(self)
end

function PLAYER:Spawn()
	BaseClass.Spawn(self)
	self.Player:SetNightVisionSize(750)
end

player_manager.RegisterClass("player_hunted", PLAYER, "player_base")