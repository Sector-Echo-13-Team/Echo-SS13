//TODO: rename this file to lmg.dm and: /obj/item/gun/ballistic/automatic/hmg --> /obj/item/gun/ballistic/automatic/lmg

/obj/item/gun/ballistic/automatic/hmg
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = 0
	weapon_weight = WEAPON_HEAVY
	burst_size = 1
	actions_types = list(/datum/action/item_action/deploy_bipod) //this is on hmg, as I need the same mechanics for a future gun. ideally, this would be an attachment, but that's still pending
	drag_slowdown = 1.5
	fire_delay = 1

	spread = 4
	spread_unwielded = 80
	recoil = 1
	recoil_unwielded = 4
	wield_slowdown = 3

	///does this have a bipod?
	var/has_bipod = FALSE
	///is the bipod deployed?
	var/bipod_deployed = FALSE
	///how long do we need to deploy the bipod?
	var/deploy_time = 2 SECONDS

	///we add these two values to recoi/spread when we have the bipod deployed
	var/deploy_recoil_bonus = -1
	var/deploy_spread_bonus = -5

	var/list/deployable_on_structures = list(
	/obj/structure/table,
	/obj/structure/barricade,
	/obj/structure/bed,
	/obj/structure/chair,
	/obj/structure/railing,
	/obj/structure/flippedtable
	)


/obj/item/gun/ballistic/automatic/hmg/Initialize()
	. = ..()
	for(var/datum/action/item_action/deploy_bipod/action as anything in actions_types)
		if(!has_bipod)
			qdel(action)

/obj/item/gun/ballistic/automatic/hmg/ComponentInitialize()
	. = ..()
	RegisterSignal(src, list(COMSIG_ITEM_EQUIPPED,COMSIG_MOVABLE_MOVED), PROC_REF(retract_bipod))

/datum/action/item_action/deploy_bipod //TODO: Make this an accessory when that's added
	name = "Deploy Bipod"
	desc = "Deploy the bipod when bracing against something to increase accuracy."

/obj/item/gun/ballistic/automatic/hmg/ui_action_click(mob/user, action)
	if(!istype(action, /datum/action/item_action/deploy_bipod))
		return ..()
	if(!bipod_deployed)
		deploy_bipod(user)
	else
		retract_bipod(user=user)

/obj/item/gun/ballistic/automatic/hmg/proc/deploy_bipod(mob/user)
	//we check if we can actually deploy the thing
	var/can_deploy = TRUE
	var/mob/living/wielder = user

	if(!wielder)
		return

	if(!wielded_fully)
		to_chat(user, "<span class='warning'>You need to fully grip [src] to deploy it's bipod!</span>")
		return

	if(wielder.body_position != LYING_DOWN) //are we braced against the ground? if not, we check for objects to brace against
		can_deploy = FALSE

		for(var/direction_to_check as anything in GLOB.cardinals) //help
			var/turf/open/turf_to_check = get_step(get_turf(src),direction_to_check)
			for(var/obj/structure/checked_struct as anything in turf_to_check.contents) //while you can fire in non-braced directions, this makes it so you have to get good positioning to fire standing up.
				for(var/checking_allowed as anything in deployable_on_structures)
					if(istype(checked_struct, checking_allowed)) //help if you know how to write this better
						can_deploy = TRUE
						break


	if(!can_deploy)
		to_chat(user, "<span class='warning'>You need to brace against something to deploy [src]'s bipod! Either lie on the floor or stand next to a waist high object like a table!</span>")
		return
	if(!do_mob(user, src, deploy_time, FALSE, TRUE, CALLBACK(src, PROC_REF(is_wielded))))
		to_chat(user, "<span class='warning'>You need to hold still to deploy [src]'s bipod!</span>")
		return
	playsound(src, 'sound/machines/click.ogg', 75, TRUE)
	to_chat(user, "<span class='notice'>You deploy [src]'s bipod.</span>")
	bipod_deployed = TRUE

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(retract_bipod))
	update_appearance()

/obj/item/gun/ballistic/automatic/hmg/proc/retract_bipod(atom/source, mob/user)
	SIGNAL_HANDLER
	if(!bipod_deployed)
		return
	if(!user || !ismob(user))
		user = loc
	playsound(src, 'sound/machines/click.ogg', 75, TRUE)
	to_chat(user, "<span class='notice'>The bipod undeploys itself.</span>")
	bipod_deployed = FALSE

	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	update_appearance()


/obj/item/gun/ballistic/automatic/hmg/on_unwield(obj/item/source, mob/user)
	. = ..()
	retract_bipod(user=user)

/obj/item/gun/ballistic/automatic/hmg/calculate_recoil(mob/user, recoil_bonus = 0)
	var/gunslinger_bonus = 1
	var/total_recoil = recoil_bonus
	if(bipod_deployed)
		total_recoil += deploy_recoil_bonus
	if(HAS_TRAIT(user, TRAIT_GUNSLINGER)) //gunslinger penalty
		total_recoil += gunslinger_bonus
	total_recoil = clamp(total_recoil,0,INFINITY)
	return total_recoil

/obj/item/gun/ballistic/automatic/hmg/calculate_spread(mob/user, bonus_spread)
	var/gunslinger_bonus = 4
	var/total_spread = bonus_spread
	if(bipod_deployed)
		total_spread += deploy_spread_bonus
	if(HAS_TRAIT(user, TRAIT_GUNSLINGER)) //gunslinger penalty
		total_spread += gunslinger_bonus
	total_spread = clamp(total_spread,0,INFINITY)
	return total_spread


/obj/item/gun/ballistic/automatic/hmg/update_icon_state()
	. = ..()
	item_state = "[initial(item_state)][bipod_deployed ? "_deployed" : ""]"

