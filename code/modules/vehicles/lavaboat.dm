
//Boat

/obj/vehicle/ridden/lavaboat
	name = "lava boat"
	desc = "A boat used for traversing lava."
	icon_state = "goliath_boat"
	icon = 'icons/obj/lavaland/dragonboat.dmi'
	var/allowed_turf = /turf/open/lava
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	can_buckle = TRUE
	legs_required = 0
	arms_required = 0

/obj/vehicle/ridden/lavaboat/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.keytype = list(/obj/item/oar)
	D.allowed_turf_typecache = typecacheof(allowed_turf)

/obj/item/oar
	name = "oar"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "oar"
	item_state = "oar"
	lefthand_file = 'icons/mob/inhands/misc/lavaland_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/lavaland_righthand.dmi'
	desc = "Not to be confused with the kind Research hassles you for."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = LAVA_PROOF | FIRE_PROOF
//Dragon Boat


/obj/item/ship_in_a_bottle
	name = "ship in a bottle"
	desc = "A tiny ship inside a bottle."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "ship_bottle"

/obj/item/ship_in_a_bottle/attack_self(mob/user)
	to_chat(user, span_notice("You're not sure how they get the ships in these things, but you're pretty sure you know how to get it out."))
	playsound(user.loc, 'sound/effects/glassbr1.ogg', 100, TRUE)
	new /obj/vehicle/ridden/lavaboat/dragon(get_turf(src))
	qdel(src)

/obj/vehicle/ridden/lavaboat/dragon
	name = "mysterious boat"
	desc = "This boat moves where you will it, forever pushing off a perfect phantom current. The tough underbelly it boasts protects against all variety of strange terrain."
	icon_state = "dragon_boat"
	var/allowed_turfdrag = list(/turf/open/lava, /turf/open/space, /turf/open/water)

/obj/vehicle/ridden/lavaboat/dragon/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 1
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(1, 2), TEXT_SOUTH = list(1, 2), TEXT_EAST = list(1, 2), TEXT_WEST = list(1, 2)))
	D.keytype = null
	D.allowed_turf_typecache = typecacheof(allowed_turfdrag)
	D.override_allow_spacemove = TRUE

