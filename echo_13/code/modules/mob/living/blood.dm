// Echo 13 - Account for vampires and blood subtypes
/mob/living/carbon/human/handle_blood() // Echo 13 - Start - Mirrored to blood.dm

	if(NOBLOOD in dna.species.species_traits)
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
					to_chat(src, span_userdanger("Blood starts to tear your skin apart. You're going to burst!"))
					inflate_gib()
			if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
				if(prob(10))
					to_chat(src, span_warning("You feel terribly bloated."))

			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)

				if(prob(1))
					to_chat(src, span_warning("You feel [word]."))
				if(oxyloss < 20)
					adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.02, 1))

			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(eye_blurry < 50)
					adjust_blurriness(5)
				if(oxyloss < 40)
					adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.02, 1))
				else
					adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.01, 1))

				if(prob(15))
					Unconscious(rand(2 SECONDS,6 SECONDS))
					to_chat(src, span_warning("You feel very [word]."))

			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.02, 1))
				adjustToxLoss(2)
				if(prob(15))
					Unconscious(rand(2 SECONDS,6 SECONDS))
					to_chat(src, span_warning("You feel extremely [word]."))
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				if(!HAS_TRAIT(src, TRAIT_NODEATH))
					death()

		//Bleeding out
		var/limb_bleed = 0
		for(var/obj/item/bodypart/BP as anything in bodyparts)
			if(BP.GetComponent(/datum/component/bandage))
				continue
			//We want an accurate reading of .len
			listclearnulls(BP.embedded_objects)
			for(var/obj/item/embeddies in BP.embedded_objects)
				if(!embeddies.isEmbedHarmless())
					BP.adjust_bleeding(0.1, BLOOD_LOSS_DAMAGE_MAXIMUM)
			limb_bleed += BP.bleeding

		var/message_cooldown = 5 SECONDS
		var/bleeeding_wording
