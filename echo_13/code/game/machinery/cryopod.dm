// Echo 13 - Account for hungerless species, I should bother main about it eventually but wa.
/obj/machinery/cryopod/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	//it always sucks a little to get up
	if(HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER))
		to_chat(sleepyhead, "<span class='notice'>Unlike most, you're fortunate enough to feel no hunger...")
	else
		sleepyhead.set_nutrition(200)
		to_chat(sleepyhead, "<span class='userdanger'>A dull hunger pangs in your stomach as you awaken...")
	sleepyhead.SetSleeping(60) //if you read this comment and feel like shitting together something to adjust elzu and IPC charge on wakeup, be my guest.

/obj/machinery/cryopod/poor/apply_effects_to_mob(mob/living/carbon/sleepyhead)
	if(!HAS_TRAIT(sleepyhead, TRAIT_NOHUNGER))
		sleepyhead.set_nutrition(200)
	sleepyhead.SetSleeping(80)
	if(prob(90))
		sleepyhead.apply_effect(rand(5,15), EFFECT_DROWSY)
	if(prob(75))
		sleepyhead.blur_eyes(rand(6, 10))
	if(prob(66))
		sleepyhead.adjust_disgust(rand(35, 45)) //rand
	if(prob(40))
		sleepyhead.adjust_disgust(rand(15, 25))
	if(prob(20))
		sleepyhead.adjust_disgust(rand(5,15))
	if(prob(30))
		sleepyhead.apply_damage_type(30, BURN)
	to_chat(sleepyhead, "<span class='userdanger'>The symptoms of a horrid cryosleep set in as you awaken...")
