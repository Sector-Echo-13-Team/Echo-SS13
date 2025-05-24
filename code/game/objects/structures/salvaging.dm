/obj/structure/salvageable
	name = "broken machinery"
	desc = "It's broken beyond repair. You may be able to salvage something from this."
	icon = 'icons/obj/salvage_structure.dmi'
	density = TRUE
	anchored = TRUE
	var/salvageable_parts = list()
	var/frame_type = /obj/structure/frame/machine

/obj/structure/salvageable/examine(mob/user)
	. = ..()
	. += "You can use a crowbar to salvage this."

/obj/structure/salvageable/proc/dismantle(mob/living/user)
	var/obj/frame = new frame_type(get_turf(src))
	frame.anchored = anchored
	frame.dir = dir
	for(var/path in salvageable_parts)
		if(prob(salvageable_parts[path]))
			new path (loc)

/obj/structure/salvageable/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return FALSE
	user.visible_message(span_notice("[user] starts dismantling [src]."), \
					span_notice("You start salvaging anything useful from [src]..."))
	tool.play_tool_sound(src, 100)
	if(do_after(user, 8 SECONDS, target = src))
		user.visible_message(span_notice("[user] dismantles [src]."), \
						span_notice("You salvage [src]."))
		dismantle(user)
		tool.play_tool_sound(src, 100)
		qdel(src)
	return TRUE

/obj/structure/salvageable/deconstruct_act(mob/living/user, obj/item/tool)
	. = ..()
	if(.)
		return FALSE
	user.visible_message(span_notice("[user] starts slicing [src]."), \
					span_notice("You start salvaging anything useful from [src]..."))
	if(tool.use_tool(src, user, 6 SECONDS))
		user.visible_message(span_notice("[user] dismantles [src]."), \
						span_notice("You salvage [src]."))
		dismantle(user)
		qdel(src)
	return TRUE

//Types themself, use them, but not the parent object

/obj/structure/salvageable/machine
	name = "broken machine"
	icon_state = "wreck_pda"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapgold/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,

		/obj/effect/spawner/random/salvage/part/capacitor = 50,
		/obj/effect/spawner/random/salvage/part/capacitor = 50,
		/obj/effect/spawner/random/salvage/part/scanning = 50,
		/obj/effect/spawner/random/salvage/part/scanning = 50,
		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/manipulator = 40,
		/obj/effect/spawner/random/salvage/part/manipulator = 40,
		/obj/effect/spawner/random/salvage_laser = 40,
		/obj/effect/spawner/random/salvage_laser = 40,
	)

/obj/structure/salvageable/computer
	name = "broken computer"
	icon_state = "computer_broken"
	frame_type = /obj/structure/frame/computer/retro
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 90,
		/obj/item/stack/ore/salvage/scrapsilver/five = 90,
		/obj/item/stack/ore/salvage/scrapgold/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,

		/obj/effect/spawner/random/salvage/part/capacitor = 60,

		/obj/item/computer_hardware/battery = 40,
		/obj/item/computer_hardware/battery = 40,
		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/computer_hardware/card_slot = 40,
		/obj/item/computer_hardware/card_slot = 40,
		/obj/item/computer_hardware/network_card/advanced = 20,

		/obj/effect/spawner/random/circuit/computer/common = 50,
		/obj/effect/spawner/random/circuit/computer/rare = 5,

		/obj/item/research_notes/loot/tiny = 10,
	)

/obj/structure/salvageable/autolathe
	name = "broken autolathe"
	icon_state = "wreck_autolathe"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,

		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/manipulator = 30,

		/obj/item/circuitboard/machine/autolathe = 35,

		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/glass/five = 10,
		/obj/item/stack/sheet/plastic/five = 10,
		/obj/item/stack/sheet/plasteel/five = 10,
		/obj/item/stack/sheet/mineral/silver/five = 10,
		/obj/item/stack/sheet/mineral/gold/five = 10,
		/obj/item/stack/sheet/mineral/plasma/five = 10,
		/obj/item/stack/sheet/mineral/uranium/five = 5,
		/obj/item/stack/sheet/mineral/diamond/five = 1,
	)

