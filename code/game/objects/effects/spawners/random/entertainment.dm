/obj/effect/spawner/random/entertainment
	name = "entertainment loot spawner"
	desc = "It's time to paaaaaarty!"

/obj/effect/spawner/random/entertainment/arcade
	name = "spawn random arcade machine"
	desc = "Automagically transforms into a random arcade machine. If you see this while in a shift, please create a bug report."
	icon_state = "arcade"
	loot = list(
		/obj/machinery/computer/arcade/orion_trail = 49,
		/obj/machinery/computer/arcade/battle = 49,
		/obj/machinery/computer/arcade/amputation = 2,
	)

/obj/effect/spawner/random/entertainment/musical_instrument
	name = "musical instrument spawner"
	icon_state = "eguitar"
	loot = list(
		/obj/item/instrument/violin = 5,
		/obj/item/instrument/banjo = 5,
		/obj/item/instrument/guitar = 5,
		/obj/item/instrument/eguitar = 5,
		/obj/item/instrument/glockenspiel = 5,
		/obj/item/instrument/accordion = 5,
		/obj/item/instrument/trumpet = 5,
		/obj/item/instrument/saxophone = 5,
		/obj/item/instrument/trombone = 5,
		/obj/item/instrument/recorder = 5,
		/obj/item/instrument/harmonica = 5,
		/obj/item/instrument/bikehorn = 2,
		/obj/item/instrument/violin/golden = 2,
	)

/obj/effect/spawner/random/entertainment/gambling
	name = "gambling valuables spawner"
	icon_state = "dice"
	loot = list(
		/obj/item/clothing/head/trapper = 3,
		/obj/effect/spawner/random/entertainment/coin = 3,
		/obj/effect/spawner/random/entertainment/money = 3,
		/obj/item/dice/d6 = 3,
		/obj/item/storage/box/syndie_kit/throwing_weapons = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka,
	)

/obj/effect/spawner/random/entertainment/coin
	name = "coin spawner"
	icon_state = "coin"
	loot = list(
		/obj/item/coin/iron = 10,
		/obj/item/coin/plastic = 5,
		/obj/item/coin/silver = 4,
		/obj/item/coin/plasma = 4,
		/obj/item/coin/uranium = 3,
		/obj/item/coin/titanium = 3,
		/obj/item/coin/diamond = 2,
		/obj/item/coin/twoheaded = 1,
		/obj/item/coin/antagtoken = 1,
	)

/obj/effect/spawner/random/entertainment/money_small
	name = "small money spawner"
	icon_state = "cash"
	spawn_loot_count = 3
	spawn_loot_split = TRUE
	loot = list(
		/obj/item/spacecash/bundle/c1 = 5,
		/obj/item/spacecash/bundle/c10 = 3,
		/obj/item/spacecash/bundle/c20 = 2,
	)

/obj/effect/spawner/random/entertainment/money
	name = "money spawner"
	icon_state = "cash"
	spawn_loot_count = 3
	spawn_loot_split = TRUE
	loot = list(
		/obj/item/spacecash/bundle/c1 = 10,
		/obj/item/spacecash/bundle/c10 = 5,
		/obj/item/spacecash/bundle/c20 = 3,
		/obj/item/spacecash/bundle/c50 = 2,
		/obj/item/spacecash/bundle/c100 = 1,
	)

/obj/effect/spawner/random/entertainment/money_medium
	name = "money spawner"
	icon_state = "cash"
	loot = list(
		/obj/item/spacecash/bundle/c100 = 25,
		/obj/item/spacecash/bundle/c200 = 15,
		/obj/item/spacecash/bundle/c50 = 10,
		/obj/item/spacecash/bundle/c500 = 5,
		/obj/item/spacecash/bundle/c1000 = 1,
	)

/obj/effect/spawner/random/entertainment/money_large
	name = "large money spawner"
	icon_state = "cash"
	spawn_loot_count = 5
	spawn_loot_split = TRUE
	loot = list(
		/obj/item/spacecash/bundle/c1 = 100,
		/obj/item/spacecash/bundle/c10 = 80,
		/obj/item/spacecash/bundle/c20 = 60,
		/obj/item/spacecash/bundle/c50 = 40,
		/obj/item/spacecash/bundle/c100 = 30,
		/obj/item/spacecash/bundle/c200 = 20,
		/obj/item/spacecash/bundle/c500 = 10,
		/obj/item/spacecash/bundle/c1000 = 5,
		/obj/item/spacecash/bundle/c10000 = 1,
	)

/obj/effect/spawner/random/entertainment/drugs
	name = "recreational drugs spawner"
	icon_state = "pill"
	loot = list(
		/obj/item/reagent_containers/food/drinks/bottle/hooch = 50,
		/obj/item/clothing/mask/cigarette/rollie/cannabis = 15,
		/obj/item/reagent_containers/syringe = 15,
		/obj/item/cigbutt/roach = 15,
		/obj/item/clothing/mask/cigarette/rollie/mindbreaker = 5,
	)

/obj/effect/spawner/random/entertainment/dice
	name = "dice spawner"
	icon_state = "dice_bag"
	loot = list(
		/obj/item/dice/d4,
		/obj/item/dice/d6,
		/obj/item/dice/d8,
		/obj/item/dice/d10,
		/obj/item/dice/d12,
		/obj/item/dice/d20,
	)

/obj/effect/spawner/random/entertainment/cigarette_pack
	name = "cigarette pack spawner"
	icon_state = "cigarettes"
	loot = list(
		/obj/item/storage/fancy/cigarettes = 3,
		/obj/item/storage/fancy/cigarettes/dromedaryco = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 1,
	)

