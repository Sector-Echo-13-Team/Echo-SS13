/**********************Jaunter**********************/
/obj/item/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated wormhole technology, Nanotrasen has since turned its eyes to bluespace for more accurate teleportation. The wormholes it creates are unpleasant to travel through, to say the least.\nThis jaunter has been modified to fit on your belt, providing you protection from chasms."
	icon = 'icons/obj/mining.dmi'
	icon_state = "Jaunter"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	slot_flags = ITEM_SLOT_BELT
	custom_price = 700

/obj/item/wormhole_jaunter/attack_self(mob/user)
	user.visible_message(span_notice("[user.name] activates the [src.name]!"))
	SSblackbox.record_feedback("tally", "jaunter", 1, "User") // user activated
	activate(user, TRUE)

/obj/item/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(user)
	if(!device_turf || is_centcom_level(device_turf))
		to_chat(user, span_notice("You're having difficulties getting the [src.name] to work."))
		return FALSE
	return TRUE

/obj/item/wormhole_jaunter/proc/get_destinations(mob/user)
	var/list/destinations = list()

	for(var/obj/item/beacon/B in GLOB.teleportbeacons)
		if(B.virtual_z() == virtual_z())
			destinations += B

	return destinations

/obj/item/wormhole_jaunter/proc/activate(mob/user, adjacent)
	if(!turf_check(user))
		return

	var/turf/targetturf = find_safe_turf()
	if(!targetturf)
		CRASH("Unable to find a blobstart landmark")
	var/obj/effect/portal/jaunt_tunnel/J = new (get_turf(src), 100, null, FALSE, targetturf)
	log_game("[user] Has jaunted to [loc_name(targetturf)].")
	message_admins("[user] Has jaunted to [ADMIN_VERBOSEJMP(targetturf)].")
	if(adjacent)
		try_move_adjacent(J)
	playsound(src,'sound/effects/sparks4.ogg',50,TRUE)
	qdel(src)

/obj/item/wormhole_jaunter/emp_act(power)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	var/mob/M = loc
	if(istype(M))
		var/triggered = FALSE
		if(M.get_item_by_slot(ITEM_SLOT_BELT) == src)
			if(power == 1)
				triggered = TRUE
			else if(power == 2 && prob(50))
				triggered = TRUE

		if(triggered)
			M.visible_message(span_warning("[src] overloads and activates!"))
			SSblackbox.record_feedback("tally", "jaunter", 1, "EMP") // EMP accidental activation
			activate(M)

/obj/item/wormhole_jaunter/proc/chasm_react(mob/user)
	if(user.get_item_by_slot(ITEM_SLOT_BELT) == src)
		to_chat(user, span_notice("Your [name] activates, saving you from the chasm!"))
		SSblackbox.record_feedback("tally", "jaunter", 1, "Chasm") // chasm automatic activation
		activate(user, FALSE)
	else
		to_chat(user, span_userdanger("[src] is not attached to your belt, preventing it from saving you from the chasm. RIP."))

//jaunter tunnel
/obj/effect/portal/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."
	mech_sized = TRUE //save your ripley
	innate_accuracy_penalty = 6

/obj/effect/portal/jaunt_tunnel/teleport(atom/movable/M)
	. = ..()
	if(.)
		// KERPLUNK
		playsound(M,'sound/weapons/resonator_blast.ogg',50,TRUE)
		if(iscarbon(M))
			var/mob/living/carbon/L = M
			L.Paralyze(60)
			if(ishuman(L))
				shake_camera(L, 20, 1)
				addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon, vomit)), 20)