/obj/structure/salvageable/protolathe
	name = "broken protolathe"
	icon_state = "wreck_protolathe"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapplasma/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,

		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/manipulator = 30,
		/obj/effect/spawner/random/salvage/part/manipulator = 30,

		/obj/effect/spawner/random/engineering/tool = 45,
		/obj/effect/spawner/random/medical/surgery_tool = 55,
		/obj/effect/spawner/random/medical/beaker = 45,
		/obj/effect/spawner/random/medical/prosthetic = 25,
		/obj/effect/spawner/random/salvage/prolathe/gun = 5, //:flushed:
		/obj/effect/spawner/random/salvage/prolathe/ammo = 5,

		/obj/item/storage/part_replacer = 20,
		/obj/item/storage/part_replacer/bluespace = 1,
		/obj/item/mop = 20,
		/obj/item/mop/advanced = 1, // the holy grail

		/obj/item/stack/sheet/metal/five = 15, //the point isnt the materials in the protolathe wreckage but you can still get them for flavor and stuff
		/obj/item/stack/sheet/glass/five = 15,
		/obj/item/stack/sheet/plastic/five = 15,
		/obj/item/stack/sheet/plasteel/five = 15,
		/obj/item/stack/sheet/mineral/silver/five = 15,
		/obj/item/stack/sheet/mineral/gold/five = 15,
		/obj/item/stack/sheet/mineral/plasma/five = 10,
		/obj/item/stack/sheet/mineral/uranium/five = 5,
		/obj/item/stack/sheet/mineral/diamond/five = 1,
	)

/obj/structure/salvageable/circuit_imprinter
	name = "broken circuit imprinter"
	icon_state = "wreck_circuit_imprinter"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapuranium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/item/stack/ore/salvage/scrapbluespace = 60,

		/obj/effect/spawner/random/salvage/part/matter_bin = 40,
		/obj/effect/spawner/random/salvage/part/manipulator = 30,

		/obj/item/stack/circuit_stack = 50, //this might be the only way in the game to get a poly circuit, and the only way for many ships to get essensial electronics. huh.
		/obj/effect/spawner/random/circuit/machine/mech = 45, //with all the wonderful broken mechs lying around, this might be a chance to get something stupidly overpowered.
		/obj/effect/spawner/random/circuit/machine/common = 50, //well.... "common"
		/obj/effect/spawner/random/circuit/machine/rare = 5,

		/obj/item/stack/sheet/metal/five = 15, //same as above but more geared towards stuff used by circuit imprinter
		/obj/item/stack/sheet/glass/five = 15,
		/obj/item/stack/sheet/mineral/silver/five = 15,
		/obj/item/stack/sheet/mineral/gold/five = 15,
		/obj/item/stack/sheet/bluespace_crystal/five = 5,
		/obj/item/stack/sheet/mineral/diamond/five = 1,
	)

/obj/structure/salvageable/destructive_analyzer
	name = "broken destructive analyzer"
	desc = "If this thing could power up, it would probably slice you in half. You may be able to salvage something from this." //this ones pretty dangerous
	icon_state = "wreck_d_analyzer"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapuranium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/item/stack/ore/salvage/scrapplasma = 60,

		/obj/effect/spawner/random/salvage/part/scanning = 40,
		/obj/effect/spawner/random/salvage_laser = 30,
		/obj/effect/spawner/random/salvage/part/manipulator = 30,

		/obj/item/storage/toolbox/syndicate/empty = 80,
		/obj/effect/spawner/random/salvage/destructive_analyzer = 65,

		/obj/item/stack/sheet/metal/five = 15, //same as above but more geared towards stuff used by circuit imprinter
		/obj/item/stack/sheet/glass/five = 15,
		/obj/item/stack/sheet/mineral/silver/five = 15,
		/obj/item/stack/sheet/mineral/gold/five = 15,
		/obj/item/stack/sheet/bluespace_crystal/five = 5,
		/obj/item/stack/sheet/mineral/diamond/five = 1,
	)

/obj/structure/salvageable/destructive_analyzer/dismantle(mob/living/user)
	. = ..()
	var/danger_level = rand(1,100)
	switch(danger_level) //scary.
		if(1 to 40)
			audible_message(span_notice("You can hear the sound of broken glass in the [src]."))
		if(41 to 60)
			visible_message(span_danger("You flinch as the [src]'s laser apparatus lights up, but your tool destroys it before it activates..."))
		if(61 to 79)
			visible_message(span_danger("You see a dim light from the [src] before the laser reactivates in your face!"))
			shoot_projectile(user, /obj/projectile/beam/scatter)
		if(80 to 89)
			visible_message(span_danger("You see a bright light from the [src] before the laser reactivates in your face!"))
			shoot_projectile(user, /obj/projectile/beam)
		if(90 to 100)
			visible_message(span_danger("You see an intense light from the [src] before the laser reactivates in your face!"))
			shoot_projectile(user, /obj/projectile/beam/laser/heavylaser) //i'd like to make this flash people. but i'm not sure how to do that. shame!

