/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_ID
	component_type = /datum/component/storage/concrete/wallet

	var/obj/item/card/id/front_id = null
	var/list/combined_access
	var/cached_flat_icon

/obj/item/storage/wallet/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage/concrete/wallet)
	STR.max_items = 4
	STR.set_holdable(list(
		/obj/item/spacecash/bundle,
		/obj/item/holochip,
		/obj/item/card,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/lighter,
		/obj/item/key/ship,
		/obj/item/gun/ballistic/derringer,
		/obj/item/lipstick,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/stamp))

/obj/item/storage/wallet/Exited(atom/movable/AM)
	. = ..()
	UnregisterSignal(AM, COSMIG_ACCESS_UPDATED)
	refresh_id()

/obj/item/storage/wallet/proc/refresh_id()
	LAZYCLEARLIST(combined_access)
	if(!(front_id in src))
		front_id = null
	for(var/obj/item/card/id/I in contents)
		if(!front_id)
			front_id = I
		LAZYOR(combined_access, I.access)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wear_id == src)
			H.sec_hud_set_ID()
	update_appearance()
	update_label()

/obj/item/storage/wallet/Entered(atom/movable/AM)
	. = ..()
	RegisterSignal(AM, COSMIG_ACCESS_UPDATED, PROC_REF(refresh_id))
	refresh_id()

/obj/item/storage/wallet/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_overlay")

/obj/item/storage/wallet/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
	return cached_flat_icon

/obj/item/storage/wallet/get_examine_string(mob/user, thats = FALSE)
	if(front_id)
		return "[icon2html(get_cached_flat_icon(), user)] [thats? "That's ":""][get_examine_name(user)]" //displays all overlays in chat
	return ..()

/obj/item/storage/wallet/proc/update_label()
	if(front_id)
		name = "wallet displaying [front_id]"
	else
		name = "wallet"

/obj/item/storage/wallet/examine()
	. = ..()
	if(front_id)
		. += span_notice("Alt-click to remove the id.")

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/RemoveID()
	if(!front_id)
		return
	. = front_id
	front_id.forceMove(get_turf(src))

/obj/item/storage/wallet/InsertID(obj/item/inserting_item)
	var/obj/item/card/inserting_id = inserting_item.RemoveID()
	if(!inserting_id)
		return FALSE
	attackby(inserting_id)
	if(inserting_id in contents)
		return TRUE
	return FALSE

/obj/item/storage/wallet/GetAccess()
	if(LAZYLEN(combined_access))
		return combined_access
	else
		return ..()

/obj/item/storage/wallet/GetBankCard()
	for(var/obj/item/card/I in contents)
		if(istype(I, /obj/item/card/bank))
			return I

/obj/item/storage/wallet/random
	icon_state = "random_wallet"

/obj/item/storage/wallet/random/PopulateContents()
	new /obj/effect/spawner/random/entertainment/wallet_storage(src)
	icon_state = "wallet"
