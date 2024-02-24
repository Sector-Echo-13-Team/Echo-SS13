// Adds wing details to the proc
/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if("wings" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wings"
		dna.species.mutant_bodyparts |= "wingsopen"
		if("wingsdetail" in dna.species.mutant_bodyparts)
			dna.species.mutant_bodyparts -= "wingsdetail"
			dna.species.mutant_bodyparts |= "wingsdetailopen"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if("wingsopen" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wingsopen"
		dna.species.mutant_bodyparts |= "wings"
		if("wingsdetailopen" in dna.species.mutant_bodyparts)
			dna.species.mutant_bodyparts -= "wingsdetailopen"
			dna.species.mutant_bodyparts |= "wingsdetail"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)
