//All defines used in reactions are located in ..\__DEFINES\reactions.dm

/proc/init_gas_reactions()
	. = list()

	for(var/r in subtypesof(/datum/gas_reaction))
		var/datum/gas_reaction/reaction = r
		if(initial(reaction.exclude))
			continue
		reaction = new r
		. += reaction
	sortTim(., /proc/cmp_gas_reactions)

/proc/cmp_gas_reactions(list/datum/gas_reaction/a, list/datum/gas_reaction/b) // compares lists of reactions by the maximum priority contained within the list
	if (!length(a) || !length(b))
		return length(b) - length(a)
	var/maxa
	var/maxb
	for (var/datum/gas_reaction/R in a)
		if (R.priority > maxa)
			maxa = R.priority
	for (var/datum/gas_reaction/R in b)
		if (R.priority > maxb)
			maxb = R.priority
	return maxb - maxa

/datum/gas_reaction
	//regarding the requirements lists: the minimum or maximum requirements must be non-zero.
	//when in doubt, use MINIMUM_MOLE_COUNT.
	var/list/min_requirements
	var/list/max_requirements
	var/exclude = FALSE //do it this way to allow for addition/removal of reactions midmatch in the future
	var/priority = 100 //lower numbers are checked/react later than higher numbers. Should be distinct per-reaction; auxmos breaks when two reactions have the same priority.
	var/name = "reaction"
	var/id = "r"

/datum/gas_reaction/New()
	init_reqs()

/datum/gas_reaction/proc/init_reqs()

/datum/gas_reaction/proc/react(datum/gas_mixture/air, atom/location)
	return NO_REACTION

/datum/gas_reaction/proc/test()
	return list("success" = TRUE)

/datum/gas_reaction/argon
	priority = INFINITY
	name = "Noble Gas Reaction Suppression"
	id = "nobstop"

/datum/gas_reaction/argon/init_reqs()
	min_requirements = list(GAS_ARGON = REACTION_OPPRESSION_THRESHOLD)

/datum/gas_reaction/argon/react()
	return STOP_REACTIONS

//water vapor: puts out fires?
/datum/gas_reaction/water_vapor
	priority = 1
	name = "Water Vapor"
	id = "vapor"

/datum/gas_reaction/water_vapor/init_reqs()
	min_requirements = list(
		GAS_H2O = MOLES_GAS_VISIBLE,
		"MAX_TEMP" = T0C + 40
	)

/datum/gas_reaction/water_vapor/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location = holder
	if(!istype(location))
		return NO_REACTION
	if (air.return_temperature() <= WATER_VAPOR_FREEZE)
		if(location && location.freon_gas_act())
			return REACTING
	else if(location && location.water_vapor_gas_act())
		air.adjust_moles(GAS_H2O, -MOLES_GAS_VISIBLE)
		return REACTING

// no test cause it's entirely based on location

//tritium combustion: combustion of oxygen and tritium (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/nitrous_decomp
	priority = 0
	name = "Nitrous Oxide Decomposition"
	id = "nitrous_decomp"

/datum/gas_reaction/nitrous_decomp/init_reqs()
	min_requirements = list(
		"TEMP" = N2O_DECOMPOSITION_MIN_ENERGY,
		GAS_NITROUS = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/nitrous_decomp/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity() //this speeds things up because accessing datum vars is slow
	var/temperature = air.return_temperature()
	var/burned_fuel = 0


	burned_fuel = max(0,0.00002*(temperature-(0.00001*(temperature**2))))*air.get_moles(GAS_NITROUS)
	air.set_moles(GAS_NITROUS, air.get_moles(GAS_NITROUS) - burned_fuel)

	if(burned_fuel)
		energy_released += (N2O_DECOMPOSITION_ENERGY_RELEASED * burned_fuel)

		air.set_moles(GAS_O2, air.get_moles(GAS_O2) + burned_fuel/2)
		air.set_moles(GAS_N2, air.get_moles(GAS_N2) + burned_fuel)

		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature*old_heat_capacity + energy_released)/new_heat_capacity)
		return REACTING
	return NO_REACTION

//tritium combustion: combustion of oxygen and tritium (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/tritfire
	priority = -1 //fire should ALWAYS be last, but tritium fires happen before plasma fires
	name = "Tritium Combustion"
	id = "tritfire"
	exclude = TRUE

