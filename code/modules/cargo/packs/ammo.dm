/datum/supply_pack/ammo
	group = "Ammunition"
	crate_type = /obj/structure/closet/crate/secure/gear

/*
		Pistol ammo
*/

/datum/supply_pack/ammo/co9mm_mag
	name = "9mm Commander Magazine Crate"
	desc = "Contains a 9mm magazine for the standard-issue Commander pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/co9mm,)
	cost = 500

/datum/supply_pack/ammo/m45_mag
	name = ".45 ACP Candor Magazine Crate"
	desc = "Contains a .45 ACP magazine for the Candor pistol, containing eight rounds."
	contains = list(/obj/item/ammo_box/magazine/m45)
	cost = 500

/datum/supply_pack/ammo/m45_speedloader
	name = ".45 ACP Speedloader Crate"
	desc = "Contains a .45 ACP speedloader for the HP Montagne, containing six rounds."
	contains = list(/obj/item/ammo_box/c45_speedloader)
	cost = 400

/datum/supply_pack/ammo/c38_mag
	name = ".38 Speedloader Crate"
	desc = "Contains a .38 speedloader for revolvers, containing six rounds."
	contains = list(/obj/item/ammo_box/c38)
	cost = 350

/datum/supply_pack/ammo/m10mm_mag
	name = "10mm Stechkin Magazine Crate"
	desc = "Contains a 10mm magazine for the stechkin pistol, containing eight rounds."
	contains = list(/obj/item/ammo_box/magazine/m10mm)
	cost = 500

/datum/supply_pack/ammo/a357_mag
	name = ".357 Speedloader Crate"
	desc = "Contains a .357 speedloader for revolvers,  containing seven rounds."
	contains = list(/obj/item/ammo_box/a357)
	cost = 750

/datum/supply_pack/ammo/mag_556mm
	name = "5.56 Pistole C Magazine Crate"
	desc = "Contains a 5.56mm magazine for the Pistole C, containing twelve rounds."
	contains = list(/obj/item/ammo_box/magazine/pistol556mm)
	cost = 750

/datum/supply_pack/ammo/fms_mag
	name = "Ferromagnetic Slug Magazine Crate"
	desc = "Contains a ferromagnetic slug magazine for the Model H pistol, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/modelh)
	cost = 750

/*
		Shotgun ammo
*/

/datum/supply_pack/ammo/buckshot
	name = "Buckshot Crate"
	desc = "Contains a box of twenty-five buckshot shells for use in lethal persuasion."
	cost = 500
	contains = list(/obj/item/ammo_box/a12g)

/datum/supply_pack/ammo/slugs
	name = "Shotgun Slug Crate"
	desc = "Contains a box of twenty-five slug shells for use in lethal persuasion."
	cost = 500
	contains = list(/obj/item/ammo_box/a12g/slug)

/*
		.38 ammo
*/

/datum/supply_pack/ammo/winchester_ammo
	name = "Flaming Arrow and Detective Special .38 Ammo Boxes"
	desc = "Contains a 30 round ammo boxes for refilling .38 weapons."
	cost = 500
	contains = list(/obj/item/ammo_box/c38_box,
					/obj/item/ammo_box/c38_box)
	crate_name = "ammo crate"

/datum/supply_pack/ammo/match
	name = ".38 Match Grade Speedloader"
	desc = "Contains one speedloader of match grade .38 ammunition, perfect for showing off trickshots."
	cost = 200
	small_item = TRUE
	contains = list(/obj/item/ammo_box/c38/match)
	crate_name = ".38 match crate"

/datum/supply_pack/ammo/dumdum
	name = ".38 DumDum Speedloader"
	desc = "Contains one speedloader of .38 DumDum ammunition, good for embedding in soft targets."
	cost = 200
	small_item = TRUE
	contains = list(/obj/item/ammo_box/c38/dumdum)
	crate_name = ".38 match crate"

/*
		WT-550 ammo
*/

/datum/supply_pack/ammo/wt550_ammo
	name = "WT-550 Auto Rifle Ammo Crate"
	desc = "Contains a 20-round magazine for the WT-550 Auto Rifle. Each magazine is designed to facilitate rapid tactical reloads."
	cost = 750
	contains = list(/obj/item/ammo_box/magazine/wt550m9)

/datum/supply_pack/ammo/cool_wt550_ammo
	name = "WT-550 Auto Rifle Exotic Ammo Crate"
	desc = "Contains one magazine of armor-piercing and one magazine of incendiary ammunition for the WT-550 Auto Rifle. Sadly, our manufacturer discontinued the uranium-tipped bullets."
	cost = 2500
	contains = list(/obj/item/ammo_box/magazine/wt550m9/ap,
					/obj/item/ammo_box/magazine/wt550m9/inc)

