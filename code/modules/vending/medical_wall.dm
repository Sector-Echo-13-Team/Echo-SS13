/obj/machinery/vending/wallmed
	name = "\improper OutpostMed"
	desc = "A vending machine filled with medical supplies, provided to you free of charge by the Outpost Authority."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = FALSE
	product_ads = "Dr. Pills approved!;Only the finest for the frontier.;Need a pick-me-up?.;Lanchester sourced equipment.;Don't be a fool. Plus yourself up.;Don't you want some?;Ping!"
	products = list(
		/obj/item/stack/medical/gauze = 8,
		/obj/item/stack/medical/splint = 8,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 4,
		/obj/item/reagent_containers/hypospray/medipen/diphen = 5,
		/obj/item/reagent_containers/hypospray/medipen/psicodine = 6,
		/obj/item/reagent_containers/hypospray/medipen/synap = 6,
		/obj/item/reagent_containers/hypospray/medipen/mannitol = 10,
		/obj/item/reagent_containers/hypospray/medipen/tricord = 6,
		/obj/item/reagent_containers/hypospray/medipen/tramal = 6,
		/obj/item/reagent_containers/hypospray/medipen/antihol = 10,
		/obj/item/reagent_containers/hypospray/medipen/anti_rad = 10,
		/obj/item/storage/pill_bottle/licarb = 4,
		/obj/item/reagent_containers/syringe/stasis = 4
	)
	premium = list(
		/obj/item/reagent_containers/medigel/styptic = 3,
		/obj/item/reagent_containers/medigel/silver_sulf = 3,
		/obj/item/storage/pill_bottle/stardrop = 5
		)
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/wallmed
	default_price = 75
	extra_price = 200
	tiltable = FALSE
	light_mask = "wallmed-light-mask"

/obj/item/vending_refill/wallmed
	machine_name = "NanoMed"
	icon_state = "refill_medical"
