/obj/item/gun/ballistic/automatic
	w_class = WEIGHT_CLASS_NORMAL
	var/select = 1
	can_suppress = TRUE
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)
	semi_auto = TRUE
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/smg/smgrack.ogg'
	suppressed_sound = 'sound/weapons/gun/smg/shot_suppressed.ogg'
	weapon_weight = WEAPON_MEDIUM
	pickup_sound =  'sound/items/handling/rifle_pickup.ogg'

/obj/item/gun/ballistic/automatic/update_overlays()
	. = ..()
	if(!select)
		. += "[initial(icon_state)]_semi"
	if(select == 1)
		. += "[initial(icon_state)]_burst"

/obj/item/gun/ballistic/automatic/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/toggle_firemode))
		burst_select()
	else
		..()

/obj/item/gun/ballistic/automatic/proc/burst_select()
	var/mob/living/carbon/human/user = usr
	select = !select
	if(!select)
		burst_size = 1
		fire_delay = 0
		to_chat(user, "<span class='notice'>You switch to semi-automatic.</span>")
	else
		burst_size = initial(burst_size)
		fire_delay = initial(fire_delay)
		to_chat(user, "<span class='notice'>You switch to [burst_size]-rnd burst.</span>")

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_appearance()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

// SNIPER //

/obj/item/gun/ballistic/automatic/sniper_rifle
	name = "sniper rifle"
	desc = "An anti-material rifle chambered in .50 BMG with a scope mounted on it. Its prodigious bulk requires both hands to use."
	icon_state = "sniper"
	item_state = "sniper"
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	load_sound = 'sound/weapons/gun/sniper/mag_insert.ogg'
	rack_sound = 'sound/weapons/gun/sniper/rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	fire_delay = 40
	burst_size = 1
	w_class = WEIGHT_CLASS_NORMAL
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/sniper_rifle/syndicate
	name = "syndicate sniper rifle"
	desc = "A heavily-modified .50 BMG anti-material rifle utilized by Syndicate agents. Requires both hands to fire."
	can_suppress = TRUE
	can_unsuppress = TRUE
	pin = /obj/item/firing_pin/implant/pindicate

// Old Semi-Auto Rifle //

/obj/item/gun/ballistic/automatic/surplus
	name = "surplus rifle"
	desc = "One of countless cheap, obsolete rifles found throughout the Frontier. Its lack of lethality renders it mostly a deterrent. Chambered in 10mm."
	icon_state = "surplus"
	item_state = "moistnugget"
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/m10mm/rifle
	fire_delay = 10
	burst_size = 1
	can_unsuppress = TRUE
	can_suppress = TRUE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	mag_display = TRUE

// Laser rifle (rechargeable magazine) //

/obj/item/gun/ballistic/automatic/laser
	name = "laser rifle"
	desc = "Though sometimes mocked for the relatively weak firepower of their energy weapons, the logistic miracle of rechargeable ammunition has given Nanotrasen a decisive edge over many a foe."
	icon_state = "oldrifle"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/recharge
	fire_delay = 2
	can_suppress = FALSE
	burst_size = 0
	actions_types = list()
	fire_sound = 'sound/weapons/laser.ogg'
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/ebr
	name = "\improper M514 EBR"
	desc = "A reliable, high-powered battle rifle often found in the hands of Syndicate personnel and remnants, chambered in .308 Winchester. Effective against personnel and armor alike."
	icon = 'icons/obj/guns/48x32guns.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	icon_state = "ebr"
	item_state = "ebr"
	mag_display = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/ebr
	fire_sound = 'sound/weapons/gun/rifle/shot_alt2.ogg'
	burst_size = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/gal
	name = "\improper CM-GAL-S"
	desc = "The standard issue DMR of the CMM. Dates back to the Xenofauna War, this particular model is in a carbine configuration, and, as such, is shorter than the standard model. Chambered in .308."
	icon = 'icons/obj/guns/48x32guns.dmi'
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	icon_state = "gal"
	item_state = "gal"
	mag_display = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/gal
	fire_sound = 'sound/weapons/gun/rifle/gal.ogg'
	burst_size = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/gal/inteq
	name = "\improper SsG-04"
	desc = "A marksman rifle purchased from the Colonial Minutemen and modified to suit IRMG's needs. Chambered in .308."
	icon_state = "gal-inteq"
	item_state = "gal-inteq"

/obj/item/gun/ballistic/automatic/zip_pistol
	name = "makeshift pistol"
	desc = "A makeshift zip gun cobbled together from various scrap bits and chambered in 9mm. It's a miracle it even works."
	icon_state = "ZipPistol"
	item_state = "ZipPistol"
	mag_type = /obj/item/ammo_box/magazine/zip_ammo_9mm
	can_suppress = FALSE
	actions_types = list()
	can_bayonet = FALSE
	mag_display = TRUE
	weapon_weight = WEAPON_LIGHT
