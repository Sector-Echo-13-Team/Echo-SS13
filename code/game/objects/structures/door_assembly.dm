/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	var/overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	anchored = FALSE
	density = TRUE
	max_integrity = 200
	var/state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
	var/base_name = "airlock"
	var/mineral = null
	var/obj/item/electronics/airlock/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass_type = /obj/machinery/door/airlock/glass
	var/glass = 0 // 0 = glass can be installed. 1 = glass is already installed.
	var/created_name = null
	var/heat_proof_finished = 0 //whether to heat-proof the finished airlock
	var/previous_assembly = /obj/structure/door_assembly
	var/noglass = FALSE //airlocks with no glass version, also cannot be modified with sheets
	var/material_type = /obj/item/stack/sheet/metal
	var/material_amt = 4

/obj/structure/door_assembly/Initialize()
	. = ..()
	update_appearance()
	update_name()

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	var/doorname = ""
	if(created_name)
		doorname = ", written on it is '[created_name]'"
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				. += span_notice("The anchoring bolts are <b>wrenched</b> in place, but the maintenance panel lacks <i>wiring</i>.")
			else
				. +=  span_notice("The assembly is <b>welded together</b>, but the anchoring bolts are <i>unwrenched</i>.")
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			. += span_notice("The maintenance panel is <b>wired</b>, but the circuit slot is <i>empty</i>.")
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			. += span_notice("The circuit is <b>connected loosely</b> to its slot, but the maintenance panel is <i>unscrewed and open</i>.")
	if(!mineral && !glass && !noglass)
		. += span_notice("There is a small <i>paper</i> placard on the assembly[doorname]. There are <i>empty</i> slots for glass windows and mineral covers.")
	else if(!mineral && glass && !noglass)
		. += span_notice("There is a small <i>paper</i> placard on the assembly[doorname]. There are <i>empty</i> slots for mineral covers.")
	else if(mineral && !glass && !noglass)
		. += span_notice("There is a small <i>paper</i> placard on the assembly[doorname]. There are <i>empty</i> slots for glass windows.")
	else
		. += span_notice("There is a small <i>paper</i> placard on the assembly[doorname].")

/obj/structure/door_assembly/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	for(var/obj/machinery/door/D in loc)
		if(!D.sub_door)
			to_chat(user, "There is another door here!")
			return FALSE

	user.visible_message(
			span_notice("[user] [anchored ? "unsecures" : "secures"] the airlock assembly to the floor."),
			span_notice("You start to [anchored ? "unsecure" : "secure"] the airlock assembly to the floor..."),
			span_hear("You hear wrenching.")
			)

	if(I.use_tool(src, user, 40, volume=100))
		to_chat(user, span_notice("You [anchored ? "unsecured" : "secured"] the airlock assembly."))
		name = "[anchored ? "secured " : ""]airlock assembly"
		anchored = !anchored
		return TRUE
	return FALSE

/obj/structure/door_assembly/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(mineral || glass || !anchored)
		if(!I.tool_start_check(user, src, amount=0))
			return FALSE

		if(mineral)
			var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
			user.visible_message(\
				span_notice("[user] welds the [mineral] plating off the airlock assembly."),
				span_notice("You start to weld the [mineral] plating off the airlock assembly..."))
			if(I.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("You weld the [mineral] plating off."))
				new mineral_path(loc, 2)
				var/obj/structure/door_assembly/PA = new previous_assembly(loc)
				transfer_assembly_vars(src, PA)
				return TRUE

		else if(glass)
			user.visible_message(
				span_notice("[user] welds the glass panel out of the airlock assembly."),
				span_notice("You start to weld the glass panel out of the airlock assembly"))
			if(I.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("You weld the glass panel out."))
				if(heat_proof_finished)
					new /obj/item/stack/sheet/rglass(get_turf(src))
					heat_proof_finished = 0
				else
					new /obj/item/stack/sheet/glass(get_turf(src))
				glass = 0
				return TRUE

		else if(!anchored)
			user.visible_message(
				span_notice("[user] disassembles the airlock assembly."), \
				span_notice("You start to disassemble the airlock assembly..."))
			if(I.use_tool(src, user, 40, volume=50))
				to_chat(user, span_notice("You disassemble the airlock assembly."))
				deconstruct(TRUE)
				return TRUE
		return FALSE