/datum/gas_reaction/tritfire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		GAS_TRITIUM = MINIMUM_MOLE_COUNT,
		GAS_O2 = MINIMUM_MOLE_COUNT
	)

/proc/fire_expose(turf/open/location, datum/gas_mixture/air, temperature)
	if(istype(location) && temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		location.hotspot_expose(temperature, CELL_VOLUME)
		for(var/I in location)
			var/atom/movable/item = I
			item.temperature_expose(air, temperature, CELL_VOLUME)
		location.temperature_expose(air, temperature, CELL_VOLUME)

/proc/radiation_burn(turf/open/location, rad_power)
	if(istype(location) && prob(10))
		radiation_pulse(location, rad_power)

/datum/gas_reaction/tritfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null

	var/burned_fuel = max(min(air.get_moles(GAS_TRITIUM), air.get_moles(GAS_O2) / TRITIUM_BURN_OXY_FACTOR), 0) / TRITIUM_BURN_TRIT_FACTOR
	if(burned_fuel > 0)
		air.adjust_moles(GAS_TRITIUM, -burned_fuel)
		air.adjust_moles(GAS_O2, -burned_fuel / 2)
		air.adjust_moles(GAS_H2O, burned_fuel)
		energy_released += (FIRE_HYDROGEN_ENERGY_RELEASED * burned_fuel)
		cached_results["fire"] += burned_fuel
		if(location && prob(10) && burned_fuel > TRITIUM_MINIMUM_RADIATION_ENERGY) //woah there let's not crash the server
			radiation_pulse(location, energy_released/TRITIUM_BURN_RADIOACTIVITY_FACTOR)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature*old_heat_capacity + energy_released)/new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/tritfire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(GAS_TRITIUM,50)
	G.set_moles(GAS_O2,50)
	G.set_temperature(500)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Trit fires aren't setting fire results correctly!")
	return ..()

//plasma combustion: combustion of oxygen and plasma (treated as hydrocarbons). creates hotspots. exothermic
/datum/gas_reaction/plasmafire
	priority = -2 //fire should ALWAYS be last, but plasma fires happen after tritium fires
	name = "Plasma Combustion"
	id = "plasmafire"
	exclude = TRUE

/datum/gas_reaction/plasmafire/init_reqs()
	min_requirements = list(
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST,
		GAS_PLASMA = MINIMUM_MOLE_COUNT,
		GAS_O2 = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/plasmafire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = 0
	var/turf/open/location = isturf(holder) ? holder : null

	//Handle plasma burning
	var/plasma_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more plasma released at higher temperatures
	var/temperature_scale = 0
	//to make tritium
	var/super_saturation = FALSE

	if(temperature > PLASMA_UPPER_TEMPERATURE)
		temperature_scale = 1
	else
		temperature_scale = (temperature-PLASMA_MINIMUM_BURN_TEMPERATURE)/(PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
	if(temperature_scale > 0)
		oxygen_burn_rate = PLASMA_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(GAS_O2) / air.get_moles(GAS_PLASMA) > SUPER_SATURATION_THRESHOLD) //supersaturation. Form Tritium.
			super_saturation = TRUE
		if(air.get_moles(GAS_O2) > air.get_moles(GAS_PLASMA)*PLASMA_OXYGEN_FULLBURN)
			plasma_burn_rate = (air.get_moles(GAS_PLASMA)*temperature_scale)/PLASMA_BURN_RATE_DELTA
		else
			plasma_burn_rate = (temperature_scale*(air.get_moles(GAS_O2)/PLASMA_OXYGEN_FULLBURN))/PLASMA_BURN_RATE_DELTA

		if(plasma_burn_rate > MINIMUM_HEAT_CAPACITY)
			plasma_burn_rate = min(plasma_burn_rate,air.get_moles(GAS_PLASMA),air.get_moles(GAS_O2)/oxygen_burn_rate) //Ensures matter is conserved properly
			air.set_moles(GAS_PLASMA, QUANTIZE(air.get_moles(GAS_PLASMA) - plasma_burn_rate))
			air.set_moles(GAS_O2, QUANTIZE(air.get_moles(GAS_O2) - (plasma_burn_rate * oxygen_burn_rate)))
			if (super_saturation)
				air.adjust_moles(GAS_TRITIUM, plasma_burn_rate)
			else
				air.adjust_moles(GAS_CO2, plasma_burn_rate)

			energy_released += FIRE_PLASMA_ENERGY_RELEASED * (plasma_burn_rate)

			cached_results["fire"] += (plasma_burn_rate)*(1+oxygen_burn_rate)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature*old_heat_capacity + energy_released)/new_heat_capacity)

	//let the floor know a fire is happening
	if(istype(location))
		temperature = air.return_temperature()
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			location.hotspot_expose(temperature, CELL_VOLUME)
			for(var/I in location)
				var/atom/movable/item = I
				item.temperature_expose(air, temperature, CELL_VOLUME)
			location.temperature_expose(air, temperature, CELL_VOLUME)

	return cached_results["fire"] ? REACTING : NO_REACTION

