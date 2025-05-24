/// Generic dirt/grass turfs, use these.
/turf/open/floor/plating/asteroid/dirt
	gender = PLURAL
	name = "dirt"
	desc = "It's quite dirty."
	icon = 'icons/turf/planetary/jungle.dmi'
	base_icon_state = "dirt"
	icon_state = "dirt"
	planetary_atmos = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_PLASTEEL)

	dug = TRUE

	baseturfs = /turf/open/floor/plating/asteroid/dirt
	floor_variance = 0
	var/has_grass = FALSE

/turf/open/floor/plating/asteroid/dirt/examine(mob/user)
	. = ..()
	if(has_grass)
		return
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>While this plot of land is now farmable and fertile, theres nothing growing on it. Perhaps you could add <i>grass?</i></span>"

/turf/open/floor/plating/asteroid/dirt/Initialize(mapload, inherited_virtual_z)
	. = ..()

/turf/open/floor/plating/asteroid/dirt/attackby(obj/item/item_attacked_by, mob/user, params)
	. = ..()
	if(has_grass)
		return
	if(!istype(item_attacked_by, /obj/item/reagent_containers/food/snacks/grown/grass))
		return FALSE
	var/grass_to_plant = /turf/open/floor/plating/asteroid/dirt/grass

	if(istype(item_attacked_by, /obj/item/reagent_containers/food/snacks/grown/grass/fairy))
		grass_to_plant = /turf/open/floor/plating/asteroid/dirt/grass/fairy

	visible_message("<span class='notice'>You plant the [item_attacked_by], and the dirt accepts it. It should be breathable now.</span>")
	qdel(item_attacked_by)
	ChangeTurf(grass_to_plant, flags = CHANGETURF_IGNORE_AIR)


/turf/open/floor/plating/asteroid/dirt/getDug()
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/dirt/burn_tile()
	ScrapeAway()
	return TRUE

/turf/open/floor/plating/asteroid/dirt/ex_act(severity, target)
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/dirt/grass
	name = "grass"
	desc = "A patch of grass."
	icon_state = "grass0"
	base_icon_state = "grass"
	bullet_bounce_sound = null
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_GRASS, SMOOTH_GROUP_FLOOR_PLASTEEL)
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	layer = GRASS_TURF_LAYER
	icon = 'icons/turf/floors/grass.dmi'
	smooth_icon = 'icons/turf/floors/grass.dmi'
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/dirt
	floor_variance = 100
	max_icon_states = 3
	tiled_dirt = FALSE
	has_grass = TRUE

/turf/open/floor/plating/asteroid/dirt/grass/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(floor_variance))
		add_overlay("grassalt_[rand(1,max_icon_states)]")

/turf/open/floor/plating/asteroid/dirt/grass/dark
	icon = 'icons/turf/floors/darkgrass.dmi'
	smooth_icon = 'icons/turf/floors/darkgrass.dmi'

/turf/open/floor/plating/asteroid/dirt/grass/fairy
	light_range = 2
	light_power = 0.80
	light_color = COLOR_BLUE_LIGHT

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin
	name = "dried basin"
	desc = "Dried up basin."
	icon_state = "dried_up"
	icon_plating = "dried_up"
	base_icon_state = "dried_up"
	digResult = /obj/item/stack/ore/glass/basalt
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin
	var/current_water = 0 //yeah

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>It could hold water, maybe 50 units per meter could do the trick. Currently, it has <i>[current_water]</i> units.</span>"

/turf/open/floor/plating/asteroid/whitesands/dried
	var/current_water = 0 //yeah

/turf/open/floor/plating/asteroid/whitesands/dried/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>It could hold water, maybe 50 units per meter could do the trick. Currently, it has <i>[current_water]</i> units.</span>"

/turf/open/floor/plating/asteroid/sand/terraform
	light_color = LIGHT_COLOR_TUNGSTEN

/turf/closed/mineral/random/volcanic/terraformed
	turf_type = /turf/open/floor/plating/asteroid/dirt
	baseturfs = /turf/open/floor/plating/asteroid/dirt

/datum/reagent/water/expose_turf(turf/exposed_turf, reac_volume)
	if(!isopenturf(exposed_turf))
		return ..()
	var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin/terraform_target = exposed_turf

	if(istype(terraform_target,  /turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin) || istype(terraform_target, /turf/open/floor/plating/asteroid/whitesands/dried)) //if basin, replace with water
		terraform_target.current_water += reac_volume
		if(terraform_target.current_water >= 50)
			terraform_target.ChangeTurf(/turf/open/water/beach, flags = CHANGETURF_INHERIT_AIR)
			terraform_target.visible_message("<span class='notice'>The [terraform_target.name] fills up with water!</span>")
			return ..()
		else
			terraform_target.visible_message("<span class='notice'>The [terraform_target.name] is filled up with [terraform_target.current_water] units of water.</span>")
			return ..()

/datum/reagent/water/expose_obj(obj/exposed_object, reac_volume)
	. = ..()
	if(istype(exposed_object, /obj/structure/flora/rock/lava) || istype(exposed_object, /obj/structure/flora/rock/pile/lava))
		exposed_object.icon = 'icons/obj/flora/rocks.dmi'
		exposed_object.visible_message("<span class='notice'>[src]cools down.</span>")

/obj/structure/flora/rock/lava/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>If I pour some <i>water</i> onto it, maybe it can cool down?</span>"


/obj/structure/flora/rock/pile/lava/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>If I pour some <i>water</i> onto it, maybe it can cool down?</span>"

// Legacy grass/firt turfs, do not use

/turf/open/floor/plating/dirt
	gender = PLURAL
	name = "dirt"
	desc = "Upon closer examination, it's still dirt."
	icon = 'icons/turf/planetary/jungle.dmi'
	icon_state = "dirt"
	planetary_atmos = TRUE
	attachment_holes = FALSE
	footstep = FOOTSTEP_MUD
	barefootstep = FOOTSTEP_MUD
	clawfootstep = FOOTSTEP_MUD
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	baseturfs = /turf/open/floor/plating/dirt

/turf/open/floor/plating/dirt/dark
	icon_state = "greenerdirt"
	baseturfs = /turf/open/floor/plating/dirt/dark
	initial_gas_mix = JUNGLEPLANET_DEFAULT_ATMOS

/turf/open/floor/plating/dirt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/dirt/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/floor/plating/dirt/icemoon
	planetary_atmos = TRUE

//ESPECIALLY dont use this

/turf/open/floor/plating/dirt/old

/turf/open/floor/plating/dirt/old/lit
	light_power = 1
	light_range = 2

/turf/open/floor/plating/dirt/old/dark

/turf/open/floor/plating/dirt/old/dark/lit
	light_power = 1
	light_range = 2

/turf/open/floor/plating/dirt/dry/lit
	light_power = 1
	light_range = 2


//Artifical sand turfs
/turf/open/floor/plating/asteroid/sand/ship
	name = "sand"
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	baseturfs = /turf/open/floor/plating
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE
	digResult = null

//artifical water turfs
/turf/open/water/ship
	icon = 'icons/misc/beach.dmi'
	icon_state = "water"
	base_icon_state = "water"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE
