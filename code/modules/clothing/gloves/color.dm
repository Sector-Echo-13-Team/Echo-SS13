/obj/item/clothing/gloves/color
	dying_key = DYE_REGISTRY_GLOVES
	supports_variations = VOX_VARIATION

/obj/item/clothing/gloves/color/yellow
	desc = "These gloves provide protection against electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE
	custom_price = 1200
	custom_premium_price = 1200

/obj/item/toy/sprayoncan
	name = "spray-on insulation applicator"
	desc = "What is the number one problem facing our society today?"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "sprayoncan"

/obj/item/toy/sprayoncan/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		var/mob/living/carbon/U = user
		var/success = C.equip_to_slot_if_possible(new /obj/item/clothing/gloves/color/yellow/sprayon, ITEM_SLOT_GLOVES, TRUE, TRUE)
		if(success)
			if(C == user)
				C.visible_message(span_notice("[U] sprays their hands with glittery rubber!"))
			else
				C.visible_message(span_warning("[U] sprays glittery rubber on the hands of [C]!"))
		else
			C.visible_message(span_warning("The rubber fails to stick to [C]'s hands!"))

		qdel(src)

/obj/item/clothing/gloves/color/yellow/sprayon
	desc = "How're you gonna get 'em off, nerd?"
	name = "spray-on insulated gloves"
	icon_state = "sprayon"
	permeability_coefficient = 0
	resistance_flags = ACID_PROOF
	var/shocks_remaining = 10

/obj/item/clothing/gloves/color/yellow/sprayon/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, PROC_REF(Shocked))

/obj/item/clothing/gloves/color/yellow/sprayon/proc/Shocked()
	shocks_remaining--
	if(shocks_remaining < 0)
		qdel(src) //if we run out of uses, the gloves crumble away into nothing, just like my dreams after working with .dm

/obj/item/clothing/gloves/color/yellow/sprayon/dropped()
	.=..()
	qdel(src) //loose nodrop items bad

/obj/item/clothing/gloves/color/yellow/sprayon/tape
	name = "taped-on insulated gloves"
	desc = "This is a totally safe idea."
	icon_state = "yellowtape"
	mob_overlay_state = "sprayon"
	shocks_remaining = 3

/obj/item/clothing/gloves/color/yellow/sprayon/tape/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/tape/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, PROC_REF(Shocked))

/obj/item/clothing/gloves/color/yellow/sprayon/tape/Shocked(mob/user)
	if(prob(50)) //Fear the unpredictable
		shocks_remaining--
	if(shocks_remaining <= 0)
		playsound(user, 'sound/items/poster_ripped.ogg', 30)
		to_chat(user, span_danger("\The [src] fall apart into useless scraps!"))
		qdel(src)


/obj/item/clothing/gloves/color/fyellow
	desc = "These gloves are cheap knockoffs of the coveted ones - no way this can end badly."
	name = "budget insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 1	//Set to a default of 1, gets overridden in Initialize()
	permeability_coefficient = 0.05
	resistance_flags = NONE

/obj/item/clothing/gloves/color/fyellow/Initialize()
	. = ..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/old
	desc = "Old and worn out insulated gloves, hopefully they still work."
	name = "worn out insulated gloves"

/obj/item/clothing/gloves/color/fyellow/old/Initialize()
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/color/black
	desc = "These gloves are fire-resistant."
	name = "black gloves"
	icon_state = "black"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	var/can_be_cut = TRUE

/obj/item/clothing/gloves/color/black/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		if(can_be_cut && icon_state == initial(icon_state))//only if not dyed
			to_chat(user, span_notice("You snip the fingertips off of [src]."))
			I.play_tool_sound(src)
			new /obj/item/clothing/gloves/fingerless(drop_location())
			qdel(src)
	..()

/obj/item/clothing/gloves/color/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"

/obj/item/clothing/gloves/color/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"

/obj/item/clothing/gloves/color/red/insulated
	name = "insulated gloves"
	desc = "These gloves provide protection against electric shock."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE

/obj/item/clothing/gloves/color/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"

/obj/item/clothing/gloves/color/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"

/obj/item/clothing/gloves/color/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"

/obj/item/clothing/gloves/color/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"

/obj/item/clothing/gloves/color/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"

/obj/item/clothing/gloves/color/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"

/obj/item/clothing/gloves/color/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"

/obj/item/clothing/gloves/color/captain
	desc = "Regal white gloves, with a nice gold trim, an integrated thermal barrier, and armoured bracers. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 50)

/obj/item/clothing/gloves/color/captain/nt
	desc = "Regal blue gloves with gold trim and a fire and acid-resistant coating. Swanky."
	name = "captain's gloves"
	icon_state = "captainnt"

/obj/item/clothing/gloves/color/latex
	name = "latex gloves"
	desc = "Cheap sterile gloves made from latex. Transfers minor paramedic knowledge to the user via budget nanochips."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.3
	permeability_coefficient = 0.01
	transfer_prints = TRUE
	resistance_flags = NONE
	var/carrytrait = TRAIT_QUICK_CARRY

/obj/item/clothing/gloves/color/latex/equipped(mob/user, slot)
	..()
	if(slot == ITEM_SLOT_GLOVES)
		ADD_TRAIT(user, carrytrait, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/latex/dropped(mob/user)
	..()
	REMOVE_TRAIT(user, carrytrait, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/latex/nitrile
	name = "nitrile gloves"
	desc = "Pricy sterile gloves that are thicker than latex. Transfers intimate paramedic knowledge into the user via nanochips."
	icon_state = "nitrile"
	transfer_prints = FALSE
	carrytrait = TRAIT_QUICKER_CARRY
	//supports_variations = KEPORI_VARIATION

/obj/item/clothing/gloves/color/latex/nitrile/evil
	name = "red nitrile gloves"
	desc = "Thick sterile gloves that reach up to the elbows, in exactly the same color as fresh blood. Transfers combat medic knowledge into the user via nanochips."
	icon_state = "nitrile_evil"

/obj/item/clothing/gloves/color/latex/nitrile/infiltrator
	name = "infiltrator gloves"
	desc = "Specialized combat gloves for carrying people around. Transfers tactical kidnapping knowledge into the user via nanochips."
	icon_state = "infiltrator"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.3
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/gloves/color/latex/nitrile/inteq
	name = "green nitrile gloves"
	desc = "Thick sterile gloves that reach up to the elbows, colored in a pine green shade. Transfers combat medic knowledge into the user via nanochips."
	icon_state = "nitrile_inteq"

/obj/item/clothing/gloves/color/latex/engineering
	name = "tinker's gloves"
	desc = "Overdesigned engineering gloves that have automated construction subrutines dialed in, allowing for faster construction while worn."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_gauntlets"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	carrytrait = TRAIT_QUICK_BUILD
	custom_materials = list(/datum/material/iron=2000, /datum/material/silver=1500, /datum/material/gold = 1000)

/obj/item/clothing/gloves/color/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "white"
	item_state = "lgloves"
	custom_price = 200

/obj/item/clothing/gloves/color/evening
	name = "evening gloves"
	desc = "White satin gloves that rise up to the elbows. Excessively fancy."
	icon_state = "evening_gloves"
	item_state = "lgloves"
	custom_price = 200

/obj/item/clothing/gloves/maid
	name = "maid arm covers"
	desc = "Cylindrical looking tubes that go over your arm, weird."
	icon_state = "maid_arms"
	item_state = "lgloves"
	supports_variations = VOX_VARIATION
