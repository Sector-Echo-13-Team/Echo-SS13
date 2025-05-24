/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "m_mask"
	body_parts_covered = 0
	clothing_flags = ALLOWINTERNALS //WS Port - Cit Internals
	visor_flags = ALLOWINTERNALS
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.1
	permeability_coefficient = 0.5
	actions_types = list(/datum/action/item_action/adjust)
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	resistance_flags = NONE

	equip_sound = 'sound/items/equip/straps_equip.ogg'
	equipping_sound = EQUIP_SOUND_VFAST_GENERIC
	unequipping_sound = UNEQUIP_SOUND_VFAST_GENERIC
	equip_delay_self = EQUIP_DELAY_MASK
	equip_delay_other = EQUIP_DELAY_MASK * 1.5
	strip_delay = EQUIP_DELAY_MASK * 1.5
	equip_self_flags = EQUIP_ALLOW_MOVEMENT | EQUIP_SLOWDOWN

/obj/item/clothing/mask/breath/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/breath/AltClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	else
		adjustmask(user)

/obj/item/clothing/mask/breath/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click [src] to adjust it.")

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "m_mask"
	permeability_coefficient = 0.01
	equip_delay_other = 10

/obj/item/clothing/mask/balaclava/inteq //inteq needs a faction clothing file badly but it's out of scope for this PR -apogee
	name = "IRMG combat balaclava"
	desc = "A surprisingly advanced balaclava. While it doesn't muffle your voice, it has a mouthpiece for internals. Comfy to boot! This one is a variataion commonly used by the IRMG to protect it's members idenites."
	icon_state = "inteq_balaclava"
	item_state = "inteq_balaclava"