/datum/gas_reaction/plasmafire/test()
	var/datum/gas_mixture/G = new
	G.set_moles(GAS_PLASMA,50)
	G.set_moles(GAS_O2,50)
	G.set_volume(1000)
	G.set_temperature(500)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(!G.reaction_results["fire"])
		return list("success" = FALSE, "message" = "Plasma fires aren't setting fire results correctly!")
	if(!G.get_moles(GAS_CO2))
		return list("success" = FALSE, "message" = "Plasma fires aren't making CO2!")
	G.clear()
	G.set_moles(GAS_PLASMA,10)
	G.set_moles(GAS_O2,1000)
	G.set_temperature(500)
	result = G.react()
	if(!G.get_moles(GAS_TRITIUM))
		return list("success" = FALSE, "message" = "Plasma fires aren't making trit!")
	return ..()

//freon reaction (is not a fire yet)
/datum/gas_reaction/freonfire
	priority = -3
	name = "Freon combustion"
	id = "freonfire"

/datum/gas_reaction/freonfire/init_reqs()
	min_requirements = list(
		GAS_O2 = MINIMUM_MOLE_COUNT,
		GAS_FREON = MINIMUM_MOLE_COUNT,
		"TEMP" = FREON_LOWER_TEMPERATURE,
		"MAX_TEMP" = FREON_MAXIMUM_BURN_TEMPERATURE
		)

