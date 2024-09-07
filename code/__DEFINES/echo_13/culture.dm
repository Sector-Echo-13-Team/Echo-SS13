#define CULTURE_CULTURE "culture"
#define CULTURE_FACTION "faction"
#define CULTURE_LOCATION "location"

//Amount of linguistic points people have by default. 1 point to understand, 2 points to get it spoken
#define LINGUISTIC_POINTS_DEFAULT 5

#define LANGUAGE_UNDERSTOOD	1
#define LANGUAGE_SPOKEN	2

#define LESS_IMPORTANT_ROLE_LANGUAGE_REQUIREMENT null
#define NORMAL_ROLE_LANGUAGE_REQUIREMENT list(/datum/language/common = LANGUAGE_UNDERSTOOD)
#define IMPORTANT_ROLE_LANGUAGE_REQUIREMENT list(/datum/language/common = LANGUAGE_SPOKEN)

#define LANGUAGES_CULTURE_GENERIC /datum/language/common, /datum/language/draconic, /datum/language/moffic, /datum/language/spider, /datum/language/vox_pidgin, /datum/language/teceti_unified, /datum/language/buzzwords
#define LANGUAGES_CULTURE_EXOTIC LANGUAGES_GENERIC, /datum/language/slime, /datum/language/sylvan

//GROUPED CULTURAL DEFINES
#define CULTURES	/datum/cultural_info/culture/generic, \
					/datum/cultural_info/culture/vatgrown, \
					/datum/cultural_info/culture/spacer_core, \
					/datum/cultural_info/culture/spacer_frontier, \
					/datum/cultural_info/culture/generic_human, \

#define LOCATIONS	/datum/cultural_info/location/generic, \
					/datum/cultural_info/location/stateless, \

#define FACTIONS	/datum/cultural_info/faction/none, \
					/datum/cultural_info/faction/generic, \
					/datum/cultural_info/faction/nanotrasen, \
					/datum/cultural_info/faction/freetrade, \
