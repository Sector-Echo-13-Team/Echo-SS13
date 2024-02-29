// Echo 13 - Account for vampire not regenerating blood at all
/mob/living/carbon/human/handle_blood()

	if(NOBLOOD in dna.species.species_traits)
		bleed_rate = 0
		return

	if(bodytemperature >= TCRYO && !(HAS_TRAIT(src, TRAIT_HUSK))) //cryosleep or husked people do not pump the blood.

		//Blood regeneration if there is some space
		if(blood_volume < BLOOD_VOLUME_NORMAL && !HAS_TRAIT(src, TRAIT_NOHUNGER))
			var/nutrition_ratio = 0
			switch(nutrition)
				if(0 to NUTRITION_LEVEL_STARVING)
					nutrition_ratio = 0.2
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					nutrition_ratio = 0.4
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					nutrition_ratio = 0.6
				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
					nutrition_ratio = 0.8
				else
					nutrition_ratio = 1
			if(satiety > 80)
				nutrition_ratio *= 1.25
			adjust_nutrition(-nutrition_ratio * HUNGER_FACTOR)
			blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 0.5 * nutrition_ratio)
		if(blood_volume < BLOOD_VOLUME_NORMAL && HAS_TRAIT(src, TRAIT_NOHUNGER) && !has_quirk(/datum/quirk/vampire)) //blood regen for non eaters
			blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 0.5 * 1.25) //assumes best nutrition conditions for non eaters because they don't eat

		//Effects of bloodloss
		var/word = pick("dizzy","woozy","faint")
		switch(blood_volume)
			if(BLOOD_VOLUME_EXCESS to BLOOD_VOLUME_MAX_LETHAL)
				if(prob(15))
					to_chat(src, "<span class='userdanger'>Blood starts to tear your skin apart. You're going to burst!</span>")
					inflate_gib()
			if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
				if(prob(10))
					to_chat(src, "<span class='warning'>You feel terribly bloated.</span>")
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(prob(5))
					to_chat(src, "<span class='warning'>You feel [word].</span>")
				adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.01, 1))
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.02, 1))
				if(prob(5))
					blur_eyes(6)
					to_chat(src, "<span class='warning'>You feel very [word].</span>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				adjustOxyLoss(5)
				if(prob(15))
					Unconscious(rand(20,60))
					to_chat(src, "<span class='warning'>You feel extremely [word].</span>")
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				if(!HAS_TRAIT(src, TRAIT_NODEATH))
					death()

		var/temp_bleed = 0
		//Bleeding out
		for(var/obj/item/bodypart/BP as anything in bodyparts)
			var/brutedamage = BP.brute_dam

			//We want an accurate reading of .len
			listclearnulls(BP.embedded_objects)
			for(var/obj/item/embeddies in BP.embedded_objects)
				if(!embeddies.isEmbedHarmless())
					temp_bleed += 0.5

			if(brutedamage >= 20)
				temp_bleed += (brutedamage * 0.013)

		bleed_rate = max(bleed_rate - 0.5, temp_bleed)//if no wounds, other bleed effects (heparin) naturally decreases

		if(bleed_rate && !bleedsuppress && !(HAS_TRAIT(src, TRAIT_FAKEDEATH)))
			bleed(bleed_rate)
