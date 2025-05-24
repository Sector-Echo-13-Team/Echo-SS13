//No idea why this is a toolbox but I'm not fixing that right now
/obj/item/storage/toolbox/ammo
	name = "ammo can"
	desc = "A metal container for storing multiple boxes of ammunition or grenades."
	icon_state = "ammobox"
	item_state = "ammobox"
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound =  'sound/items/handling/ammobox_pickup.ogg'
	supports_variations = null
	material_flags = NONE
	has_latches = FALSE
	w_class = WEIGHT_CLASS_BULKY
	var/holdable_items = list(
		/obj/item/storage/box/ammo,
		/obj/item/mine,
		/obj/item/grenade,
		/obj/item/ammo_casing/caseless/rocket,
		/obj/item/ammo_box/magazine/ammo_stack,
		/obj/item/ammo_casing,
		/obj/item/mine,
		/obj/item/grenade,
		/obj/item/stock_parts/cell/gun
	)

/obj/item/storage/toolbox/ammo/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 400
	STR.set_holdable(holdable_items)

	unique_reskin = list(
		"EXPLOSIVE" = "ammobox_expl",
		"12ga Buckshot" = "ammobox_12ga",
		"9x18mm" = "ammobox_9mm",
		"10x22mm" = "ammobox_10mm",
		".45" = "ammobox_45",
		".38" = "ammobox_38",
		".22lr" = "ammobox_22",
		"5.7x39mm" = "ammobox_57",
		"5.56x42mm CLIP" = "ammobox_556",
		"7.62x40mm CLIP" = "ammobox_762",
		".44 Roumain" = "ammobox_44",
		"8x50mmR" = "ammobox_850",
		"8x58mm" = "ammobox_858",
		".308" = "ammobox_308",
		"7.5x64mm CLIP" = "ammobox_75",
		".300" = "ammobox_300",
		".357" = "ammobox_357",
		".299 Eoehoma" = "ammobox_299",
		".45-70" = "ammobox_4570",
		"Cell" = "ammobox_cell",
		"Pellet" = "ammobox_plt",
		".50BMG" = "ammobox_50",
		"Slug" = "ammobox_slug",
		"Lance" = "ammobox_lance",
		"None" = "ammobox",
		)

/obj/item/storage/toolbox/ammo/a850r/PopulateContents()
	name = "ammo can (8x50mmR)"
	icon_state = "ammobox_850"
	for(var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a8_50r(src)

/obj/item/storage/toolbox/ammo/a762_40/PopulateContents()
	name = "ammo can (7.62x40mm CLIP)"
	icon_state = "ammobox_762"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a762_40(src)

/obj/item/storage/toolbox/ammo/a308/PopulateContents()
	name = "ammo can (.308)"
	icon_state = "ammobox_308"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a308(src)

/obj/item/storage/toolbox/ammo/c45/PopulateContents()
	name = "ammo can (.45)"
	icon_state = "ammobox_45"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c45(src)

/obj/item/storage/toolbox/ammo/c9mm/PopulateContents()
	name = "ammo can (9x18mm)"
	icon_state = "ammobox_9mm"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c9mm(src)

/obj/item/storage/toolbox/ammo/c10mm/PopulateContents()
	name = "ammo can (10x22mm)"
	icon_state = "ammobox_10mm"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c10mm(src)

/obj/item/storage/toolbox/ammo/c38/PopulateContents()
	name = "ammo can (.38)"
	icon_state = "ammobox_38"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c38(src)

/obj/item/storage/toolbox/ammo/a44roum/PopulateContents()
	name = "ammo can (.44 Roumain)"
	icon_state = "ammobox_44"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a44roum(src)

/obj/item/storage/toolbox/ammo/c556/PopulateContents()
	name = "ammo can (5.56x42mm CLIP)"
	icon_state = "ammobox_556"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a556_42(src)

/obj/item/storage/toolbox/ammo/c556hitp/PopulateContents()
	name = "ammo can (5.56 HITP)"
	icon_state = "ammobox_556"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c556mm(src)

/obj/item/storage/toolbox/ammo/c57/PopulateContents()
	name = "ammo can (5.7x39mm)"
	icon_state = "ammobox_57"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c57x39(src)

/obj/item/storage/toolbox/ammo/c46/PopulateContents()
	name = "ammo can (4.6x30mm)"
	icon_state = "ammobox_46"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c46x30mm(src)

/obj/item/storage/toolbox/ammo/c75/PopulateContents()
	name = "ammo can (7.5x64mm CLIP)"
	icon_state = "ammobox_75"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a75clip(src)

/obj/item/storage/toolbox/ammo/c300/PopulateContents()
	name = "ammo can (.300)"
	icon_state = "ammobox_300"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a300(src)

/obj/item/storage/toolbox/ammo/c357/PopulateContents()
	name = "ammo can (.357)"
	icon_state = "ammobox_357"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a357(src)

/obj/item/storage/toolbox/ammo/c22lr/PopulateContents()
	name = "ammo can (.22LR)"
	icon_state = "ammobox_22"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c22lr(src)

/obj/item/storage/toolbox/ammo/c299/PopulateContents()
	name = "ammo can (.299 Eoehoma)"
	icon_state = "ammobox_299"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/c299(src)

/obj/item/storage/toolbox/ammo/c4570/PopulateContents()
	name = "ammo can (.45-70)"
	icon_state = "ammobox_4570"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a4570(src)

/obj/item/storage/toolbox/ammo/shotgun/PopulateContents()
	name = "ammo can (12ga)"
	icon_state = "ammobox_12ga"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a12g_buckshot(src)

/obj/item/storage/toolbox/ammo/c50bmg/PopulateContents()
	name = "ammo can (.50BMG)"
	icon_state = "ammobox_50"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a50box(src)

/obj/item/storage/toolbox/ammo/a858/PopulateContents()
	name = "ammo can (8x58mm)"
	icon_state = "ammobox_858"
	for (var/i in 1 to 4)
		new /obj/item/storage/box/ammo/a858(src)
