//XENO TEAM
/datum/team/xeno
	name = "Aliens"
	/// How many alien queens have already died
	var/queen_deaths = 0
	/// How many alien queens can die before no more can be created
	var/max_queen_deaths = 2

//Simply lists them.
/datum/team/xeno/roundend_report()
	var/list/parts = list()
	parts += span_header("The [name] were:")
	parts += printplayerlist(members)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

//XENO ANTAG
/datum/antagonist/xeno
	name = "Xenomorph"
	job_rank = ROLE_ALIEN
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	show_to_ghosts = TRUE
	var/datum/team/xeno/xeno_team

/datum/antagonist/xeno/create_team(datum/team/xeno/new_team)
	if(!new_team)
		for(var/datum/antagonist/xeno/X in GLOB.antagonists)
			if(!X.owner || !X.xeno_team)
				continue
			xeno_team = X.xeno_team
			return
		xeno_team = new
	else
		if(!istype(new_team))
			CRASH("Wrong xeno team type provided to create_team")
		xeno_team = new_team

/datum/antagonist/xeno/get_team()
	return xeno_team

/mob/living/carbon/alien/mind_initialize()
	..()
	if(!mind.has_antag_datum(/datum/antagonist/xeno) && !istype(src, /mob/living/carbon/alien/humanoid/royal/queen))
		mind.add_antag_datum(/datum/antagonist/xeno)

//QUEEN ANTAG
/datum/antagonist/xeno/queen
	name = "Xenomorph Queen"

/datum/antagonist/xeno/queen/on_gain()
	var/datum/objective/escape/xeno_queen/escape = new()
	objectives += escape
	. = ..()
	owner.announce_objectives()

/datum/objective/escape/xeno_queen
	name = "shuttle takeover"
	explanation_text = "Escape on a ship to spread the hivemind to other sectors"

/datum/antagonist/xeno/queen/roundend_report()
	var/list/parts = list()
	var/datum/objective/escape/xeno_queen/objective = locate() in objectives
	if(objective.check_completion())
		parts += "<span class='redtext big'>The [name] has succeeded! The hive will now spread beyond this sector!</span>"
	else
		parts += "<span class='redtext big'>The [name] has failed! The crew has managed to keep the alien threat at bay!</span>"
	parts += printplayer(owner)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
