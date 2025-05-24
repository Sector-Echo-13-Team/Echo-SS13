//Echo 13 - Add phyto hairs to the proc

/proc/make_datum_references_lists()
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, GLOB.hairstyles_list, GLOB.hairstyles_male_list, GLOB.hairstyles_female_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, GLOB.facial_hairstyles_list, GLOB.facial_hairstyles_male_list, GLOB.facial_hairstyles_female_list)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, GLOB.undershirt_list)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, GLOB.socks_list)
	//bodypart accessories (blizzard intensifies)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, GLOB.body_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard, GLOB.tails_list_lizard)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/lizard, GLOB.animated_tails_list_lizard)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, GLOB.tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/human, GLOB.animated_tails_list_human)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/face_markings, GLOB.face_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/horns,GLOB.horns_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, GLOB.ears_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings_open, GLOB.wings_open_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, GLOB.frills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, GLOB.spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spines_animated, GLOB.animated_spines_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/legs, GLOB.legs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, GLOB.r_wings_list,roundstart = TRUE)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_wings, GLOB.moth_wings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_markings, GLOB.moth_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_fluff, GLOB.moth_fluff_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/squid_face, GLOB.squid_face_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_screens, GLOB.ipc_screens_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_antennas, GLOB.ipc_antennas_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_tail, GLOB.ipc_tail_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/ipc_chassis, GLOB.ipc_chassis_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/moth_markings, GLOB.moth_markings_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spider_legs, GLOB.spider_legs_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/spider_spinneret, GLOB.spider_spinneret_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/kepori_feathers, GLOB.kepori_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/kepori_body_feathers, GLOB.kepori_body_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/kepori_head_feathers, GLOB.kepori_head_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/kepori_tail_feathers, GLOB.kepori_tail_feathers_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_head_quills, GLOB.vox_head_quills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/vox_neck_quills, GLOB.vox_neck_quills_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/elzu_horns,GLOB.elzu_horns_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/elzu, GLOB.tails_list_elzu)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/tails_animated/elzu, GLOB.animated_tails_list_elzu)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/phyto_hair, GLOB.phyto_hair_list)
	init_sprite_accessory_subtypes(/datum/sprite_accessory/phyto_flower, GLOB.phyto_flower_list)

	//Species
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		GLOB.species_list[S.id] = spath
	sortList(GLOB.species_list, /proc/cmp_typepaths_asc)

	//Species clothing
	for(var/spath in subtypesof(/datum/species))
		var/datum/species/S = new spath()
		GLOB.species_clothing_icons[S.id] = list()

	//Surgeries
	for(var/path in subtypesof(/datum/surgery))
		GLOB.surgeries_list += new path()
	sortList(GLOB.surgeries_list, /proc/cmp_typepaths_asc)

	// Hair Gradients - Initialise all /datum/sprite_accessory/hair_gradient into an list indexed by gradient-style name
	for(var/path in subtypesof(/datum/sprite_accessory/hair_gradient))
		var/datum/sprite_accessory/hair_gradient/H = new path()
		GLOB.hair_gradients_list[H.name] = H

	//Materials
	for(var/path in subtypesof(/datum/material))
		var/datum/material/D = new path()
		GLOB.materials_list[D.id] = D
	sortList(GLOB.materials_list, /proc/cmp_typepaths_asc)

	//Default Jobs
	for(var/path in subtypesof(/datum/job))
		var/datum/job/new_job = new path()
		GLOB.occupations += new_job
		GLOB.name_occupations[new_job.name] = new_job
		GLOB.type_occupations[path] = new_job

	// Keybindings
	init_keybindings()

	GLOB.emote_list = init_emote_list()

	init_subtypes(/datum/crafting_recipe, GLOB.crafting_recipes)

	make_echo_datum_references()

// Echo 13 - Echoprefs
/proc/make_echo_datum_references()
	make_culture_references()

/proc/make_culture_references()
	for(var/path in subtypesof(/datum/cultural_info/culture))
		var/datum/cultural_info/L = path
		if(!initial(L.name))
			continue
		L = new path()
		GLOB.culture_cultures[path] = L
	for(var/path in subtypesof(/datum/cultural_info/location))
		var/datum/cultural_info/L = path
		if(!initial(L.name))
			continue
		L = new path()
		GLOB.culture_locations[path] = L
	for(var/path in subtypesof(/datum/cultural_info/faction))
		var/datum/cultural_info/L = path
		if(!initial(L.name))
			continue
		L = new path()
		GLOB.culture_factions[path] = L
