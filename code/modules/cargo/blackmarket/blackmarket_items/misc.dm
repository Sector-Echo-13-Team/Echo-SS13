/datum/blackmarket_item/misc
	category = "Miscellaneous"

/datum/blackmarket_item/misc/cap_gun
	name = "Cap Gun"
	desc = "Prank your friends with this harmless gun! Harmlessness guranteed."
	item = /obj/item/toy/gun

	price_min = 50
	price_max = 200
	stock_max = 6
	availability_prob = 80

/datum/blackmarket_item/misc/cham_holster
	name = "Chameleon Shoulder holster"
	desc = "Looking to pack some heat without attracting attention? This adapative chameleon shoulder holster can disguise itself and your piece!"
	item = /obj/item/clothing/accessory/holster

	price_min = 200
	price_max = 800
	stock_max = 4
	availability_prob = 40

/datum/blackmarket_item/misc/strange_seed
	name = "Strange Seeds"
	desc = "An Exotic Variety of seed that can contain anything from glow to acid."
	item = /obj/item/seeds/random

	price_min = 150
	price_max = 360
	availability_prob = 100
	unlimited = TRUE

/datum/blackmarket_item/misc/smugglers_satchel
	name = "Smuggler's Satchel"
	desc = "This easily hidden satchel can become a versatile tool to anybody with the desire to keep certain items out of sight and out of mind."
	item = /obj/item/storage/backpack/satchel/flat/empty

	price_min = 250
	price_max = 1000
	stock_max = 2
	availability_prob = 30

/datum/blackmarket_item/misc/organs
	name = "Organ Freezer"
	desc = "Need some fresh organs in a jiffy? We got you covered. Make good use of them, someone died to get these to you."
	item = /obj/structure/closet/crate/freezer/surplus_limbs/organs

	price_min = 1000
	price_max = 2500
	stock_max = 3
	availability_prob = 30

/datum/blackmarket_item/misc/abandoned_crate
	name = "Abandoned Crate"
	desc = "Why, it could be anything. Are you feeling lucky?"
	item = /obj/structure/closet/crate/secure/loot

	price_min = 100
	price_max = 300
	availability_prob = 100
	unlimited =  TRUE

/datum/blackmarket_item/misc/secret_docs
	name = "Classified Documents"
	desc = "Good people died to get these. Luckily, we aren't good people."
	item = /obj/item/documents

	price_min = 1000
	price_max = 10000
	stock = 1
	availability_prob = 40

/datum/blackmarket_item/misc/secret_docs/spawn_item(loc)
	var/docs = pick(list(/obj/item/documents/nanotrasen,
				/obj/item/documents/solgov,
				/obj/item/documents/terragov,
				/obj/item/documents/syndicate/red))
	return new docs(loc)

/datum/blackmarket_item/misc/black_box
	name = "Blackbox"
	desc = "Recorded in here is final moments of some poor souls who are no longer with us. We suggest watching it with friends and popcorn."
	item = /obj/item/blackbox

	price_min = 1000
	price_max = 10000
	stock = 1
	availability_prob = 40

/datum/blackmarket_item/misc/knockoff_plush
	name = "Knockoff T4LI Plush"
	desc = "You'll hardly be able to tell that it's an offbrand rip off!"
	item = /obj/item/toy/plush/tali

	price_min = 50
	price_max = 150
	stock_min = 2
	stock_max = 5
	availability_prob = 60

/datum/blackmarket_item/misc/knockoff_plush/spawn_item(loc)
	var/obj/item/toy/plush/tali/plush = ..()
	plush.name = "T3MMI"
	plush.desc = "A rather shoddy and unlicensed plushie 'paying homage' to a character from the RILENA series."
	return new plush(loc)

/datum/blackmarket_item/misc/pens
	name = "Pen"
	desc = "We found an old Cybersun blacksite, and came across an unmarked crate full of pens. Want one?"
	item = /obj/item/pen

	price_min = 50
	price_max = 150
	unlimited = TRUE
	availability_prob = 60

/datum/blackmarket_item/misc/pens/spawn_item(loc)
	var/pen = pick(list(/obj/item/pen,
				/obj/item/pen/blue,
				/obj/item/pen/red,
				/obj/item/pen/fourcolor,
				/obj/item/pen/fountain,
				/obj/item/pen/fountain/captain,
				/obj/item/pen/solgov,
				/obj/item/pen/fountain/solgov,
				/obj/item/pen/edagger,
				/obj/item/pen/survival,
				/obj/item/pen/sleepy))
	return new pen(loc)

/datum/blackmarket_item/misc/hexacrete
	name = "Jug of Hexacrete"
	desc = "Need to make a blacksite in a jiffy? Skip the fuss with this 150u jug of hexacrete!"
	item = /obj/item/reagent_containers/glass/chem_jug/hexacrete

	price_min = 750
	price_max = 1500
	stock_min = 3
	stock_max = 10
	availability_prob = 30