/datum/supply_pack/ammo/smgm45ammo
	name = ".45 Cobra Ammo Crate"
	desc = "Contains a .45 magazine for the Cobra-20, containing 24 rounds."
	cost = 750
	contains = list(/obj/item/ammo_box/magazine/smgm45)

/*
		Rifle ammo
*/

/datum/supply_pack/ammo/gal308_ammo
	name = "CM-GAL .308 Magazine Crate"
	desc = "Contains a .308 CM-GAL magazine for the CM-GAL rifle, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/gal)
	cost = 1000

/datum/supply_pack/ammo/gar_ammo
	name = "GAR Ferromagnetic Lance Magazine Crate"
	desc = "Contains a ferromagnetic lance magazine for the GAR rifle, containing thirty two rounds."
	contains = list(/obj/item/ammo_box/magazine/gar)
	cost = 1000

/datum/supply_pack/ammo/claris_ammo
	name = "Claris Ferromagnetic Pellet Speedloader Crate"
	desc = "Contains a ferromagnetic pellet speedloader for the Claris rifle, containing twenty two rounds."
	contains = list(/obj/item/ammo_box/amagpellet_claris)
	cost = 1000

/datum/supply_pack/ammo/ebr_ammo
	name = "M514 EBR .308 Magazine Crate"
	desc = "Contains a .308 magazine for the M514 EBR rifle, containing ten rounds."
	contains = list(/obj/item/ammo_box/magazine/ebr)
	cost = 1000

/datum/supply_pack/ammo/skm_ammo
	name = "SKM 7.62x40mm CLIP Magazine Crate"
	desc = "Contains a 7.62x40mm magazine for the SKM rifles, containing twenty rounds."
	contains = list(/obj/item/ammo_box/magazine/skm_762_40)
	cost = 1000

/datum/supply_pack/ammo/p16_ammo
	name = "P-16 5.56mm Magazine Crate"
	desc = "Contains a 5.56mm magazine for the P-16 rifle, containing thirty rounds."
	contains = list(/obj/item/ammo_box/magazine/p16)
	cost = 1000

/datum/supply_pack/ammo/a850r_ammo
	name = "8x50mmR En Bloc Clip Crate"
	desc = "Contains a 8x50mmR en bloc clip for rifles like the illestren rifle, containing five rounds."
	contains = list(/obj/item/ammo_box/magazine/illestren_a850r)
	cost = 250

/datum/supply_pack/ammo/a762_ammo_box
	name = "7.62x40mm CLIP Ammo Box Crate"
	desc = "Contains a eighty-round 7.62x40mm CLIP box for the SKM rifles."
	contains = list(/obj/item/ammo_box/a762_40)
	cost = 500

/datum/supply_pack/ammo/c556mmHITP_ammo_box
	name = "5.56 Caseless Ammo Box Crate"
	desc = "Contains a fifty-round 5.56mm caseless box for SolGov sidearms like the Pistole C."
	contains = list(/obj/item/ammo_box/c556mmHITP)
	cost = 250

/datum/supply_pack/ammo/c45_ammo_box
	name = ".45 Ammo Box Crate"
	desc = "Contains a fifty-round .45 box for pistols and SMGs like the Candor or the C-20r."
	contains = list(/obj/item/ammo_box/c45)
	cost = 250

/datum/supply_pack/ammo/c10mm_ammo_box
	name = "10mm Ammo Box Crate"
	desc = "Contains a fifty-round 10mm box for pistols and SMGs like the Stechkin or the SkM-44(k)."
	contains = list(/obj/item/ammo_box/c10mm)
	cost = 250

/datum/supply_pack/ammo/c9mm_ammo_box
	name = "9mm Ammo Box Crate"
	desc = "Contains a fifty-round 9mm box for pistols and SMGs such as the Commander or Saber."
	contains = list(/obj/item/ammo_box/c9mm)
	cost = 250

/datum/supply_pack/ammo/a308_ammo_box
	name = "308 Ammo Box Crate"
	desc = "Contains a thirty-round .308 box for DMRs such as the SsG-04 and CM-GAL-S."
	contains = list(/obj/item/ammo_box/a308)
	cost = 500

/datum/supply_pack/ammo/c9mmap_ammo_box
	name = "9mm AP Ammo Box Crate"
	desc = "Contains a fifty-round 9mm box loaded with armor piercing ammo."
	contains = list(/obj/item/ammo_box/c9mm/ap)
	cost = 500

/datum/supply_pack/ammo/c556mmHITPap_ammo_box
	name = "5.56 caseless AP Ammo Box Crate"
	desc = "Contains a fifty-round 5.56mm caseless boxloaded with armor piercing ammo."
	contains = list(/obj/item/ammo_box/c556mmHITP/ap)
	cost = 500

/datum/supply_pack/ammo/c45ap_ammo_box
	name = ".45 AP Ammo Box Crate"
	desc = "Contains a fifty-round .45 box loaded with armor piercing ammo."
	contains = list(/obj/item/ammo_box/c45/ap)
	cost = 500

