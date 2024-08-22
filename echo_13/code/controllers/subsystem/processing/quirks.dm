// Echo 13 - Vampires
/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	if(!quirks.len)
		SetupQuirks()

	quirk_blacklist = list(list("Blind","Nearsighted"), \
							list("Jolly","Depression","Apathetic","Hypersensitive"), \
							list("Ageusia","Vegetarian","Deviant Tastes"), \
							list("Ananas Affinity","Ananas Aversion"), \
							list("Alcohol Tolerance","Light Drinker"), \
							list("Blood Deficiency", "Vampirism"), \
							list("Clown Fan","Mime Fan", "RILENA Super Fan"), \
							list("Bad Touch", "Friendly"))

	species_blacklist = list("Blood Deficiency" = list(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_VAMPIRE), \
	"Vampirism" = list(SPECIES_IPC, SPECIES_JELLYPERSON, SPECIES_PLASMAMAN, SPECIES_ELZUOSE, SPECIES_VAMPIRE, SPECIES_POD))

	for(var/client/client in GLOB.clients)
		client?.prefs.check_quirk_compatibility()
	return ..()
