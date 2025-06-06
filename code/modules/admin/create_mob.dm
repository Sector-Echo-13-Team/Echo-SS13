
/datum/admins/proc/create_mob(mob/user)
	var/static/create_mob_html
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "Create Object", "Create Mob")
		create_mob_html = replacetext(create_mob_html, "null; /* object types */", "\"[mobjs]\"")

	user << browse(create_panel_helper(create_mob_html), "window=create_mob;size=425x475")

/* /proc/randomize_human(mob/living/carbon/human/H) // Echo 13 - Start - Mirrored to create_mob.dm
	H.gender = pick(MALE, FEMALE)
	H.real_name = random_unique_name(H.gender)
	H.name = H.real_name
	H.underwear = random_underwear(H.gender)
	H.underwear_color = random_color()
	H.skin_tone = random_skin_tone()
	H.hairstyle = random_hairstyle(H.gender)
	H.facial_hairstyle = random_facial_hairstyle(H.gender)
	H.hair_color = random_color_natural()
	H.facial_hair_color = H.hair_color
	H.eye_color = random_eye_color()
	H.dna.blood_type = random_blood_type()
	H.generic_adjective = pick_species_adjective(H)

	// Mutant randomizing, doesn't affect the mob appearance unless it's the specific mutant.
	H.dna.features["mcolor"] = random_short_color()
	H.dna.features["mcolor2"] = random_short_color()
	H.dna.features["ethcolor"] = GLOB.color_list_ethereal[pick(GLOB.color_list_ethereal)]
	H.dna.features["tail_lizard"] = pick(GLOB.tails_list_lizard)
	H.dna.features["face_markings"] = pick(GLOB.face_markings_list)
	H.dna.features["horns"] = pick(GLOB.horns_list)
	H.dna.features["frills"] = pick(GLOB.frills_list)
	H.dna.features["spines"] = pick(GLOB.spines_list)
	H.dna.features["body_markings"] = pick(GLOB.body_markings_list)
	H.dna.features["moth_wings"] = pick(GLOB.moth_wings_list)
	H.dna.features["moth_fluff"] = pick(GLOB.moth_fluff_list)
	H.dna.features["spider_legs"] = pick(GLOB.spider_legs_list)
	H.dna.features["spider_spinneret"] = pick(GLOB.spider_spinneret_list)
	H.dna.features["squid_face"] = pick(GLOB.squid_face_list)
	H.dna.features["kepori_feathers"] = pick(GLOB.kepori_feathers_list)
	H.dna.features["kepori_body_feathers"] = pick(GLOB.kepori_body_feathers_list)
	H.dna.features["kepori_head_feathers"] = pick(GLOB.kepori_head_feathers_list)
	H.dna.features["vox_head_quills"] = pick(GLOB.vox_head_quills_list)
	H.dna.features["vox_neck_quills"] = pick(GLOB.vox_neck_quills_list)
	H.dna.features["elzu_horns"] = pick(GLOB.elzu_horns_list)
	H.dna.features["tail_elzu"] = pick(GLOB.tails_list_elzu)

	H.update_body()
	H.update_hair() */ // Echo 13 - End - Mirrored to create_mob.dm