/datum/gas_reaction/freonfire/react(datum/gas_mixture/air, datum/holder)
	var/energy_released = 0
	var/old_heat_capacity = air.heat_capacity()
	var/temperature = air.return_temperature()
	var/turf/open/location = isturf(holder) ? holder : null

	//Handle freon burning (only reaction now)
	var/freon_burn_rate = 0
	var/oxygen_burn_rate = 0
	//more freon released at lower temperatures
	var/temperature_scale = 1

	if(temperature < FREON_LOWER_TEMPERATURE) //stop the reaction when too cold
		temperature_scale = 0
	else
		temperature_scale = (FREON_MAXIMUM_BURN_TEMPERATURE - temperature)/(FREON_MAXIMUM_BURN_TEMPERATURE - FREON_LOWER_TEMPERATURE) //calculate the scale based on the temperature
	if(temperature_scale >= 0)
		oxygen_burn_rate = PLASMA_BURN_RATE_BASE - temperature_scale
		if(air.get_moles(GAS_O2) > air.get_moles(GAS_FREON)*FREON_OXYGEN_FULLBURN)
			freon_burn_rate = (air.get_moles(GAS_FREON)*temperature_scale)/FREON_BURN_RATE_DELTA
		else
			freon_burn_rate = (temperature_scale*(air.get_moles(GAS_O2)/FREON_OXYGEN_FULLBURN))/FREON_BURN_RATE_DELTA

		if(freon_burn_rate > MINIMUM_HEAT_CAPACITY)
			freon_burn_rate = min(freon_burn_rate,air.get_moles(GAS_FREON),air.get_moles(GAS_O2)/oxygen_burn_rate) //Ensures matter is conserved properly
			air.set_moles(GAS_FREON, QUANTIZE(air.get_moles(GAS_FREON) - freon_burn_rate))
			air.set_moles(GAS_O2, QUANTIZE(air.get_moles(GAS_O2) - (freon_burn_rate * oxygen_burn_rate)))
			air.set_moles(GAS_CO2, air.get_moles(GAS_CO2) + freon_burn_rate)

			if(temperature < 160 && temperature > 120 && prob(2))
				new /obj/item/stack/sheet/hot_ice(location)

			energy_released += FIRE_FREON_ENERGY_RELEASED * (freon_burn_rate)

	if(energy_released < 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature((temperature*old_heat_capacity + energy_released)/new_heat_capacity)

/datum/gas_reaction/genericfire
	priority = -4 // very last reaction
	name = "Combustion"
	id = "genericfire"

/datum/gas_reaction/genericfire/init_reqs()
	var/lowest_fire_temp = INFINITY
	var/list/fire_temperatures = GLOB.gas_data.fire_temperatures
	for(var/gas in fire_temperatures)
		lowest_fire_temp = min(lowest_fire_temp, fire_temperatures[gas])
	var/lowest_oxi_temp = INFINITY
	var/list/oxidation_temperatures = GLOB.gas_data.oxidation_temperatures
	for(var/gas in oxidation_temperatures)
		lowest_oxi_temp = min(lowest_oxi_temp, oxidation_temperatures[gas])
	min_requirements = list(
		"TEMP" = max(lowest_oxi_temp, lowest_fire_temp),
		"FIRE_REAGENTS" = MINIMUM_MOLE_COUNT
	)

// no requirements, always runs
// bad idea? maybe
// this is overridden by auxmos but, hey, good idea to have it readable

/datum/gas_reaction/genericfire/react(datum/gas_mixture/air, datum/holder)
	var/temperature = air.return_temperature()
	var/list/oxidation_temps = GLOB.gas_data.oxidation_temperatures
	var/list/oxidation_rates = GLOB.gas_data.oxidation_rates
	var/oxidation_power = 0
	var/list/burn_results = list()
	var/list/fuels = list()
	var/list/oxidizers = list()
	var/list/fuel_rates = GLOB.gas_data.fire_burn_rates
	var/list/fuel_temps = GLOB.gas_data.fire_temperatures
	var/total_fuel = 0
	var/energy_released = 0
	for(var/G in air.get_gases())
		var/oxidation_temp = oxidation_temps[G]
		if(oxidation_temp && oxidation_temp > temperature)
			var/temperature_scale = max(0, 1-(temperature / oxidation_temp))
			var/amt = air.get_moles(G) * temperature_scale
			oxidizers[G] = amt
			oxidation_power += amt * oxidation_rates[G]
		else
			var/fuel_temp = fuel_temps[G]
			if(fuel_temp && fuel_temp > temperature)
				var/amt = (air.get_moles(G) / fuel_rates[G]) * max(0, 1-(temperature / fuel_temp))
				fuels[G] = amt // we have to calculate the actual amount we're using after we get all oxidation together
				total_fuel += amt
	if(oxidation_power <= 0 || total_fuel <= 0)
		return NO_REACTION
	var/oxidation_ratio = oxidation_power / total_fuel
	if(oxidation_ratio > 1)
		for(var/oxidizer in oxidizers)
			oxidizers[oxidizer] /= oxidation_ratio
	else if(oxidation_ratio < 1)
		for(var/fuel in fuels)
			fuels[fuel] *= oxidation_ratio
	fuels += oxidizers
	var/list/fire_products = GLOB.gas_data.fire_products
	var/list/fire_enthalpies = GLOB.gas_data.enthalpies
	for(var/fuel in fuels + oxidizers)
		var/amt = fuels[fuel]
		if(!burn_results[fuel])
			burn_results[fuel] = 0
		burn_results[fuel] -= amt
		energy_released += amt * fire_enthalpies[fuel]
		for(var/product in fire_products[fuel])
			if(!burn_results[product])
				burn_results[product] = 0
			burn_results[product] += amt
	var/final_energy = air.thermal_energy() + energy_released
	for(var/result in burn_results)
		air.adjust_moles(result, burn_results[result])
	air.set_temperature(final_energy / air.heat_capacity())
	var/list/cached_results = air.reaction_results
	cached_results["fire"] = min(total_fuel, oxidation_power) * 2
	return cached_results["fire"] ? REACTING : NO_REACTION

//fusion: a terrible idea that was fun but broken. Now reworked to be "less" broken and more interesting. Again (and again, and again). Again!
//Fusion Rework Counter: Please increment this if you make a major overhaul to this system again.
//6 reworks

/proc/fusion_ball(datum/holder, reaction_energy, standard_energy)
	var/turf/open/location

	if (istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/fusion_pipenet = holder
		location = get_turf(pick(fusion_pipenet.members))
	else
		location = get_turf(holder)
	if(location)
		if(prob(PERCENT(((PARTICLE_CHANCE_CONSTANT)/(reaction_energy-PARTICLE_CHANCE_CONSTANT)) + 1))) //Asymptopically approaches 100% as the energy of the reaction goes up.
			location.fire_nuclear_particle(customize = TRUE, custompower = standard_energy)
		radiation_pulse(location, max(2000 * 3 ** (log(10,standard_energy) - FUSION_RAD_MIDPOINT), 0))

/datum/gas_reaction/fusion
	exclude = FALSE
	priority = 2
	name = "Plasmic Fusion"
	id = "fusion"

/datum/gas_reaction/fusion/init_reqs()
	min_requirements = list(
		"TEMP" = FUSION_TEMPERATURE_THRESHOLD,
		GAS_TRITIUM = FUSION_TRITIUM_MOLES_USED,
		GAS_PLASMA = FUSION_MOLE_THRESHOLD,
		GAS_CO2 = FUSION_MOLE_THRESHOLD)

/datum/gas_reaction/fusion/react(datum/gas_mixture/air, datum/holder)
	var/turf/open/location
	if (istype(holder,/datum/pipeline)) //Find the tile the reaction is occuring on, or a random part of the network if it's a pipenet.
		var/datum/pipeline/fusion_pipenet = holder
		location = get_turf(pick(fusion_pipenet.members))
	else
		location = get_turf(holder)
	if(!air.analyzer_results)
		air.analyzer_results = new
	var/list/cached_scan_results = air.analyzer_results
	var/thermal_energy = air.thermal_energy()
	var/reaction_energy = 0 //Reaction energy can be negative or positive, for both exothermic and endothermic reactions.
	var/initial_plasma = air.get_moles(GAS_PLASMA)
	var/initial_carbon = air.get_moles(GAS_CO2)
	var/scale_factor = max(air.return_volume() / FUSION_SCALE_DIVISOR, FUSION_MINIMAL_SCALE)
	var/temperature_scale = log(10, air.return_temperature())
	//The size of the phase space hypertorus
	var/toroidal_size = 	TOROID_CALCULATED_THRESHOLD \
							+ (temperature_scale <= FUSION_BASE_TEMPSCALE ? \
							(temperature_scale-FUSION_BASE_TEMPSCALE) / FUSION_BUFFER_DIVISOR \
							: 4 ** (temperature_scale-FUSION_BASE_TEMPSCALE) / FUSION_SLOPE_DIVISOR)
	var/gas_power = 0
	for (var/gas_id in air.get_gases())
		gas_power += (GLOB.gas_data.fusion_powers[gas_id]*air.get_moles(gas_id))
	var/instability = MODULUS((gas_power*INSTABILITY_GAS_POWER_FACTOR),toroidal_size) //Instability effects how chaotic the behavior of the reaction is
	cached_scan_results[id] = instability//used for analyzer feedback

	var/plasma = (initial_plasma-FUSION_MOLE_THRESHOLD)/(scale_factor) //We have to scale the amounts of carbon and plasma down a significant amount in order to show the chaotic dynamics we want
	var/carbon = (initial_carbon-FUSION_MOLE_THRESHOLD)/(scale_factor) //We also subtract out the threshold amount to make it harder for fusion to burn itself out.

	//The reaction is a specific form of the Kicked Rotator system, which displays chaotic behavior and can be used to model particle interactions.
	plasma = MODULUS(plasma - (instability*sin(TODEGREES(carbon))), toroidal_size)
	carbon = MODULUS(carbon - plasma, toroidal_size)

	air.set_moles(GAS_PLASMA, plasma*scale_factor + FUSION_MOLE_THRESHOLD)//Scales the gases back up
	air.set_moles(GAS_CO2, carbon*scale_factor + FUSION_MOLE_THRESHOLD)
	var/delta_plasma = min(initial_plasma - air.get_moles(GAS_PLASMA), toroidal_size * scale_factor * 1.5)

	//Energy is gained or lost corresponding to the creation or destruction of mass.
	//Low instability prevents endothermality while higher instability acutally encourages it.
	reaction_energy = 	instability <= FUSION_INSTABILITY_ENDOTHERMALITY || delta_plasma > 0 ? \
						max(delta_plasma*PLASMA_BINDING_ENERGY, 0) \
						: delta_plasma*PLASMA_BINDING_ENERGY * (instability-FUSION_INSTABILITY_ENDOTHERMALITY)**0.5

	//To achieve faster equilibrium. Too bad it is not that good at cooling down.
	if (reaction_energy)
		var/middle_energy = (((TOROID_CALCULATED_THRESHOLD / 2) * scale_factor) + FUSION_MOLE_THRESHOLD) * (200 * FUSION_MIDDLE_ENERGY_REFERENCE)
		thermal_energy = middle_energy * FUSION_ENERGY_TRANSLATION_EXPONENT ** log(10, thermal_energy / middle_energy)

		//This bowdlerization is a double-edged sword. Tread with care!
		var/bowdlerized_reaction_energy = 	clamp(reaction_energy, \
											thermal_energy * ((1 / FUSION_ENERGY_TRANSLATION_EXPONENT ** 2) - 1), \
											thermal_energy * (FUSION_ENERGY_TRANSLATION_EXPONENT ** 2 - 1))
		thermal_energy = middle_energy * 10 ** log(FUSION_ENERGY_TRANSLATION_EXPONENT, (thermal_energy + bowdlerized_reaction_energy) / middle_energy)

	//The reason why you should set up a tritium production line.
	air.adjust_moles(GAS_TRITIUM, -FUSION_TRITIUM_MOLES_USED)

	//The decay of the tritium and the reaction's energy produces waste gases, different ones depending on whether the reaction is endo or exothermic
	var/standard_waste_gas_output = scale_factor * (FUSION_TRITIUM_CONVERSION_COEFFICIENT*FUSION_TRITIUM_MOLES_USED)
	delta_plasma > 0 ? air.adjust_moles(GAS_H2O, standard_waste_gas_output) : air.adjust_moles(GAS_BZ, standard_waste_gas_output)
	air.adjust_moles(GAS_O2, standard_waste_gas_output) //Oxygen is a bit touchy subject

	if(reaction_energy)
		if(location)
			var/standard_energy = 400 * air.get_moles(GAS_PLASMA) * air.return_temperature() //Prevents putting meaningless waste gases to achieve high rads.
			if(prob(PERCENT(((PARTICLE_CHANCE_CONSTANT)/(reaction_energy-PARTICLE_CHANCE_CONSTANT)) + 1))) //Asymptopically approaches 100% as the energy of the reaction goes up.
				location.fire_nuclear_particle(customize = TRUE, custompower = standard_energy)
			radiation_pulse(location, max(2000 * 3 ** (log(10,standard_energy) - FUSION_RAD_MIDPOINT), 0))
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(clamp(thermal_energy/new_heat_capacity, TCMB, INFINITY))
		return REACTING
	else if(reaction_energy == 0 && instability <= FUSION_INSTABILITY_ENDOTHERMALITY)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(clamp(thermal_energy/new_heat_capacity, TCMB, INFINITY)) //THIS SHOULD STAY OR FUSION WILL EAT YOUR FACE
		return REACTING

//has fusion ever worked?

/datum/gas_reaction/nitrousformation //formationn of n2o, esothermic, requires bz as catalyst
	priority = 3
	name = "Nitrous Oxide formation"
	id = "nitrousformation"

/datum/gas_reaction/nitrousformation/init_reqs()
	min_requirements = list(
		GAS_O2 = 10,
		GAS_N2 = 20,
		GAS_BZ = 5,
		"TEMP" = 200,
		"MAX_TEMP" = 250
	)

/datum/gas_reaction/nitrousformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST*100), air.get_moles(GAS_O2) ,air.get_moles(GAS_N2))
	var/energy_used = heat_efficency * NITROUS_FORMATION_ENERGY
	if ((air.get_moles(GAS_O2) - heat_efficency < 0)|| (air.get_moles(GAS_N2) - heat_efficency < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(GAS_O2, -heat_efficency)
	air.adjust_moles(GAS_N2, -heat_efficency * 2)
	air.adjust_moles(GAS_NITROUS, heat_efficency)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature * old_heat_capacity + energy_used) / new_heat_capacity),TCMB)) //the air heats up when reacting
		return REACTING

