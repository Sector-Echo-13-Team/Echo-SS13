// Echo 13 - True draculine bloodtype, Sap blood
/datum/reagent/blood/expose_mob(mob/living/L, method=TOUCH, reac_volume)
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing

			if((D.spread_flags & DISEASE_SPREAD_SPECIAL) || (D.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
				continue

			if(((method == TOUCH || method == SMOKE) || method == VAPOR) && (D.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS))
				L.ContactContractDisease(D)
			else //ingest, patch or inject
				L.ForceContractDisease(D)

	if(iscarbon(L))
		var/mob/living/carbon/exposed_carbon = L
		if((ispath(exposed_carbon.get_blood_id(), /datum/reagent/blood)) && (method == INJECT || (method == INGEST && exposed_carbon.dna && exposed_carbon.dna.species && (DRINKSBLOOD in exposed_carbon.dna.species.species_traits))))
			if(data && data["blood_type"])
				var/datum/blood_type/blood_type = data["blood_type"]
				if(blood_type.type in exposed_carbon.dna.blood_type.compatible_types)
					exposed_carbon.blood_volume = min(exposed_carbon.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)
					return
			exposed_carbon.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)

/datum/reagent/blood/true_draculine
	name = "True Draculine"
	description = "Slowly heals all damage types. Overdose will, after a short while, turn you into a vampire, addiction lowers your max health as your body attempts to fight off the corruption, if you're incompatible you're immune to the addiction and overdose will damage you instead."
	metabolization_rate = 1
	addiction_threshold = 20
	overdose_threshold = 30
	var/healing = 0.20

/datum/reagent/blood/true_draculine/on_mob_add(mob/living/carbon/human/M)
	if(M.dna.species.exotic_blood)
		src.addiction_threshold = 0
	if(M.dna.species.exotic_blood == /datum/reagent/blood/true_draculine)
		src.overdose_threshold = 0
	..()

/datum/reagent/blood/true_draculine/on_mob_life(mob/living/carbon/human/M)
	if(M.dna.species.exotic_blood != /datum/reagent/blood/true_draculine)
		M.adjustToxLoss(-healing*REM, 0, TRUE)
		M.adjustOxyLoss(-healing*REM, 0)
		M.adjustBruteLoss(-healing*REM, 0)
		M.adjustFireLoss(-healing*REM, 0)
		M.Jitter(2)
		. = 1
	..()

/datum/reagent/blood/true_draculine/overdose_process(mob/living/carbon/human/M)
	if(M.dna.species.exotic_blood)
		M.adjustToxLoss(1*REM, 0)
		M.adjustOxyLoss(1*REM, 0)
		M.adjustBruteLoss(1*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(1*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.Jitter(6)
	else
		if(current_cycle >= 50)
			for(var/datum/reagent/addiction in M.reagents.addiction_list)
				if(addiction.name == "True Draculine")
					M.reagents.remove_addiction(addiction)
			M.add_quirk(/datum/quirk/vampire)
	..()
	. = 1

/datum/reagent/blood/true_draculine/addiction_act_stage1(mob/living/carbon/human/M)
	M.dna.species.species_traits |= list(DRINKSBLOOD)
	if(M.health > 60)
		M.adjustToxLoss(1.5*REM, 0)
		M.adjustOxyLoss(1.5*REM, 0)
		M.adjustBruteLoss(1.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(1.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = 1
	M.Jitter(3)
	..()

/datum/reagent/blood/true_draculine/addiction_act_stage2(mob/living/M)
	if(M.health > 50)
		M.adjustToxLoss(2.5*REM, 0)
		M.adjustOxyLoss(2.5*REM, 0)
		M.adjustBruteLoss(2.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(2.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = 1
	M.Jitter(4)
	..()

/datum/reagent/blood/true_draculine/addiction_act_stage3(mob/living/M)
	if(M.health > 40)
		M.adjustToxLoss(3*REM, 0)
		M.adjustOxyLoss(3*REM, 0)
		M.adjustBruteLoss(3*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(3*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = 1
	M.Jitter(5)
	..()

/datum/reagent/blood/true_draculine/addiction_act_stage4(mob/living/M)
	if(M.health > 30)
		M.adjustToxLoss(5*REM, 0)
		M.adjustOxyLoss(5*REM, 0)
		M.adjustBruteLoss(5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = 1
	M.Jitter(6)
	..()

/datum/reagent/blood/true_draculine/on_addiction_removal(mob/living/carbon/human/M)
	if(!(/datum/quirk/vampire in M.roundstart_quirks))
		M.dna.species.species_traits ^= list(DRINKSBLOOD)
	..()

/datum/reagent/phyto_sap
	name = "Phytosian Sap"
	description = "The sap that drips from phytosians. When applied to skin, it reconstructs tissue, a very large amount of it might be enough to treat severe tissue damage... Ingesting it would be a bad idea, considering what it does. Excessive consumption is rumored to lead to a coma and transformation into a phytosian." //Might make this real later it would be the same amount that takes to unhusk someone, might also make the unhusk turn you into a phytosian.
	color = "#af7011"

/datum/reagent/phyto_sap/expose_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 0)
	if(iscarbon(M))
		if(M.stat != DEAD)
			show_message = 1
			if(!ispodperson(M))
				if(method in list(INGEST, VAPOR, INJECT))
					M.adjustToxLoss(0.6*reac_volume)
					if(show_message)
						to_chat(M, "<span class='warning'>You don't feel so good...</span>")
		if(method in list(PATCH, TOUCH, SMOKE))
			M.adjustBruteLoss(-0.3 * reac_volume)
			M.adjustFireLoss(-0.3 * reac_volume)
			if(show_message)
				to_chat(M, "<span class='nicegreen'>Your wounds are covered by leaves and go numb as the invasive sap stitches you back together.</span>")
			if(HAS_TRAIT_FROM(M, TRAIT_HUSK, "burn") && M.getFireLoss() < THRESHOLD_UNHUSK && (M.reagents.get_reagent_amount(/datum/reagent/phyto_sap) + reac_volume >= 400))
				M.cure_husk("burn")
				M.visible_message("<span class='nicegreen'>A cocoon of leaves surrounds [M] briefly before wilting away. [M] looks a lot healthier!")
	..()
