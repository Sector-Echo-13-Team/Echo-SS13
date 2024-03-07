// Echo 13 - Handle species and quirks before spawning
/mob/dead/new_player/proc/AttemptLateSpawn(datum/job/job, datum/overmap/ship/controlled/ship, check_playtime = TRUE)
	if(auth_check)
		return

	if(!client.prefs.randomise[RANDOM_NAME]) // do they have random names enabled
		var/name = client.prefs.real_name
		if(GLOB.real_names_joined.Find(name)) // is there someone who spawned with the same name
			to_chat(usr, "<span class='warning'>Someone has spawned with this name already.")
			return FALSE

	var/error = IsJobUnavailable(job, ship, check_playtime)
	if(error != JOB_AVAILABLE)
		alert(src, get_job_unavailable_error_message(error, job))
		return FALSE

	//Removes a job slot
	ship.job_slots[job]--

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	var/mob/living/carbon/human/character = create_character(TRUE)	//creates the human and transfers vars and mind
	var/equip = job.EquipRank(character, ship)
	if(isliving(equip))	//Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

	if(ishuman(character))	//These procs all expect humans
		var/mob/living/carbon/human/humanc = character
		ship.manifest_inject(humanc, client, job)
		GLOB.data_core.manifest_inject(humanc, client)
		AnnounceArrival(humanc, job.name, ship)
		AddEmploymentContract(humanc)
		SSblackbox.record_feedback("tally", "species_spawned", 1, humanc.dna.species.name)

		if(GLOB.summon_guns_triggered)
			give_guns(humanc)
		if(GLOB.summon_magic_triggered)
			give_magic(humanc)
		if(GLOB.curse_of_madness_triggered)
			give_madness(humanc, GLOB.curse_of_madness_triggered)
		if(CONFIG_GET(flag/roundstart_traits))
			SSquirks.AssignQuirks(humanc, humanc.client, TRUE)

	if(job && !job.override_latejoin_spawn(character))
		var/atom/spawn_point = pick(ship.shuttle_port.spawn_points)
		spawn_point.join_player_here(character)
		var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
		Spl.Fade(TRUE)
		character.playsound_local(get_turf(character), 'sound/voice/ApproachingTG.ogg', 25)

		character.update_parallax_teleport()

	character.client.init_verbs() // init verbs for the late join

	GLOB.joined_player_list += character.ckey

	log_manifest(character.mind.key, character.mind, character, TRUE)

	if(length(ship.job_slots) > 1 && ship.job_slots[1] == job) // if it's the "captain" equivalent job of the ship. checks to make sure it's not a one-job ship
		minor_announce("[job.name] [character.real_name] on deck!", zlevel = ship.shuttle_port.virtual_z())
	return TRUE
