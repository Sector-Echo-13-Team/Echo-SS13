/datum/supply_pack/tools
	group = "Tools & Tanks"
	crate_type = /obj/structure/closet/crate/engineering

/*
		Vehicles
*/

/datum/supply_pack/tools/all_terrain_vehicle
	name = "All Terrain Vehicle"
	desc = "Contains one ATV and a key, for when you want to explore the frontier in style."
	cost = 2000
	contains = list(/obj/vehicle/ridden/atv,
					/obj/item/key)
	crate_name = "ATV crate"
	crate_type = /obj/structure/closet/crate/large

/*
		Actual tools
*/

/datum/supply_pack/tools/toolbox
	name = "Tool Crate"
	desc = "Get some work done. Contains an electrical toolbox, a mechanical toolbox, and a welding helmet."
	contains = list(/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/clothing/head/welding)
	cost = 500
	crate_name = "toolbox crate"

/datum/supply_pack/tools/engigear
	name = "Engineering Gear Crate"
	desc = "Contains three toolbelts and 2 sets of meson goggles."
	cost = 750
	contains = list(/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/clothing/glasses/meson/engine,
					/obj/item/clothing/glasses/meson/engine)
	crate_name = "engineering gear crate"

/datum/supply_pack/tools/rped
	name = "RPED crate"
	desc = "Tired of deconstructing all of your machines just to replace the power cells? This device has you covered. Actual parts not included."
	cost = 750
	contains = list(/obj/item/storage/part_replacer)
	crate_name = "\improper RPED crate"

/datum/supply_pack/tools/mining
	name = "Basic Mining Crate"
	desc = "Contains two pickaxes, two ore bags, and two manual mining scanners."
	cost = 1000
	contains = list(
		/obj/item/pickaxe,
		/obj/item/pickaxe/mini,
		/obj/item/storage/bag/ore,
		/obj/item/storage/bag/ore,
		/obj/item/mining_scanner,
		/obj/item/mining_scanner
	)
	crate_name = "basic mining crate"

/datum/supply_pack/tools/jackhammers
	name = "Jackhammer Crate"
	desc = "Contains two jackhammers, ideal for breaking rocks and breaking hull."
	cost = 3500
	contains = list(
		/obj/item/pickaxe/drill/jackhammer,
		/obj/item/pickaxe/drill/jackhammer,
	)
	crate_name = "jackhammer crate"


/datum/supply_pack/tools/metalfoam
	name = "Metal Foam Grenade Crate"
	desc = "Seal up those pesky hull breaches with 7 metal foam grenades."
	cost = 1000
	contains = list(/obj/item/storage/box/metalfoam)
	crate_name = "metal foam grenade crate"

/datum/supply_pack/tools/insulated_gloves
	name = "Insulated Gloves Crate"
	desc = "The backbone of modern society. Barely ever ordered for actual engineering. Contains two insulated gloves."
	cost = 1500
	contains = list(/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow)
	crate_name = "insulated gloves crate"

/datum/supply_pack/tools/jetpack
	name = "Jetpack Crate"
	desc = "For when you need to go fast in space."
	cost = 2000
	contains = list(/obj/item/tank/jetpack/carbondioxide)
	crate_name = "jetpack crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/tools/transfer_valves
	name = "Tank Transfer Valves Crate"
	desc = "The key ingredient for making a lot of people very angry very fast. Contains two tank transfer valves."
	cost = 6000
	contains = list(/obj/item/transfer_valve,
					/obj/item/transfer_valve)
	crate_name = "tank transfer valves crate"
	crate_type = /obj/structure/closet/crate/secure/science

/*
		Liquid tanks
*/

/datum/supply_pack/tools/fueltank
	name = "Fuel Tank Crate"
	desc = "Contains a welding fuel tank, for when your lust for welding is insatiable. Highly flammable."
	cost = 800
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/tools/watertank
	name = "Water Tank Crate"
	desc = "Contains a tank of dihydrogen monoxide. Sounds dangerous."
	cost = 600
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/tools/hightank
	name = "Large Water Tank Crate"
	desc = "Contains a high-capacity water tank. Useful for botany or other service jobs."
	cost = 1200
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	crate_name = "high-capacity water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/tools/foamtank
	name = "Firefighting Foam Tank Crate"
	desc = "Contains a tank of firefighting foam. Also known as \"plasmaman's bane\"."
	cost = 1500
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "foam tank crate"
	crate_type = /obj/structure/closet/crate/large
