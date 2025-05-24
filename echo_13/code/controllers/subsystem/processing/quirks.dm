/datum/controller/subsystem/processing/quirks/Initialize(timeofday) // Echo 13 - Start - Vampires
	if(!quirks.len)
		SetupQuirks()

	quirk_blacklist = list(
		list("Blind","Nearsighted"), \
		list("Ageusia","Vegetarian","Deviant Tastes"), \
		list("Alcohol Tolerance","Light Drinker"), \
		list("Bad Touch", "Friendly"), \
		list("Self-Aware", "Congenital Analgesia"), \
		list("Blood Deficiency", "Vampirism"), \
		list("(Language) Moth Pidgin", "(Language) Solarian International", "(Language) Teceti Unified Standard", "(Language) Kalixcian Common"), \
		)

	species_blacklist = list("Blood Deficiency" = list(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_VAMPIRE), \
	"Vampirism" = list(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_ELZUOSE, SPECIES_VAMPIRE, SPECIES_POD))

	for(var/client/client in GLOB.clients)
		client?.prefs.check_quirk_compatibility()
	return ..()
