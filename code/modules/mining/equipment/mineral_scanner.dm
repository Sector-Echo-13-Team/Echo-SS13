#define SCANMODE_SURFACE 0
#define SCANMODE_SUBSURFACE 1

/**********************Mining Scanners**********************/
/obj/item/mining_scanner
	desc = "A scanner that checks surrounding rock for useful minerals; it can also be used to stop gibtonite detonations.\nIt has a speaker that can be toggled with <b>alt+click</b>"
	name = "manual mining scanner"
	icon = 'icons/obj/device.dmi'
	icon_state = "mining1"
	item_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_price = 200
	var/cooldown = 35
	var/current_cooldown = 0
	var/speaker = TRUE // Speaker that plays a sound when pulsed.

/obj/item/mining_scanner/AltClick(mob/user)
	speaker = !speaker
	to_chat(user, span_notice("You toggle [src]'s speaker to [speaker ? "<b>ON</b>" : "<b>OFF</b>"]."))

/obj/item/mining_scanner/attack_self(mob/user)
	if(!user.client)
		return
	if(current_cooldown <= world.time)
		current_cooldown = world.time + cooldown
		mineral_scan_pulse(get_turf(user))
		if(speaker)
			playsound(src, 'sound/effects/ping.ogg', 20)

//Debug item to identify all ore spread quickly
/obj/item/mining_scanner/admin

/obj/item/mining_scanner/admin/attack_self(mob/user)
	for(var/turf/closed/mineral/M in world)
		if(M.scan_state)
			M.icon_state = M.scan_state
	qdel(src)

/obj/item/t_scanner/adv_mining_scanner
	desc = "A scanner that automatically checks surrounding rock for useful minerals; it can also be used to stop gibtonite detonations.\nIt has a speaker that can be toggled with <b>alt+click</b>"
	name = "advanced automatic mining scanner"
	icon = 'icons/obj/device.dmi'
	icon_state = "mining0"
	item_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_price = 800
	var/cooldown = 35
	var/current_cooldown = 0
	var/range = 7
	var/speaker = FALSE // Speaker that plays a sound when pulsed.

/obj/item/t_scanner/adv_mining_scanner/AltClick(mob/user)
	speaker = !speaker
	to_chat(user, span_notice("You toggle [src]'s speaker to [speaker ? "<b>ON</b>" : "<b>OFF</b>"]."))

/obj/item/t_scanner/adv_mining_scanner/cyborg/Initialize()
	. = ..()
	toggle_on()

/obj/item/t_scanner/adv_mining_scanner/lesser
	name = "automatic mining scanner"
	desc = "A scanner that automatically checks surrounding rock for useful minerals; it can also be used to stop gibtonite detonations.\nIt has a speaker that can be toggled with <b>alt+click</b>"
	range = 4
	cooldown = 50

/obj/item/t_scanner/adv_mining_scanner/scan()
	if(current_cooldown <= world.time)
		current_cooldown = world.time + cooldown
		var/turf/t = get_turf(src)
		mineral_scan_pulse(t, range)
		if(speaker)
			playsound(src, 'sound/effects/ping.ogg', 20)

/proc/mineral_scan_pulse(turf/T, range = world.view)
	var/list/minerals = list()
	for(var/turf/closed/mineral/M in range(range, T))
		if(M.scan_state)
			minerals += M
	if(LAZYLEN(minerals))
		for(var/turf/closed/mineral/M in minerals)
			var/obj/effect/temp_visual/mining_overlay/oldC = locate(/obj/effect/temp_visual/mining_overlay) in M
			if(oldC)
				qdel(oldC)
			var/obj/effect/temp_visual/mining_overlay/C = new /obj/effect/temp_visual/mining_overlay(M)
			C.icon_state = M.scan_state

/obj/effect/temp_visual/mining_overlay
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/ore_visuals.dmi'
	appearance_flags = TILE_BOUND
	duration = 35
	pixel_x = 0
	pixel_y = 0

/obj/effect/temp_visual/mining_overlay/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration, easing = EASE_IN)

/*
		Vein Mining Scanner
*/

/obj/item/pinpointer/mineral //Definitely not the deepcore scanner with the serial number filed off
	name = "ground penetrating mining scanner"
	desc = "A handheld dowsing utility for locating material deep beneath the surface and on the surface. Alt-Click to change modes."
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining"
	custom_price = 300
	custom_premium_price = 300
	icon_suffix = "_mining"
	var/scanning_surface = FALSE
	var/cooldown = 50
	var/current_cooldown = 0
	var/range = 4
	var/scanmode = SCANMODE_SURFACE

/obj/item/pinpointer/mineral/examine(mob/user)
	. = ..()
	. += span_notice("It is currently set to [scanmode ? "scan underground" : "scan the surface"].")
	. += span_notice("You can use the scanner on an vein on harm intent to mark them as sites of no interest, causing them to no longer show up on scans.")

