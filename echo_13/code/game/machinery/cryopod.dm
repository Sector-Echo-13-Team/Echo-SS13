// Echo 13 - Account for hungerless species, vampire quirk.
/obj/machinery/cryopod
	var/list/hungerless_quirks = list("Vampirism")

/obj/machinery/cryopod/proc/check_hungerless_quirks(mob/living/carbon/sleepyhead)
	var/list/matching_quirks = hungerless_quirks & sleepyhead?.client?.prefs.all_quirks
	if(length(matching_quirks))
		return TRUE

/obj/machinery/cryopod/proc/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	sleepyhead.set_sleeping(60)
	if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER) && !check_hungerless_quirks(sleepyhead))
		sleepyhead.set_nutrition(200)
	to_chat(sleepyhead, span_boldnotice("You begin to wake from cryosleep..."))
	var/ship_name = "<span class='maptext' style=font-size:24pt;text-align:center valign='top'><u>[linked_ship.current_ship.name]</u></span>"
	var/sector_name = "[linked_ship.current_ship.current_overmap.name]"
	var/time = "[station_time_timestamp("hh:mm")]"
	var/character_name = "[sleepyhead.real_name]"

/obj/machinery/cryopod/poor/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER) && !check_hungerless_quirks(sleepyhead))
		sleepyhead.set_nutrition(200)
	sleepyhead.set_sleeping(80)
	if(prob(90)) //suffer
		sleepyhead.apply_effect(rand(5,15), EFFECT_DROWSY)
	if(prob(75))
		sleepyhead.blur_eyes(rand(6, 10))
	if(prob(66))
		sleepyhead.adjust_disgust(rand(35, 45))
	if(prob(40))
		sleepyhead.adjust_disgust(rand(15, 25))
	if(prob(20))
		sleepyhead.adjust_disgust(rand(5,15))
	to_chat(sleepyhead, "<span class='userdanger'>The symptoms of a horrid cryosleep set in as you awaken...")
