// Echo 13 - Account for multiple breath products dependant on what was breathed in.
/obj/item/organ/lungs/proc/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
//TODO: add lung damage = less oxygen gains
	var/breathModifier = (5-(5*(damage/maxHealth)/2)) //range 2.5 - 5
	if(H.status_flags & GODMODE)
		return
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return

	if(!breath || (breath.total_moles() == 0))
		if(H.reagents.has_reagent(crit_stabilizing_reagent))
			return
		if(H.health >= H.crit_threshold)
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else if(!HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
			H.adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		H.failed_last_breath = TRUE
		var/alert_category
		var/alert_type
		if(ispath(breathing_class))
			var/datum/breathing_class/class = GLOB.gas_data.breathing_classes[breathing_class]
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
		else
			var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
			if(breathing_class in breath_alert_info)
				var/list/alert = breath_alert_info[breathing_class]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
		if(alert_category)
			H.throw_alert(alert_category, alert_type)
		return FALSE

	#define PP_MOLES(X) ((X / total_moles) * pressure)

	#define PP(air, gas) PP_MOLES(air.get_moles(gas))

	var/gas_breathed = 0

	var/pressure = breath.return_pressure()
	var/total_moles = breath.total_moles()
	var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
	var/list/breath_results = GLOB.gas_data.breath_results
	var/list/breathing_classes = GLOB.gas_data.breathing_classes
	var/list/mole_adjustments = list()
	for(var/entry in gas_min)
		var/required_pp = 0
		var/required_moles = 0
		var/safe_min = gas_min[entry]
		var/alert_category = null
		var/alert_type = null
		if(ispath(entry))
			var/datum/breathing_class/class = breathing_classes[entry]
			var/list/gases = class.gases
			var/list/products = class.products
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
			for(var/gas in gases)
				var/moles = breath.get_moles(gas)
				var/multiplier = gases[gas]
				mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - moles : -moles
				required_pp += PP_MOLES(moles) * multiplier
				required_moles += moles
				if(multiplier > 0)
					var/to_add = moles * multiplier
					for(var/product in products)
						mole_adjustments[product] = (product in mole_adjustments) ? mole_adjustments[product] + to_add : to_add
		else
			required_moles = breath.get_moles(entry)
			required_pp = PP_MOLES(required_moles)
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			mole_adjustments[entry] = -required_moles
			mole_adjustments[breath_results[entry]] = required_moles
		if(required_pp < safe_min)
			var/multiplier = handle_too_little_breath(H, required_pp, safe_min, required_moles)
			if(required_moles > 0)
				multiplier /= required_moles
			for(var/adjustment in mole_adjustments)
				mole_adjustments[adjustment] *= multiplier
			if(alert_category)
				H.throw_alert(alert_category, alert_type)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-breathModifier)
			if(alert_category)
				H.clear_alert(alert_category)
	var/list/danger_reagents = GLOB.gas_data.breath_reagents_dangerous
	for(var/entry in gas_max)
		var/found_pp = 0
		var/datum/breathing_class/breathing_class = entry
		var/datum/reagent/danger_reagent = null
		var/alert_category = null
		var/alert_type = null
		if(ispath(breathing_class))
			breathing_class = breathing_classes[breathing_class]
			alert_category = breathing_class.high_alert_category
			alert_type = breathing_class.high_alert_datum
			danger_reagent = breathing_class.danger_reagent
			found_pp = breathing_class.get_effective_pp(breath)
		else
			danger_reagent = danger_reagents[entry]
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["too_much_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			found_pp = PP(breath, entry)
		if(found_pp > gas_max[entry])
			if(istype(danger_reagent))
				H.reagents.add_reagent(danger_reagent,1)
			var/list/damage_info = (entry in gas_damage) ? gas_damage[entry] : gas_damage["default"]
			var/dam = found_pp / gas_max[entry] * 10
			H.apply_damage_type(clamp(dam, damage_info["min"], damage_info["max"]), damage_info["damage_type"])
			if(alert_category && alert_type)
				H.throw_alert(alert_category, alert_type)
		else if(alert_category)
			H.clear_alert(alert_category)
	var/list/breath_reagents = GLOB.gas_data.breath_reagents
	for(var/gas in breath.get_gases())
		if(gas in breath_reagents)
			var/datum/reagent/R = breath_reagents[gas]
			H.reagents.add_reagent(R, breath.get_moles(gas) * 2) // 2 represents molarity of O2, we don't have citadel molarity
			mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - breath.get_moles(gas) : -breath.get_moles(gas)

	if(can_smell)
		handle_smell(breath, H)

	for(var/gas in mole_adjustments)
		breath.adjust_moles(gas, mole_adjustments[gas])


	//-- TRACES --//

	if(breath)	// If there's some other shit in the air lets deal with it here.

	// N2O

		var/SA_pp = PP(breath, GAS_NITROUS)
		if(SA_pp > SA_para_min) // Enough to make us stunned for a bit
			H.Unconscious(60) // 60 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				H.Sleeping(200)
				ADD_TRAIT(owner, TRAIT_ANALGESIA, GAS_NITROUS)
		else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				H.emote(pick("giggle", "laugh"))
				SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")
			REMOVE_TRAIT(owner, TRAIT_ANALGESIA, GAS_NITROUS)


	// BZ

		var/bz_pp = PP(breath, GAS_BZ)
		if(bz_pp > BZ_brain_damage_min)
			H.hallucination += 10
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,5)
			if(prob(33))
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)

		else if(bz_pp > BZ_trip_balls_min)
			H.hallucination += 5
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,1)

	// Freon
		var/freon_pp = PP(breath,GAS_FREON)
		if (prob(freon_pp))
			to_chat(H, span_alert("Your mouth feels like it's burning!"))
		if (freon_pp >40)
			H.emote("gasp")
			H.adjustOxyLoss(15)
			if (prob(freon_pp/2))
				to_chat(H, span_alert("Your throat closes up!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustOxyLoss(freon_pp/4)
		gas_breathed = breath.get_moles(GAS_FREON)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/freon,1)

		breath.adjust_moles(GAS_FREON, -gas_breathed)

	// Chlorine
		var/chlorine_pp = PP(breath,GAS_CHLORINE)
		if (prob(chlorine_pp))
			to_chat(H, span_alert("Your lungs feel awful!"))
		if (chlorine_pp >20)
			H.emote("gasp")
			H.adjustOxyLoss(5)
			if (prob(chlorine_pp/2))
				to_chat(H, span_alert("Your throat closes up!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustOxyLoss(round(chlorine_pp/8))
		gas_breathed = breath.get_moles(GAS_CHLORINE)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/chlorine,1)

		breath.adjust_moles(GAS_CHLORINE, -gas_breathed)
	// Hydrogen Chloride
		var/hydrogen_chloride_pp = PP(breath,GAS_HYDROGEN_CHLORIDE)
		if (prob(hydrogen_chloride_pp))
			to_chat(H, span_alert("Your lungs feel terrible!"))
		if (hydrogen_chloride_pp >20)
			H.emote("gasp")
			H.adjustOxyLoss(10)
			if (prob(hydrogen_chloride_pp/2))
				to_chat(H, span_alert("Your throat closes up!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustOxyLoss(round(hydrogen_chloride_pp/4))
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/hydrogen_chloride)

		breath.adjust_moles(GAS_HYDROGEN_CHLORIDE, -gas_breathed)

	//TODO: This probably should be a status effect, While all gas effects are standardized here, monoxide is way too complicated for this system.
	// Carbon Monoxide
		var/carbon_monoxide_pp = PP(breath,GAS_CO)
		if (carbon_monoxide_pp > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/carbon_monoxide, 2)
			var/datum/reagent/carbon_monoxide/monoxide_reagent = H.reagents.has_reagent(/datum/reagent/carbon_monoxide)
			if(monoxide_reagent.volume > 10)
				monoxide_reagent.metabolization_rate = (10 - carbon_monoxide_pp)
			else
				monoxide_reagent.metabolization_rate = monoxide_reagent::metabolization_rate
			switch(carbon_monoxide_pp)
				if (0 to 20)
					monoxide_reagent.accumulation = min(monoxide_reagent.accumulation,50)
				if (20 to 100)
					monoxide_reagent.accumulation = min(monoxide_reagent.accumulation, 150)
					H.reagents.add_reagent(/datum/reagent/carbon_monoxide,2)
				if (100 to 200)
					monoxide_reagent.accumulation = min(monoxide_reagent.accumulation, 250)
					H.reagents.add_reagent(/datum/reagent/carbon_monoxide,4)
				if (200 to 400)
					monoxide_reagent.accumulation = min(monoxide_reagent.accumulation, 250)
					H.reagents.add_reagent(/datum/reagent/carbon_monoxide,8)
				if (400 to INFINITY)
					monoxide_reagent.accumulation = max(monoxide_reagent.accumulation, 450)
					H.reagents.add_reagent(/datum/reagent/carbon_monoxide,16)
		else
			var/datum/reagent/carbon_monoxide/monoxide_reagent = H.reagents.has_reagent(/datum/reagent/carbon_monoxide)
			if(monoxide_reagent)
				monoxide_reagent.accumulation = min(monoxide_reagent.accumulation, 150)
				monoxide_reagent.metabolization_rate = 10 //purges 10 per tick
		breath.adjust_moles(GAS_CO, -gas_breathed)

	// Sulfur Dioxide
		var/sulfur_dioxide_pp = PP(breath,GAS_SO2)
		if (prob(sulfur_dioxide_pp) && !HAS_TRAIT(H, TRAIT_ANALGESIA))
			to_chat(H, span_alert("It hurts to breath."))
		if (sulfur_dioxide_pp >40)
			H.emote("gasp")
			H.adjustOxyLoss(5)
			if (prob(sulfur_dioxide_pp/2))
				to_chat(H, span_alert("Your throat closes up!"))
				H.silent = max(H.silent, 3)
		else
			H.adjustOxyLoss(round(sulfur_dioxide_pp/8))
		gas_breathed = breath.get_moles(GAS_SO2)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/sulfur_dioxide,1)

		breath.adjust_moles(GAS_SO2, -gas_breathed)

	// Ozone
		var/ozone_pp = PP(breath,GAS_O3)
		if (prob(ozone_pp))
			to_chat(H, span_alert("Your heart feels funny."))
		if (ozone_pp >40)
			H.emote("gasp")
			H.adjustOxyLoss(5)
			if (prob(ozone_pp/2))
				to_chat(H, span_alert("Your throat closes up!"))
				H.silent = max(H.silent, 3)
		gas_breathed = breath.get_moles(GAS_O3)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/ozone,1)

		breath.adjust_moles(GAS_O3, -gas_breathed)

	// Ammonia
		var/ammonia_pp = PP(breath,GAS_AMMONIA)
		if (prob(ammonia_pp)*2)
			to_chat(H, span_alert("Your lungs feel terrible!"))

		if (ammonia_pp > 10)
			H.emote("gasp")
			H.adjustOxyLoss(5)
			H.adjustOxyLoss(round(ammonia_pp/8))
			if (prob(ammonia_pp/2))
				to_chat(H, span_alert("Your throat burns!</span>"))
				H.silent = max(H.silent, 2)
		else
			H.adjustOxyLoss(round(ammonia_pp/8))
		gas_breathed = breath.get_moles(GAS_AMMONIA)
		if (gas_breathed > gas_stimulation_min)
			if(prob(25))//unlike the chlorine reagent ammonia doesnt do lung damage do we handle it here instead
				H.adjustOrganLoss(ORGAN_SLOT_LUNGS,2*1.6)
			//ammonia is actually disposed of naturally by humans, but extremely poorly by non mammals, maybe we can make it toxic ONLY to certain species (plural) sometime?
			H.reagents.add_reagent(/datum/reagent/ammonia,1)

		breath.adjust_moles(GAS_AMMONIA, -gas_breathed)

// Plant lungs
/obj/item/organ/lungs/plant
	name = "mesophyll"
	desc = "A lung-shaped organ playing a key role in phytosian's photosynthesis." //phytosians don't need that for their light healing so that's just flavor, I might try to tie their light powers to it later(tm) //Not a promise made by me I am the thief
	icon = 'echo_13/icons/obj/surgery.dmi'
	icon_state = "lungs-plant"
	organ_flags = NONE
	breathing_class = BREATH_PLANT
	gas_max = list(GAS_PLASMA = MOLES_GAS_VISIBLE)

/obj/item/organ/lungs/plant/Initialize()
	. = ..()
	AddComponent(/datum/component/edible, list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/salbutamol = 5), null, VEGETABLES | FRUIT, null, 10, null, null, null, CALLBACK(src, PROC_REF(on_eat_from)))

#undef PP
#undef PP_MOLES
