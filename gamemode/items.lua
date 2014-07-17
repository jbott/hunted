local items = {
	ammo_pistol = {
		displayname = "Ammo - Pistol (24)",
		weight = 1,
		category = INVENTORY_CAT_AMMO,
		ammoname = "Pistol",
		ammoquantiy = 24
	},
	ammo_rifle = {
		displayname = "Ammo - Rifle (60)",
		weight = 2,
		category = INVENTORY_CAT_AMMO,
		ammoname = "AR2",
		ammoquantiy = 60
	},
	ammo_shotgun = {
		displayname = "Ammo - Shotgun (12)",
		weight = 2,
		category = INVENTORY_CAT_AMMO,
		ammoname = "Buckshot",
		ammoquantiy = 12
	},
	ammo_sniper = {
		displayname = "Ammo - Sniper (10)",
		weight = 3,
		category = INVENTORY_CAT_AMMO,
		ammoname = "SniperRound",
		ammoquantiy = 10
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
				category = translateCategory(weapon.InvCategory)
			})
		end
	end

	for k,v in pairs(items) do
		local item = {
			displayName = "SETME",
			weight = 0,
			max = 0,
			restrict = 0,
			category = INVENTORY_CAT_NONE
		}
		table.Merge(item, v)
		INVENTORY.AddItem(k, item)
	end
end
hook.Add("InventoryReload", "inventory_addItems", addInventoryItems)