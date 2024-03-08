//Additional var for wing details
/datum/species
	var/wings_detail

// Echo 13 - Add wing details to the proc
/**
 * Proc called when a carbon is no longer this species.
 *
 * This sets up and adds/changes/removes things, qualities, abilities, and traits so that the transformation is as smooth and bugfree as possible.
 * Produces a [COMSIG_SPECIES_LOSS] signal.
 * Arguments:
 * * C - Carbon, this is whoever lost this species.
 * * new_species - The new species that the carbon became, used for genetics mutations.
 * * pref_load - Preferences to be loaded from character setup, loads in preferred mutant things like bodyparts, digilegs, skin color, etc.
 */
/datum/species/proc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	if(C.dna.species.exotic_bloodtype)
		C.dna.blood_type = random_blood_type()

	if(NOMOUTH in species_traits)
		for(var/obj/item/bodypart/head/head in C.bodyparts)
			head.mouth = TRUE

	for(var/X in inherent_traits)
		REMOVE_TRAIT(C, X, SPECIES_TRAIT)

	//If their inert mutation is not the same, swap it out
	if((inert_mutation != new_species.inert_mutation) && LAZYLEN(C.dna.mutation_index) && (inert_mutation in C.dna.mutation_index))
		C.dna.remove_mutation(inert_mutation)
		//keep it at the right spot, so we can't have people taking shortcuts
		var/location = C.dna.mutation_index.Find(inert_mutation)
		C.dna.mutation_index[location] = new_species.inert_mutation
		C.dna.default_mutation_genes[location] = C.dna.mutation_index[location]
		C.dna.mutation_index[new_species.inert_mutation] = create_sequence(new_species.inert_mutation)
		C.dna.default_mutation_genes[new_species.inert_mutation] = C.dna.mutation_index[new_species.inert_mutation]

	if(inherent_factions)
		for(var/i in inherent_factions)
			C.faction -= i

	if(flying_species)
		fly.Remove(C)
		QDEL_NULL(fly)
		if(C.movement_type & FLYING)
			ToggleFlight(C)
	if(C.dna && C.dna.species && (C.dna.features["wings"] == wings_icon))
		if("wings" in C.dna.species.mutant_bodyparts)
			C.dna.species.mutant_bodyparts -= "wings"
		C.dna.features["wings"] = "None"
		if(wings_detail && C.dna.features["wingsdetail"] == wings_detail)
			if("wingsdetail" in C.dna.species.mutant_bodyparts)
				C.dna.species.mutant_bodyparts -= "wingsdetail"
			C.dna.features["wingsdetail"] = "None"
		C.update_body()

	C.remove_movespeed_modifier(/datum/movespeed_modifier/species)
	SEND_SIGNAL(C, COMSIG_SPECIES_LOSS, src)

// Echo 13 - Add phyto hairs to the proc
/**
 * Handles hair icons and dynamic hair.
 *
 * Handles hiding hair with clothing, hair layers, losing hair due to husking or augmented heads, facial hair, head hair, and hair styles.
 * Arguments:
 * * H - Human, whoever we're handling the hair for
 * * forced_colour - The colour of hair we're forcing on this human. Leave null to not change. Mind the british spelling!
 */