/obj/structure/salvageable/destructive_analyzer/proc/shoot_projectile(mob/living/target, obj/projectile/projectile_to_shoot)
	var/obj/projectile/projectile_being_shot = new projectile_to_shoot(get_turf(src))
	projectile_being_shot.preparePixelProjectile(get_step(src, pick(GLOB.alldirs)), get_turf(src))
	projectile_being_shot.firer = src
	projectile_being_shot.fire(Get_Angle(src,target))

/obj/structure/salvageable/server
	name = "broken server"
	icon_state = "wreck_server"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapuranium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/item/stack/ore/salvage/scrapbluespace = 60,

		/obj/item/research_notes/loot/tiny = 50,
		/obj/item/research_notes/loot/medium = 20,
		/obj/item/research_notes/loot/big = 5, //you have a chance at summoning god damn ripley lobster from this thing, might as well

		/obj/item/disk/tech_disk = 20,
		/obj/item/disk/data = 20,
		/obj/item/disk/holodisk = 20,
		/obj/item/disk/plantgene = 20,

		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/stock_parts/subspace/amplifier = 40,
		/obj/item/stock_parts/subspace/amplifier = 40,
		/obj/item/stock_parts/subspace/analyzer = 40,
		/obj/item/stock_parts/subspace/analyzer = 40,
		/obj/item/stock_parts/subspace/ansible = 40,
		/obj/item/stock_parts/subspace/ansible = 40,
		/obj/item/stock_parts/subspace/transmitter = 40,
		/obj/item/stock_parts/subspace/transmitter = 40,
		/obj/item/stock_parts/subspace/crystal = 30,
		/obj/item/stock_parts/subspace/crystal = 30,
		/obj/item/computer_hardware/network_card/advanced = 20,
	)

/obj/structure/salvageable/server/dismantle(mob/living/user)
	. = ..()
	var/danger_level = rand(1,100)
	switch(danger_level) //ever wanted the extreme danger of turn based rng but in space station 13?
		if(1 to 45)
			audible_message(span_notice("The [src] makes a crashing sound as its salvaged."))

		if(46 to 89)
			playsound(src, 'sound/machines/buzz-two.ogg', 100, FALSE, FALSE)
			audible_message(span_danger("You hear a buzz from the [src] and a voice,"))
			new /mob/living/simple_animal/bot/medbot/rockplanet(get_turf(src))

		if(95 to 100)
			playsound(src, 'sound/machines/buzz-two.ogg', 100, FALSE, FALSE)
			audible_message(span_danger("You hear a buzz from the [src] and a voice,"))

			new /mob/living/simple_animal/bot/firebot/rockplanet(get_turf(src))

		if(90 to 94)
			playsound(src, 'sound/machines/buzz-two.ogg', 100, FALSE, FALSE)
			audible_message(span_danger("You hear as buzz from the [src] as an abandoned security bot rolls out from the [src]!!"))

			new /mob/living/simple_animal/bot/secbot/ed209/rockplanet(get_turf(src))

/obj/structure/salvageable/safe_server //i am evil and horrible and i don't deserve to touch code
	name = "broken server"
	icon_state = "wreck_server"
	salvageable_parts = list(
		/obj/item/stack/sheet/glass/two = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scrapuranium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/item/stack/ore/salvage/scrapbluespace = 60,

		/obj/item/research_notes/loot/tiny = 50,
		/obj/item/research_notes/loot/medium = 20,
		/obj/item/research_notes/loot/big = 5,

		/obj/item/disk/tech_disk = 20,
		/obj/item/disk/data = 20,
		/obj/item/disk/holodisk = 20,
		/obj/item/disk/plantgene = 20,

		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/network_card = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/computer_hardware/processor_unit = 40,
		/obj/item/stock_parts/subspace/amplifier = 40,
		/obj/item/stock_parts/subspace/amplifier = 40,
		/obj/item/stock_parts/subspace/analyzer = 40,
		/obj/item/stock_parts/subspace/analyzer = 40,
		/obj/item/stock_parts/subspace/ansible = 40,
		/obj/item/stock_parts/subspace/ansible = 40,
		/obj/item/stock_parts/subspace/transmitter = 40,
		/obj/item/stock_parts/subspace/transmitter = 40,
		/obj/item/stock_parts/subspace/crystal = 30,
		/obj/item/stock_parts/subspace/crystal = 30,
		/obj/item/computer_hardware/network_card/advanced = 20,
	)