/obj/structure/door_assembly/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
		user.visible_message(
				span_notice("[user] cuts the wires from the airlock assembly."), \
				span_notice("You start to cut the wires from the airlock assembly...")
		)

		if(I.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
				return
			to_chat(user, span_notice("You cut the wires from the airlock assembly."))
			var/obj/item/cable = new /obj/item/stack/cable_coil(get_turf(src), 1)
			user.put_in_hands(cable)
			state = AIRLOCK_ASSEMBLY_NEEDS_WIRES
			name = "secured airlock assembly"
			return TRUE

/obj/structure/door_assembly/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		user.visible_message(span_notice("[user] removes the electronics from the airlock assembly."), \
								span_notice("You start to remove electronics from the airlock assembly..."))

		if(I.use_tool(src, user, 40, volume=100))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				return
			to_chat(user, span_notice("You remove the airlock electronics."))
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			name = "wired airlock assembly"
			var/obj/item/electronics/airlock/ae
			if (!electronics)
				ae = new/obj/item/electronics/airlock(loc)
			else
				ae = electronics
				electronics = null
				ae.forceMove(src.loc)

/obj/structure/door_assembly/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
		user.visible_message(
			span_notice("[user] finishes the airlock."),
			span_notice("You start finishing the airlock...")
		)

		if(I.use_tool(src, user, 40, volume=100))
			if(loc && state == AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
				to_chat(user, span_notice("You finish the airlock."))
				new_door()
				return TRUE
	return FALSE

/obj/structure/door_assembly/proc/new_door()
	var/obj/machinery/door/airlock/door
	if(glass)
		door = new glass_type(loc)
	else
		door = new airlock_type(loc)
	door.setDir(dir)
	door.unres_sides = electronics.unres_sides
	door.electronics = electronics
	door.heat_proof = heat_proof_finished
	door.security_level = 0
	if(electronics.one_access)
		door.req_one_access = electronics.accesses
	else
		door.req_access = electronics.accesses
	door.close_speed = electronics.close_speed
	if(created_name)
		door.name = created_name
	else
		door.name = base_name
	door.previous_airlock = previous_assembly
	electronics.forceMove(door)
	door.update_appearance()
	qdel(src)

/obj/structure/door_assembly/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/t = stripped_input(user, "Enter the name for the door.", name, created_name,MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t

	else if(istype(W, /obj/item/stack/cable_coil) && state == AIRLOCK_ASSEMBLY_NEEDS_WIRES && anchored)
		if(!W.tool_start_check(user, src, amount=1))
			return

		user.visible_message(span_notice("[user] wires the airlock assembly."), \
							span_notice("You start to wire the airlock assembly..."))
		if(W.use_tool(src, user, 40, amount=1))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_WIRES)
				return
			state = AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS
			to_chat(user, span_notice("You wire the airlock assembly."))
			name = "wired airlock assembly"
			return TRUE

	else if(istype(W, /obj/item/electronics/airlock) && state == AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
		W.play_tool_sound(src, 100)
		user.visible_message(span_notice("[user] installs the electronics into the airlock assembly."), \
							span_notice("You start to install electronics into the airlock assembly..."))
		if(do_after(user, 40, target = src))
			if(state != AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
				return
			if(!user.transferItemToLoc(W, src))
				return

			to_chat(user, span_notice("You install the airlock electronics."))
			state = AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER
			name = "near finished airlock assembly"
			electronics = W
			return TRUE

	else if(istype(W, /obj/item/stack/sheet) && (!glass || !mineral))
		var/obj/item/stack/sheet/G = W
		if(G)
			if(G.get_amount() >= 1)
				if(!noglass)
					if(!glass)
						if(istype(G, /obj/item/stack/sheet/rglass) || istype(G, /obj/item/stack/sheet/glass))
							playsound(src, 'sound/items/crowbar.ogg', 100, TRUE)
							user.visible_message(span_notice("[user] adds [G.name] to the airlock assembly."), \
												span_notice("You start to install [G.name] into the airlock assembly..."))
							if(do_after(user, 40, target = src))
								if(G.get_amount() < 1 || glass)
									return
								if(G.type == /obj/item/stack/sheet/rglass)
									to_chat(user, span_notice("You install [G.name] windows into the airlock assembly."))
									heat_proof_finished = 1 //reinforced glass makes the airlock heat-proof
									name = "near finished heat-proofed window airlock assembly"
								else
									to_chat(user, span_notice("You install regular glass windows into the airlock assembly."))
									name = "near finished window airlock assembly"
								G.use(1)
								glass = TRUE
					if(!mineral)
						if(istype(G, /obj/item/stack/sheet/mineral) && G.sheettype)
							var/M = G.sheettype
							if(G.get_amount() >= 2)
								playsound(src, 'sound/items/crowbar.ogg', 100, TRUE)
								user.visible_message(
									span_notice("[user] adds [G.name] to the airlock assembly."),
									span_notice("You start to install [G.name] into the airlock assembly...")
								)
								if(do_after(user, 40, target = src))
									if(G.get_amount() < 2 || mineral)
										return
									to_chat(user, span_notice("You install [M] plating into the airlock assembly."))
									G.use(2)
									var/mineralassembly = text2path("/obj/structure/door_assembly/door_assembly_[M]")
									var/obj/structure/door_assembly/MA = new mineralassembly(loc)

									if(MA.noglass && glass) //in case the new door doesn't support glass. prevents the new one from reverting to a normal airlock after being constructed.
										var/obj/item/stack/sheet/dropped_glass
										if(heat_proof_finished)
											dropped_glass = new /obj/item/stack/sheet/rglass(drop_location())
											heat_proof_finished = FALSE
										else
											dropped_glass = new /obj/item/stack/sheet/glass(drop_location())
										glass = FALSE
										to_chat(user, span_notice("As you finish, a [dropped_glass.singular_name] falls out of [MA]'s frame."))

									transfer_assembly_vars(src, MA, TRUE)
							else
								to_chat(user, span_warning("You need at least two sheets add a mineral cover!"))
					else
						to_chat(user, span_warning("You cannot add [G] to [src]!"))
				else
					to_chat(user, span_warning("You cannot add [G] to [src]!"))
			update_name()
			update_appearance()
	else
		return ..()


/obj/structure/door_assembly/update_overlays()
	. = ..()
	if(!glass)
		. += get_airlock_overlay("fill_construction", icon)
	else
		. += get_airlock_overlay("glass_construction", overlays_file)
	. += get_airlock_overlay("panel_c[state+1]", overlays_file)

/obj/structure/door_assembly/update_name()
	name = ""
	switch(state)
		if(AIRLOCK_ASSEMBLY_NEEDS_WIRES)
			if(anchored)
				name = "secured "
		if(AIRLOCK_ASSEMBLY_NEEDS_ELECTRONICS)
			name = "wired "
		if(AIRLOCK_ASSEMBLY_NEEDS_SCREWDRIVER)
			name = "near finished "
	name += "[heat_proof_finished ? "heat-proofed " : ""][glass ? "window " : ""][base_name] assembly"
	return ..()

/obj/structure/door_assembly/proc/transfer_assembly_vars(obj/structure/door_assembly/source, obj/structure/door_assembly/target, previous = FALSE)
	target.glass = source.glass
	target.heat_proof_finished = source.heat_proof_finished
	target.created_name = source.created_name
	target.state = source.state
	target.set_anchored(source.anchored)
	if(previous)
		target.previous_assembly = source.type
	if(electronics)
		target.electronics = source.electronics
		source.electronics.forceMove(target)
	target.update_appearance()
	target.update_name()
	qdel(source)

/obj/structure/door_assembly/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/turf/T = get_turf(src)
		if(!disassembled)
			material_amt = rand(2,4)
		new material_type(T, material_amt)
		if(glass)
			if(disassembled)
				if(heat_proof_finished)
					new /obj/item/stack/sheet/rglass(T)
				else
					new /obj/item/stack/sheet/glass(T)
			else
				new /obj/item/shard(T)
		if(mineral)
			var/obj/item/stack/sheet/mineral/mineral_path = text2path("/obj/item/stack/sheet/mineral/[mineral]")
			new mineral_path(T, 2)
	qdel(src)

/obj/structure/door_assembly/deconstruct_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return FALSE
	if(!I.tool_start_check(user, src, amount=0))
		return FALSE
	if (I.use_tool(src, user, 3 SECONDS, volume=100))
		to_chat(user, span_warning("You slice [src] apart."))
		deconstruct(FALSE)
		return TRUE

/obj/structure/door_assembly/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_DECONSTRUCT)
		return list("mode" = RCD_DECONSTRUCT, "delay" = 50, "cost" = 16)
	return FALSE

/obj/structure/door_assembly/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct [src]."))
			qdel(src)
			return TRUE
	return FALSE
