#define SHOWER_FREEZING "freezing"
#define SHOWER_NORMAL "normal"
#define SHOWER_BOILING "boiling"

/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2550s by the Nanotrasen Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	use_power = NO_POWER_USE
	var/on = FALSE
	var/current_temperature = SHOWER_NORMAL
	var/datum/looping_sound/showering/soundloop
	var/reagent_id = /datum/reagent/water
	var/reaction_volume = 200

/obj/machinery/shower/Initialize()
	. = ..()
	create_reagents(reaction_volume)
	reagents.add_reagent(reagent_id, reaction_volume)

	soundloop = new(list(src), FALSE)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/shower/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(reagents)
	return ..()

/obj/machinery/shower/interact(mob/M)
	on = !on
	update_appearance()
	handle_mist()
	add_fingerprint(M)
	if(on)
		START_PROCESSING(SSmachines, src)
		process(SSMACHINES_DT)
		soundloop.start()
	else
		soundloop.stop()
		if(isopenturf(loc))
			var/turf/open/tile = loc
			tile.MakeSlippery(TURF_WET_WATER, min_wet_time = 5 SECONDS, wet_time_to_add = 1 SECONDS)

/obj/machinery/shower/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_ANALYZER)
		to_chat(user, span_notice("The water temperature seems to be [current_temperature]."))
	else
		return ..()

/obj/machinery/shower/wrench_act(mob/living/user, obj/item/I)
	..()
	to_chat(user, span_notice("You begin to adjust the temperature valve with \the [I]..."))
	if(I.use_tool(src, user, 50))
		switch(current_temperature)
			if(SHOWER_NORMAL)
				current_temperature = SHOWER_FREEZING
			if(SHOWER_FREEZING)
				current_temperature = SHOWER_BOILING
			if(SHOWER_BOILING)
				current_temperature = SHOWER_NORMAL
		user.visible_message(span_notice("[user] adjusts the shower with \the [I]."), span_notice("You adjust the shower with \the [I] to [current_temperature] temperature."))
		user.log_message("has wrenched a shower at [AREACOORD(src)] to [current_temperature].", LOG_ATTACK)
		add_hiddenprint(user)
	handle_mist()
	return TRUE


/obj/machinery/shower/update_overlays()
	. = ..()
	if(on)
		. += mutable_appearance('icons/obj/watercloset.dmi', "water", ABOVE_MOB_LAYER)

/obj/machinery/shower/proc/handle_mist()
	// If there is no mist, and the shower was turned on (on a non-freezing temp): make mist in 5 seconds
	// If there was already mist, and the shower was turned off (or made cold): remove the existing mist in 25 sec
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && current_temperature != SHOWER_FREEZING)
		addtimer(CALLBACK(src, PROC_REF(make_mist)), 5 SECONDS)

	if(mist && (!on || current_temperature == SHOWER_FREEZING))
		addtimer(CALLBACK(src, PROC_REF(clear_mist)), 25 SECONDS)

/obj/machinery/shower/proc/make_mist()
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && current_temperature != SHOWER_FREEZING)
		new /obj/effect/mist(loc)

/obj/machinery/shower/proc/clear_mist()
	var/obj/effect/mist/mist = locate() in loc
	if(mist && (!on || current_temperature == SHOWER_FREEZING))
		qdel(mist)


/obj/machinery/shower/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(on)
		wash_atom(AM)

/obj/machinery/shower/proc/wash_atom(atom/A)
	A.wash(CLEAN_RAD | CLEAN_TYPE_WEAK) // Clean radiation non-instantly
	A.wash(CLEAN_WASH)
	SEND_SIGNAL(A, COMSIG_ADD_MOOD_EVENT, "shower", /datum/mood_event/nice_shower)
	reagents.expose(A, TOUCH, reaction_volume)

	if(isliving(A))
		check_heat(A)

	if(iscarbon(A))
		var/mob/living/carbon/C = A
		C.mothdust -= 10;

/obj/machinery/shower/process(seconds_per_tick)
	if(on)
		wash_atom(loc)
		for(var/am in loc)
			var/atom/movable/movable_content = am
			if(!ismopable(movable_content)) // Mopables will be cleaned anyways by the turf wash above
				wash_atom(movable_content)
	else
		return PROCESS_KILL

/obj/machinery/shower/deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/metal(drop_location(), 3)
	qdel(src)

/obj/machinery/shower/proc/check_heat(mob/living/L)
	if(iscarbon(L))
		var/mob/living/carbon/C = L

		switch(current_temperature)
			if(SHOWER_FREEZING)
				C.adjust_bodytemperature(-3, 280)
				to_chat(L, span_warning("[src] is cold!"))
			if(SHOWER_BOILING)
				C.adjust_bodytemperature(3, 0, 330)
				to_chat(L, span_danger("[src] is hot!"))
			if(SHOWER_NORMAL)
				if(C.bodytemperature >= HUMAN_BODYTEMP_NORMAL)
					C.adjust_bodytemperature(-2, HUMAN_BODYTEMP_NORMAL)
				else
					C.adjust_bodytemperature(2, HUMAN_BODYTEMP_NORMAL)

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
