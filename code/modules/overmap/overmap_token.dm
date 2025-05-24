/obj/overmap
	icon = 'icons/misc/overmap.dmi'
	///~~If we need to render a map for cameras and helms for this object~~ basically can you look at and use this as a ship or station.
	var/render_map = FALSE
	/// The parent overmap datum for this overmap token that has all of the actual functionality.
	var/datum/overmap/parent
	// Stuff needed to render the map
	var/map_name
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/plane_master/lighting/cam_plane_master
	var/atom/movable/screen/background/cam_background
	/// Countdown we use in case it's needed
	var/obj/effect/countdown/countdown

/obj/overmap/rendered
	render_map = TRUE

/obj/overmap/Initialize(mapload, new_parent)
	. = ..()
	parent = new_parent
	name = parent.name
	icon_state = parent.token_icon_state
	if(render_map)	// Initialize map objects
		map_name = "overmap_[REF(src)]_map"
		cam_screen = new
		cam_screen.name = "screen"
		cam_screen.assigned_map = map_name
		cam_screen.del_on_map_removal = FALSE
		cam_screen.screen_loc = "[map_name]:1,1"
		cam_plane_master = new
		cam_plane_master.name = "plane_master"
		cam_plane_master.assigned_map = map_name
		cam_plane_master.del_on_map_removal = FALSE
		cam_plane_master.screen_loc = "[map_name]:CENTER"
		cam_background = new
		cam_background.assigned_map = map_name
		cam_background.del_on_map_removal = FALSE
		update_screen()
	update_appearance()

/obj/overmap/Destroy(force)
	if(!QDELETED(parent))
		stack_trace("attempted to qdel a token that still has a parent")
		return QDEL_HINT_LETMELIVE
	if(render_map)
		QDEL_NULL(cam_screen)
		QDEL_NULL(cam_plane_master)
		QDEL_NULL(cam_background)
	QDEL_NULL(countdown)
	return ..()

/obj/overmap/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_VV_PARENT, "View Variables Of Parent Datum")
	VV_DROPDOWN_OPTION(VV_HK_UNFSCK_OBJECT, "Unfsck this overmap object | PANIC BUTTON")

/obj/overmap/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_VV_PARENT])
		if(!check_rights(R_VAREDIT))
			return
		usr.client.debug_variables(parent)
	if(href_list[VV_HK_UNFSCK_OBJECT])
		return parent.vv_do_topic(href_list)


/obj/overmap/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, render_map))
			if(!render_map && var_value)
				map_name = "overmap_[REF(src)]_map"
				cam_screen = new
				cam_screen.name = "screen"
				cam_screen.assigned_map = map_name
				cam_screen.del_on_map_removal = FALSE
				cam_screen.screen_loc = "[map_name]:1,1"
				cam_plane_master = new
				cam_plane_master.name = "plane_master"
				cam_plane_master.assigned_map = map_name
				cam_plane_master.del_on_map_removal = FALSE
				cam_plane_master.screen_loc = "[map_name]:CENTER"
				cam_background = new
				cam_background.assigned_map = map_name
				cam_background.del_on_map_removal = FALSE
				update_screen()
			else if(render_map && !var_value)
				QDEL_NULL(cam_screen)
				QDEL_NULL(cam_plane_master)
				QDEL_NULL(cam_background)
		if(NAMEOF(src, x))
			return parent.overmap_move(var_value, parent.y)
		if(NAMEOF(src, y))
			return parent.overmap_move(parent.x, var_value)
		if(NAMEOF(src, name))
			parent.Rename(var_value, TRUE)
			return TRUE
	return ..()

/**
 * Updates the screen object, which is displayed on all connected helms
 */
/obj/overmap/proc/update_screen()
	if(render_map)
		var/list/visible_turfs = list()
		for(var/turf/T in view(4, get_turf(src)))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen?.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)
		return TRUE

/obj/overmap/proc/choose_token(mob/user)
	var/nearby_objects = parent.current_overmap.overmap_container[parent.x][parent.y]
	if(length(nearby_objects) <= 1)
		return src

	var/list/choices_to_options = list() //Dict of object name | dict of object processing settings
	var/list/choices = list()
	for(var/datum/overmap/nearby_object in nearby_objects)
		if(!nearby_object.token)
			continue
		var/obj/overmap/token = nearby_object.token
		var/option_name = token.name
		choices_to_options[option_name] = token
		choices += list("[option_name]" = image(icon = token.icon, icon_state = token.icon_state))

	var/picked = show_radial_menu(user, src, choices, radius = 42, require_near = FALSE)
	var/obj/overmap/picked_token = choices_to_options[picked]
	return picked_token

/obj/overmap/Click(location, control, params)
	if(istype(usr.client.click_intercept,/datum/buildmode))
		return ..()
	var/obj/overmap/token = choose_token(usr)
	if(!isobj(token))
		return
	if(token.flags_1 & INITIALIZED_1)
		SEND_SIGNAL(token, COMSIG_CLICK, location, control, params, usr)

		usr.ClickOn(token, params)

/obj/overmap/attack_ghost(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_NO_ATTACK_HAND)
		return TRUE
	var/turf/jump_to_turf = parent.get_jump_to_turf()
	if(!jump_to_turf)
		return
	user.abstract_move(jump_to_turf)

/obj/overmap/examine(mob/user)
	. = ..()
	parent.ui_interact(user)
