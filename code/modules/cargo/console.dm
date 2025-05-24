#define SP_LINKED 1
#define SP_READY 2
#define SP_LAUNCH 3
#define SP_UNLINK 4
#define SP_UNREADY 5

/obj/machinery/computer/cargo
	name = "outpost communications console"
	desc = "This console allows the user to communicate with a nearby outpost to \
			purchase supplies and manage missions. Purchases will be delivered to your hangar's delivery zone."
	icon_screen = "supply_express"
	circuit = /obj/item/circuitboard/computer/cargo
	light_color = COLOR_BRIGHT_ORANGE

	/// The ship we reside on for ease of access
	var/datum/overmap/ship/controlled/current_ship
	var/contraband = FALSE
	var/self_paid = FALSE
	var/safety_warning = "For safety reasons, the automated supply shuttle \
		cannot transport live organisms, human remains, classified nuclear weaponry, \
		homing beacons or machinery housing any form of artificial intelligence."
	/// var that tracks message cooldown
	var/message_cooldown

	var/blockade_warning = "Bluespace instability detected. Delivery impossible."
	var/message
	var/list/supply_pack_data
	/// The account to charge purchases to, defaults to the cargo budget
	var/datum/bank_account/charge_account

/obj/machinery/computer/cargo/Initialize()
	. = ..()
	var/obj/item/circuitboard/computer/cargo/board = circuit
	contraband = board.contraband
	if (board.obj_flags & EMAGGED)
		obj_flags |= EMAGGED
	else
		obj_flags &= ~EMAGGED

/obj/machinery/computer/cargo/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(user)
		user.visible_message(span_warning("[user] swipes a suspicious card through [src]!"),
		span_notice("You adjust [src]'s routing and receiver spectrum, unlocking special supplies and contraband."))

	obj_flags |= EMAGGED
	contraband = TRUE

	// This also permamently sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.contraband = TRUE
	board.obj_flags |= EMAGGED
	update_static_data(user)

/obj/machinery/computer/cargo/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	current_ship = port.current_ship

/obj/machinery/computer/cargo/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OutpostCommunications", name)
		ui.open()
		if(!charge_account)
			reconnect()

/obj/machinery/computer/cargo/ui_static_data(mob/user)
	. = ..()
	var/outpost_docked = istype(current_ship.docked_to, /datum/overmap/outpost)
	if(outpost_docked)
		generate_pack_data()
	else
		supply_pack_data = list()

/obj/machinery/computer/cargo/ui_data(mob/user)
	var/list/data = list()

	var/outpost_docked = istype(current_ship.docked_to, /datum/overmap/outpost)

	data["onShip"] = !isnull(current_ship)
	data["shipFaction"] = current_ship.source_template.faction.name
	data["numMissions"] = current_ship ? LAZYLEN(current_ship.missions) : 0
	data["maxMissions"] = current_ship ? current_ship.max_missions : 0
	data["outpostDocked"] = outpost_docked
	data["points"] = charge_account ? charge_account.account_balance : 0
	data["siliconUser"] = user.has_unlimited_silicon_privilege && check_ship_ai_access(user)
	data["supplies"] = list()
	message = "Purchases will be delivered to your hangar's delivery zone."
	if(SSshuttle.supplyBlocked)
		message = blockade_warning
	data["message"] = message
	data["supplies"] = supply_pack_data

	data["shipMissions"] = list()
	data["outpostMissions"] = list()

	if(current_ship)
		for(var/datum/mission/outpost/M as anything in current_ship.missions)
			data["shipMissions"] += list(M.get_tgui_info())
		if(outpost_docked)
			var/datum/overmap/outpost/out = current_ship.docked_to
			for(var/datum/mission/outpost/M as anything in out.missions)
				data["outpostMissions"] += list(M.get_tgui_info())

	return data

/obj/machinery/computer/cargo/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("withdrawCash")
			var/val = text2num(params["value"])
			// no giving yourself money
			if(!charge_account || !val || val <= 0)
				return
			if(charge_account.adjust_money(-val, CREDIT_LOG_WITHDRAW))
				var/obj/item/holochip/cash_chip = new /obj/item/holochip(drop_location(), val)
				if(ishuman(usr))
					var/mob/living/carbon/human/user = usr
					user.put_in_hands(cash_chip)
				playsound(src, 'sound/machines/twobeep_high.ogg', 50, TRUE)
				src.visible_message(span_notice("[src] dispenses a holochip."))
			return TRUE

		if("purchase")
			var/list/purchasing = params["cart"]
			var/total_cost = text2num(params["total"])
			var/datum/overmap/outpost/current_outpost = current_ship.docked_to
			if(!istype(current_ship.docked_to) || purchasing.len == 0)
				return

			if(!charge_account.adjust_money(-total_cost, CREDIT_LOG_CARGO))
				return

			var/list/unprocessed_packs = list()
			for(var/list/current_item as anything in purchasing)
				unprocessed_packs += locate(current_item["ref"]) in current_outpost.supply_packs

			while(unprocessed_packs.len > 0)
				var/datum/supply_pack/initial_pack = unprocessed_packs[1]
				if(initial_pack.no_bundle)
					make_single_order(usr, initial_pack)
					unprocessed_packs -= initial_pack
					continue

				var/list/combo_packs = list()
				var/combo_group = initial_pack.group
				for(var/datum/supply_pack/current_pack in unprocessed_packs)
					if(current_pack.group != combo_group || current_pack.no_bundle)
						continue
					combo_packs += current_pack
					unprocessed_packs -= current_pack

				if(combo_packs.len == 1) // No items could be bundled with the initial pack, make a single order
					make_single_order(usr, initial_pack)
					unprocessed_packs -= initial_pack
					continue

				make_combo_order(usr, combo_packs)
				unprocessed_packs -= combo_packs

		if("mission-act")
			var/datum/mission/outpost/mission = locate(params["ref"])
			var/obj/docking_port/mobile/D = SSshuttle.get_containing_shuttle(src)
			var/datum/overmap/ship/controlled/ship = D.current_ship
			var/datum/overmap/outpost/outpost = ship.docked_to
			if(!istype(outpost) || mission.source_outpost != outpost) // important to check these to prevent href fuckery
				return
			if(!mission.accepted)
				if(LAZYLEN(ship.missions) >= ship.max_missions)
					return
				mission.accept(ship, loc)
				return TRUE
			else if(mission.servant == ship)
				if(mission.can_complete())
					mission.turn_in()
				else if(tgui_alert(usr, "Give up on [mission]?", src, list("Yes", "No")) == "Yes")
					mission.give_up()
				return TRUE

