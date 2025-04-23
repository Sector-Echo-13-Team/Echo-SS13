// Adds phytosians to the proc //Later I'll see if I get permission to add almost everyone who has wings that would fit since it's kinda dumb as is
/datum/reagent/flightpotion/expose_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		var/mob/living/carbon/C = M
		var/holycheck = ishumanbasic(C)
		if(reac_volume < 5 || !(holycheck || islizard(C) || isipc(C) || ispodperson(C) || (ismoth(C) && C.dna.features["moth_wings"] != "Burnt Off"))) // implying xenohumans are holy //as with all things,
			if(method == INGEST && show_message)
				to_chat(C, span_notice("<i>You feel nothing but a terrible aftertaste.</i>"))
			return ..()
		if(C.dna.species.has_innate_wings)
			to_chat(C, span_userdanger("A terrible pain travels down your back as your wings change shape!"))
			C.dna.features["moth_wings"] = "None"
		else
			to_chat(C, span_userdanger("A terrible pain travels down your back as wings burst out!"))
		C.dna.species.GiveSpeciesFlight(C)
		if(holycheck)
			to_chat(C, span_notice("You feel blessed!"))
			ADD_TRAIT(C, TRAIT_HOLY, SPECIES_TRAIT)
		playsound(C.loc, 'sound/items/poster_ripped.ogg', 50, TRUE, -1)
		C.adjustBruteLoss(20)
		C.force_scream()
	..()
