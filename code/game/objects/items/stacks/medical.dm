/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stack_objects.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	var/splint_fracture = FALSE //WS Edit- Splints
	var/failure_chance //WS Edit - Failure chance
	var/self_delay = 50
	var/other_delay = 0
	var/repeating = FALSE
	var/experience_given = 1
	///Sound/Sounds to play when this is applied
	var/apply_sounds

/obj/item/stack/medical/attack(mob/living/target, mob/user)
	. = ..()
	try_heal(target, user)


/obj/item/stack/medical/proc/try_heal(mob/living/target, mob/user, silent = FALSE)
	if(!target.can_inject(user, TRUE))
		return
	if(target == user)
		playsound(src, islist(apply_sounds) ? pick(apply_sounds) : apply_sounds, 25)
		if(!do_mob(user, target, self_delay, extra_checks=CALLBACK(target, /mob/living/proc/can_inject, user, TRUE)))
			return
		if(!silent)
			user.visible_message("<span class='notice'>[user] starts to apply \the [src] on [user.p_them()]self...</span>", "<span class='notice'>You begin applying \the [src] on yourself...</span>")

	else if(other_delay)
		playsound(src, islist(apply_sounds) ? pick(apply_sounds) : apply_sounds, 25)
		if(!do_mob(user, target, other_delay, extra_checks=CALLBACK(target, /mob/living/proc/can_inject, user, TRUE)))
			return
		if(!silent)
			user.visible_message("<span class='notice'>[user] starts to apply \the [src] on [target].</span>", "<span class='notice'>You begin applying \the [src] on [target]...</span>")


	if(heal(target, user))
		playsound(src, islist(apply_sounds) ? pick(apply_sounds) : apply_sounds, 25)
		user?.mind.adjust_experience(/datum/skill/healing, experience_given)
		log_combat(user, target, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(target, user, TRUE)

/obj/item/stack/medical/proc/heal(mob/living/target, mob/user)
	return

/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, "<span class='warning'>[C] doesn't have \a [parse_zone(user.zone_selected)]!</span>")
		return
	if(!IS_ORGANIC_LIMB(affecting)) //Limb must be organic to be healed - RR
		to_chat(user, "<span class='warning'>\The [src] won't work on a robotic limb!</span>")
		return

	//WS begin - failure chance
	if(prob(failure_chance))
		user.visible_message("<span class='warning'>[user] tries to apply \the [src] on [C]'s [affecting.name], but fails!</span>", "<span class='warning'>You try to apply \the [src] on  on [C]'s [affecting.name], but fail!")
		return
	//WS end

	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message("<span class='green'>[user] applies \the [src] on [C]'s [affecting.name].</span>", "<span class='green'>You apply \the [src] on [C]'s [affecting.name].</span>")
		var/brute2heal = brute
		var/burn2heal = burn
		var/skill_mod = user?.mind?.get_skill_modifier(/datum/skill/healing, SKILL_SPEED_MODIFIER)
		if(skill_mod)
			brute2heal *= (2-skill_mod)
			burn2heal *= (2-skill_mod)
		if(affecting.heal_damage(brute2heal, burn2heal))
			C.update_damage_overlays()
		return TRUE


	//WS Begin - Splints
	if(splint_fracture) //Check if it's a splint and the bone is broken
		if(affecting.body_part in list(CHEST, HEAD)) // Check if it isn't the head or chest
			to_chat(user, "<span class='warning'>You can't splint that bodypart!</span>")
			return
		else if(affecting.bone_status == BONE_FLAG_SPLINTED) // Check if it isn't already splinted
			to_chat(user, "<span class='warning'>[C]'s [affecting.name] is already splinted!</span>")
			return
		else if(!(affecting.bone_status == BONE_FLAG_BROKEN)) // Check if it's actually broken
			to_chat(user, "<span class='warning'>[C]'s [affecting.name] isn't broken!</span>")
			return
		affecting.bone_status = BONE_FLAG_SPLINTED
		// C.update_inv_splints() something breaks
		user.visible_message("<span class='green'>[user] applies [src] on [C].</span>", "<span class='green'>You apply [src] on [C]'s [affecting.name].</span>")
		return TRUE
	//WS End


	to_chat(user, "<span class='warning'>[C]'s [affecting.name] can not be healed with \the [src]!</span>")


/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A therapeutic gel pack and bandages designed to treat blunt-force trauma."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	var/heal_brute = 40
	self_delay = 20
	grind_results = list(/datum/reagent/medicine/styptic_powder = 10)

/obj/item/stack/medical/bruise_pack/heal(mob/living/target, mob/user)
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(isanimal(target))
		var/mob/living/simple_animal/critter = target
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>You cannot use \the [src] on [target]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[target] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies \the [src] on [target].</span>", "<span class='green'>You apply \the [src] on [target].</span>")
		target.heal_bodypart_damage((heal_brute/2))
		return TRUE
	if(iscarbon(target))
		return heal_carbon(target, user, heal_brute, 0)
	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")

