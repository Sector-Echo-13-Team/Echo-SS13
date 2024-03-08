// Echo 13 - Account for hungerless species, vampire quirk.
/obj/machinery/cryopod
	var/list/hungerless_quirks = list("Vampirism")

/obj/machinery/cryopod/proc/check_hungerless_quirks(mob/living/carbon/sleepyhead)
	var/list/matching_quirks = hungerless_quirks & sleepyhead?.client?.prefs.all_quirks
	if(length(matching_quirks))
		return TRUE

/obj/machinery/cryopod/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	//it always sucks a little to get up
	if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER) && !check_hungerless_quirks(sleepyhead))
		sleepyhead.set_nutrition(200)
	sleepyhead.SetSleeping(60)

	var/wakeupmessage = "The cryopod shudders as the pneumatic seals separating you and the waking world let out a hiss."
	if(prob(60))
		if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER) && !check_hungerless_quirks(sleepyhead))
			wakeupmessage += " A sickly feeling along with the pangs of hunger greet you upon your awakening."
			sleepyhead.set_nutrition(100)
		else
			wakeupmessage += " You feel particularly drowsy..."
		sleepyhead.apply_effect(rand(3,10), EFFECT_DROWSY)
	to_chat(sleepyhead, span_danger(examine_block(wakeupmessage)))

/obj/machinery/cryopod/poor/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER) && !check_hungerless_quirks(sleepyhead))
		sleepyhead.set_nutrition(200)
	sleepyhead.SetSleeping(80)
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