/datum/species/proc/handle_hair(mob/living/carbon/human/H, forced_colour)
	H.remove_overlay(HAIR_LAYER)
	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	if(!HD) //Decapitated
		return

	if(HAS_TRAIT(H, TRAIT_HUSK))
		return
	var/datum/sprite_accessory/S
	var/list/standing = list()

	var/hair_hidden = FALSE //ignored if the matching dynamic_X_suffix is non-empty
	var/facialhair_hidden = FALSE // ^

	//for augmented heads
	if(!IS_ORGANIC_LIMB(HD))
		return

	//we check if our hat or helmet hides our facial hair.
	if(H.head)
		var/obj/item/I = H.head
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/I = H.wear_mask
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = TRUE

	if(H.facial_hairstyle && (FACEHAIR in species_traits) && !facialhair_hidden)
		S = GLOB.facial_hairstyles_list[H.facial_hairstyle]
		if(S)

			var/mutable_appearance/facial_overlay = mutable_appearance(S.icon, S.icon_state, -HAIR_LAYER)

			if(!forced_colour)
				if(hair_color)
					if(hair_color == "mutcolor")
						facial_overlay.color = "#" + H.dna.features["mcolor"]
					else if(hair_color == "fixedmutcolor")
						facial_overlay.color = "#[fixed_mut_color]"
					else
						facial_overlay.color = "#" + hair_color
				else
					facial_overlay.color = "#" + H.facial_hair_color
			else
				facial_overlay.color = forced_colour

			facial_overlay.alpha = hair_alpha

			standing += facial_overlay

	if(H.head)
		var/obj/item/I = H.head
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(H.wear_mask)
		var/obj/item/I = H.wear_mask
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = TRUE

	if(!hair_hidden)
		var/mutable_appearance/hair_overlay = mutable_appearance(layer = -HAIR_LAYER)
		var/mutable_appearance/gradient_overlay = mutable_appearance(layer = -HAIR_LAYER)
		if(!hair_hidden && !H.getorgan(/obj/item/organ/brain)) //Applies the debrained overlay if there is no brain
			if(!(NOBLOOD in species_traits))
				hair_overlay.icon = 'icons/mob/human_face.dmi'
				hair_overlay.icon_state = "debrained"

		else if(H.hairstyle && (HAIR in species_traits))
			S = GLOB.hairstyles_list[H.hairstyle]
			if(S)

				var/hair_state = S.icon_state
				var/hair_file = S.icon

				hair_overlay.icon = hair_file
				hair_overlay.icon_state = hair_state

				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							hair_overlay.color = "#" + H.dna.features["mcolor"]
						else if(hair_color == "fixedmutcolor")
							hair_overlay.color = "#[fixed_mut_color]"
						else
							hair_overlay.color = "#" + hair_color
					else
						hair_overlay.color = "#" + H.hair_color

					//Gradients
					grad_style = H.grad_style
					grad_color = H.grad_color
					if(grad_style)
						var/datum/sprite_accessory/gradient = GLOB.hair_gradients_list[grad_style]
						var/icon/temp = icon(gradient.icon, gradient.icon_state)
						var/icon/temp_hair = icon(hair_file, hair_state)
						temp.Blend(temp_hair, ICON_ADD)
						gradient_overlay.icon = temp
						gradient_overlay.color = "#" + grad_color


				else
					hair_overlay.color = forced_colour
				hair_overlay.alpha = hair_alpha
		if(hair_overlay.icon)
			standing += hair_overlay
			standing += gradient_overlay

		if("phyto_hair" in H.dna.species.mutant_bodyparts)
		//alright bear with me for a second while i explain this awful code since it was literally 3 days of me bumbling through blind
		//for hair code to work, you need to start by removing the layer, as in the beginning with remove_overlay(head), then you need to use a mutable appearance variable
		//the mutable appearance will store the sprite file dmi, the name of the sprite (icon_state), and the layer this will go on (in this case HAIR_LAYER)
		//those are the basic variables, then you color the sprite with whatever source color you're using and set the alpha. from there it's added to the "standing" list
		//which is storing all the individual mutable_appearance variables (each one is a sprite), and then standing is loaded into the H.overlays_standing and finalized
		//with apply_overlays.
		//if you're working with sprite code i hope this helps because i wish i was dead now.
			S = GLOB.phyto_hair_list[H.dna.features["phyto_hair"]]
			if(S)
				if(ReadHSV(RGBtoHSV(H.hair_color))[3] <= ReadHSV("#7F7F7F")[3])
					H.hair_color = H.dna.species.default_color
				var/hair_state = S.icon_state
				var/hair_file = S.icon
				hair_overlay.icon = hair_file
				hair_overlay.icon_state = hair_state
				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							hair_overlay.color = "#" + H.dna.features["mcolor"]
						else if(hair_color == "fixedmutcolor")
							hair_overlay.color = "#[fixed_mut_color]"
						else
							hair_overlay.color = "#" + hair_color
					else
						hair_overlay.color = "#" + H.hair_color
				hair_overlay.alpha = hair_alpha
				standing+=hair_overlay
				//var/mutable_appearance/phyto_flower = mutable_appearance(GLOB.phyto_flower_list[H.dna.features["phyto_flower"]].icon, GLOB.phyto_flower_list[H.dna.features["phyto_flower"]].icon_state, -HAIR_LAYER)
				S = GLOB.phyto_flower_list[H.dna.features["phyto_flower"]]
				if(S)
					var/flower_state = S.icon_state
					var/flower_file = S.icon
					// flower_overlay.icon = flower_file
					// flower_overlay.icon_state = flower_state
					var/mutable_appearance/flower_overlay = mutable_appearance(flower_file, flower_state, -HAIR_LAYER)
					if(!forced_colour)
						if(hair_color)
							if(hair_color == "mutcolor")
								flower_overlay.color = "#" + H.dna.features["mcolor"]
							else if(hair_color == "fixedmutcolor")
								flower_overlay.color = "#[fixed_mut_color]"
							else
								flower_overlay.color = "#" + hair_color
						else
							flower_overlay.color = "#" + H.facial_hair_color
					flower_overlay.alpha = hair_alpha
					standing += flower_overlay

	if(standing.len)
		H.overlays_standing[HAIR_LAYER] = standing

	H.apply_overlay(HAIR_LAYER)

