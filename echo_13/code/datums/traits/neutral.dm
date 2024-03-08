/datum/quirk/vampire
	name = "Vampirism"
	desc = "You're a bloodsucking vampire, able to suck the blood of others, heal in coffins, transfer to them your own, and you're undead, do be careful not to run out of blood or give others too much of your own, lest peril come. <b>This is not a license to grief.</b>"
	value = 0
	gain_text = "<span class='notice'>Your blood is accursed, feed on others lest you become dry and fall apart, however your blood is also helpful to others which are not vampires, and you may gift them, careful for them not to become like you.</span>"
	lose_text = "<span class='notice'>You feel blessed, your blood no longer cursed.</span>"
	medical_record_text = "Patient is a vampire."
	mob_traits = list(TRAIT_NOBREATH, TRAIT_NOHUNGER)
	var/old_blood
	var/obj/item/organ/heart/old_heart
	var/datum/action/vampire_quirk_drain/vampire_drain
	var/datum/action/vampire_quirk_transfer/vampire_transfer
	var/list/old_traits
	var/list/old_biotypes
	var/list/species_traits = list(NOHEART, DRINKSBLOOD)

/datum/quirk/vampire/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/heart/current_heart = H.getorganslot(ORGAN_SLOT_HEART)
	old_heart = current_heart.type
	vampire_drain = new
	vampire_transfer = new
	vampire_drain.Grant(H)
	vampire_transfer.Grant(H)
	old_blood = H.dna.blood_type
	H.dna.species.exotic_blood = /datum/reagent/blood/true_draculine
	H.dna.blood_type = get_blood_type("Draculine")
	H.dna.species.species_traits |= species_traits
	H.dna.species.inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	RegisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))

/datum/quirk/vampire/post_add()
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Please note that your vampirism does NOT give you the right to attack people or otherwise cause any interference to \
	the round without reason or escalation. You are not an antagonist, and the rules will treat you the same as other crewmembers.</span>")

/datum/quirk/vampire/remove()
	if(quirk_holder)
		var/mob/living/carbon/human/H = quirk_holder
		if(vampire_drain)
			vampire_drain.Remove(H)
		if(vampire_transfer)
			vampire_transfer.Remove(H)
		H.dna.species.exotic_blood = ""
		H.dna.blood_type = old_blood
		if(!H.getorganslot(ORGAN_SLOT_HEART))
			old_heart = new
			old_heart.Insert(H)
		H.dna.species.species_traits ^= species_traits
		H.dna.species.inherent_biotypes = old_biotypes
	UnregisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS)

