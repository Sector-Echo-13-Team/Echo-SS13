SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	var/list/currentrun = list()

	/// List of player mobs by their stringified virtual z-level
	var/static/list/list/players_by_virtual_z = list()

	/// List of all dead player mobs by virtual z-level
	var/static/list/list/dead_players_by_virtual_z = list()

	var/static/list/cubemonkeys = list()
	var/static/list/cheeserats = list()

/datum/controller/subsystem/mobs/stat_entry(msg)
	msg = "P:[length(GLOB.mob_living_list)]"
	return ..()

/datum/controller/subsystem/mobs/get_metrics()
	. = ..()
	var/list/cust = list()
	cust["processing"] = length(GLOB.mob_living_list)
	.["custom"] = cust

/datum/controller/subsystem/mobs/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.mob_living_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	var/seconds_per_tick = wait / (1 SECONDS)
	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--
		if(L)
			L.Life(seconds_per_tick, times_fired)
		else
			GLOB.mob_living_list.Remove(L)
			stack_trace("[L] no longer exists in mob_living_list")
		if (MC_TICK_CHECK)
			return