// Echo 13 - Add phyto hairs and wing details to the proc
/**
 * Handles the mutant bodyparts of a human
 *
 * Handles the adding and displaying of, layers, colors, and overlays of mutant bodyparts and accessories.
 * Handles digitigrade leg displaying and squishing.
 * Arguments:
 * * H - Human, whoever we're handling the body for
 * * forced_colour - The forced color of an accessory. Leave null to use mutant color.
 */
/datum/species/proc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/list/standing	= list()

	H.remove_overlay(BODY_BEHIND_LAYER)
	H.remove_overlay(BODY_ADJ_LAYER)
	H.remove_overlay(BODY_FRONT_LAYER)

	if(!mutant_bodyparts)
		return

	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)

	if("tail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_human"

	if("waggingtail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_human"
		else if ("tail_human" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_human"

	if("spines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "spines"

	if("waggingspines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingspines"
		else if ("tail" in mutant_bodyparts)
			bodyparts_to_add -= "waggingspines"

	if("face_markings" in mutant_bodyparts) //Take a closer look at that snout! //technically
		if((H.wear_mask?.flags_inv & HIDEFACE) || (H.head?.flags_inv & HIDEFACE) || !HD)
			bodyparts_to_add -= "face_markings"

	if("horns" in mutant_bodyparts)
		if(!H.dna.features["horns"] || H.dna.features["horns"] == "None" || H.head && (H.head.flags_inv & HIDEHORNS) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHORNS)) || !HD)
			bodyparts_to_add -= "horns"

	if("frills" in mutant_bodyparts)
		if(!H.dna.features["frills"] || H.dna.features["frills"] == "None" || (H.head?.flags_inv & HIDEEARS) || !HD)
			bodyparts_to_add -= "frills"

	if("ears" in mutant_bodyparts)
		if(!H.dna.features["ears"] || H.dna.features["ears"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "ears"
			bodyparts_to_add -= "ears"

	if("ipc_screen" in mutant_bodyparts)
		if(!H.dna.features["ipc_screen"] || H.dna.features["ipc_screen"] == "None" || (H.wear_mask && (H.wear_mask.flags_inv & HIDEEYES)) || !HD)
			bodyparts_to_add -= "ipc_screen"

	if("ipc_antenna" in mutant_bodyparts)
		if(!H.dna.features["ipc_antenna"] || H.dna.features["ipc_antenna"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || !HD)
			bodyparts_to_add -= "ipc_antenna"

	if("spider_mandibles" in mutant_bodyparts)
		if(!H.dna.features["spider_mandibles"] || H.dna.features["spider_mandibles"] == "None" || H.head && (H.head.flags_inv & HIDEFACE) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || !HD) //|| HD.status == BODYTYPE_ROBOTIC removed from here
			bodyparts_to_add -= "spider_mandibles"

	if("squid_face" in mutant_bodyparts)
		if(!H.dna.features["squid_face"] || H.dna.features["squid_face"] == "None" || H.head && (H.head.flags_inv & HIDEFACE) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || !HD) // || HD.status == BODYTYPE_ROBOTIC
			bodyparts_to_add -= "squid_face"

	if("kepori_tail_feathers" in mutant_bodyparts)
		if(!H.dna.features["kepori_tail_feathers"] || H.dna.features["kepori_tail_feathers"] == "None")
			bodyparts_to_add -= "kepori_tail_feathers"

	if("kepori_feathers" in mutant_bodyparts)
		if(!H.dna.features["kepori_feathers"] || H.dna.features["kepori_feathers"] == "None" || (H.head && (H.head.flags_inv & HIDEHAIR)) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD) //HD.status == BODYTYPE_ROBOTIC) and here too
			bodyparts_to_add -= "kepori_feathers"

	if("vox_head_quills" in mutant_bodyparts)
		if(!H.dna.features["vox_head_quills"] || H.dna.features["vox_head_quills"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "vox_head_quills"

	if("vox_neck_quills" in mutant_bodyparts)
		if(!H.dna.features["vox_neck_quills"] || H.dna.features["vox_neck_quills"] == "None")
			bodyparts_to_add -= "vox_neck_quills"

	if("phyto_hair" in mutant_bodyparts)
		if(!H.dna.features["phyto_hair"] || H.dna.features["phyto_hair"] == "None" || (H.head && (H.head.flags_inv & HIDEHAIR)) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "phyto_hair"

	if("phyto_flower" in mutant_bodyparts)
		if(!H.dna.features["phyto_flower"] || H.dna.features["phyto_flower"] == "None" || (H.head && (H.head.flags_inv & HIDEHAIR)) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
			bodyparts_to_add -= "phyto_flower"
		if(H.dna.features["phyto_flower"] != H.dna.features["phyto_hair"])
			H.dna.features["phyto_flower"] = H.dna.features["phyto_hair"]

	////PUT ALL YOUR WEIRD ASS REAL-LIMB HANDLING HERE

	///Digi handling
	if(H.dna.species.bodytype & BODYTYPE_DIGITIGRADE)
		var/uniform_compatible = FALSE
		var/suit_compatible = FALSE
		if(!(H.w_uniform) || (H.w_uniform.supports_variations & DIGITIGRADE_VARIATION) || (H.w_uniform.supports_variations & DIGITIGRADE_VARIATION_NO_NEW_ICON)) //Checks uniform compatibility
			uniform_compatible = TRUE
		if((!H.wear_suit) || (H.wear_suit.supports_variations & DIGITIGRADE_VARIATION) || !(H.wear_suit.body_parts_covered & LEGS) || (H.wear_suit.supports_variations & DIGITIGRADE_VARIATION_NO_NEW_ICON)) //Checks suit compatability
			suit_compatible = TRUE

		var/show_digitigrade = suit_compatible && (uniform_compatible || H.wear_suit?.flags_inv & HIDEJUMPSUIT) //If the uniform is hidden, it doesnt matter if its compatible
		for(var/obj/item/bodypart/BP as anything in H.bodyparts)
			if(BP.bodytype & BODYTYPE_DIGITIGRADE)
				BP.plantigrade_forced = !show_digitigrade

	///End digi handling

	////END REAL-LIMB HANDLING
	H.update_body_parts()



	if(!bodyparts_to_add)
		return

	var/g = (H.gender == FEMALE) ? "f" : "m"

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/S
			switch(bodypart)
				if("tail_lizard")
					S = GLOB.tails_list_lizard[H.dna.features["tail_lizard"]]
				if("waggingtail_lizard")
					S = GLOB.animated_tails_list_lizard[H.dna.features["tail_lizard"]]
				if("tail_human")
					S = GLOB.tails_list_human[H.dna.features["tail_human"]]
				if("waggingtail_human")
					S = GLOB.animated_tails_list_human[H.dna.features["tail_human"]]
				if("spines")
					S = GLOB.spines_list[H.dna.features["spines"]]
				if("waggingspines")
					S = GLOB.animated_spines_list[H.dna.features["spines"]]
				if("face_markings")
					S = GLOB.face_markings_list[H.dna.features["face_markings"]]
				if("frills")
					S = GLOB.frills_list[H.dna.features["frills"]]
				if("horns")
					S = GLOB.horns_list[H.dna.features["horns"]]
				if("ears")
					S = GLOB.ears_list[H.dna.features["ears"]]
				if("body_markings")
					S = GLOB.body_markings_list[H.dna.features["body_markings"]]
				if("wings")
					S = GLOB.wings_list[H.dna.features["wings"]]
				if("wingsopen")
					S = GLOB.wings_open_list[H.dna.features["wings"]]
				if("wingsdetail")
					S = GLOB.wings_list[H.dna.features["wingsdetail"]]
				if("wingsdetailopen")
					S = GLOB.wings_open_list[H.dna.features["wingsdetail"]]
				if("legs")
					S = GLOB.legs_list[H.dna.features["legs"]]
				if("moth_wings")
					S = GLOB.moth_wings_list[H.dna.features["moth_wings"]]
				if("moth_fluff")
					S = GLOB.moth_fluff_list[H.dna.features["moth_fluff"]]
				if("moth_markings")
					S = GLOB.moth_markings_list[H.dna.features["moth_markings"]]
				if("squid_face")
					S = GLOB.squid_face_list[H.dna.features["squid_face"]]
				if("ipc_screen")
					S = GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]
				if("ipc_antenna")
					S = GLOB.ipc_antennas_list[H.dna.features["ipc_antenna"]]
				if("ipc_tail")
					S = GLOB.ipc_tail_list[H.dna.features["ipc_tail"]]
				if("ipc_chassis")
					S = GLOB.ipc_chassis_list[H.dna.features["ipc_chassis"]]
				if("ipc_brain")
					S = GLOB.ipc_brain_list[H.dna.features["ipc_brain"]]
				if("spider_legs")
					S = GLOB.spider_legs_list[H.dna.features["spider_legs"]]
				if("spider_spinneret")
					S = GLOB.spider_spinneret_list[H.dna.features["spider_spinneret"]]
				if("kepori_body_feathers")
					S = GLOB.kepori_body_feathers_list[H.dna.features["kepori_body_feathers"]]
				if("kepori_tail_feathers")
					S = GLOB.kepori_tail_feathers_list[H.dna.features["kepori_tail_feathers"]]
				if("kepori_feathers")
					S = GLOB.kepori_feathers_list[H.dna.features["kepori_feathers"]]
				if("vox_head_quills")
					S = GLOB.vox_head_quills_list[H.dna.features["vox_head_quills"]]
				if("vox_neck_quills")
					S = GLOB.vox_neck_quills_list[H.dna.features["vox_neck_quills"]]
				if("elzu_horns")
					S = GLOB.elzu_horns_list[H.dna.features["elzu_horns"]]
				if("tail_elzu")
					S = GLOB.tails_list_elzu[H.dna.features["tail_elzu"]]
				if("waggingtail_elzu")
					S = GLOB.animated_tails_list_elzu[H.dna.features["tail_elzu"]]
			if(!S || S.icon_state == "none")
				continue

			var/mutable_appearance/accessory_overlay = mutable_appearance(S.icon, layer = -layer)

			//A little rename so we don't have to use tail_lizard, tail_human, or tail_elzu when naming the sprites.
			accessory_overlay.alpha = S.image_alpha
			if(bodypart == "tail_lizard" || bodypart == "tail_human" || bodypart == "tail_elzu")
				bodypart = "tail"
			else if(bodypart == "waggingtail_lizard" || bodypart == "waggingtail_human" || bodypart == "waggingtail_elzu")
				bodypart = "waggingtail"

			var/used_color_src = S.color_src

			var/icon_state_name = S.icon_state
			if(S.synthetic_icon_state)
				var/obj/item/bodypart/attachment_point = H.get_bodypart(S.body_zone)
				if(attachment_point && IS_ROBOTIC_LIMB(attachment_point))
					icon_state_name = S.synthetic_icon_state
					if(S.synthetic_color_src)
						used_color_src = S.synthetic_color_src

			if(S.gender_specific)
				accessory_overlay.icon_state = "[g]_[bodypart]_[icon_state_name]_[layertext]"
			else
				accessory_overlay.icon_state = "m_[bodypart]_[icon_state_name]_[layertext]"

			if(S.center)
				accessory_overlay = center_image(accessory_overlay, S.dimension_x, S.dimension_y)

			if(!(HAS_TRAIT(H, TRAIT_HUSK)))
				if(!forced_colour)
					switch(used_color_src)
						if(MUTCOLORS)
							if(fixed_mut_color)
								accessory_overlay.color = "#[fixed_mut_color]"
							else
								accessory_overlay.color = "#[H.dna.features["mcolor"]]"
						if(MUTCOLORS_SECONDARY)
							accessory_overlay.color = "#[H.dna.features["mcolor2"]]"
						if(SKINCOLORS)
							accessory_overlay.color = "#[(skintone2hex(H.skin_tone))]"

						if(HAIR)
							if(hair_color == "mutcolor")
								accessory_overlay.color = "#[H.dna.features["mcolor"]]"
							else if(hair_color == "fixedmutcolor")
								accessory_overlay.color = "#[fixed_mut_color]"
							else
								accessory_overlay.color = "#[H.hair_color]"
						if(FACEHAIR)
							accessory_overlay.color = "#[H.facial_hair_color]"
						if(EYECOLOR)
							accessory_overlay.color = "#[H.eye_color]"
				else
					accessory_overlay.color = forced_colour
			standing += accessory_overlay

			if(S.secondary_color)
				var/mutable_appearance/secondary_color_overlay = mutable_appearance(S.icon, layer = -layer)
				if(S.gender_specific)
					secondary_color_overlay.icon_state = "[g]_[bodypart]_secondary_[S.icon_state]_[layertext]"
				else
					secondary_color_overlay.icon_state = "m_[bodypart]_secondary_[S.icon_state]_[layertext]"

				if(S.center)
					secondary_color_overlay = center_image(secondary_color_overlay, S.dimension_x, S.dimension_y)
				secondary_color_overlay.color = "#[H.dna.features["mcolor2"]]"
				standing += secondary_color_overlay

		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(BODY_BEHIND_LAYER)
	H.apply_overlay(BODY_ADJ_LAYER)
	H.apply_overlay(BODY_FRONT_LAYER)

// Echo 13 - Add wing details to the proc
/datum/species/proc/GiveSpeciesFlight(mob/living/carbon/human/H)
	if(flying_species) //species that already have flying traits should not work with this proc
		return
	flying_species = TRUE
	if(wings_icons.len > 1)
		if(!H.client)
			wings_icon = pick(wings_icons)
		else
			var/list/wings = list()
			for(var/W in wings_icons)
				var/datum/sprite_accessory/S = GLOB.wings_list[W]	//Gets the datum for every wing this species has, then prompts user with a radial menu
				var/image/img = image(icon = 'icons/mob/clothing/wings.dmi', icon_state = "m_wingsopen_[S.icon_state]_BEHIND")	//Process the HUD elements
				img.transform *= 0.5
				img.pixel_x = -32
				if(wings[S.name])
					stack_trace("Different wing types with repeated names. Please fix as this may cause issues.")
				else
					wings[S.name] = img
			wings_icon = show_radial_menu(H, H, wings, tooltips = TRUE)
			if(!wings_icon)
				wings_icon = pick(wings_icons)
	else
		wings_icon = wings_icons[1]
	if(isnull(fly))
		fly = new
		fly.Grant(H)
	if(H.dna.features["wings"] != wings_icon)
		mutant_bodyparts |= "wings"
		H.dna.features["wings"] = wings_icon
		if(wings_detail && H.dna.features["wingsdetail"] != wings_detail)
			mutant_bodyparts |= "wingsdetail"
			H.dna.features["wingsdetail"] = wings_detail
		H.update_body()