/obj/item/stack/medical/gauze
	name = "medical gauze"
	desc = "A roll of elastic cloth that is extremely effective at stopping bleeding, but does not heal wounds."
	gender = PLURAL
	singular_name = "medical gauze"
	icon_state = "gauze"
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	var/stop_bleeding = 1800
	self_delay = 20
	max_amount = 12
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = 100

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/heal(mob/living/target, mob/user)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.bleedsuppress && H.bleed_rate) //so you can't stack bleed suppression
			H.suppress_bloodloss(stop_bleeding)
			to_chat(user, "<span class='notice'>You stop the bleeding of [target]!</span>")
			return TRUE
	to_chat(user, "<span class='warning'>You can not use \the [src] on [target]!</span>")

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two gauzes to do this!</span>")
			return
		new /obj/item/stack/sheet/cotton/cloth(user.drop_location())
		user.visible_message(
			"<span class='notice'>[user] cuts [src] into pieces of cloth with [I].</span>",
			"<span class='notice'>You cut [src] into pieces of cloth with [I].</span>",
			"<span class='hear'>You hear cutting.</span>"
		)
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/improvised
	name = "improvised gauze"
	singular_name = "improvised gauze"
	desc = "A roll of cloth roughly cut from something that can stop bleeding, but does not heal wounds."
	stop_bleeding = 900

/obj/item/stack/medical/gauze/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 250

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burn wounds."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = 'sound/effects/ointment.ogg'
	var/heal_burn = 40
	self_delay = 20
	grind_results = list(/datum/reagent/medicine/silver_sulfadiazine = 10)

/obj/item/stack/medical/ointment/heal(mob/living/target, mob/user)
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(iscarbon(target))
		return heal_carbon(target, user, 0, heal_burn)
	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")

/obj/item/stack/medical/suture
	name = "suture"
	desc = "Sterile sutures used to seal up cuts and lacerations."
	gender = PLURAL
	singular_name = "suture"
	icon_state = "suture"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	repeating = TRUE
	var/heal_brute = 10
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)

/obj/item/stack/medical/suture/medicated
	name = "medicated suture"
	icon_state = "suture_purp"
	desc = "A suture infused with drugs that speed up wound healing of the treated laceration."
	heal_brute = 15
	grind_results = list(/datum/reagent/medicine/polypyr = 2)

/obj/item/stack/medical/suture/heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(iscarbon(target))
		return heal_carbon(target, user, heal_brute, 0)
	if(isanimal(target))
		var/mob/living/simple_animal/critter = target
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>You cannot use \the [src] on [target]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[target] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies \the [src] on [target].</span>", "<span class='green'>You apply \the [src] on [target].</span>")
		target.heal_bodypart_damage(heal_brute)
		return TRUE

	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")

/obj/item/stack/medical/mesh
	name = "regenerative mesh"
	desc = "A bacteriostatic mesh used to dress burns."
	gender = PLURAL
	singular_name = "regenerative mesh"
	icon_state = "regen_mesh"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	repeating = TRUE
	var/heal_burn = 10
	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)

/obj/item/stack/medical/mesh/Initialize()
	. = ..()
	if(amount == max_amount)	 //only seal full mesh packs
		is_open = FALSE
		update_appearance()

/obj/item/stack/medical/mesh/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "regen_mesh_closed"

/obj/item/stack/medical/mesh/heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(iscarbon(target))
		return heal_carbon(target, user, 0, heal_burn)
	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")


/obj/item/stack/medical/mesh/try_heal(mob/living/target, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user)
	if(!is_open && user.get_inactive_held_item() == src)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, "<span class='notice'>You open the sterile mesh package.</span>")
		update_appearance()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	. = ..()

/obj/item/stack/medical/mesh/advanced
	name = "advanced regenerative mesh"
	desc = "An advanced mesh made with aloe extracts and sterilizing chemicals, used to treat burns."

	gender = PLURAL
	singular_name = "advanced regenerative mesh"
	icon_state = "aloe_mesh"
	heal_burn = 15
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "aloe_mesh_closed"

/obj/item/stack/medical/aloe
	name = "aloe cream"
	desc = "A healing paste you can apply on wounds."

	icon_state = "aloe_paste"
	apply_sounds = 'sound/effects/ointment.ogg'
	self_delay = 20
	other_delay = 10
	novariants = TRUE
	amount = 20
	max_amount = 20
	var/heal = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/aloe/heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return FALSE
	if(iscarbon(target))
		return heal_carbon(target, user, heal, heal)
	if(isanimal(target))
		var/mob/living/simple_animal/critter = target
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>You cannot use \the [src] on [target]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[target] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies \the [src] on [target].</span>", "<span class='green'>You apply \the [src] on [target].</span>")
		target.heal_bodypart_damage(heal, heal)
		return TRUE

	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")


	/*
	The idea is for these medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	*/

// SPLINTS
/obj/item/stack/medical/splint
	amount = 4
	name = "splints"
	desc = "Used to secure limbs following a fracture."
	gender = PLURAL
	singular_name = "splint"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "splint"
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	self_delay = 40
	other_delay = 15
	splint_fracture = TRUE

/obj/item/stack/medical/splint/heal(mob/living/target, mob/user)
	. = ..()
	if(iscarbon(target))
		return heal_carbon(target, user)
	to_chat(user, "<span class='warning'>You can't splint [target]'s limb' with the \the [src]!</span>")

/obj/item/stack/medical/splint/ghetto //slightly shittier, but gets the job done
	name = "makeshift splints"
	desc = "Used to secure limbs following a fracture. This one is made out of simple materials."
	amount = 2
	self_delay = 50
	other_delay = 20
	failure_chance = 20

/obj/item/stack/medical/bruise_pack/herb
	name = "ashen herbal pack"
	singular_name = "ashen herbal pack"
	icon_state = "hbrutepack"
	desc = "Thereputic herbs designed to treat bruises."
	heal_brute = 15

/obj/item/stack/medical/ointment/herb
	name = "burn ointment slurry"
	singular_name = "burn ointment slurry"
	icon_state = "hointment"
	desc = "Herb slurry meant to treat burns."
	heal_burn = 15
