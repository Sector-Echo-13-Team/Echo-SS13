/datum/supply_pack/medical
	group = "Medical"
	crate_type = /obj/structure/closet/crate/medical

/*
		First aid kits
*/

/datum/supply_pack/medical/firstaid_single
	name = "First Aid Kit Single-Pack"
	desc = "Contains one first aid kit for healing most types of wounds."
	cost = 750
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/regular)

/datum/supply_pack/medical/firstaidbruises_single
	name = "Bruise Treatment Kit Single-Pack"
	desc = "Contains one first aid kit focused on healing bruises and broken bones."
	cost = 1250
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/brute)

/datum/supply_pack/medical/firstaidburns_single
	name = "Burn Treatment Kit Single-Pack"
	desc = "Contains one first aid kit focused on healing severe burns."
	cost = 1250
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/fire)

/datum/supply_pack/medical/firstaidoxygen_single
	name = "Oxygen Deprivation Kit Single-Pack"
	desc = "Contains one first aid kit focused on helping oxygen deprivation victims."
	cost = 1250
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/o2)

/datum/supply_pack/medical/firstaidtoxins_single
	name = "Toxin Treatment Kit Single-Pack"
	desc = "Contains one first aid kit focused on healing damage dealt by heavy toxins."
	cost = 1250
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/toxin)

/datum/supply_pack/medical/firstaid_rad_single
	name = "Radiation Treatment Kit Single-Pack"
	desc = "Contains one first aid kit focused on reducing the damage done by radiation."
	cost = 1000
	small_item = TRUE
	contains = list(/obj/item/storage/firstaid/radiation)

/*
		Tools
*/

/datum/supply_pack/medical/iv_drip
	name = "IV Drip Crate"
	desc = "Contains a single IV drip for administering blood to patients."
	cost = 1000
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"

/datum/supply_pack/medical/defibs
	name = "Defibrillator Crate"
	desc = "Contains two defibrillators for bringing the recently deceased back to life."
	cost = 1500
	contains = list(/obj/item/defibrillator/loaded,
					/obj/item/defibrillator/loaded)
	crate_name = "defibrillator crate"

/datum/supply_pack/medical/surgery
	name = "Surgical Supplies Crate"
	desc = "Do you want to perform surgery, but don't have one of those fancy shmancy degrees? Just get started with this crate containing a medical duffelbag, Sterilizine spray and collapsible roller bed."
	cost = 3000
	contains = list(/obj/item/storage/backpack/duffelbag/med/surgery,
					/obj/item/reagent_containers/medigel/sterilizine,
					/obj/item/roller)
	crate_name = "surgical supplies crate"

/*
		Bundles and supplies
*/

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	desc = "Contains several different blood packs for reintroducing blood to patients."
	cost = 1000
	contains = list(/obj/item/reagent_containers/blood,
					/obj/item/reagent_containers/blood,
					/obj/item/reagent_containers/blood/APlus,
					/obj/item/reagent_containers/blood/AMinus,
					/obj/item/reagent_containers/blood/BPlus,
					/obj/item/reagent_containers/blood/BMinus,
					/obj/item/reagent_containers/blood/OPlus,
					/obj/item/reagent_containers/blood/OMinus,
					/obj/item/reagent_containers/blood/lizard)
	crate_name = "blood freezer"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/surplus
	name = "Medical Surplus Crate"
	desc = "Contains an assortment of medical supplies haphazardly pulled from storage. German doctor not included."
	cost = 3000
	contains = list(/obj/item/reagent_containers/glass/bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/toxin,
					/obj/item/reagent_containers/glass/beaker/large,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/stack/medical/gauze,
					/obj/item/storage/box/beakers,
					/obj/item/storage/box/medigels,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/brute,
					/obj/item/storage/firstaid/fire,
					/obj/item/defibrillator/loaded,
					/obj/item/reagent_containers/blood/OMinus,
					/obj/item/storage/pill_bottle/mining,
					/obj/item/reagent_containers/pill/neurine,
					/obj/item/vending_refill/medical)
	crate_name = "medical surplus crate"

/datum/supply_pack/medical/surplus/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 7)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/medical/virus
	name = "Virus Crate"
	desc = "Contains twelve different bottles, containing several viral samples for virology research. Also includes seven beakers and syringes. Balled-up jeans not included."
	cost = 3500
	contains = list(/obj/item/reagent_containers/glass/bottle/flu_virion,
					/obj/item/reagent_containers/glass/bottle/cold,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/reagent_containers/glass/bottle/magnitis,
					/obj/item/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/reagent_containers/glass/bottle/brainrot,
					/obj/item/reagent_containers/glass/bottle/anxiety,
					/obj/item/reagent_containers/glass/bottle/beesease,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/glass/bottle/mutagen)
	crate_name = "virus crate"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/salglucanister
	name = "Heavy-Duty Saline Canister"
	desc = "Contains a bulk supply of saline-glucose condensed into a single canister that should last a long time, with a large pump to fill containers with. Direct injection of saline should be left to medical professionals as the pump is capable of overdosing patients."
	cost = 5000
	contains = list(/obj/machinery/iv_drip/saline)
	crate_name = "saline glucose crate"
	crate_type = /obj/structure/closet/crate/large
