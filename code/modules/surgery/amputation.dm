
/datum/surgery/amputation
	name = "Amputation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/sever_limb)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
	requires_bodypart_type = 0


/datum/surgery_step/sever_limb
	name = "sever limb"
	implements = list(//this is fine, detaching limbs doesn't require precision - this is only more precise because zone targeting is randomized
		/obj/item/shears = 300,
		TOOL_SCALPEL = 100,
		TOOL_SAW = 100,
		/obj/item/melee/arm_blade = 80,
		/obj/item/melee/axe/fire = 50,
		/obj/item/hatchet = 40,
		/obj/item/melee/knife/butcher = 25)
	time = 6.4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	time = 64
	experience_given = MEDICAL_SKILL_ORGAN_FIX

/datum/surgery_step/sever_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to sever [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"))

/datum/surgery_step/sever_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/L = target
	display_results(user, target, span_notice("You sever [L]'s [parse_zone(target_zone)]."),
		span_notice("[user] severs [L]'s [parse_zone(target_zone)]!"),
		span_notice("[user] severs [L]'s [parse_zone(target_zone)]!"))
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
	if(user.mind)
		user.mind.adjust_experience(/datum/skill/healing, experience_given)
	return ..()
