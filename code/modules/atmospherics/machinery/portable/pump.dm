#define PUMP_OUT "out"
#define PUMP_IN "in"
#define PUMP_MAX_PRESSURE (ONE_ATMOSPHERE * 25)
#define PUMP_MIN_PRESSURE (ONE_ATMOSPHERE / 10)
#define PUMP_DEFAULT_PRESSURE (ONE_ATMOSPHERE)

/obj/machinery/portable_atmospherics/pump
	name = "portable air pump"
	icon_state = "psiphon:0"
	density = TRUE

	var/on = FALSE
	var/direction = PUMP_OUT
	var/target_pressure = ONE_ATMOSPHERE
	var/obj/machinery/atmospherics/components/binary/pump/pump

	volume = 1000

/obj/machinery/portable_atmospherics/pump/Initialize()
	. = ..()
	pump = new(src, FALSE)
	pump.on = TRUE
	pump.machine_stat = 0
	SSair.add_to_rebuild_queue(pump)

/obj/machinery/portable_atmospherics/pump/Destroy()
	var/turf/T = get_turf(src)
	T.assume_air(air_contents)
	air_update_turf()
	QDEL_NULL(pump)
	return ..()

/obj/machinery/portable_atmospherics/pump/update_icon_state()
	icon_state = "psiphon:[on]"
	return ..()

/obj/machinery/portable_atmospherics/pump/update_overlays()
	. = ..()
	if(holding)
		. += "siphon-open"
	if(connected_port)
		. += "siphon-connector"

/obj/machinery/portable_atmospherics/pump/process_atmos(seconds_per_tick)
	..()
	if(!on)
		pump.airs[1] = null
		pump.airs[2] = null
		return

	var/turf/T = get_turf(src)
	if(direction == PUMP_OUT) // Hook up the internal pump.
		pump.airs[1] = holding ? holding.air_contents : air_contents
		pump.airs[2] = holding ? air_contents : T.return_air()
	else
		pump.airs[1] = holding ? air_contents : T.return_air()
		pump.airs[2] = holding ? holding.air_contents : air_contents

	pump.process_atmos() // Pump gas.
	if(!holding)
		air_update_turf() // Update the environment if needed.

/obj/machinery/portable_atmospherics/pump/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(is_operational)
		if(prob(50 / severity))
			on = !on
		if(prob(100 / severity))
			direction = PUMP_OUT
		pump.target_pressure = rand(0, 100 * ONE_ATMOSPHERE)
		update_appearance()

/obj/machinery/portable_atmospherics/pump/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(.)
		if(close_valve)
			if(on)
				on = FALSE
				update_appearance()
		else if(on && holding && direction == PUMP_OUT)
			investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortablePump", name)
		ui.open()

/obj/machinery/portable_atmospherics/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["direction"] = direction == PUMP_IN ? TRUE : FALSE
	data["connected"] = connected_port ? TRUE : FALSE
	data["pressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["target_pressure"] = round(pump.target_pressure ? pump.target_pressure : 0)
	data["default_pressure"] = round(PUMP_DEFAULT_PRESSURE)
	data["min_pressure"] = round(PUMP_MIN_PRESSURE)
	data["max_pressure"] = round(PUMP_MAX_PRESSURE)

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		data["holding"]["pressure"] = round(holding.air_contents.return_pressure())
	else
		data["holding"] = null
	return data

/obj/machinery/portable_atmospherics/pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			if(on && !holding)
				var/plasma = air_contents.get_moles(GAS_PLASMA)
				var/n2o = air_contents.get_moles(GAS_NITROUS)
				if(n2o || plasma)
					message_admins("[ADMIN_LOOKUPFLW(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [ADMIN_VERBOSEJMP(src)]")
					log_admin("[key_name(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [AREACOORD(src)]")
			else if(on && direction == PUMP_OUT)
				investigate_log("[key_name(usr)] started a transfer into [holding].", INVESTIGATE_ATMOS)
			. = TRUE
		if("direction")
			if(direction == PUMP_OUT)
				direction = PUMP_IN
			else
				if(on && holding)
					investigate_log("[key_name(usr)] started a transfer into [holding].", INVESTIGATE_ATMOS)
				direction = PUMP_OUT
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = PUMP_DEFAULT_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = PUMP_MIN_PRESSURE
				. = TRUE
			else if(pressure == "max")
				pressure = PUMP_MAX_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				pump.target_pressure = clamp(round(pressure), PUMP_MIN_PRESSURE, PUMP_MAX_PRESSURE)
				investigate_log("was set to [pump.target_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("eject")
			if(holding)
				replace_tank(usr, FALSE)
				. = TRUE
	update_appearance()
