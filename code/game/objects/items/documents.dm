/obj/item/documents
	name = "secret documents"
	desc = "\"Top Secret\" documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	item_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	throw_range = 1
	throw_speed = 1
	layer = MOB_LAYER
	pressure_resistance = 2
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/documents/nanotrasen
	desc = "\"Top Secret\" Nanotrasen documents, filled with complex diagrams and lists of names, dates and coordinates."
	icon_state = "docs_verified"

/obj/item/documents/solgov
	desc = "\"TOP SECRET\"-level memo, listing a number of black company operatives on various space stations and worlds. Some entries have been crossed out, underlined in red, or even redacted entirely with black ink."
	icon_state = "docs_verified"

/obj/item/documents/terragov
	desc = "\"RESTRICTED\"-level state documents listing points in space, all within five light-years of the Bezuts star system. Portions of the document are covered in unintelligible blue annotations."
	icon_state = "docs_verified"

/obj/item/documents/syndicate
	desc = "\"Top Secret\" documents detailing sensitive Syndicate operational intelligence."

/obj/item/documents/syndicate/cybersun
	name = "classified Cybersun documents"
	desc = "\"Top Secret\" documents detailing sensitive Cybersun Virtual Solutions operational intelligence. These documents are verified with a red wax seal."
	icon_state = "docs_red"

/obj/item/documents/syndicate/cybersun/biodynamics
	desc = "\"Top Secret\" Cybersun Biodynamics documents, filled with patient lists and unfinished designs. These documents are verified with a teal wax seal."
	icon_state = "docs_teal"

/obj/item/documents/syndicate/red
	name = "red secret documents"
	desc = "\"Top Secret\" documents detailing sensitive Syndicate operational intelligence. These documents are verified with a red wax seal."
	icon_state = "docs_red"

/obj/item/documents/syndicate/blue
	name = "blue secret documents"
	desc = "\"Top Secret\" documents detailing sensitive Syndicate operational intelligence. These documents are verified with a blue wax seal."
	icon_state = "docs_blue"

/obj/item/documents/syndicate/mining
	desc = "\"Top Secret\" documents detailing Syndicate plasma mining operations."

/obj/item/documents/syndicate/ngr
	name = "Second Battlegroup secret documents"
	desc = "\"Top Secret\" documents belonging to the Second Battlegroup of New Gorlex Republic. They are filled with sensitive operational intelligence. These documents are verified with a red wax seal."
	icon_state = "docs_red"

/obj/item/documents/eoehoma // For use in Eoehoma-related ruins.
	desc = "\"Top Secret\" Eoehoma Firearms documents. Filled with weapon blueprints and eviction notices."
	icon_state = "docs_blue"

/obj/item/documents/frontier
	desc = "\"Top Secret\" Frotiersmen Fleet documents. Filled with operational intelligence for the local area."
	icon_state = "docs_olive"

/obj/item/documents/frontier/logistics
	desc = "\"Top Secret\" Frotiersmen Fleet documents. Filled with intelligence on local Frontiersmen supply lines, supply depot, and logistical infrastructure."

/obj/item/documents/photocopy
	desc = "A copy of some top-secret documents. Nobody will notice they aren't the originals... right?"
	var/forgedseal = 0
	var/copy_type = null

/obj/item/documents/photocopy/New(loc, obj/item/documents/copy = null)
	..()
	if(copy)
		copy_type = copy.type
		if(istype(copy, /obj/item/documents/photocopy)) // Copy Of A Copy Of A Copy
			var/obj/item/documents/photocopy/C = copy
			copy_type = C.copy_type

/obj/item/documents/photocopy/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/toy/crayon/red) || istype(O, /obj/item/toy/crayon/blue))
		if (forgedseal)
			to_chat(user, span_warning("You have already forged a seal on [src]!"))
		else
			var/obj/item/toy/crayon/C = O
			name = "[C.crayon_color] secret documents"
			icon_state = "docs_[C.crayon_color]"
			forgedseal = C.crayon_color
			to_chat(user, span_notice("You forge the official seal with a [C.crayon_color] crayon. No one will notice... right?"))
			update_appearance()
