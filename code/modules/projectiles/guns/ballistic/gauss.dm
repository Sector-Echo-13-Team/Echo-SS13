/obj/item/gun/ballistic/automatic/powered/gauss
	name = "prototype gauss rifle"
	desc = "An experimental Nanotrasen rifle with a high capacity. Useful for putting down crowds. Chambered in ferromagnetic pellets."
	icon_state = "gauss"
	item_state = "arg"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/gauss
	fire_sound = 'sound/weapons/gun/gauss/magrifle.ogg'
	load_sound = 'sound/weapons/gun/gauss/rifle_reload.ogg'
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 3
	spread = 0
	mag_display = TRUE
	empty_indicator = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	charge_sections = 4
	ammo_x_offset = 2

/obj/item/gun/ballistic/automatic/powered/gauss/modelh
	name = "Model H"
	desc = "Standard-issue pistol of the Solarian Confederation. Fires slow ferromagnetic slugs at a high energy cost, though they rend flesh with ease."
	mag_type = /obj/item/ammo_box/magazine/modelh
	icon_state = "model-h"
	item_state = "model-h"
	fire_sound = 'sound/weapons/gun/gauss/modelh.ogg'
	load_sound = 'sound/weapons/gun/gauss/pistol_reload.ogg'
	cell_type = /obj/item/stock_parts/cell/gun/solgov
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	fire_delay = 0 //pistol
	mag_display = FALSE
	empty_indicator = FALSE

/obj/item/gun/ballistic/automatic/powered/gauss/claris
	name = "Claris"
	desc = "An antiquated Solarian rifle. Chambered in ferromagnetic pellets, just as the founding Solarians intended."
	mag_type = /obj/item/ammo_box/magazine/internal/claris
	icon = 'icons/obj/guns/48x32guns.dmi'
	icon_state = "claris"
	item_state = "claris"
	fire_sound = 'sound/weapons/gun/gauss/claris.ogg'
	load_sound = 'sound/weapons/gun/gauss/sniper_reload.ogg'
	cell_type = /obj/item/stock_parts/cell/gun/solgov
	fire_delay = 2
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	casing_ejector = FALSE
	mag_display = FALSE
	empty_indicator = FALSE

/obj/item/gun/ballistic/automatic/powered/gauss/gar
	name = "Solar 'GAR' Assault Rifle"
	desc = "A Solarian assault rifle, unusually modern for its producers. Launches ferromagnetic lances at alarming speeds."
	mag_type = /obj/item/ammo_box/magazine/gar
	icon = 'icons/obj/guns/48x32guns.dmi'
	icon_state = "gar"
	item_state = "gar"
	fire_sound = 'sound/weapons/gun/gauss/gar.ogg'
	load_sound = 'sound/weapons/gun/gauss/rifle_reload.ogg'
	cell_type = /obj/item/stock_parts/cell/gun/solgov
	burst_size = 2
	fire_delay = 2
	actions_types = list()
	empty_indicator = FALSE

/obj/item/gun/ballistic/automatic/powered/gauss/gar/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS) //setiting this to 0.1 breaks auotfire, not sure why, so we use the standard fire rate but in 2 shot bursts to shoot 'faster'
