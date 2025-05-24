SUBSYSTEM_DEF(jukeboxes)
	name = "Jukeboxes"
	wait = 5
	var/list/songs = list()
	var/list/activejukeboxes = list()
	var/list/freejukeboxchannels = list()

/datum/track
	var/song_name = "generic"
	var/song_path = null
	var/song_length = 0
	var/song_beat_deciseconds = 120

/datum/track/New(name, path, length, beat)
	song_name = name
	song_path = path
	song_length = length
	song_beat_deciseconds = beat

/datum/controller/subsystem/jukeboxes/proc/addjukebox(obj/jukebox, datum/track/T, jukefalloff = 1)
	if(!istype(T))
		CRASH("[src] tried to play a song with a nonexistant track")
	var/channeltoreserve = pick(freejukeboxchannels)
	if(!channeltoreserve)
		return FALSE
	freejukeboxchannels -= channeltoreserve
	var/list/youvegotafreejukebox = list(T, channeltoreserve, jukebox, jukefalloff)
	activejukeboxes.len++
	activejukeboxes[activejukeboxes.len] = youvegotafreejukebox

	//Due to changes in later versions of 512, SOUND_UPDATE no longer properly plays audio when a file is defined in the sound datum. As such, we are now required to init the audio before we can actually do anything with it.
	//Downsides to this? This means that you can *only* hear the jukebox audio if you were present on the server when it started playing, and it means that it's now impossible to add loops to the jukebox track list.
	var/sound/song_to_init = sound(T.song_path)
	song_to_init.status = SOUND_MUTE
	for(var/mob/M in GLOB.player_list)
		if(!(M?.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue

		M.playsound_local(M, null, 100, channel = youvegotafreejukebox[2], S = song_to_init)
	return activejukeboxes.len

/datum/controller/subsystem/jukeboxes/Recover()
	songs = SSjukeboxes.songs
	activejukeboxes = SSjukeboxes.activejukeboxes
	freejukeboxchannels = SSjukeboxes.freejukeboxchannels

/datum/controller/subsystem/jukeboxes/proc/removejukebox(IDtoremove)
	if(islist(activejukeboxes[IDtoremove]))
		var/jukechannel = activejukeboxes[IDtoremove][2]
		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			M.stop_sound_channel(jukechannel)
		freejukeboxchannels |= jukechannel
		activejukeboxes.Cut(IDtoremove, IDtoremove+1)
		return TRUE
	else
		CRASH("Tried to remove jukebox with invalid ID")

/datum/controller/subsystem/jukeboxes/proc/findjukeboxindex(obj/jukebox)
	if(activejukeboxes.len)
		for(var/list/jukeinfo in activejukeboxes)
			if(jukebox in jukeinfo)
				return activejukeboxes.Find(jukeinfo)
	return FALSE

/datum/controller/subsystem/jukeboxes/Initialize()
	var/list/tracks = flist("[global.config.directory]/jukebox_music/sounds/")
	//Cache all the sounds ahead of time so we minimize rust calls
	SSsound_cache.cache_sounds(tracks)

	for(var/S in tracks)
		var/datum/track/T = new()
		T.song_path = file("[global.config.directory]/jukebox_music/sounds/[S]")
		T.song_length = SSsound_cache.get_sound_length(T.song_path)
		var/list/L = splittext(S,"+")
		T.song_name = L[1]
		var/bpm
		if(L.len > 1)
			bpm = text2num(L[2])
		if(isnum(bpm))
			T.song_beat_deciseconds = 600 / bpm
		songs |= T
	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX)
		freejukeboxchannels |= i
	return ..()

/datum/controller/subsystem/jukeboxes/fire()
	for(var/list/jukeinfo as anything in activejukeboxes)
		if(!jukeinfo.len)
			stack_trace("Active jukebox without any associated metadata.")
			continue
		var/datum/track/juketrack = jukeinfo[1]
		if(!istype(juketrack))
			stack_trace("Invalid jukebox track datum.")
			continue
		var/obj/machinery/jukebox/jukebox = jukeinfo[3]
		if(!istype(jukebox))
			stack_trace("Nonexistant or invalid object associated with jukebox.")
			continue
		var/sound/song_played = sound(juketrack.song_path)
		var/turf/currentturf = get_turf(jukebox)
		var/list/hearerscache = get_hearers_in_view(7, jukebox)

		var/datum/virtual_level/zone = currentturf.get_virtual_level()
		var/turf/above_turf = zone.get_above_turf(currentturf)
		var/turf/below_turf = zone.get_below_turf(currentturf)

		var/list/virtual_ids = list(zone.id)
		var/list/areas = list(get_area(jukebox))
		if(above_turf && istransparentturf(above_turf))
			virtual_ids += above_turf.virtual_z
			areas += get_area(above_turf)
		if(below_turf && istransparentturf(below_turf))
			virtual_ids += below_turf.virtual_z
			areas += get_area(below_turf)

		song_played.falloff = jukeinfo[4]

		for(var/mob/M as anything in GLOB.player_list)
			if(!(M.client?.prefs.toggles & SOUND_INSTRUMENTS) || !M.can_hear())
				M.stop_sound_channel(jukeinfo[2])
				continue

			var/inrange = FALSE
			if(jukebox.volume <= 0 || !(M.virtual_z() in virtual_ids))
				song_played.status = SOUND_MUTE | SOUND_UPDATE
			else
				song_played.status = SOUND_UPDATE
				if((get_area(M) in areas) || (M in hearerscache))
					inrange = TRUE

			M.playsound_local(currentturf, null, jukebox.volume, channel = jukeinfo[2], S = song_played, envwet = (inrange ? -250 : 0), envdry = (inrange ? 0 : -10000))

			if(MC_TICK_CHECK)
				return
