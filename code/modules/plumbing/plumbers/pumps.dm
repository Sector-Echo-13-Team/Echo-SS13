///We pump liquids from activated(plungerated) geysers to a plumbing outlet. We need to be wired.
/obj/machinery/plumbing/liquid_pump
	name = "liquid pump"
	desc = "Pump up those sweet liquids from under the surface. Uses thermal energy from geysers to power itself." //better than placing 200 cables, because it wasnt fun
	icon = 'icons/obj/plumbing/plumbers.dmi'
	icon_state = "pump"
	base_icon_state = "pump"
	anchored = FALSE
	density = TRUE
	idle_power_usage = IDLE_DRAW_MINIMAL
	active_power_usage = ACTIVE_DRAW_MEDIUM

	rcd_cost = 30
	rcd_delay = 40

	///units we pump per process
	var/pump_power = 1
	///set to true if the loop couldnt find a geyser in process, so it remembers and stops checking every loop until moved. more accurate name would be absolutely_no_geyser_under_me_so_dont_try
	var/geyserless = FALSE
	///The geyser object
	var/obj/structure/geyser/geyser
	///volume of our internal buffer
	var/volume = 200

/obj/machinery/plumbing/liquid_pump/Initialize(mapload, bolt)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt)

///please note that the component has a hook in the parent call, wich handles activating and deactivating
/obj/machinery/plumbing/liquid_pump/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		geyser = null
		update_appearance()
		geyserless = FALSE //we switched state, so lets just set this back aswell

/obj/machinery/plumbing/liquid_pump/process(seconds_per_tick)
	if(!anchored || panel_open || geyserless)
		return

	if(!geyser)
		for(var/obj/structure/geyser/G in loc.contents)
			geyser = G
			update_appearance()
		if(!geyser) //we didnt find one, abort
			geyserless = TRUE
			visible_message(span_warning("The [name] makes a sad beep!"))
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
			return

	pump(seconds_per_tick)

///pump up that sweet geyser nectar
/obj/machinery/plumbing/liquid_pump/proc/pump(seconds_per_tick)
	if(!geyser || !geyser.reagents)
		return
	geyser.reagents.trans_to(src, pump_power * seconds_per_tick)

/obj/machinery/plumbing/liquid_pump/update_icon_state()
	if(geyser)
		icon_state = "[base_icon_state]-on"
	else if(panel_open)
		icon_state = "[base_icon_state]-open"
	else
		icon_state = "[base_icon_state]"
	return ..()
