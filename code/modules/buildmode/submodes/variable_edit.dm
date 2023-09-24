/datum/buildmode_mode/varedit
	key = "edit"
	// Varedit mode
	var/varholder = null
	var/valueholder = null

/datum/buildmode_mode/varedit/Destroy()
	varholder = null
	valueholder = null
	return ..()

/datum/buildmode_mode/varedit/show_help(client/target_client)
	to_chat(target_client, span_purple(examine_block(
		"[span_bold("Select var(type) & value")] -> Right Mouse Button on buildmode button\n\
		[span_bold("Set var(type) & value")] -> Left Mouse Button on turf/obj/mob\n\
		[span_bold("Reset var's value")] -> Right Mouse Button on turf/obj/mob"))
	)

/datum/buildmode_mode/varedit/Reset()
	. = ..()
	varholder = null
	valueholder = null

/datum/buildmode_mode/varedit/change_settings(client/target_client)
	varholder = input(target_client, "Enter variable name:" ,"Name", "name")

	if(!vv_varname_lockcheck(varholder))
		return

	var/temp_value = target_client.vv_get_value()
	if(isnull(temp_value["class"]))
		Reset()
		to_chat(target_client, "<span class='notice'>Variable unset.</span>")
		return
	valueholder = temp_value["value"]

/datum/buildmode_mode/varedit/handle_click(client/target_client, params, obj/object)
	var/list/modifiers = params2list(params)

	if(isnull(varholder))
		to_chat(target_client, "<span class='warning'>Choose a variable to modify first.</span>")
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(object.vars.Find(varholder))
			if(object.vv_edit_var(varholder, valueholder) == FALSE)
				to_chat(target_client, "<span class='warning'>Your edit was rejected by the object.</span>")
				return
			log_admin("Build Mode: [key_name(target_client)] modified [object.name]'s [varholder] to [valueholder]")
		else
			to_chat(target_client, "<span class='warning'>[initial(object.name)] does not have a var called '[varholder]'</span>")
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(object.vars.Find(varholder))
			var/reset_value = initial(object.vars[varholder])
			if(object.vv_edit_var(varholder, reset_value) == FALSE)
				to_chat(target_client, "<span class='warning'>Your edit was rejected by the object.</span>")
				return
			log_admin("Build Mode: [key_name(target_client)] modified [object.name]'s [varholder] to [reset_value]")
		else
			to_chat(target_client, "<span class='warning'>[initial(object.name)] does not have a var called '[varholder]'</span>")

