// Echo 13 - Account for vampires
/mob/living/carbon/get_blood_dna_list()
	if(ispath(get_blood_id(), /datum/reagent/blood))
		return
	var/list/blood_dna = list()
	if(dna)
		blood_dna[dna.unique_enzymes] = dna.blood_type
	else
		blood_dna["UNKNOWN DNA"] = "X*"
	return blood_dna