/obj/effect/spawner/random/entertainment/cigarette
	name = "cigarette spawner"
	icon_state = "cigarettes"
	loot = list(
		/obj/item/clothing/mask/cigarette/space_cigarette = 3,
		/obj/item/clothing/mask/cigarette/rollie/cannabis = 3,
		/obj/item/clothing/mask/cigarette/rollie/nicotine = 3,
		/obj/item/clothing/mask/cigarette/dromedary = 2,
		/obj/item/clothing/mask/cigarette/uplift = 2,
		/obj/item/clothing/mask/cigarette/robust = 2,
		/obj/item/clothing/mask/cigarette/carp = 1,
		/obj/item/clothing/mask/cigarette/robustgold = 1,
	)

/obj/effect/spawner/random/entertainment/cigar
	name = "cigar spawner"
	icon_state = "cigarettes"
	loot = list(
		/obj/item/clothing/mask/cigarette/cigar = 3,
		/obj/item/clothing/mask/cigarette/cigar/havana = 2,
		/obj/item/clothing/mask/cigarette/cigar/cohiba = 1,
	)

/obj/effect/spawner/random/entertainment/wallet_lighter
	name = "lighter wallet spawner"
	icon_state = "lighter"
	loot = list( // these fit inside a wallet
		/obj/item/match = 10,
		/obj/item/lighter/greyscale = 10,
		/obj/item/lighter = 1,
	)

/obj/effect/spawner/random/entertainment/lighter
	name = "lighter spawner"
	icon_state = "lighter"
	loot = list(
		/obj/item/storage/box/matches = 10,
		/obj/item/lighter/greyscale = 10,
		/obj/item/lighter = 1,
	)

/obj/effect/spawner/random/entertainment/wallet_storage
	name = "wallet contents spawner"
	icon_state = "wallet"
	spawn_loot_count = 1
	loot = list(	// random photos would go here. IF I HAD ONE. :'(
		/obj/item/lipstick/random,
		/obj/effect/spawner/random/food_or_drink/seed,
		/obj/effect/spawner/random/medical/minor_healing,
		/obj/effect/spawner/random/entertainment/coin,
		/obj/effect/spawner/random/entertainment/dice,
		/obj/effect/spawner/random/entertainment/cigarette,
		/obj/effect/spawner/random/entertainment/wallet_lighter,
		/obj/effect/spawner/random/bureaucracy/paper,
		/obj/effect/spawner/random/bureaucracy/crayon,
		/obj/effect/spawner/random/bureaucracy/pen,
		/obj/effect/spawner/random/bureaucracy/stamp,
	)

/obj/effect/spawner/random/entertainment/deck
	name = "deck spawner"
	icon_state = "deck"
	loot = list(
		/obj/item/toy/cards/deck = 5,
		/obj/item/toy/cards/deck/kotahi = 2,
		/obj/item/toy/cards/deck/tarot = 1,
	)

/obj/effect/spawner/random/entertainment/toy_figure
	name = "toy figure spawner"
	icon_state = "toy"
	loot_subtype_path = /obj/item/toy/figure
	loot = list()

/obj/effect/spawner/random/entertainment/toy
	name = "toy spawner"
	icon_state = "toy"
	loot = list()

/obj/effect/spawner/random/entertainment/toy/Initialize(mapload)
	loot += GLOB.arcade_prize_pool
	return ..()

/obj/effect/spawner/random/entertainment/plushie
	name = "plushie spawner"
	icon_state = "plushie"
	loot = list (
		/obj/item/toy/plush/beeplushie,
		/obj/item/toy/plush/blahaj,
		/obj/item/toy/plush/carpplushie,
		/obj/item/toy/plush/flushed,
		/obj/item/toy/plush/kari,
		/obj/item/toy/plush/lizardplushie,
		/obj/item/toy/plush/mora,
		/obj/item/toy/plush/realgoat,
		/obj/item/toy/plush/rilena,
		/obj/item/toy/plush/sharai,
		/obj/item/toy/plush/slimeplushie,
		/obj/item/toy/plush/snakeplushie,
		/obj/item/toy/plush/spider,
		/obj/item/toy/plush/tali,
		/obj/item/toy/plush/xader,
		/obj/item/toy/plush/frederick,
		/obj/effect/spawner/random/entertainment/plushie/moth // fair chances
	)

/obj/effect/spawner/random/entertainment/plushie/moth
	loot = list (
		/obj/item/toy/plush/moth,
		/obj/item/toy/plush/moth/monarch,
		/obj/item/toy/plush/moth/luna,
		/obj/item/toy/plush/moth/atlas,
		/obj/item/toy/plush/moth/redish,
		/obj/item/toy/plush/moth/royal,
		/obj/item/toy/plush/moth/gothic,
		/obj/item/toy/plush/moth/lovers,
		/obj/item/toy/plush/moth/whitefly,
		/obj/item/toy/plush/moth/punished,
		/obj/item/toy/plush/moth/firewatch,
		/obj/item/toy/plush/moth/deadhead,
		/obj/item/toy/plush/moth/poison,
		/obj/item/toy/plush/moth/ragged,
		/obj/item/toy/plush/moth/snow,
		/obj/item/toy/plush/moth/moonfly
	)

/obj/effect/spawner/random/entertainment/colorful_grenades
	name = "colorful/glitter grenades spawner"
	loot = list(
		/obj/item/grenade/chem_grenade/glitter/pink,
		/obj/item/grenade/chem_grenade/glitter/blue,
		/obj/item/grenade/chem_grenade/glitter/white,
		/obj/item/grenade/chem_grenade/colorful
	)