/datum/gas_reaction/bzformation //Formation of BZ by combining plasma and tritium at low pressures. Exothermic.
	priority = 5
	name = "BZ Gas formation"
	id = "bzformation"

/datum/gas_reaction/bzformation/init_reqs()
	min_requirements = list(
		GAS_NITROUS = 10,
		GAS_PLASMA = 10
	)

/datum/gas_reaction/bzformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/pressure = air.return_pressure()
	var/old_heat_capacity = air.heat_capacity()
	var/reaction_efficency = min(1/((pressure/(0.1*ONE_ATMOSPHERE))*(max(air.get_moles(GAS_PLASMA)/air.get_moles(GAS_NITROUS),1))),air.get_moles(GAS_NITROUS),air.get_moles(GAS_PLASMA)/2)
	var/energy_released = 2*reaction_efficency*FIRE_CARBON_ENERGY_RELEASED
	if ((air.get_moles(GAS_NITROUS) - reaction_efficency < 0)|| (air.get_moles(GAS_PLASMA) - (2*reaction_efficency) < 0) || energy_released <= 0) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(GAS_BZ, reaction_efficency)
	if(reaction_efficency == air.get_moles(GAS_NITROUS))
		air.adjust_moles(GAS_BZ, -min(pressure,1))
		air.adjust_moles(GAS_O2, min(pressure,1))
	air.adjust_moles(GAS_NITROUS, -reaction_efficency)
	air.adjust_moles(GAS_PLASMA, -2*reaction_efficency)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature*old_heat_capacity + energy_released)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/bzformation/test()
	var/datum/gas_mixture/G = new
	G.set_moles(GAS_PLASMA,15)
	G.set_moles(GAS_NITROUS,15)
	G.set_volume(1000)
	G.set_temperature(10)
	var/result = G.react()
	if(result != REACTING)
		return list("success" = FALSE, "message" = "Reaction didn't go at all!")
	if(abs(G.get_moles(GAS_BZ) - 4) > 0.1) // efficiency is 4.0643 and bz generation == efficiency
		return list("success" = FALSE, "message" = "BZ isn't being generated correctly! Only [G.get_moles(GAS_BZ)] mols were produced, when there should be 4!")
	return ..()

