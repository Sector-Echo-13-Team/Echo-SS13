//Firebot

#define SPEECH_INTERVAL 300  // Time between idle speeches
#define DETECTED_VOICE_INTERVAL 300  // Time between fire detected callouts
#define FOAM_INTERVAL 50  // Time between deployment of fire fighting foam

/mob/living/simple_animal/bot/firebot
	name = "\improper Firebot"
	desc = "A little fire extinguishing bot. He looks rather anxious."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "firebot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25

	radio_key = /obj/item/encryptionkey/headset_com
	radio_channel = RADIO_CHANNEL_COMMAND
	bot_type = FIRE_BOT
	model = "Firebot"
	bot_core = /obj/machinery/bot_core/firebot
	window_id = "autoextinguisher"
	window_name = "Mobile Fire Extinguisher v1.0"
	path_image_color = "#FFA500"

	var/datum/weakref/target_fire_ref
	var/datum/weakref/old_target_fire_ref

	var/obj/item/extinguisher/internal_ext

	var/last_found = 0

	var/speech_cooldown = 0
	var/detected_cooldown = 0
	var/foam_cooldown = 0

	var/extinguish_people = TRUE
	var/extinguish_fires = TRUE
	var/stationary_mode = FALSE

/mob/living/simple_animal/bot/firebot/rockplanet
	name = "\improper Abandoned Firebot"
	desc = "A little fire extinguishing bot. He looks rather bloodthrirsty."
	emagged = 2
	remote_disabled = 1
	locked = TRUE
	faction = list("mining", "silicon" , "turret")
	extinguish_fires = FALSE
	extinguish_people = TRUE

/mob/living/simple_animal/bot/firebot/rockplanet/create_extinguisher()
	internal_ext = new /obj/item/extinguisher(src)
	internal_ext.chem = /datum/reagent/clf3 //Refill the internal extinguisher with liquid fire
	internal_ext.safety = FALSE
	internal_ext.precision = TRUE
	internal_ext.max_water = INFINITY
	internal_ext.refill()

/mob/living/simple_animal/bot/firebot/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	update_appearance()
	var/datum/job/engineer/J = new/datum/job/engineer
	access_card.access += J.get_access()
	prev_access = access_card.access

	create_extinguisher()

/mob/living/simple_animal/bot/firebot/Destroy()
	QDEL_NULL(internal_ext)
	return ..()

/mob/living/simple_animal/bot/firebot/bot_reset()
	create_extinguisher()

/mob/living/simple_animal/bot/firebot/proc/create_extinguisher()
	internal_ext = new /obj/item/extinguisher(src)
	internal_ext.safety = FALSE
	internal_ext.precision = TRUE
	internal_ext.max_water = INFINITY
	internal_ext.refill()

/mob/living/simple_animal/bot/firebot/UnarmedAttack(atom/A)
	if(!on)
		return
	if(internal_ext)
		internal_ext.afterattack(A, src)
	else
		return ..()

/mob/living/simple_animal/bot/firebot/RangedAttack(atom/A)
	if(!on)
		return
	if(internal_ext)
		internal_ext.afterattack(A, src)
	else
		return ..()

/mob/living/simple_animal/bot/firebot/turn_on()
	. = ..()
	update_appearance()

/mob/living/simple_animal/bot/firebot/turn_off()
	..()
	update_appearance()

/mob/living/simple_animal/bot/firebot/bot_reset()
	..()
	target_fire_ref = null
	old_target_fire_ref = null
	ignore_list = list()
	anchored = FALSE
	update_appearance()

/mob/living/simple_animal/bot/firebot/proc/soft_reset()
	path = list()
	target_fire_ref = null
	mode = BOT_IDLE
	last_found = world.time
	update_appearance()

/mob/living/simple_animal/bot/firebot/set_custom_texts()
	text_hack = "You corrupt [name]'s safety protocols."
	text_dehack = "You detect errors in [name] and reset his programming."
	text_dehack_fail = "[name] is not responding to reset commands!"

