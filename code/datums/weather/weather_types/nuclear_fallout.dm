/datum/weather/nuclear_fallout //ported from NSV, at least some part of the RBMK can live on.
	name = "nuclear fallout"
	desc = "Irradiated dust falls down everywhere."

	telegraph_duration = 20 SECONDS
	telegraph_message = span_boldwarning("The air suddenly becomes dusty..")
	telegraph_overlay = "fallout"

	weather_message = span_userdanger("<i>You feel a wave of hot ash fall down on you.</i>")
	weather_overlay = "snowfall_heavy"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	area_type = /area
	protect_indoors = TRUE

	weather_color = "green"
	telegraph_sound = null
	weather_sound = 'sound/weather/fallout/falloutwind.ogg'
	end_duration = 100

	end_message = span_notice("The ash stops falling.")
	immunity_type = "rad"

/datum/weather/nuclear_fallout/weather_act(mob/living/akimov)
	akimov.rad_act(100)
	to_chat(akimov, span_notice("You taste metal."))

/datum/weather/nuclear_fallout/normal
	name = "dust storm"
	desc = "The extreme dust creates a harsh wind, harmless."

	weather_message = span_notice("You feel a wave of dusty air blow through you.")
	weather_overlay = "dust"

	end_message = span_notice("The dust stops blowing.")

	aesthetic = TRUE
