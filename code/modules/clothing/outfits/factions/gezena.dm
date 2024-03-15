/datum/outfit/job/gezena
	name = "PGF - Base Outfit"
	// faction_icon = "bg_pgf"

/datum/outfit/job/gezena/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.faction |= list(FACTION_PLAYER_GEZENA)

//Playable Roles (put in ships):
/datum/outfit/job/gezena/assistant
	name = "PGF - Crewman"
	id_assignment = "Crewman"
	jobtype = /datum/job/assistant
	job_icon = "assistant"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

/datum/outfit/job/gezena/engineer
	name = "PGF - Navy Engineer"
	id_assignment = "Naval Engineer"
	jobtype = /datum/job/engineer
	job_icon = "stationengineer"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/engi

/datum/outfit/job/gezena/doctor
	name = "PGF - Navy Doctor"
	jobtype = /datum/job/doctor
	job_icon = "medicaldoctor"

	uniform = /obj/item/clothing/under/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med

/datum/outfit/job/gezena/security
	name = "PGF - Marine"
	id_assignment = "Marine"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

/datum/outfit/job/gezena/hos
	name = "PGF - Marine Sergeant"
	id_assignment = "Sergeant"
	jobtype = /datum/job/hos
	job_icon = "headofsecurity"

	uniform = /obj/item/clothing/under/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain

/datum/outfit/job/gezena/captain
	name = "PGF - Captain"
	jobtype = /datum/job/captain
	job_icon = "captain"

	uniform = /obj/item/clothing/under/gezena/captain
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain

//Adminspawn Roles (for events):

/datum/outfit/job/gezena/assistant/geared
	name = "PGF - Crewman - Equipped"
	jobtype = /datum/job/assistant
	job_icon = "assistant"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/armor/gezena
	head = /obj/item/clothing/head/gezena
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena

/datum/outfit/job/gezena/engineer/geared
	name = "PGF - Navy Engineer - Equipped"
	jobtype = /datum/job/engineer
	job_icon = "stationengineer"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/armor/gezena/engi
	head = /obj/item/clothing/head/gezena
	belt = /obj/item/storage/belt/utility/full/engi
	gloves = /obj/item/clothing/gloves/gezena/engi
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/engi

/datum/outfit/job/gezena/doctor/geared
	name = "PGF - Navy Doctor - Equipped"
	jobtype = /datum/job/doctor
	job_icon = "medicaldoctor"

	uniform = /obj/item/clothing/under/gezena
	suit = /obj/item/clothing/suit/armor/gezena
	head = /obj/item/clothing/head/gezena/medic
	gloves = /obj/item/clothing/gloves/gezena
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med

/datum/outfit/job/gezena/security/geared
	name = "PGF - Marine - Equipped"
	jobtype = /datum/job/officer
	job_icon = "securityofficer"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/helmet/gezena
	belt = /obj/item/storage/belt/military/gezena
	gloves = /obj/item/clothing/gloves/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena
	r_hand = /obj/item/gun/energy/kalix/pgf/heavy

/datum/outfit/job/gezena/hos/geared
	name = "PGF - Marine Sergeant - Equipped"
	jobtype = /datum/job/hos
	job_icon = "headofsecurity"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/helmet/gezena
	belt = /obj/item/storage/belt/military/gezena
	gloves = /obj/item/clothing/gloves/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain
	r_hand = /obj/item/gun/energy/kalix/pgf

/datum/outfit/job/gezena/paramedic
	name = "PGF - Marine Medic - Equipped"
	jobtype = /datum/job/paramedic
	job_icon = "paramedic"

	uniform = /obj/item/clothing/under/gezena/marine
	suit = /obj/item/clothing/suit/armor/gezena/marine
	head = /obj/item/clothing/head/helmet/gezena
	belt = /obj/item/storage/belt/medical/gezena
	gloves = /obj/item/clothing/gloves/gezena/marine
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/med
	r_hand = /obj/item/gun/energy/kalix/pgf


/datum/outfit/job/gezena/captain/geared
	name = "PGF - Captain - Equipped"
	jobtype = /datum/job/captain
	job_icon = "captain"

	uniform = /obj/item/clothing/under/gezena/captain
	suit = /obj/item/clothing/suit/armor/gezena/captain
	head = /obj/item/clothing/head/gezena/captain
	gloves = /obj/item/clothing/gloves/gezena/captain
	shoes = /obj/item/clothing/shoes/combat/gezena
	neck = /obj/item/clothing/neck/cloak/gezena/captain