/obj/item/gun/ballistic/automatic/hmg/update_overlays()
	. = ..()
	if(has_bipod)
		. += "[base_icon_state || initial(icon_state)][bipod_deployed ? "_deployed" : "_undeployed"]"


// L6 SAW //

/obj/item/gun/ballistic/automatic/hmg/l6_saw
	name = "\improper L6 SAW"
	desc = "A heavy machine gun, designated 'L6 SAW'. Chambered in 7.12x82mm."
	icon_state = "l6"
	item_state = "l6closedmag"
	base_icon_state = "l6"
	mag_type = /obj/item/ammo_box/magazine/mm712x82
	can_suppress = FALSE
	spread = 7
	bolt_type = BOLT_TYPE_OPEN
	mag_display = TRUE
	mag_display_ammo = TRUE
	tac_reloads = FALSE
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	rack_sound = 'sound/weapons/gun/l6/l6_rack.ogg'
	suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	manufacturer = MANUFACTURER_SCARBOROUGH
	var/cover_open = FALSE

/obj/item/gun/ballistic/automatic/hmg/l6_saw/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

/obj/item/gun/ballistic/automatic/hmg/l6_saw/examine(mob/user)
	. = ..()
	. += "<b>alt + click</b> to [cover_open ? "close" : "open"] the dust cover."
	if(cover_open && magazine)
		. += "<span class='notice'>It seems like you could use an <b>empty hand</b> to remove the magazine.</span>"

/obj/item/gun/ballistic/automatic/hmg/l6_saw/AltClick(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	playsound(user, 'sound/weapons/gun/l6/l6_door.ogg', 60, TRUE)
	update_appearance()

/obj/item/gun/ballistic/automatic/hmg/l6_saw/update_overlays()
	. = ..()
	. += "l6_door_[cover_open ? "open" : "closed"]"

/obj/item/gun/ballistic/automatic/hmg/l6_saw/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return
	else
		. = ..()
		update_appearance()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/gun/ballistic/automatic/hmg/l6_saw/attack_hand(mob/user)
	if (loc != user)
		..()
		return
	if (!cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is closed! Open it before trying to remove the magazine!</span>")
		return
	..()

/obj/item/gun/ballistic/automatic/hmg/l6_saw/attackby(obj/item/A, mob/user, params)
	if(!cover_open && istype(A, mag_type))
		to_chat(user, "<span class='warning'>[src]'s dust cover prevents a magazine from being fit.</span>")
		return
	..()

/obj/item/gun/ballistic/automatic/hmg/solar //This thing fires a 5.56 equivalent, that's an LMG, not an HMG, get out
	name = "\improper Solar"
	desc = "A TerraGov LMG-169 designed in 169 FS, nicknamed 'Solar.' A inscription reads: 'PROPERTY OF TERRAGOV', with 'TERRAGOV' poorly scribbled out, and replaced by 'SOLAR ARMORIES'. Chambered in 4.73×33mm caseless ammunition."
	icon_state = "solar"
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/rifle47x33mm
	spread = 7
	can_suppress = FALSE
	can_bayonet = FALSE
	mag_display = TRUE
	w_class = WEIGHT_CLASS_BULKY
	manufacturer = MANUFACTURER_SOLARARMORIES

/obj/item/gun/ballistic/automatic/hmg/solar/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

/obj/item/gun/ballistic/automatic/hmg/skm_lmg
	name = "\improper SKM-24u"
	desc = "What appears to be a standard SKM-24 at first glance is actually a light machine gun conversion, with an extended, heavy barrel and overhauled internals. Its weight, bulk, and robust fire rate make it difficult to handle without using the bipod in a prone position or against appropriate cover such as a table. Chambered in 7.62x40mm CLIP."

	icon = 'icons/obj/guns/48x32guns.dmi'
	icon_state = "skm_lmg"
	item_state = "skm_lmg"

	fire_sound = 'sound/weapons/gun/rifle/skm.ogg'
	rack_sound = 'sound/weapons/gun/rifle/skm_cocked.ogg'
	load_sound = 'sound/weapons/gun/rifle/skm_reload.ogg'
	load_empty_sound = 'sound/weapons/gun/rifle/skm_reload.ogg'
	eject_sound = 'sound/weapons/gun/rifle/skm_unload.ogg'
	eject_empty_sound = 'sound/weapons/gun/rifle/skm_unload.ogg'


	mag_display = TRUE
	special_mags = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	manufacturer = MANUFACTURER_IMPORT
	mag_type = /obj/item/ammo_box/magazine/skm_762_40


	spread = 7 //you can hipfire, but why?
	spread_unwielded = 25

	recoil = 1 //identical to other LMGS
	recoil_unwielded = 4 //same as skm

	wield_slowdown = 1 //not as severe as other lmgs, but worse than the normal skm
	wield_delay = 0.85 SECONDS //faster than normal lmgs, slower than stock skm

	has_bipod = TRUE

/obj/item/gun/ballistic/automatic/hmg/skm_lmg/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.13 SECONDS) //slower than other lmgs but faster than skm and most smgs
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/ballistic/automatic/hmg/skm_lmg/extended //spawns with the proper extended magazine, for erts
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/hmg/skm_lmg/extended/Initialize()
	. = ..()
	magazine = new /obj/item/ammo_box/magazine/skm_762_40/extended(src)
	chamber_round()

/obj/item/gun/ballistic/automatic/hmg/skm_lmg/drum_mag //spawns with a drum, maybe not for erts but admin enhanced ERTS? when things really go to shit
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/hmg/skm_lmg/drum_mag/Initialize()
	. = ..()
	magazine = new /obj/item/ammo_box/magazine/skm_762_40/drum(src)
	chamber_round()
