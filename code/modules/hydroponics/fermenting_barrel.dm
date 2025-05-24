/obj/structure/fermenting_barrel
	name = "wooden barrel"
	desc = "A large wooden barrel. You can ferment fruits and such inside it, or just use it to hold liquid."
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrel"
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2 * ONE_ATMOSPHERE
	max_integrity = 300
	var/closed_state = "barrel"
	var/open = FALSE
	var/speed_multiplier = 1 //How fast it distills. Defaults to 100% (1.0). Lower is better.

/obj/structure/fermenting_barrel/Initialize()
	// Bluespace beakers, but without the portability or efficiency in circuits.
	create_reagents(300, DRAINABLE | AMOUNT_VISIBLE)
	. = ..()

/obj/structure/fermenting_barrel/examine(mob/user)
	. = ..()
	. += span_notice("It is currently [open?"open, letting you pour liquids in.":"closed, letting you draw liquids from the tap."]")

/obj/structure/fermenting_barrel/proc/makeWine(obj/item/reagent_containers/food/snacks/grown/fruit)
	if(fruit.reagents)
		fruit.reagents.trans_to(src, fruit.reagents.total_volume)
	var/amount = fruit.seed.potency / 4
	if(fruit.distill_reagent)
		reagents.add_reagent(fruit.distill_reagent, amount)
	else
		var/data = list()
		data["names"] = list("[initial(fruit.name)]" = 1)
		data["color"] = fruit.filling_color
		data["boozepwr"] = fruit.wine_power
		if(fruit.wine_flavor)
			data["tastes"] = list(fruit.wine_flavor = 1)
		else
			data["tastes"] = list(fruit.tastes[1] = 1)
		reagents.add_reagent(/datum/reagent/consumable/ethanol/fruit_wine, amount, data)
	qdel(fruit)
	playsound(src, 'sound/effects/bubbles.ogg', 50, TRUE)

/obj/structure/fermenting_barrel/attackby(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/food/snacks/grown/fruit = I
	if(istype(fruit))
		if(!fruit.can_distill)
			to_chat(user, span_warning("You can't distill this into anything..."))
			return TRUE
		else if(!user.transferItemToLoc(I,src))
			to_chat(user, span_warning("[I] is stuck to your hand!"))
			return TRUE
		to_chat(user, span_notice("You place [I] into [src] to start the fermentation process."))
		addtimer(CALLBACK(src, PROC_REF(makeWine), fruit), rand(80, 120) * speed_multiplier)
		return TRUE
	if(I)
		if(I.is_refillable())
			return FALSE //so we can refill them via their afterattack.
	else
		return ..()

/obj/structure/fermenting_barrel/attack_hand(mob/user)
	open = !open
	if(open)
		reagents.flags &= ~(DRAINABLE)
		reagents.flags |= REFILLABLE
		to_chat(user, span_notice("You open [src], letting you fill it."))
	else
		reagents.flags |= DRAINABLE
		reagents.flags &= ~(REFILLABLE)
		to_chat(user, span_notice("You close [src], letting you draw from its tap."))
	update_appearance()

/obj/structure/fermenting_barrel/update_icon_state()
	if(open)
		icon_state = closed_state+"_open"
	else
		icon_state = closed_state
	return ..()

/obj/structure/fermenting_barrel/gunpowder
	name = "gunpowder barrel"
	desc = "A wooden barrel packed with gunpowder. You should probably keep this away from sparks or open fires."

/obj/structure/fermenting_barrel/gunpowder/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/gunpowder, 200)

/obj/structure/fermenting_barrel/trickwine
	name = "barrel of trickwine"
	desc = "finely crafted trickwine."

/obj/structure/fermenting_barrel/trickwine/Initialize()
	. = ..()
	var/datum/reagent/trickwine_type
	trickwine_type = pick(list(
		/datum/reagent/consumable/ethanol/trickwine/ash_wine,
		/datum/reagent/consumable/ethanol/trickwine/ice_wine,
		/datum/reagent/consumable/ethanol/trickwine/shock_wine,
		/datum/reagent/consumable/ethanol/trickwine/hearth_wine,
	))
	reagents.add_reagent(trickwine_type, 200)
	name = "barrel of [trickwine_type::name]"

/obj/structure/fermenting_barrel/distiller
	name = "distiller"
	icon_state = "distiller"
	closed_state = "distiller"
	desc = "A repurposed barrel and keg host to a special culture of bacteria native to Illestren"