/mob/living/simple_animal/bot/firebot/get_controls(mob/user)
	var/dat
	dat += hack(user)
	dat += showpai(user)
	dat += "<TT><B>Mobile Fire Extinguisher v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=[REF(src)];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel panel is [open ? "opened" : "closed"]<BR>"

	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	if(!locked || issilicon(user) || isAdminGhostAI(user))
		dat += "Extinguish Fires: <A href='?src=[REF(src)];operation=extinguish_fires'>[extinguish_fires ? "Yes" : "No"]</A><BR>"
		dat += "Extinguish People: <A href='?src=[REF(src)];operation=extinguish_people'>[extinguish_people ? "Yes" : "No"]</A><BR>"
		dat += "Patrol Station: <A href='?src=[REF(src)];operation=patrol'>[auto_patrol ? "Yes" : "No"]</A><BR>"
		dat += "Stationary Mode: <a href='?src=[REF(src)];operation=stationary_mode'>[stationary_mode ? "Yes" : "No"]</a><br>"

	return dat

/mob/living/simple_animal/bot/firebot/emag_act(mob/user)
	..()
	if(emagged == 2)
		if(user)
			to_chat(user, "<span class='danger'>[src] buzzes and beeps.</span>")
		audible_message("<span class='danger'>[src] buzzes oddly!</span>")
		playsound(src, "sparks", 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		if(user)
			old_target_fire_ref = WEAKREF(user)
		extinguish_fires = FALSE
		extinguish_people = TRUE

		internal_ext = new /obj/item/extinguisher(src)
		internal_ext.chem = /datum/reagent/clf3 //Refill the internal extinguisher with liquid fire
		internal_ext.power = 3
		internal_ext.safety = FALSE
		internal_ext.precision = FALSE
		internal_ext.max_water = INFINITY
		internal_ext.refill()

/mob/living/simple_animal/bot/firebot/Topic(href, href_list)
	if(..())
		return TRUE

	switch(href_list["operation"])
		if("extinguish_fires")
			extinguish_fires = !extinguish_fires
		if("extinguish_people")
			extinguish_people = !extinguish_people
		if("stationary_mode")
			stationary_mode = !stationary_mode

	update_controls()
	update_appearance()

/mob/living/simple_animal/bot/firebot/proc/is_burning(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.on_fire || (emagged == 2 && !M.on_fire))
			return TRUE

	else if(isturf(target))
		var/turf/open/T = target
		if(T.active_hotspot || T.turf_fire)
			return TRUE

	return FALSE

/mob/living/simple_animal/bot/firebot/handle_automated_action()
	if(!..())
		return

	if(IsStun() || IsParalyzed())
		old_target_fire_ref = target_fire_ref
		target_fire_ref = null
		mode = BOT_IDLE
		return

	if(prob(1) && !target_fire_ref)
		var/list/messagevoice = list("No fires detected." = 'sound/voice/firebot/nofires.ogg',
		"Only you can prevent station fires." = 'sound/voice/firebot/onlyyou.ogg',
		"Temperature nominal." = 'sound/voice/firebot/tempnominal.ogg',
		"Keep it cool." = 'sound/voice/firebot/keepitcool.ogg')
		var/message = pick(messagevoice)
		speak(message)
		playsound(src, messagevoice[message], 50)

	// Couldn't reach the target, reset and try again ignoring the old one
	if(frustration > 8)
		old_target_fire_ref = target_fire_ref
		soft_reset()

	var/atom/target_fire = target_fire_ref?.resolve()

	// We extinguished our target or it was deleted
	if(QDELETED(target_fire) || !is_burning(target_fire) || isdead(target_fire))
		target_fire = null
		target_fire_ref = null
		var/scan_range = (stationary_mode ? 1 : DEFAULT_SCAN_RANGE)
		var/old_target_fire = old_target_fire_ref?.resolve()

		if(extinguish_people)
			target_fire = scan(/mob/living, old_target_fire, scan_range) // Scan for burning humans first
			target_fire_ref = WEAKREF(target_fire)

		if(!target_fire && extinguish_fires)
			target_fire = scan(/turf/open, old_target_fire, scan_range) // Scan for burning turfs second
			target_fire_ref = WEAKREF(target_fire)

		old_target_fire_ref = target_fire_ref

	if(!target_fire)
		if(auto_patrol)
			if(mode == BOT_IDLE || mode == BOT_START_PATROL)
				start_patrol()

			if(mode == BOT_PATROL)
				bot_patrol()
		return

	// Target reached ENGAGE WATER CANNON
	if(get_dist(src, target_fire) <= (emagged == 2 ? 1 : 2)) // Make the bot spray water from afar when not emagged
		if((speech_cooldown + SPEECH_INTERVAL) < world.time)
			if(ishuman(target_fire))
				speak("Stop, drop and roll!")
				playsound(src, 'sound/voice/firebot/stopdropnroll.ogg', 50, FALSE)
			else
				speak("Extinguishing!")
				playsound(src, 'sound/voice/firebot/extinguishing.ogg', 50, FALSE)
			speech_cooldown = world.time

			flick("firebot1_use", src)
			spray_water(target_fire, src)

		soft_reset()

	// Target ran away
	else if(length(path) && (get_dist(target_fire, path[length(path)]) > 2))
		path = list()
		mode = BOT_IDLE
		last_found = world.time

	else if(stationary_mode)
		soft_reset()
		return

	if(get_dist(src, target_fire) > 2)

		path = get_path_to(src, get_turf(target_fire), /turf/proc/Distance_cardinal, 0, 30, 1, id=access_card)
		mode = BOT_MOVING
		if(!length(path))
			soft_reset()

	if(length(path))
		if(!bot_move(path[path.len]))
			old_target_fire_ref = target_fire_ref
			soft_reset()
		return

	// We got a target but it's too far away from us
	if(length(path) > 8)
		frustration++


//Look for burning people or turfs around the bot
/mob/living/simple_animal/bot/firebot/process_scan(atom/scan_target)
	var/result

	if(scan_target == src)
		return result

	if(is_burning(scan_target))
		if((detected_cooldown + DETECTED_VOICE_INTERVAL) < world.time)
			speak("Fire detected!")
			playsound(src, 'sound/voice/firebot/detected.ogg', 50, FALSE)
			detected_cooldown = world.time
		result = scan_target

	return result

/mob/living/simple_animal/bot/firebot/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if((temperature > T0C + 200 || temperature < HUMAN_BODYTEMP_COLD_DAMAGE_LIMIT) && foam_cooldown + FOAM_INTERVAL < world.time)
		new /obj/effect/particle_effect/foam/firefighting(loc)
		foam_cooldown = world.time
	..()

/mob/living/simple_animal/bot/firebot/proc/spray_water(atom/target, mob/user)
	if(stationary_mode)
		flick("firebots_use", user)
	else
		flick("firebot1_use", user)
	internal_ext.afterattack(target, user, null)

/mob/living/simple_animal/bot/firebot/update_icon_state()
	. = ..()
	if(!on)
		icon_state = "firebot0"
		return
	if(IsStun() || IsParalyzed())
		icon_state = "firebots1"
		return
	else if(stationary_mode) //Bot has yellow light to indicate stationary mode.
		icon_state = "firebots1"
		return
	icon_state = "firebot1"

/mob/living/simple_animal/bot/firebot/explode()
	on = FALSE
	visible_message("<span class='boldannounce'>[src] blows apart!</span>")

	var/atom/Tsec = drop_location()

	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/clothing/head/hardhat/red(Tsec)

	var/turf/T = get_turf(Tsec)

	if(isopenturf(T))
		var/turf/open/theturf = T
		theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)
	..()

/obj/machinery/bot_core/firebot
	req_one_access = list(ACCESS_CONSTRUCTION, ACCESS_ROBOTICS)

#undef SPEECH_INTERVAL
#undef DETECTED_VOICE_INTERVAL
#undef FOAM_INTERVAL

