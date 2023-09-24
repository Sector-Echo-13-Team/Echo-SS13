SUBSYSTEM_DEF(idlenpcpool)
	name = "Idling NPC Pool"
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	priority = FIRE_PRIORITY_IDLE_NPC
	wait = 60
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/list/idle_mobs_by_virtual_level = list()

/datum/controller/subsystem/idlenpcpool/stat_entry(msg)
	var/list/idlelist = GLOB.simple_animals[AI_IDLE]
	var/list/zlist = GLOB.simple_animals[AI_Z_OFF]
	msg = "IdleNPCS:[length(idlelist)]|Z:[length(zlist)]"
	return ..()

/datum/controller/subsystem/idlenpcpool/proc/try_wakeup_virtual_z(virt_z)
	virt_z = "[virt_z]"
	for(var/mob/living/simple_animal/animal as anything in LAZYACCESS(idle_mobs_by_virtual_level, virt_z))
		animal.check_should_sleep()

/datum/controller/subsystem/idlenpcpool/fire(resumed = FALSE)

	if (!resumed)
		var/list/idlelist = GLOB.simple_animals[AI_IDLE]
		src.currentrun = idlelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/simple_animal/SA = currentrun[currentrun.len]
		--currentrun.len
		if (!SA)
			GLOB.simple_animals[AI_IDLE] -= SA
			continue

		if(!SA.ckey)
			if(SA.stat != DEAD)
				SA.handle_automated_movement()
			if(SA.stat != DEAD)
				SA.check_should_sleep()
		if (MC_TICK_CHECK)
			return
