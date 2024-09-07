// Echo 13 - Remove Prescription hud thing
/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/glasses_type = /obj/item/clothing/glasses/regular
	glasses = new glasses_type(get_turf(quirk_holder))
	var/list/slots = list(
		"on your face, silly!" = ITEM_SLOT_EYES,
		"in your left pocket." = ITEM_SLOT_LPOCKET,
		"in your right pocket." = ITEM_SLOT_RPOCKET,
		"in your backpack." = ITEM_SLOT_BACKPACK,
		"in your hands." = ITEM_SLOT_HANDS
	)
	where = H.equip_in_one_of_slots(glasses, slots, FALSE) || "at your feet, don't drop them next time!"
