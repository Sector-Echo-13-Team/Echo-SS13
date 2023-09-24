/obj/item/pitchfork
	icon_state = "pitchfork0"
	base_icon_state = "pitchfork"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "pitchfork"
	desc = "A simple tool used for moving hay."
	force = 7
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("attacked", "impaled", "pierced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 30)
	resistance_flags = FIRE_PROOF
	var/wielded = FALSE // track wielded status on item

/obj/item/pitchfork/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

/obj/item/pitchfork/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=7, force_wielded=15, icon_wielded="[base_icon_state]1")

/// triggered on wield of two handed item
/obj/item/pitchfork/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/pitchfork/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/pitchfork/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

/obj/item/pitchfork/demonic
	name = "demonic pitchfork"
	desc = "A red pitchfork, it looks like the work of the devil."
	force = 19
	throwforce = 24
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 6
	light_color = COLOR_SOFT_RED


/obj/item/pitchfork/demonic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=19, force_wielded=25)

/obj/item/pitchfork/demonic/greater
	force = 24
	throwforce = 50

/obj/item/pitchfork/demonic/greater/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=24, force_wielded=34)

/obj/item/pitchfork/demonic/ascended
	force = 100
	throwforce = 100

/obj/item/pitchfork/demonic/ascended/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=100, force_wielded=500000) // Kills you DEAD

/obj/item/pitchfork/demonic/pickup(mob/living/user)
	. = ..()
	if(isliving(user) && user.mind && user.owns_soul() && !is_devil(user))
		var/mob/living/U = user
		U.visible_message("<span class='warning'>As [U] picks [src] up, [U]'s arms briefly catch fire.</span>", \
			"<span class='warning'>\"As you pick up [src] your arms ignite, reminding you of all your past sins.\"</span>")
		if(ishuman(U))
			var/mob/living/carbon/human/H = U
			H.apply_damage(rand(force/2, force), BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			U.adjustFireLoss(rand(force/2,force))

/obj/item/pitchfork/demonic/attack(mob/target, mob/living/carbon/human/user)
	if(user.mind && user.owns_soul() && !is_devil(user))
		to_chat(user, "<span class='warning'>[src] burns in your hands.</span>")
		user.apply_damage(rand(force/2, force), BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
	..()

/obj/item/pitchfork/demonic/ascended/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !wielded)
		return
	if(iswallturf(target))
		var/turf/closed/wall/W = target
		user.visible_message("<span class='danger'>[user] blasts \the [target] with \the [src]!</span>")
		playsound(target, 'sound/magic/disintegrate.ogg', 100, TRUE)
		W.dismantle_wall(devastated = FALSE)
		return
