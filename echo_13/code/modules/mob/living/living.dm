/mob/living/carbon/human/makeTrail(turf/T)
	if((NOBLOOD in dna.species.species_traits) || (NOTRAIL in dna.species.species_traits) || !bleed_rate || bleedsuppress)
		return
	..()
