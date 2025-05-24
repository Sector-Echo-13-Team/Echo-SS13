// Hey! Listen! Update _maps\map_catalogue.txt with your new ruins!

/datum/map_template/ruin/space
	prefix = "_maps/RandomRuins/SpaceRuins/"
	cost = 1
	allow_duplicates = FALSE
	ruin_type = RUINTYPE_SPACE

/datum/map_template/ruin/space/bigderelict1
	id = "bigderelict1"
	suffix = "bigderelict1.dmm"
	name = "Derelict Tradepost"
	description = "A once-bustling tradestation that handled imports and exports from nearby stations now lays eerily dormant. \
	The last received message was a distress call from one of the on-board officers, but we had no success in making contact again."
	ruin_tags = list(RUIN_TAG_MINOR_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_SHELTER)

/datum/map_template/ruin/space/onehalf
	id = "onehalf"
	suffix = "onehalf.dmm"
	name = "DK Excavator 453"
	description = "Formerly a thriving planetary mining outpost, now a bit of an exploded mess. One has to wonder how it got here"
	ruin_tags = list(RUIN_TAG_MINOR_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_INHOSPITABLE)

/datum/map_template/ruin/space/power_puzzle
	id = "power_puzzle"
	suffix = "power_puzzle.dmm"
	name = "Power Puzzle"
	description = "an abandoned secure storage location. there is no power left in the batteries and the former ocupants locked it pretty tight before leaving.\
	You will have to power areas to raise the bolts on the doors. look out for secrets."
	ruin_tags = list(RUIN_TAG_MINOR_COMBAT, RUIN_TAG_MAJOR_LOOT, RUIN_TAG_SHELTER, RUIN_TAG_HAZARDOUS)
	ruin_mission_types = list(/datum/mission/ruin/data_retrieval)

/datum/map_template/ruin/space/singularitylab
	id = "singularitylab"
	suffix = "singularity_lab.dmm"
	name = "Singularity Lab"
	description = "An overgrown facility, home to an inactive singularity and many plants"
	ruin_tags = list(RUIN_TAG_BOSS_COMBAT, RUIN_TAG_MAJOR_LOOT, RUIN_TAG_SHELTER)
	ruin_mission_types = list(/datum/mission/ruin/oh_fuck)

/datum/mission/ruin/oh_fuck
	name = "Singularity Generator Signature"
	desc = "There is a Singularity Generator Signature emitting from this location of space. This is incredibly dangerous. We are willing to pay top dollar to whoever can locate and secure this thing. God help us if a black hole opens up in the system."
	author = "The Outpost"
	value = 4000
	mission_limit = 1
	setpiece_item = /obj/machinery/the_singularitygen

/datum/map_template/ruin/space/spacemall
	id = "spacemall"
	suffix = "spacemall.dmm"
	name = "Space Mall"
	description = "An old shopping centre, owned by a former member of Nanotrasen's board of directors.."
	ruin_tags = list(RUIN_TAG_MEDIUM_COMBAT, RUIN_TAG_MAJOR_LOOT, RUIN_TAG_SHELTER)

/datum/map_template/ruin/space/scrapstation
	id = "scrapstation"
	suffix = "scrapstation.dmm"
	name = "Ramzi Scrapping Station"
	description = "A Syndicate FOB dating back to the ICW, now home to the Ramzi Clique and their latest haul."
	ruin_tags = list(RUIN_TAG_BOSS_COMBAT, RUIN_TAG_MAJOR_LOOT, RUIN_TAG_SHELTER)
	ruin_mission_types = list(
		/datum/mission/ruin/pgf_captain,
		/datum/mission/ruin/signaled/kill/foreman
	)

/datum/mission/ruin/signaled/kill/foreman
	name = "Kill Foreman Bonsha"
	desc = "Defector Verron Bonsha has established a Ramzi Clique post inside a former Coalation FOB. Killing him should send the local Clique into disarray and disrupt their supply lines."
	author = "2nd Battlegroup Headquarters"
	faction = /datum/faction/syndicate/ngr
	value = 2000
	mission_limit = 1

/datum/mission/ruin/pgf_captain
	name = "MIA Vessel Investigation"
	desc = "The recovery beacon for a PFGN vessel that went missing on patrol has activated. Intellegence suggests they may have been assaulted by pirates. Recover the vessel captain's body and you will be compensated for your services."
	author = "PGFN Naval Command"
	value = 1500
	mission_limit = 1
	faction = /datum/faction/pgf
	setpiece_item = /mob/living/carbon/human
