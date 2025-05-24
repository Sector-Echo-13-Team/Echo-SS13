#define GUNPOINT_SHOOTER_STRAY_RANGE 2
#define GUNPOINT_DELAY_STAGE_2 25
#define GUNPOINT_DELAY_STAGE_3 75 // cumulative with past stages, so 100 deciseconds
#define GUNPOINT_MULT_STAGE_1 1
#define GUNPOINT_MULT_STAGE_2 2
#define GUNPOINT_MULT_STAGE_3 2.5


/datum/component/gunpoint
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/target
	var/obj/item/gun/weapon

	var/stage = 1
	var/damage_mult = GUNPOINT_MULT_STAGE_1

	var/point_of_no_return = FALSE

// *extremely bad russian accent* no!
/datum/component/gunpoint/Initialize(mob/living/targ, obj/item/gun/wep)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/shooter = parent
	target = targ
	weapon = wep
	RegisterSignal(targ, list(COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_ITEM_ATTACK, COMSIG_MOVABLE_MOVED, COMSIG_MOB_FIRED_GUN), PROC_REF(trigger_reaction))

	RegisterSignal(weapon, list(COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED), PROC_REF(cancel))

	shooter.visible_message(span_danger("[shooter] aims [weapon] point blank at [target]!"), \
		span_danger("You aim [weapon] point blank at [target]!"), target)
	to_chat(target, span_userdanger("[shooter] aims [weapon] point blank at you!"))

	shooter.apply_status_effect(STATUS_EFFECT_HOLDUP)
	target.apply_status_effect(STATUS_EFFECT_HELDUP)

	if(target.job == "Captain" && target.stat == CONSCIOUS && is_nuclear_operative(shooter))
		if(istype(weapon, /obj/item/gun/ballistic/rocketlauncher) && weapon.chambered)
			shooter.client.give_award(/datum/award/achievement/misc/rocket_holdup, shooter)

	target.do_alert_animation()
	target.playsound_local(target.loc, 'sound/machines/chime.ogg', 50, TRUE)
	SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "gunpoint", /datum/mood_event/gunpoint)

	addtimer(CALLBACK(src, PROC_REF(update_stage), 2), GUNPOINT_DELAY_STAGE_2)

/datum/component/gunpoint/Destroy(force)
	var/mob/living/shooter = parent
	shooter.remove_status_effect(STATUS_EFFECT_HOLDUP)
	target.remove_status_effect(STATUS_EFFECT_HELDUP)
	return ..()

/datum/component/gunpoint/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_deescalate))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(flinch))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(check_shove))
	RegisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP), PROC_REF(check_bump))

/datum/component/gunpoint/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_HAND)
	UnregisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP))

/datum/component/gunpoint/proc/check_bump(atom/B, atom/A)
	SIGNAL_HANDLER

	var/mob/living/T = A
	if(T && T == target)
		var/mob/living/shooter = parent
		shooter.visible_message(span_danger("[shooter] bumps into [target] and fumbles [shooter.p_their()] aim!"), \
			span_danger("You bump into [target] and fumble your aim!"), target)
		to_chat(target, span_userdanger("[shooter] bumps into you and fumbles [shooter.p_their()] aim!"))
		qdel(src)

/datum/component/gunpoint/proc/check_shove(mob/living/carbon/shooter, mob/shooter_again, mob/living/T)
	SIGNAL_HANDLER

	if(T == target && (shooter.a_intent == INTENT_DISARM || shooter.a_intent == INTENT_GRAB))
		shooter.visible_message(span_danger("[shooter] bumps into [target] and fumbles [shooter.p_their()] aim!"), \
			span_danger("You bump into [target] and fumble your aim!"), target)
		to_chat(target, span_userdanger("[shooter] bumps into you and fumbles [shooter.p_their()] aim!"))
		qdel(src)

// if you're gonna try to break away from a holdup, better to do it right away
/datum/component/gunpoint/proc/update_stage(new_stage)
	stage = new_stage
	if(stage == 2)
		to_chat(parent, span_danger("You steady [weapon] on [target]."))
		to_chat(target, span_userdanger("[parent] has steadied [weapon] on you!"))
		damage_mult = GUNPOINT_MULT_STAGE_2
		addtimer(CALLBACK(src, PROC_REF(update_stage), 3), GUNPOINT_DELAY_STAGE_3)
	else if(stage == 3)
		to_chat(parent, span_danger("You have fully steadied [weapon] on [target]."))
		to_chat(target, span_userdanger("[parent] has fully steadied [weapon] on you!"))
		damage_mult = GUNPOINT_MULT_STAGE_3

/datum/component/gunpoint/proc/check_deescalate()
	SIGNAL_HANDLER

	if(!can_see(parent, target, GUNPOINT_SHOOTER_STRAY_RANGE - 1))
		cancel()

/datum/component/gunpoint/proc/trigger_reaction()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(async_trigger_reaction))

/datum/component/gunpoint/proc/async_trigger_reaction()

	SEND_SIGNAL(target, COMSIG_CLEAR_MOOD_EVENT, "gunpoint")
	if(point_of_no_return)
		return
	point_of_no_return = TRUE

	var/mob/living/shooter = parent

	if(!weapon.can_shoot() || !weapon.can_trigger_gun(shooter) || (weapon.weapon_weight == WEAPON_HEAVY && shooter.get_inactive_held_item()))
		shooter.visible_message(span_danger("[shooter] fumbles [weapon]!"), \
			span_danger("You fumble [weapon] and fail to fire at [target]!"), target)
		to_chat(target, span_userdanger("[shooter] fumbles [weapon] and fails to fire at you!"))
		qdel(src)
		return

	if(weapon.chambered && weapon.chambered.BB)
		weapon.chambered.BB.damage *= damage_mult

	weapon.pre_fire(target, shooter)
	qdel(src)

/datum/component/gunpoint/proc/cancel()
	SIGNAL_HANDLER

	var/mob/living/shooter = parent
	shooter.visible_message(span_danger("[shooter] breaks [shooter.p_their()] aim on [target]!"), \
		span_danger("You are no longer aiming [weapon] at [target]."), target)
	to_chat(target, span_userdanger("[shooter] breaks [shooter.p_their()] aim on you!"))
	SEND_SIGNAL(target, COMSIG_CLEAR_MOOD_EVENT, "gunpoint")
	qdel(src)

/datum/component/gunpoint/proc/flinch(attacker, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	var/mob/living/shooter = parent

	var/flinch_chance = 50
	var/gun_hand = LEFT_HANDS

	if(shooter.held_items[RIGHT_HANDS] == weapon)
		gun_hand = RIGHT_HANDS

	if((def_zone == BODY_ZONE_L_ARM && gun_hand == LEFT_HANDS) || (def_zone == BODY_ZONE_R_ARM && gun_hand == RIGHT_HANDS))
		flinch_chance = 80

	if(prob(flinch_chance))
		shooter.visible_message(span_danger("[shooter] flinches!"), \
			span_danger("You flinch!"))
		trigger_reaction()

#undef GUNPOINT_SHOOTER_STRAY_RANGE
#undef GUNPOINT_DELAY_STAGE_2
#undef GUNPOINT_DELAY_STAGE_3
#undef GUNPOINT_MULT_STAGE_1
#undef GUNPOINT_MULT_STAGE_2
#undef GUNPOINT_MULT_STAGE_3
