/*
Mineral Sheets
	Contains:
		- Sandstone
		- Sandbags
		- Diamond
		- Snow
		- Uranium
		- Plasma
		- Gold
		- Silver
		- Clown
		- Titanium
		- Plastitanium
	Others:
		- Adamantine
		- Mythril
		- Alien Alloy
		- Coal
*/

/*
 * Sandstone
 */

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("pile of dirt", /obj/machinery/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Breakdown into sand", /obj/item/stack/ore/glass, 1, one_per_turf = 0, on_floor = 1) \
	))

/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	item_state = "sheet-sandstone"
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/sandstone=MINERAL_MATERIAL_AMOUNT)
	sheettype = "sandstone"
	merge_type = /obj/item/stack/sheet/mineral/sandstone
	walltype = /turf/closed/wall/mineral/sandstone
	material_type = /datum/material/sandstone

/obj/item/stack/sheet/mineral/sandstone/get_main_recipes()
	. = ..()
	. += GLOB.sandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/thirty
	amount = 30

/*
 * Sandbags
 */

/obj/item/stack/sheet/mineral/sandbags
	name = "sandbags"
	icon_state = "sandbags"
	singular_name = "sandbag"
	layer = LOW_ITEM_LAYER
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/mineral/sandbags

GLOBAL_LIST_INIT(sandbag_recipes, list ( \
	new/datum/stack_recipe("sandbags", /obj/structure/barricade/sandbags, 1, time = 25, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/sandbags/get_main_recipes()
	. = ..()
	. += GLOB.sandbag_recipes

/obj/item/emptysandbag
	name = "empty sandbag"
	desc = "A bag to be filled with sand."
	icon_state = "sandbag"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/emptysandbag/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/glass/G = W
		to_chat(user, span_notice("You fill the sandbag."))
		var/obj/item/stack/sheet/mineral/sandbags/I = new /obj/item/stack/sheet/mineral/sandbags(drop_location())
		qdel(src)
		if (Adjacent(user) && !issilicon(user))
			user.put_in_hands(I)
		G.use(1)
	else
		return ..()

/*
 * Diamond
 */
/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "sheet-diamond"
	item_state = "sheet-diamond"
	singular_name = "diamond"
	sheettype = "diamond"
	custom_materials = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/carbon = 20)
	point_value = 25
	merge_type = /obj/item/stack/sheet/mineral/diamond
	material_type = /datum/material/diamond
	walltype = /turf/closed/wall/mineral/diamond

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("diamond tile", /obj/item/stack/tile/mineral/diamond, 1, 4, 20),  \
	))

/obj/item/stack/sheet/mineral/diamond/get_main_recipes()
	. = ..()
	. += GLOB.diamond_recipes

/obj/item/stack/sheet/mineral/diamond/fifty
	amount = 50

/obj/item/stack/sheet/mineral/diamond/twenty
	amount = 20

/obj/item/stack/sheet/mineral/diamond/five
	amount = 5

/*
 * Uranium
 */
/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-uranium"
	item_state = "sheet-uranium"
	singular_name = "uranium sheet"
	sheettype = "uranium"
	custom_materials = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/uranium
	material_type = /datum/material/uranium
	walltype = /turf/closed/wall/mineral/uranium

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("uranium tile", /obj/item/stack/tile/mineral/uranium, 1, 4, 20), \
	new/datum/stack_recipe("Nuke Statue", /obj/structure/statue/uranium/nuke, 5, one_per_turf = 1, on_floor = 1), \
	))

/obj/item/stack/sheet/mineral/uranium/get_main_recipes()
	. = ..()
	. += GLOB.uranium_recipes

/obj/item/stack/sheet/mineral/uranium/fifty
	amount = 50

/obj/item/stack/sheet/mineral/uranium/twenty
	amount = 20

/obj/item/stack/sheet/mineral/uranium/ten
	amount = 10

/obj/item/stack/sheet/mineral/uranium/five
	amount = 5

/*
 * Plasma
 */
/obj/item/stack/sheet/mineral/plasma
	name = "plasma crystals"
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "ingot-plasma"
	item_state = "ingot-plasma"
	singular_name = "plasma crystal"
	sheettype = "plasma"
	resistance_flags = FLAMMABLE
	max_integrity = 100
	custom_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/plasma = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/plasma
	material_type = /datum/material/plasma
	walltype = /turf/closed/wall/mineral/plasma