/obj/structure/salvageable/seed
	name = "ruined seed vendor"
	desc = "This is where the seeds lived. Maybe you can still get some?"//megaseed voiceline reference
	icon_state = "seeds-broken"
	icon = 'icons/obj/vending.dmi'
	color = "#808080"

	salvageable_parts = list(
		/obj/effect/spawner/random/food_or_drink/seed = 80,
		/obj/effect/spawner/random/food_or_drink/seed = 80,
		/obj/effect/spawner/random/food_or_drink/seed = 80,
		/obj/effect/spawner/random/food_or_drink/seed = 80,
		/obj/effect/spawner/random/food_or_drink/seed = 80,
		/obj/item/seeds/random = 80,
		/obj/item/seeds/random = 40,
		/obj/item/seeds/random = 40,
		/obj/item/stack/ore/salvage/scrapmetal/five = 80,
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/disk/plantgene = 20,
	)

/obj/structure/salvageable/seed/dismantle(mob/living/user)
	. = ..()
	var/danger_level = rand(1,100)
	switch(danger_level)
		if(1 to 50)
			audible_message(span_notice("The [src] buzzes softly as it falls apart."))

		if(51 to 80)
			playsound(src, 'sound/machines/buzz-two.ogg', 100, FALSE, FALSE)
			audible_message(span_danger("As the [src] collapses, an oversized tomato lunges out from inside!"))
			new /mob/living/simple_animal/hostile/killertomato(get_turf(src))

		if(81 to 100)
			playsound(src, 'sound/machines/buzz-two.ogg', 100, FALSE, FALSE)
			audible_message(span_danger("A bundle of vines unfurls from inside the [src]!"))
			new /mob/living/simple_animal/hostile/venus_human_trap(get_turf(src))

//scrap item, mostly for fluff
/obj/item/stack/ore/salvage
	name = "salvage"
	icon = 'icons/obj/salvage_structure.dmi'
	icon_state = "smetal"
	refined_type = null

/obj/item/stack/ore/salvage/examine(mob/user)
	. = ..()
	. += "You could probably reclaim this in an autolathe, Ore Redemption Machine, or smelter."

/obj/item/stack/ore/salvage/scrapmetal
	name = "scrap metal"
	desc = "A collection of metal parts and pieces."
	points = 1
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapmetal/five
	amount = 5

/obj/item/stack/ore/salvage/scrapmetal/ten
	amount = 10

/obj/item/stack/ore/salvage/scrapmetal/twenty
	amount = 20

/obj/item/stack/ore/salvage/scraptitanium
	name = "scrap titanium"
	desc = "Lightweight, rust-resistant parts and pieces from high-performance equipment."
	icon_state = "stitanium"
	points = 50
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scraptitanium/five
	amount = 5

/obj/item/stack/ore/salvage/scrapsilver
	name = "worn crt"
	desc = "An old CRT display with the letters 'STANDBY' burnt into the screen."
	icon_state = "ssilver"
	points = 16
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapsilver/five
	amount = 5

/obj/item/stack/ore/salvage/scrapgold
	name = "scrap electronics"
	desc = "Various bits of electrical components."
	icon_state = "sgold"
	points = 18
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapgold/five
	amount = 5

/obj/item/stack/ore/salvage/scrapplasma
	name = "junk plasma cell"
	desc = "A nonfunctional plasma cell, once used as portable power generation."
	icon_state = "splasma"
	points = 15
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapplasma/five
	amount = 5

/obj/item/stack/ore/salvage/scrapuranium
	name = "broken detector"
	desc = "The label on the side warns the reader of radioactive elements."
	icon_state = "suranium"
	points = 30
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapuranium/five
	amount = 5

/obj/item/stack/ore/salvage/scrapbluespace
	name = "damaged bluespace circuit"
	desc = "It's damaged beyond repair, but the crystal inside its housing looks fine."
	icon_state = "sbluespace"
	points = 50
	material_flags = MATERIAL_NO_EFFECTS
	custom_materials = list(/datum/material/bluespace=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/ore/salvage/scrapbluespace/five
	amount = 5