/obj/item/pinpointer/mineral/AltClick(mob/user) //switching modes
	..()
	if(user.canUseTopic(src, BE_CLOSE))
		if(scanning_surface||active) //prevents swithcing modes when active
			to_chat(user, span_warning("You have to turn the [src] off first before switching modes!"))
		else
			scanmode = !scanmode
			to_chat(user, span_notice("You switch the [src] to [scanmode ? "scan underground " : "scan the surface"]."))

/obj/item/pinpointer/mineral/attack_self(mob/living/user)
	switch(scanmode)
		if(SCANMODE_SUBSURFACE)
			if(active)
				toggle_on()
				user.visible_message(span_notice("[user] deactivates [user.p_their()] scanner."), span_notice("You deactivate your scanner."))
				return

			var/vein = scan_for_target()
			if(!vein)
				user.visible_message(span_notice("[user]'s scanner fails to detect any material."), span_notice("Your scanner fails to detect any material."))
				return

			toggle_on()
			user.visible_message(span_notice("[user] activates [user.p_their()] scanner."), span_notice("You activate your scanner."))
			update_icon()

		if(SCANMODE_SURFACE)
			scanning_surface = !scanning_surface
			update_icon()
			if(scanning_surface)
				START_PROCESSING(SSobj, src)
				user.visible_message(span_notice("[user] activates [user.p_their()] scanner."), span_notice("You activate your scanner."))
			else
				STOP_PROCESSING(SSobj, src)
				user.visible_message(span_notice("[user] deactivates [user.p_their()] scanner."), span_notice("You deactivate your scanner."))
			playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

/obj/item/pinpointer/mineral/process(seconds_per_tick)
	switch(scanmode)
		if(SCANMODE_SUBSURFACE)
			if(active && target && target.loc == null)
				target = null
				toggle_on()
			. = ..() //returns pinpointer code if its scanning for deepcore spots

		if(SCANMODE_SURFACE)
			if(!scanning_surface)
				STOP_PROCESSING(SSobj, src)
				return null
			scan_minerals()

/obj/item/pinpointer/mineral/proc/scan_minerals() //used by the surface mining mode
	if(current_cooldown <= world.time)
		current_cooldown = world.time + cooldown
		var/turf/t = get_turf(src)
		mineral_scan_pulse(t, range)
		playsound(src, 'sound/effects/ping.ogg', 20)

/obj/item/pinpointer/mineral/update_overlays()
	. = ..()
	var/mutable_appearance/scan_mode_overlay
	switch(scanmode)
		if(SCANMODE_SURFACE)
			if(scanning_surface)
				scan_mode_overlay = mutable_appearance(icon, "on_overlay")
		if(SCANMODE_SUBSURFACE)
			if(active)
				scan_mode_overlay = mutable_appearance(icon, "pinpointing_overlay")
		else
			scan_mode_overlay = mutable_appearance(icon, "null")
	. += scan_mode_overlay

/obj/item/pinpointer/mineral/scan_for_target()
	var/turf/here = get_turf(src)
	var/located_dist
	var/obj/structure/located_vein
	for(var/obj/structure/vein/I in GLOB.ore_veins)
		if(I.z == 0 || I.virtual_z() != here.virtual_z() || I.detectable == FALSE)
			continue
		if(located_vein)
			var/new_dist = get_dist(here, get_turf(I))
			if(new_dist < located_dist)
				located_dist = new_dist
				located_vein = I
		else
			located_dist = get_dist(here, get_turf(I))
			located_vein = I
	target = located_vein
	return located_vein

//For scanning ore veins of their contents
/obj/item/pinpointer/mineral/afterattack(obj/structure/vein/our_vein, mob/user, proximity)
	. = ..()
	if(!proximity || !istype(our_vein,/obj/structure/vein))
		return
	playsound(src, 'sound/effects/fastbeep.ogg', 10)
	if(user.a_intent == INTENT_HARM)
		if(our_vein.detectable == TRUE)
			to_chat(user,span_notice("You blacklist the vein from the scanner's telemetry, and will no longer be detected as a site of interest to the scanner."))
			our_vein.detectable = FALSE
			return
		else
			to_chat(user,span_notice("You mark vein into the scanner's telemetry, allowing it be located by underground scans."))
			our_vein.detectable = TRUE
			return

	if(our_vein.vein_contents.len > 0)
		to_chat(user, span_notice("Class [our_vein.vein_class] ore vein with [our_vein.mining_charges] possible ore lodes found."))
		for(var/our_ore in our_vein.vein_contents)
			to_chat(user, span_notice("\tExtractable amounts of [our_ore?:name]."))
	else
		to_chat(user, span_notice("No notable mineral deposits found in [our_vein]."))
