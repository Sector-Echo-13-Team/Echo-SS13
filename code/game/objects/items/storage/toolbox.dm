/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon_state = "toolbox_default"
	item_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 12
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = 500)
	attack_verb = list("robusted")
	hitsound = 'sound/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbox_pickup.ogg'
	material_flags = MATERIAL_COLOR
	var/latches = null
	var/has_latches = TRUE

/obj/item/storage/toolbox/Initialize()
	. = ..()
	if(has_latches && !latches)
		latches = "single_latch"
		if(prob(10))
			latches = "double_latch"
			if(prob(1))
				latches = "triple_latch"
	update_appearance()

/obj/item/storage/toolbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.use_sound = 'sound/items/storage/toolbox.ogg'

/obj/item/storage/toolbox/update_overlays()
	. = ..()
	if(has_latches)
		. += latches

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"
	material_flags = NONE

/obj/item/storage/toolbox/emergency/PopulateContents()
	new /obj/item/crowbar/red(src)
	new /obj/item/weldingtool/mini(src)
	new /obj/item/extinguisher/mini(src)
	switch(rand(1,3))
		if(1)
			new /obj/item/flashlight(src)
		if(2)
			new /obj/item/flashlight/glowstick(src)
		if(3)
			new /obj/item/flashlight/flare(src)
	new /obj/item/radio(src)

/obj/item/storage/toolbox/emergency/old
	name = "rusty red toolbox"
	icon_state = "toolbox_red_old"
	has_latches = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/mechanical/PopulateContents()
	if(prob(50))
		new /obj/item/wrench(src)
	else
		new /obj/item/wrench/crescent(src)
	new /obj/item/screwdriver(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/analyzer(src)
	new /obj/item/wirecutters(src)

/obj/item/storage/toolbox/mechanical/old
	name = "rusty blue toolbox"
	icon_state = "toolbox_blue_old"
	has_latches = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/mechanical/old/PopulateContents()
	new /obj/item/screwdriver/old(src)
	new /obj/item/wrench/old(src)
	new /obj/item/weldingtool/old(src)
	new /obj/item/crowbar/old(src)
	new /obj/item/wirecutters/old(src)

/obj/item/storage/toolbox/mechanical/old/heirloom
	name = "toolbox" //this will be named "X family toolbox"
	desc = "It's seen better days."
	force = 5
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/toolbox/mechanical/old/heirloom/PopulateContents()
	return

/obj/item/storage/toolbox/mechanical/old/clean
	name = "toolbox"
	desc = "A old, blue toolbox, it looks robust."
	icon_state = "oldtoolboxclean"
	item_state = "toolbox_blue"
	has_latches = FALSE
	force = 19
	throwforce = 22

/obj/item/storage/toolbox/mechanical/old/clean/proc/calc_damage()
	var/power = 0
	for (var/obj/item/stack/telecrystal/TC in GetAllContents())
		power += TC.amount
	force = 19 + power
	throwforce = 22 + power

/obj/item/storage/toolbox/mechanical/old/clean/attack(mob/target, mob/living/user)
	calc_damage()
	..()

/obj/item/storage/toolbox/mechanical/old/clean/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	calc_damage()
	..()

/obj/item/storage/toolbox/mechanical/old/clean/PopulateContents()
	new /obj/item/screwdriver/old(src)
	new /obj/item/wrench/old(src)
	new /obj/item/weldingtool/old(src)
	new /obj/item/crowbar/old(src)
	new /obj/item/wirecutters/old(src)
	new /obj/item/multitool/old(src)
	new /obj/item/clothing/gloves/color/yellow(src)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	material_flags = NONE

/obj/item/storage/toolbox/electrical/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/t_scanner(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)
	new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)
	if(prob(5))
		new /obj/item/clothing/gloves/color/yellow(src)
	else
		new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)

/obj/item/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	material_flags = NONE

