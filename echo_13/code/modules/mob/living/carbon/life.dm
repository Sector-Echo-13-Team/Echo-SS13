// Echo 13 - Vampires
/mob/living/carbon/proc/needs_heart()
	if(HAS_TRAIT(src, TRAIT_STABLEHEART))
		return FALSE
	if(dna && dna.species && (NOBLOOD in dna.species.species_traits) || (NOHEART in dna.species.species_traits)) //not all carbons have species!
		return FALSE
	return TRUE