/datum/gas_reaction/freonformation
	priority = 6
	name = "Freon formation"
	id = "freonformation"

/datum/gas_reaction/freonformation/init_reqs() //minimum requirements for freon formation
	min_requirements = list(
		GAS_PLASMA = 40,
		GAS_CO2 = 20,
		GAS_BZ = 20,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
		)

/datum/gas_reaction/freonformation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/heat_efficency = min(temperature/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 10), air.get_moles(GAS_PLASMA), air.get_moles(GAS_CO2), air.get_moles(GAS_BZ))
	var/energy_used = heat_efficency * 100
	if ((air.get_moles(GAS_PLASMA) - heat_efficency < 0) || (air.get_moles(GAS_CO2) - heat_efficency < 0) || (air.get_moles(GAS_BZ) - heat_efficency < 0)) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(GAS_PLASMA, -(heat_efficency * 5))
	air.adjust_moles(GAS_CO2, -heat_efficency)
	air.adjust_moles(GAS_BZ, -(heat_efficency * 0.25))
	air.adjust_moles(GAS_FREON, heat_efficency * 2)

	if(energy_used > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature*old_heat_capacity - energy_used)/new_heat_capacity),TCMB))
		return REACTING

/datum/gas_reaction/hydrogen_chloride_formation
	priority = 11
	name = "Hydrogen Chloride formation"
	id = "hydrogenchlorideformation"

