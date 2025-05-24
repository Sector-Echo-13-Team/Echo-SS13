// Echo 13 - Vampires and more
#define TRAIT_SPECIES_WHITELIST(ids...) list("type" = "allowed", ids)
#define TRAIT_SPECIES_BLACKLIST(ids...) list("type" = "blocked", ids)
//Used to process and handle roundstart quirks
// - Quirk strings are used for faster checking in code
// - Quirk datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	init_order = INIT_ORDER_QUIRKS
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME

	///Assoc. list of all roundstart quirk datum types; "name" = /path/
	var/list/quirks = list()
	///Assoc. list of quirk names and their "point cost"; positive numbers are good traits, and negative ones are bad
	var/list/quirk_points = list()
	///A list of all quirk objects in the game, since some may process
	var/list/quirk_objects = list()
	///A list a list of quirks that can not be used with each other. Format: list(quirk1,quirk2),list(quirk3,quirk4)
	var/list/quirk_blacklist = list()
	///List of id-based locks for species, use either TRAIT_SPECIES_WHITELIST or TRAIT_SPECIES_BLACKLIST inputting the species ids to said macros. Example: species_lock = TRAIT_SPECIES_WHITELIST(SPECIES_IPC, SPECIES_MOTH)
	var/list/quirk_species_locks = list("Phobia" = list("Phobia"= list("limit" = 5, )))
	var/list/quirk_customizations = list(
		"Phobia" = list(
			"Phobia"= list(
				"limit" = 5,
				"options" = list(
					"anime"=				list("cost" = 1, "value" = -1),
					"aliens" =				list("cost" = 2, "value" = -4),
					"authority" =			list("cost" = 1, "value" = -2),
					"birds" =				list("cost" = 2, "value" = -4),
					"clowns"=				list("cost" = 1, "value" = -1),
					"doctors" =				list("cost" = 2, "value" = -4),
					"falling" =				list("cost" = 0, "value" = -1),
					"greytide" =			list("cost" = 1, "value" = -2),
					"lizards" =				list("cost" = 2, "value" = -4),
					"robots" =				list("cost" = 2, "value" = -4),
					"security" =			list("cost" = 1, "value" = -2),
					"skeletons" =			list("cost" = 1, "value" = -2),
					"snakes"=				list("cost" = 1, "value" = -1),
					"space" =				list("cost" = 2, "value" = -5),
					"spiders" =				list("cost" = 2, "value" = -3),
					"strangers" =			list("cost" = 0, "value" = 0),
					"the supernatural" =	list("cost" = 2, "value" = -3)
				)
			)
		),
		"Addicted" = list(
			"Addiction"= list(
				"limit" = 6,
				"options" = list(
					"Crank" =				list("cost" = 1, "value" = -1),
					"Happiness" =			list("cost" = 1, "value" = -1),
					"Krokodil" =			list("cost" = 3, "value" = -2),
					"Methamphetamine" =		list("cost" = 2, "value" = -1),
					"Morphine"=				list("cost" = 1, "value" = -1)
				)
			)
		),
		"Smoker" = list(
			"Favorite Brand"= list(
				"limit" = 1,
				"options" = list(
					"None" =				list("cost" = 1, "value" = 0),
					"Carp Classic"=			list("cost" = 1, "value" = -2),
					"Midori Tabako" =		list("cost" = 1, "value" = -2),
					"Robust" =				list("cost" = 1, "value" = -2),
					"Robust Gold" =			list("cost" = 1, "value" = -2),
					"Space Cigarettes"=		list("cost" = 1, "value" = -2),
					"Uplift Smooth" =		list("cost" = 1, "value" = -2)
				)
			)
		)
			)

/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	if(!quirks.len)
		SetupQuirks()

	quirk_blacklist = list(list("Blind","Nearsighted"), \
							list("Jolly","Depression","Apathetic","Hypersensitive"), \
							list("Ageusia","Vegetarian","Deviant Tastes"), \
							list("Ananas Affinity","Ananas Aversion"), \
							list("Alcohol Tolerance","Light Drinker"), \
							list("Clown Fan","Mime Fan", "RILENA Super Fan"), \
							list("Bad Touch", "Friendly"))
	quirk_species_locks = list("Blood Deficiency" = TRAIT_SPECIES_BLACKLIST(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_VAMPIRE), \
	"Vampirism" = TRAIT_SPECIES_BLACKLIST(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_ELZUOSE, SPECIES_VAMPIRE, SPECIES_POD))


	for(var/client/client in GLOB.clients)
		client?.prefs.check_quirk_compatibility()
		client?.prefs.update_quirk_preferences()
	return ..()

/datum/controller/subsystem/processing/quirks/proc/SetupQuirks()
	// Sort by Positive, Negative, Neutral; and then by name
	var/list/quirk_list = sortList(subtypesof(/datum/quirk), /proc/cmp_quirk_asc)

	for(var/V in quirk_list)
		var/datum/quirk/T = V
		quirks[initial(T.name)] = T
		quirk_points[initial(T.name)] = initial(T.value)

/datum/controller/subsystem/processing/quirks/proc/AssignQuirks(mob/living/user, client/cli, spawn_effects)
	var/badquirk = FALSE
	var/list/conflicting_quirks = cli?.prefs.check_quirk_compatibility()
	conflicting_quirks &= cli?.prefs.all_quirks
	if(length(conflicting_quirks) > 0)
		stack_trace("Conflicting quirks [conflicting_quirks.Join(", ")] in client [cli.ckey] preferences on spawn")
	for(var/V in cli?.prefs.all_quirks)
		var/datum/quirk/Q = quirks[V]
		if(Q)
			user.add_quirk(Q, spawn_effects)
		else
			stack_trace("Invalid quirk \"[V]\" in client [cli.ckey] preferences")
			cli?.prefs.all_quirks -= V
			badquirk = TRUE
	if(badquirk)
		cli?.prefs.save_character()

	if(length(conflicting_quirks) > 0)
		alert(user, "Your quirks have been altered because you had a conflicting or invalid quirk, this was likely caused by mood being disabled or the species locks on a quirk being updated!")

#undef TRAIT_SPECIES_BLACKLIST
#undef TRAIT_SPECIES_WHITELIST
