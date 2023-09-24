/obj/item/ammo_box/magazine/sniper_rounds
	name = "anti-material rifle magazine (.50 BMG)"
	desc = "A large, heavy 6-round box magazine designed for the sniper rifle. These rounds deal absurd damage, able to delimb targets, knock them on their feet, and bypass most protective equipment."
	icon_state = ".50mag"
	base_icon_state = ".50mag"
	ammo_type = /obj/item/ammo_casing/p50
	max_ammo = 6
	caliber = ".50 BMG"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/sniper_rounds/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][ammo_count() ? "-ammo" : ""]"

/obj/item/ammo_box/magazine/sniper_rounds/soporific
	name = "anti-material rifle magazine (.50 BMG soporific)"
	desc = "A large, heavy 3-round box magazine designed for the sniper rifle. These soporific rounds are completely non-lethal, but render targets asleep for a little under a minute."
	icon_state = "soporific"
	ammo_type = /obj/item/ammo_casing/p50/soporific
	max_ammo = 3

/obj/item/ammo_box/magazine/sniper_rounds/penetrator
	name = "anti-material rifle magazine (.50 BMG penetrator)"
	desc = "A large, heavy 5-round box magazine designed for the sniper rifle. These penetrator rounds deal incredible damage and will penetrate most structures, though they don't knock down or delimb targets."
	icon_state = "haemorrhage"
	ammo_type = /obj/item/ammo_casing/p50/penetrator
	max_ammo = 5