/obj/item/storage/toolbox/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/toolbox/syndicate/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench/syndie(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/syndie(src)
	new /obj/item/wirecutters/syndie(src)
	new /obj/item/multitool/syndie(src)
	new /obj/item/clothing/gloves/color/yellow(src)

/obj/item/storage/toolbox/syndicate/empty

/obj/item/storage/toolbox/syndicate/empty/PopulateContents()
	return
/obj/item/storage/toolbox/drone
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/drone/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/toolbox/artistic
	name = "artistic toolbox"
	desc = "A toolbox painted bright green. Why anyone would store art supplies in a toolbox is beyond you, but it has plenty of extra space."
	icon_state = "green"
	item_state = "artistic_toolbox"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE

/obj/item/storage/toolbox/artistic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 20
	STR.max_items = 10

/obj/item/storage/toolbox/artistic/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil/red(src)
	new /obj/item/stack/cable_coil/yellow(src)
	new /obj/item/stack/cable_coil/blue(src)
	new /obj/item/stack/cable_coil/green(src)
	new /obj/item/stack/cable_coil/pink(src)
	new /obj/item/stack/cable_coil/orange(src)
	new /obj/item/stack/cable_coil/cyan(src)
	new /obj/item/stack/cable_coil/white(src)

/obj/item/storage/toolbox/infiltrator
	name = "insidious case"
	desc = "Bearing the emblem of the Syndicate, this case contains a full infiltrator stealth suit, and has enough room to fit weaponry if necessary."
	icon_state = "infiltrator_case"
	item_state = "infiltrator_case"
	force = 15
	throwforce = 18
	w_class = WEIGHT_CLASS_NORMAL
	has_latches = FALSE

/obj/item/storage/toolbox/infiltrator/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(
		/obj/item/clothing/head/helmet/infiltrator,
		/obj/item/clothing/suit/armor/vest/infiltrator,
		/obj/item/clothing/under/syndicate/bloodred,
		/obj/item/clothing/gloves/color/latex/nitrile/infiltrator,
		/obj/item/clothing/mask/infiltrator,
		/obj/item/gun/ballistic/automatic/pistol/ringneck,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box
		))

/obj/item/storage/toolbox/infiltrator/PopulateContents()
	new /obj/item/clothing/head/helmet/infiltrator(src)
	new /obj/item/clothing/suit/armor/vest/infiltrator(src)
	new /obj/item/clothing/under/syndicate/bloodred(src)
	new /obj/item/clothing/gloves/color/latex/nitrile/infiltrator(src)
	new /obj/item/clothing/mask/infiltrator(src)

/obj/item/storage/toolbox/bounty
	name = "defused explosives case"
	desc = "Store defused landmines in here."
	icon_state = "infiltrator_case"
	item_state = "infiltrator_case"

/obj/item/storage/toolbox/bounty/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 4
	STR.max_items = 2

/obj/item/storage/toolbox/bounty/hunt
	name = "dogtag case"
	desc = "Store pirate dogtags in here."

/obj/item/storage/toolbox/bounty/hunt/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 6
	STR.max_items = 3

/obj/item/storage/toolbox/bounty/salvage
	name = "research case"
	desc = "Store salvaged science equipment in here."

/obj/item/storage/toolbox/bounty/salvage/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 2
	STR.max_items = 1

//floorbot assembly
/obj/item/storage/toolbox/attackby(obj/item/stack/tile/plasteel/T, mob/user, params)
	var/list/allowed_toolbox = list(/obj/item/storage/toolbox/emergency,	//which toolboxes can be made into floorbots
							/obj/item/storage/toolbox/electrical,
							/obj/item/storage/toolbox/mechanical,
							/obj/item/storage/toolbox/artistic,
							/obj/item/storage/toolbox/syndicate)

	if(!istype(T, /obj/item/stack/tile/plasteel))
		..()
		return
	if(!is_type_in_list(src, allowed_toolbox) && (type != /obj/item/storage/toolbox))
		return
	if(contents.len >= 1)
		to_chat(user, span_warning("They won't fit in, as there is already stuff inside!"))
		return
	if(T.use(10))
		var/obj/item/bot_assembly/floorbot/B = new
		B.toolbox = type
		switch(B.toolbox)
			if(/obj/item/storage/toolbox)
				B.toolbox_color = "r"
			if(/obj/item/storage/toolbox/emergency)
				B.toolbox_color = "r"
			if(/obj/item/storage/toolbox/electrical)
				B.toolbox_color = "y"
			if(/obj/item/storage/toolbox/artistic)
				B.toolbox_color = "g"
			if(/obj/item/storage/toolbox/syndicate)
				B.toolbox_color = "s"
		user.put_in_hands(B)
		B.update_appearance()
		to_chat(user, span_notice("You add the tiles into the empty [name]. They protrude from the top."))
		qdel(src)
	else
		to_chat(user, span_warning("You need 10 floor tiles to start building a floorbot!"))
		return