/datum/quirk/vampire/on_process()
	var/mob/living/carbon/human/C = quirk_holder
	if(istype(C.loc, /obj/structure/closet/crate/coffin))
		C.heal_overall_damage(2,2,0, BODYPART_ORGANIC)
		C.adjustToxLoss(-2)
		C.adjustOxyLoss(-2)
		C.adjustCloneLoss(-2)
		return
	if(!C.client) //Can't blame no one for no disconnects
		return
	C.blood_volume -= max(C.blood_volume/3500, 0.07)
	if(C.blood_volume <= BLOOD_VOLUME_BAD)
		if(prob(5) && C.blood_volume > BLOOD_VOLUME_SURVIVE)
			to_chat(C, "<span class='danger'>You're running out of blood!</span>")
	if(C.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(C, "<span class='danger'>You ran out of blood!</span>")
		C.death()
		C.Drain()

#define VAMP_DRAIN_AMOUNT 20

/datum/action/vampire_quirk_drain
	name = "Drain Victim"
	desc = "Leech blood from any compatible victim you are passively grabbing."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/effects/bleed.dmi'
	button_icon_state = "bleed1"

/datum/action/vampire_quirk_drain/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		if(H.quirk_cooldown["Vampire"] >= world.time)
			return
		while(H.pulling && iscarbon(H.pulling) && H.grab_state == GRAB_PASSIVE)
			var/mob/living/carbon/victim = H.pulling
			if(H.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				to_chat(H, "<span class='warning'>You're already full!</span>")
				break
			if(victim.stat == DEAD)
				to_chat(H, "<span class='warning'>You need a living victim!</span>")
				break
			if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || !(victim.dna.blood_type.type in H.dna.blood_type.compatible_types))))
				to_chat(H, "<span class='warning'>[victim] doesn't have suitable blood!</span>")
				break
			H.quirk_cooldown["Vampire"] = world.time + 30
			if(victim.anti_magic_check(FALSE, TRUE, FALSE, 0))
				to_chat(victim, "<span class='warning'>[H] tries to bite you, but stops before touching you!</span>")
				to_chat(H, "<span class='warning'>[victim] is blessed! You stop just in time to avoid catching fire.</span>")
				break
			if(victim?.reagents?.has_reagent(/datum/reagent/consumable/garlic))
				to_chat(victim, "<span class='warning'>[H] tries to bite you, but recoils in disgust!</span>")
				to_chat(H, "<span class='warning'>[victim] reeks of garlic! you can't bring yourself to drain such tainted blood.</span>")
				break
			if(!do_after(H, 30, target = victim))
				break
			var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - H.blood_volume //How much capacity we have left to absorb blood
			var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)
			to_chat(victim, "<span class='danger'>[H] is draining your blood!</span>")
			to_chat(H, "<span class='notice'>You drain some blood!</span>")
			playsound(H, 'sound/items/drink.ogg', 30, TRUE, -2)
			victim.blood_volume = clamp(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			H.blood_volume = clamp(H.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			if(!victim.blood_volume)
				to_chat(H, "<span class='notice'>You finish off [victim]'s blood supply.</span>")

#undef VAMP_DRAIN_AMOUNT

#define VAMP_TRANSFER_AMOUNT 5

/datum/action/vampire_quirk_transfer
	name = "Blood Transfer"
	desc = "Transfer your own tainted blood to one from which you could feed."
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/effects/bleed.dmi'
	button_icon_state = "bleed9"

/datum/action/vampire_quirk_transfer/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		if(H.quirk_cooldown["Vampire Transfer"] >= world.time)
			return
		if(H.pulling && iscarbon(H.pulling) && H.grab_state == GRAB_PASSIVE)
			var/mob/living/carbon/victim = H.pulling
			if(victim.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				to_chat(H, "<span class='warning'>They're already full!</span>")
				return
			if(victim.stat == DEAD)
				to_chat(H, "<span class='warning'>You need to transfer blood to a living being!</span>")
				return
			if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || !(victim.dna.blood_type.type in H.dna.blood_type.compatible_types))))
				to_chat(H, "<span class='warning'>[victim] doesn't have suitable blood!</span>")
				return
			H.quirk_cooldown["Vampire Transfer"] = world.time + 20
			if(victim.anti_magic_check(FALSE, TRUE, FALSE, 0))
				to_chat(victim, "<span class='warning'>[H] tries to twist you, but stops before touching you!</span>")
				to_chat(H, "<span class='warning'>[victim] is blessed! You stop just in time to avoid catching fire.</span>")
				return
			if(victim?.reagents?.has_reagent(/datum/reagent/consumable/garlic))
				to_chat(victim, "<span class='warning'>[H] tries to twist you, but recoils in disgust!</span>")
				to_chat(H, "<span class='warning'>[victim] reeks of garlic! you can't bring yourself to twist such tainted blood.</span>")
				return
			if(!do_after(H, 20, target = victim))
				return
			var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - victim.blood_volume //How much capacity we have left to transfer blood
			var/transfered_blood = min(H.blood_volume, VAMP_TRANSFER_AMOUNT, blood_volume_difference)
			to_chat(victim, "<span class='danger'>You feel darkness leaving[H] and entering you!</span>")
			to_chat(H, "<span class='notice'>You transfer blood to [victim]!</span>")
			playsound(H, 'sound/items/drink.ogg', 30, TRUE, -2)
			H.blood_volume = clamp(H.blood_volume - transfered_blood, 0, BLOOD_VOLUME_MAXIMUM)
			var/blood_id = H.get_blood_id()
			var/list/blood_data = H.get_blood_data(blood_id)
			victim.reagents.add_reagent(blood_id, transfered_blood, blood_data, H.bodytemperature)

#undef VAMP_TRANSFER_AMOUNT


/datum/quirk/vampire/proc/get_status_tab_item(mob/living/carbon/source, list/items)
	SIGNAL_HANDLER
	items += "Blood Level: [source.blood_volume]/[BLOOD_VOLUME_MAXIMUM]"
