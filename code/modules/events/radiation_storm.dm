/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	start_when = 3
	end_when = start_when + 1
	announce_when	= 1

/datum/round_event/radiation_storm/announce(fake)
	priority_announce("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert", 'sound/ai/radiation.ogg')
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	/// Should point to a central mapzone.weather_controller, one doesn't exist in shiptest
	WARNING("Radiation Storm is not implemented.")
	return
