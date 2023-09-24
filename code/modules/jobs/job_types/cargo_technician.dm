/datum/job/cargo_tech
	name = "Cargo Technician"
	wiki_page = "Cargo_technician" //WS Edit - Wikilinks/Warning

	outfit = /datum/outfit/job/cargo_tech

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM)

	display_order = JOB_DISPLAY_ORDER_CARGO_TECHNICIAN

/datum/outfit/job/cargo_tech
	name = "Cargo Technician"
	job_icon = "cargotechnician"
	jobtype = /datum/job/cargo_tech

	belt = /obj/item/pda/cargo
	ears = /obj/item/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo/tech
	alt_uniform = /obj/item/clothing/under/shorts/grey //WS Edit - Alt Uniforms
	alt_suit = /obj/item/clothing/suit/hazardvest
	dcoat = /obj/item/clothing/suit/hooded/wintercoat/cargo //WS Edit - Alt Uniforms
	l_hand = /obj/item/export_scanner
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/cargo=1)

//Shiptest outfits

/datum/outfit/job/cargo_tech/pilot
	name = "Pilot"

	uniform = /obj/item/clothing/under/syndicate/camo
	accessory = /obj/item/clothing/accessory/armband/cargo
	suit = /obj/item/clothing/suit/jacket
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/sunglasses/big

/datum/outfit/job/cargo_tech/donk
	name = "Customer Associate (Donk! Co.)"
	id = /obj/item/card/id/syndicate_command/crew_id
	uniform = /obj/item/clothing/under/syndicate/donk
	suit = /obj/item/clothing/suit/hazardvest/donk

/datum/outfit/job/cargo_tech/frontiersmen
	name = "Cargo Tech (frontiersmen)"

	uniform = /obj/item/clothing/under/rank/security/officer/frontier
	suit = /obj/item/clothing/suit/hazardvest
	ears = /obj/item/radio/headset/pirate
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/soft
	backpack_contents = list(
		/obj/item/modular_computer/tablet/preset/cargo = 1,
	)
