local items = {
	ammo_pistol = {
		displayname = "Ammo - Pistol",
		weight = 1,
		category = INVENTORY_CAT_AMMO,
		ammoname = "Pistol",
		ammoquantity = 24
	},
	ammo_rifle = {
		displayname = "Ammo - Rifle",
		weight = 2,
		category = INVENTORY_CAT_AMMO,
		ammoname = "AR2",
		ammoquantity = 60
	},
	ammo_shotgun = {
		displayname = "Ammo - Shotgun",
		weight = 2,
		category = INVENTORY_CAT_AMMO,
		ammoname = "Buckshot",
		ammoquantity = 12
	},
	ammo_sniper = {
		displayname = "Ammo - Sniper",
		weight = 3,
		category = INVENTORY_CAT_AMMO,
		ammoname = "SniperRound",
		ammoquantity = 10
	},
	ammo_flare = {
		displayname = "Ammo - Flare",
		weight = 3,
		category = INVENTORY_CAT_AMMO,
		ammoname = "AR2AltFire",
		ammoquantity = 4
	}
}

local catTranslation = {
	none      = INVENTORY_CAT_NONE,
	primary   = INVENTORY_CAT_PRIMARY,
	secondary = INVENTORY_CAT_SECONDARY,
	ammo      = INVENTORY_CAT_AMMO,
	medical   = INVENTORY_CAT_MEDICAL,
	expl      = INVENTORY_CAT_EXPL,
	misc      = INVENTORY_CAT_MISC
}

function translateCategory(cat)
	cat = cat or ""
	return catTranslation[string.lower(cat)] or INVENTORY_CAT_NONE
end

function addInventoryItems()
	for _, weapon in pairs(weapons.GetList()) do
		if (weapon.InvSpawnable) then
			INVENTORY.AddItem(weapon.ClassName, {
				displayname = weapon.PrintName or weapon.ClassName,
				weight = weapon.InvWeight or 0,
				max = weapon.InvMaxItems or 0,
				restrict = weapon.InvRestrict or 0,
				category = translateCategory(weapon.InvCategory),
				clip1max = weapon.Primary.ClipSize or -1,
				clip1 = weapon.Primary.ClipSize or -1
			})
		end
	end

	for k,v in pairs(items) do
		local item = {
			displayname = "SETME",
			weight = 0,
			max = 0,
			restrict = 0,
			category = INVENTORY_CAT_NONE
		}
		table.Merge(item, v)
		item.clip1max = item.ammoquantity
		INVENTORY.AddItem(k, item)
	end
end
hook.Add("InventoryReload", "inventory_addItems", addInventoryItems)

if (game.SinglePlayer()) then
	concommand.Add("force_inv_load", function()
		hook.Call("InventoryReload")
		BroadcastLua([[hook.Call("InventoryReload")]])
	end)
end