//		var/bleed_change_wording
		switch(limb_bleed)
			if(0 to 0.5)
				bleeeding_wording = "You hear droplets of blood drip down."
				message_cooldown *= 2.5
			if(0.5 to 1)
				bleeeding_wording = "You feel your blood flow quietly to the floor."
				message_cooldown *= 2
			if(1 to 2)
				bleeeding_wording = "The flow of blood leaving your body onto the ground is worrying..."
				message_cooldown *= 1.7
			if(2 to 4)
				bleeeding_wording = "You're losing blood <b><i>very fast</i></b>, which is freaking you out!"
				message_cooldown *= 1.5
			if(4 to INFINITY)
				bleeeding_wording = "<b>Your heartbeat beats unstably fast as you lose a massive amount of blood!!</b>"

		if(limb_bleed && !bleedsuppress && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
			bleed(limb_bleed)

			if(!blood_particle)
				blood_particle = new(src, /particles/droplets/blood, PARTICLE_ATTACH_MOB)
			blood_particle.particles.color = dna.blood_type.color //mouthful
			blood_particle.particles.spawning = (limb_bleed/2)
			blood_particle.particles.count = (round(clamp((limb_bleed * 2), 1, INFINITY)))

			if(COOLDOWN_FINISHED(src, bloodloss_message) && bleeeding_wording)
				to_chat(src, span_warning("[bleeeding_wording]"))
				COOLDOWN_START(src, bloodloss_message, message_cooldown)
		else
			if(blood_particle)
				QDEL_NULL(blood_particle)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced) // Echo 13 - Start - Mirrored to blood.dm
	if(!blood_volume || !AM.reagents)
		return FALSE
	if(blood_volume < BLOOD_VOLUME_BAD && !forced)
		return FALSE

	if(blood_volume < amount)
		amount = blood_volume

	var/blood_id = get_blood_id()
	if(!blood_id)
		return FALSE

	blood_volume -= amount

	var/list/blood_data = get_blood_data(blood_id)

	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(blood_id == C.get_blood_id())//both mobs have the same blood substance
			if(blood_id == /datum/reagent/blood) //normal blood
				if(blood_data["viruses"])
					for(var/thing in blood_data["viruses"])
						var/datum/disease/D = thing
						if((D.spread_flags & DISEASE_SPREAD_SPECIAL) || (D.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
							continue
						C.ForceContractDisease(D)

				var/datum/blood_type/blood_type = blood_data["blood_type"]
				if(!blood_type || !(blood_type.type in C.dna.blood_type.compatible_types))
					C.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
					return TRUE

			C.blood_volume = min(C.blood_volume + round(amount, 0.1), BLOOD_VOLUME_MAX_LETHAL)
			return TRUE

	AM.reagents.add_reagent(blood_id, amount, blood_data, bodytemperature)
	return TRUE

/mob/living/carbon/get_blood_data(blood_id) // Echo 13 - Start - Mirrored to blood.dm
	if(blood_id == /datum/reagent/blood) //actual blood reagent
		var/blood_data = list()
		//set the blood data
		blood_data["viruses"] = list()

		for(var/thing in diseases)
			var/datum/disease/D = thing
			blood_data["viruses"] += D.Copy()

		blood_data["blood_DNA"] = dna.unique_enzymes
		if(disease_resistances && disease_resistances.len)
			blood_data["resistances"] = disease_resistances.Copy()
		var/list/temp_chem = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			temp_chem[R.type] = R.volume
		blood_data["trace_chem"] = list2params(temp_chem)
		if(mind)
			blood_data["mind"] = mind
		else if(last_mind)
			blood_data["mind"] = last_mind
		if(ckey)
			blood_data["ckey"] = ckey
		else if(last_mind)
			blood_data["ckey"] = ckey(last_mind.key)

		blood_data["blood_type"] = dna.blood_type
		blood_data["gender"] = gender
		blood_data["real_name"] = real_name
		blood_data["features"] = dna.features
		blood_data["factions"] = faction
		blood_data["quirks"] = list()
		for(var/V in roundstart_quirks)
			var/datum/quirk/T = V
			blood_data["quirks"] += T.type
		return blood_data

/mob/living/proc/add_splatter_floor(turf/T, small_drip, amt)
	if(get_blood_id() != /datum/reagent/blood)
		return
	if(!T)
		T = get_turf(src)

	var/list/temp_blood_DNA

	if(small_drip)
		// Only a certain number of drips (or one large splatter) can be on a given turf.
		var/obj/effect/decal/cleanable/blood/drip/drop = locate() in T
		if(drop)
			if(drop.drips < 5)
				drop.drips++
				drop.add_overlay(pick(drop.random_icon_states))
				drop.transfer_mob_blood_dna(src)
				return
			else
				temp_blood_DNA = drop.return_blood_DNA() //we transfer the dna from the drip to the splatter
				qdel(drop)//the drip is replaced by a bigger splatter
		else if (amt < 2)
			drop = new(T, get_static_viruses())
			drop.transfer_mob_blood_dna(src)
			return

	// Find a blood decal or create a new one.
	var/obj/effect/decal/cleanable/blood/B
	for (var/obj/effect/decal/cleanable/blood/candidate in T)
		if (QDELETED(T))
			continue
		B = candidate
		break
	if(!B)
		if(amt > 4)
			B = new /obj/effect/decal/cleanable/blood(T, get_static_viruses())
		else
			B = new /obj/effect/decal/cleanable/blood/splatter(T, get_static_viruses())

	if(QDELETED(B)) //Give it up
		return
	B.bloodiness = min((B.bloodiness + BLOOD_AMOUNT_PER_DECAL), BLOOD_POOL_MAX)
	B.transfer_mob_blood_dna(src) //give blood info to the blood decal.
	if(temp_blood_DNA)
		B.add_blood_DNA(temp_blood_DNA)