/datum/supply_pack/ammo/c10mmap_ammo_box
	name = "10mm AP Ammo Box Crate"
	desc = "Contains a fifty-round 10mm box loaded with armor piercing ammo."
	contains = list(/obj/item/ammo_box/c10mm/ap)
	cost = 500

/datum/supply_pack/ammo/c9mmhp_ammo_box
	name = "9mm HP Ammo Box Crate"
	desc = "Contains a fifty-round 9mm box loaded with hollow point ammo, great against unarmored targets."
	contains = list(/obj/item/ammo_box/c9mm/hp)
	cost = 500

/datum/supply_pack/ammo/c10mmhp_ammo_box
	name = "10mm HP Ammo Box Crate"
	desc = "Contains a fifty-round 10mm box loaded with hollow point ammo, great against unarmored targets."
	contains = list(/obj/item/ammo_box/c10mm/hp)
	cost = 500
/datum/supply_pack/ammo/c45hp_ammo_box
	name = ".45 HP Ammo Box Crate"
	desc = "Contains a fifty-round 10mm box loaded with hollow point ammo, great against unarmored targets."
	contains = list(/obj/item/ammo_box/c45/hp)
	cost = 500

/datum/supply_pack/ammo/c556mmhitphp_ammo_box
	name = "5.56 Caseless HP Ammo Box Crate"
	desc = "Contains a fifty-round 5.56mm caseless box loaded with hollow point ammo, great against unarmored targets."
	contains = list(/obj/item/ammo_box/c556mmHITP/hp)
	cost = 500

/datum/supply_pack/ammo/c9mmrubber_ammo_box
	name = "9mm Rubber Ammo Box Crate"
	desc = "Contains a fifty-round 9mm box loaded with less-than-lethal rubber rounds."
	contains = list(/obj/item/ammo_box/c9mm/rubbershot)
	cost = 250

/datum/supply_pack/ammo/c10mmrubber_ammo_box
	name = "10mm Rubber Ammo Box Crate"
	desc = "Contains a fifty-round 10mm box loaded with less-than-lethal rubber rounds."
	contains = list(/obj/item/ammo_box/c10mm/rubbershot)
	cost = 250

/datum/supply_pack/ammo/c45mmrubber_ammo_box
	name = ".45 Rubber Ammo Box Crate"
	desc = "Contains a fifty-round .45 box loaded with less-than-lethal rubber rounds."
	contains = list(/obj/item/ammo_box/c45/rubbershot)
	cost = 250


/datum/supply_pack/ammo/c556HITPrubber_ammo_box
	name = "5.56 Caseless Rubber Ammo Box Crate"
	desc = "Contains a fifty-round 5.56 caseless box loaded with less-than-lethal rubber rounds."
	contains = list(/obj/item/ammo_box/c556mmHITP/rubbershot)
	cost = 250

/datum/supply_pack/ammo/guncell
	name = "Weapon Cell Crate"
	desc = "Contains a weapon cell, compatible with laser guns."
	contains = list(/obj/item/stock_parts/cell/gun)
	cost = 500

/datum/supply_pack/ammo/c46x30mm_boxcrate
	name = "4.6x30mm Ammo Box Crate"
	desc = "Contains a fifty-round 4.6x30mm box for PDWs such as the WT-550."
	contains = list(/obj/item/ammo_box/c46x30mm_box)
	cost = 250

/datum/supply_pack/ammo/c8x50mm_boxcrate
	name = "8x50mm Ammo Box Crate"
	desc = "Contains a twenty-round 8x50mm ammo box for rifles such as the Illestren."
	contains = list(/obj/item/ammo_box/c8x50mm_box)
	cost = 250

/datum/supply_pack/ammo/c8x50mm_boxhp_boxcrate
	name = "8x50mm Hollow Point Crate"
	desc = "Contains a twenty-round 8x50mm ammo box loaded with hollow point ammo, great against unarmored targets."
	contains = list(/obj/item/ammo_box/c8x50mmhp_box)
	cost = 500

/datum/supply_pack/ammo/ferropelletboxcrate
	name = "Ferromagnetic Pellet Box Crate"
	desc = "Contains a fifty-round ferromagnetic pellet ammo box for gauss guns such as the Claris."
	contains = list(/obj/item/ammo_box/ferropelletbox)
	cost = 250

/datum/supply_pack/ammo/ferroslugboxcrate
	name = "Ferromagnetic Slug Box Crate"
	desc = "Contains a twenty-round ferromagnetic slug for gauss guns such as the Model-H."
	contains = list(/obj/item/ammo_box/ferroslugbox)
	cost = 250

/datum/supply_pack/ammo/ferrolanceboxcrate
	name = "Ferromagnetic Lance Box Crate"
	desc = "Contains a fifty-round box for high-powered gauss guns such as the GAR assault rifle."
	contains = list(/obj/item/ammo_box/ferrolancebox)
	cost = 250