/obj/machinery/computer/cargo/proc/make_single_order(mob/user, datum/supply_pack/pack)
	var/name = "*None Provided*"
	var/rank = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		name = H.get_authentification_name()
		rank = H.get_assignment(hand_first = TRUE)
	else if(issilicon(user))
		name = user.real_name
		rank = "Silicon"
	var/datum/supply_order/SO = new(pack, name, rank, user.ckey, "", ordering_outpost = current_ship.docked_to)
	var/obj/hangar_crate_spawner/crate_spawner = return_crate_spawner()
	crate_spawner.handle_order(SO)
	update_appearance() // ??????????????????
	return TRUE

/obj/machinery/computer/cargo/proc/make_combo_order(mob/user, list/combo_packs)
	var/name = "*None Provided*"
	var/rank = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		name = H.get_authentification_name()
		rank = H.get_assignment(hand_first = TRUE)
	else if(issilicon(user))
		name = user.real_name
		rank = "Silicon"
	var/datum/supply_order/combo/SO = new(combo_packs, name, rank, user.ckey, "", ordering_outpost = current_ship.docked_to)
	var/obj/hangar_crate_spawner/crate_spawner = return_crate_spawner()
	crate_spawner.handle_order(SO)
	update_appearance() // ??????????????????
	return TRUE

/obj/machinery/computer/cargo/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	reconnect(port)

/obj/machinery/computer/cargo/proc/reconnect(obj/docking_port/mobile/port)
	if(!port)
		var/area/ship/current_area = get_area(src)
		if(!istype(current_area))
			return
		port = current_area.mobile_port
	if(!port)
		return
	charge_account = port.current_ship.ship_account

/obj/machinery/computer/cargo/attackby(obj/item/W, mob/living/user, params)
	var/value = W.get_item_credit_value()
	if(value && charge_account)
		charge_account.adjust_money(value, CREDIT_LOG_DEPOSIT)
		to_chat(user, span_notice("You deposit [W]. The Vessel Budget is now [charge_account.account_balance] cr."))
		qdel(W)
		return TRUE
	..()

/obj/machinery/computer/cargo/proc/generate_pack_data()
	supply_pack_data = list()

	if(!current_ship.docked_to)
		return supply_pack_data

	var/datum/overmap/outpost/outpost_docked = current_ship.docked_to

	if(!istype(outpost_docked))
		return supply_pack_data

	for(var/datum/supply_pack/current_pack as anything in outpost_docked.supply_packs)
		if(!supply_pack_data[current_pack.group])
			supply_pack_data[current_pack.group] = list(
				"name" = current_pack.group,
				"packs" = list()
			)
		if((current_pack.hidden))
			continue
		var/same_faction = current_pack.faction ? current_pack.faction.allowed_faction(current_ship.source_template.faction) : FALSE
		var/discountedcost = (same_faction && current_pack.faction_discount) ? current_pack.cost - (current_pack.cost * (current_pack.faction_discount * 0.01)) : null
		if(current_pack.faction_locked && !same_faction)
			continue
		supply_pack_data[current_pack.group]["packs"] += list(list(
			"name" = current_pack.name,
			"cost" = current_pack.cost,
			"discountedcost" = discountedcost ? discountedcost : null,
			"discountpercent" = current_pack.faction_discount,
			"faction_locked" = current_pack.faction_locked, //this will only show if you are same faction, so no issue
			"ref" = REF(current_pack),
			"desc" = (current_pack.desc || current_pack.name) + (discountedcost ? "\n-[current_pack.faction_discount]% off due to your faction affiliation.\nWas [current_pack.cost]" : "") + (current_pack.faction_locked ? "\nYou are able to purchase this item due to your faction affiliation." : ""), // If there is a description, use it. Otherwise use the pack's name.
			"no_bundle" = current_pack.no_bundle
		))


/obj/machinery/computer/cargo/proc/return_crate_spawner()
	var/obj/hangar_crate_spawner/spawner
	spawner = current_ship.shuttle_port.docked.crate_spawner
	return spawner

/obj/machinery/computer/cargo/retro
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-retro"
	deconpath = /obj/structure/frame/computer/retro

/obj/machinery/computer/cargo/solgov
	icon = 'icons/obj/machines/retro_computer.dmi'
	icon_state = "computer-solgov"
	deconpath = /obj/structure/frame/computer/solgov