GLOBAL_LIST_INIT(plasma_recipes, list ( \
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plasma tile", /obj/item/stack/tile/mineral/plasma, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/plasma/get_main_recipes()
	. = ..()
	. += GLOB.plasma_recipes

/obj/item/stack/sheet/mineral/plasma/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Plasma sheets ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma sheets ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.get_temperature())
	else
		return ..()

/obj/item/stack/sheet/mineral/plasma/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("plasma=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/plasma/fifty
	amount = 50

/obj/item/stack/sheet/mineral/plasma/twenty
	amount = 20

/obj/item/stack/sheet/mineral/plasma/ten
	amount = 10

/obj/item/stack/sheet/mineral/plasma/five
	amount = 5

/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-gold"
	item_state = "sheet-gold"
	singular_name = "gold bar"
	sheettype = "gold"
	custom_materials = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/gold
	material_type = /datum/material/gold
	walltype = /turf/closed/wall/mineral/gold

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("mortar", /obj/item/reagent_containers/glass/mortar/gold, 3), \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("chemical crate", /obj/structure/closet/crate/chem, 1, time = 15, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("gold tile", /obj/item/stack/tile/mineral/gold, 1, 4, 20), \
	new/datum/stack_recipe("blank plaque", /obj/item/plaque, 1), \
	new/datum/stack_recipe("Simple Crown", /obj/item/clothing/head/crown, 5), \
	))

/obj/item/stack/sheet/mineral/gold/get_main_recipes()
	. = ..()
	. += GLOB.gold_recipes

/obj/item/stack/sheet/mineral/gold/attackby(obj/item/item, mob/user, params)
	. = ..()
	if(item.tool_behaviour != TOOL_WIRECUTTER)
		return
	playsound(src, 'sound/weapons/slice.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("You start whittling away some of [src]..."))
	if(!do_after(user, 1 SECONDS, src))
		return
	var/obj/item/result = new /obj/item/garnish/gold(drop_location())
	var/give_to_user = user.is_holding(src)
	use(1)
	if(QDELETED(src) && give_to_user)
		user.put_in_hands(result)
	to_chat(user, span_notice("You finish cutting [src]"))

/obj/item/stack/sheet/mineral/gold/fifty
	amount = 50

/obj/item/stack/sheet/mineral/gold/twenty
	amount = 20

/obj/item/stack/sheet/mineral/gold/five
	amount = 5

/*
 * Silver
 */
/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-silver"
	item_state = "sheet-silver"
	singular_name = "silver bar"
	sheettype = "silver"
	custom_materials = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/silver = 20)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/silver
	material_type = /datum/material/silver
	tableVariant = /obj/structure/table/optable
	walltype = /turf/closed/wall/mineral/silver

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("silver tile", /obj/item/stack/tile/mineral/silver, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/silver/get_main_recipes()
	. = ..()
	. += GLOB.silver_recipes

/obj/item/stack/sheet/mineral/silver/attackby(obj/item/item, mob/user, params)
	. = ..()
	if(item.tool_behaviour != TOOL_WIRECUTTER)
		return
	playsound(src, 'sound/weapons/slice.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("You start whittling away some of [src]..."))
	if(!do_after(user, 1 SECONDS, src))
		return
	var/obj/item/result = new /obj/item/garnish/silver(drop_location())
	var/give_to_user = user.is_holding(src)
	use(1)
	if(QDELETED(src) && give_to_user)
		user.put_in_hands(result)
	to_chat(user, span_notice("You finish cutting [src]"))

/obj/item/stack/sheet/mineral/silver/fifty
	amount = 50

/obj/item/stack/sheet/mineral/silver/twenty
	amount = 20

/obj/item/stack/sheet/mineral/silver/five
	amount = 5

/*
 * Titanium
 */
/obj/item/stack/sheet/mineral/titanium
	name = "titanium"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-titanium"
	item_state = "sheet-titanium"
	singular_name = "titanium sheet"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "titanium"
	custom_materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/titanium = 20)		//WS Edit - Adds titanium reagent
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/titanium
	material_type = /datum/material/titanium
	walltype = /turf/closed/wall/mineral/titanium

GLOBAL_LIST_INIT(titanium_recipes, list ( \
	new/datum/stack_recipe("titanium tile", /obj/item/stack/tile/mineral/titanium, 1, 4, 20), \
	new/datum/stack_recipe("shuttle seat", /obj/structure/chair/comfy/shuttle, 2, one_per_turf = TRUE, on_floor = TRUE), \
	))

/obj/item/stack/sheet/mineral/titanium/get_main_recipes()
	. = ..()
	. += GLOB.titanium_recipes

/obj/item/stack/sheet/mineral/titanium/fifty
	amount = 50

/obj/item/stack/sheet/mineral/titanium/twenty
	amount = 20

/obj/item/stack/sheet/mineral/titanium/five
	amount = 5

/*
 * Plastitanium
 */
/obj/item/stack/sheet/mineral/plastitanium
	name = "plastitanium"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-plastitanium"
	item_state = "sheet-plastitanium"
	singular_name = "plastitanium sheet"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	sheettype = "plastitanium"
	custom_materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT, /datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	point_value = 45
	merge_type = /obj/item/stack/sheet/mineral/plastitanium
	material_flags = MATERIAL_NO_EFFECTS
	walltype = /turf/closed/wall/mineral/plastitanium
	tableVariant = /obj/structure/table/chem

/obj/item/stack/sheet/mineral/plastitanium/fifty
	amount = 50

/obj/item/stack/sheet/mineral/plastitanium/twenty
	amount = 20

/obj/item/stack/sheet/mineral/plastitanium/five
	amount = 5

GLOBAL_LIST_INIT(plastitanium_recipes, list ( \
	new/datum/stack_recipe("plastitanium tile", /obj/item/stack/tile/mineral/plastitanium, 1, 4, 20), \
	new/datum/stack_recipe("chemistry sink", /obj/structure/sink/chem, 1 , one_per_turf = TRUE, on_floor = TRUE, applies_mats = TRUE), \
	))

/obj/item/stack/sheet/mineral/plastitanium/get_main_recipes()
	. = ..()
	. += GLOB.plastitanium_recipes

/*
 * Snow
 */

/obj/item/stack/sheet/mineral/snow
	name = "snow"
	icon_state = "sheet-snow"
	item_state = "sheet-snow"
	custom_materials = list(/datum/material/snow = MINERAL_MATERIAL_AMOUNT)
	singular_name = "snow block"
	force = 1
	throwforce = 2
	grind_results = list(/datum/reagent/consumable/ice = 20)
	merge_type = /obj/item/stack/sheet/mineral/snow
	walltype = /turf/closed/wall/mineral/snow
	material_type = /datum/material/snow

GLOBAL_LIST_INIT(snow_recipes, list ( \
	new/datum/stack_recipe("Snow wall", /turf/closed/wall/mineral/snow, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Snowman", /obj/structure/statue/snow/snowman, 5, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("Snowball", /obj/item/toy/snowball, 1), \
	new/datum/stack_recipe("Snow tile", /obj/item/stack/tile/mineral/snow, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/snow/get_main_recipes()
	. = ..()
	. += GLOB.snow_recipes

/*
 * Alien Alloy
 */
/obj/item/stack/sheet/mineral/abductor
	name = "alien alloy"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "sheet-abductor"
	item_state = "sheet-abductor"
	singular_name = "alien alloy sheet"
	sheettype = "abductor"
	merge_type = /obj/item/stack/sheet/mineral/abductor

GLOBAL_LIST_INIT(abductor_recipes, list ( \
	new/datum/stack_recipe("alien bed", /obj/structure/bed/abductor, 2, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien locker", /obj/structure/closet/abductor, 2, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien table frame", /obj/structure/table_frame/abductor, 1, time = 15, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("alien airlock assembly", /obj/structure/door_assembly/door_assembly_abductor, 4, time = 20, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("alien floor tile", /obj/item/stack/tile/mineral/abductor, 1, 4, 20), \
	))

/obj/item/stack/sheet/mineral/abductor/get_main_recipes()
	. = ..()
	. += GLOB.abductor_recipes

/*
 * Carbon
 */

/obj/item/stack/sheet/mineral/coal
	name = "carbon rods"
	singular_name = "carbon rod"
	desc = "A rod of pure carbon."
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "ingot-graphite"

	custom_materials = list(/datum/material/carbon=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/coal
	grind_results = list(/datum/reagent/carbon = 20)

/obj/item/stack/ore/graphite/coal/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		var/turf/T = get_turf(src)
		message_admins("Carbon rod ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Carbon rod ignited by [key_name(user)] in [AREACOORD(T)]")
		fire_act(W.get_temperature())
		T.IgniteTurf((W.get_temperature()/20))
		return TRUE
	else
		return ..()

/obj/item/stack/ore/graphite/coal/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("co2=[amount*10];TEMP=[exposed_temperature]")
	qdel(src)

/obj/item/stack/sheet/mineral/coal/five
	amount = 5

/obj/item/stack/sheet/mineral/coal/ten
	amount = 10

/*
 * Hellstone
 */
/obj/item/stack/sheet/mineral/hidden
	name = "????????"
	singular_name = "????????"

/obj/item/stack/sheet/mineral/hidden/hellstone
	name = "hellstone"
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "sheet-hellstone"
	item_state = "sheet-hellstone"
	singular_name = "hellstone bar"
	sheettype = "hellstone"
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/hellstone=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/clf3 = 5)
	point_value = 20
	merge_type = /obj/item/stack/sheet/mineral/hidden/hellstone
	material_type = /datum/material/hellstone

/obj/item/stack/sheet/mineral/hidden/hellstone/fifty
	amount = 50

/obj/item/stack/sheet/mineral/hidden/hellstone/twenty
	amount = 20

/obj/item/stack/sheet/mineral/hidden/hellstone/ten
	amount = 10

/obj/item/stack/sheet/mineral/hidden/hellstone/five
	amount = 5

/*
 * Sulfur
 */
/obj/item/stack/sheet/mineral/sulfur
	name = "sulfur crystals"
	singular_name = "sulfur crystal"
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "ingot-sulfur"
	item_state = "ingot-sulfur"
	custom_materials = list(/datum/material/sulfur=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/sulfur = 20)
	point_value = 1
	merge_type = /obj/item/stack/sheet/mineral/sulfur
	material_type = /datum/material/sulfur

/*
 * Copper
 */
/obj/item/stack/sheet/mineral/copper
	name = "copper"
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-copper"
	item_state = "sheet-copper"
	singular_name = "copper bar"
	sheettype = "copper"
	custom_materials = list(/datum/material/copper=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/copper = 20)
	point_value = 3
	merge_type = /obj/item/stack/sheet/mineral/copper

/obj/item/stack/sheet/mineral/copper/fifty
	amount = 50

/obj/item/stack/sheet/mineral/copper/twenty
	amount = 20

/obj/item/stack/sheet/mineral/copper/five
	amount = 5

/obj/item/stack/sheet/mineral/lead
	name = "lead"
	desc = "Looks tasty."
	icon = 'icons/obj/materials/sheets.dmi'
	icon_state = "sheet-lead"
	item_state = "sheet-lead"
	singular_name = "lead bar"
	sheettype = "lead"
	custom_materials = list(/datum/material/lead=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/leadacetate = 20)
	point_value = 2
	merge_type = /obj/item/stack/sheet/mineral/lead

/obj/item/stack/sheet/mineral/lead/fifty
	amount = 50

/obj/item/stack/sheet/mineral/lead/twenty
	amount = 20

/obj/item/stack/sheet/mineral/lead/five
	amount = 5

/obj/item/stack/sheet/mineral/silicon
	name = "silicon crystals"
	desc = "Looks tasty."
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "ingot-silicon"
	item_state = "ingot-silicon"
	singular_name = "silicon crystal"
	sheettype = "lead"
	custom_materials = list(/datum/material/silicon=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/toxin/leadacetate = 20) //maybe make it a more unique reagent?
	point_value = 2
	merge_type = /obj/item/stack/sheet/mineral/silicon

/obj/item/stack/sheet/mineral/silicon/fifty
	amount = 50

/obj/item/stack/sheet/mineral/silicon/twenty
	amount = 20

/obj/item/stack/sheet/mineral/silicon/five
	amount = 5

/obj/item/stack/sheet/mineral/quartz
	name = "quartz crystals"
	singular_name = "quartz crystal"
	icon = 'icons/obj/materials/ingots.dmi'
	icon_state = "ingot-quartz"
	item_state = "ingot-quartz"
	sheettype = "quartz"
	custom_materials = list(/datum/material/quartz=MINERAL_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/quartz = 20) //maybe make it a more unique reagent?
	point_value = 1
	merge_type = /obj/item/stack/sheet/mineral/quartz

/obj/item/stack/sheet/mineral/quartz/fifty
	amount = 50

/obj/item/stack/sheet/mineral/quartz/twenty
	amount = 20

/obj/item/stack/sheet/mineral/quartz/five
	amount = 5