/datum/gas_reaction/hydrogen_chloride_formation/init_reqs()
	min_requirements = list(
		GAS_CHLORINE = 5,
		GAS_HYDROGEN = 5,
		"TEMP" = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	)

/datum/gas_reaction/hydrogen_chloride_formation/react(datum/gas_mixture/air)
	var/temperature = air.return_temperature()
	var/old_heat_capacity = air.heat_capacity()
	var/reaction_efficency = min((temperature/(FIRE_MINIMUM_TEMPERATURE_TO_EXIST*10)),air.get_moles(GAS_CHLORINE),air.get_moles(GAS_HYDROGEN))
	var/energy_released = reaction_efficency*185000
	if ((air.get_moles(GAS_CHLORINE) - reaction_efficency < 0)|| (air.get_moles(GAS_HYDROGEN) - (reaction_efficency) < 0) || energy_released <= 0) //Shouldn't produce gas from nothing.
		return NO_REACTION
	air.adjust_moles(GAS_HYDROGEN_CHLORIDE, reaction_efficency)
	air.adjust_moles(GAS_HYDROGEN, -reaction_efficency)
	air.adjust_moles(GAS_CHLORINE, -reaction_efficency)

	if(energy_released > 0)
		var/new_heat_capacity = air.heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			air.set_temperature(max(((temperature*old_heat_capacity + energy_released)/new_heat_capacity),TCMB))
		return REACTING
