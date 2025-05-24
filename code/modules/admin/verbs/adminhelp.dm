/client/var/adminhelptimerid = 0	//a timer id for returning the ahelp verb
/client/var/datum/admin_help/current_ticket	//the current ticket the (usually) not-admin client is dealing with

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/admin_help_tickets, new)

/datum/admin_help_tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()
	var/total_statclick_errors = 0

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/admin_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/admin_help_tickets/proc/ticket_by_id(id)
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.id == id)
				return J

/datum/admin_help_tickets/proc/tickets_by_ckey(ckey)
	. = list()
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.initiator_ckey == ckey)
				. += AH

//private
/datum/admin_help_tickets/proc/list_insert(datum/admin_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			ticket_list = active_tickets
		if(AHELP_CLOSED)
			ticket_list = closed_tickets
		if(AHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/admin_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/admin_help_tickets/proc/browse_tickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(AHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(AHELP_CLOSED)
			l2b = closed_tickets
			title = "Closed Tickets"
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>[title]</title></head>")
	dat += "<A href='?_src_=holder;[HrefToken()];ahelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/I in l2b)
		var/datum/admin_help/AH = I
		dat += "[span_adminnotice("<span class='adminhelp'>Ticket #[AH.id]")]: <A href='?_src_=holder;[HrefToken()];ahelp=[REF(AH)];ahelp_action=ticket'>[AH.initiator_key_name]: [AH.name]</A></span><br>"

	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_entry()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/L = list()
	var/num_disconnected = 0
	L[++L.len] = list("Active Tickets:", "[astatclick.update("[length(active_tickets)]")]", null, REF(astatclick))
	astatclick.update("[length(active_tickets)]")
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator)
			if(QDELETED(AH.statclick))
				total_statclick_errors++
				AH.statclick = new(null, AH)
				if(!AH.error_screamed)
					stack_trace("statclick null?")
					message_admins("Ticket #[AH.id] had a null statclick, this message will only be shown once.")
					AH.error_screamed = TRUE

			L[++L.len] = list("#[AH.id]. [AH.initiator_key_name] (Claimed by [AH.claimed_by || "nobody"]):", "[AH.statclick.update()]", REF(AH))
		else
			++num_disconnected

	if(num_disconnected)
		L[++L.len] = list("Disconnected:", "[astatclick.update("[num_disconnected]")]", null, REF(astatclick))
	L[++L.len] = list("Closed Tickets:", "[cstatclick.update("[length(closed_tickets)]")]", null, REF(cstatclick))
	L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[length(resolved_tickets)]")]", null, REF(rstatclick))
	L[++L.len] = list("Statclick Errors:", "[total_statclick_errors]", null, null)
	return L

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/client_login(client/C)
	C.current_ticket = ckey2active_ticket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.initiator = C
		C.current_ticket.add_interaction("Client reconnected.")
		SSblackbox.log_ahelp(C.current_ticket.id, "Reconnected", "Client reconnected", C.ckey)

//Dissasociate ticket
/datum/admin_help_tickets/proc/client_logout(client/C)
	if(C.current_ticket)
		var/datum/admin_help/T = C.current_ticket
		T.add_interaction("Client disconnected.")
		SSblackbox.log_ahelp(T.id, "Disconnected", "Client disconnected", C.ckey)
		T.initiator = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/ckey2active_ticket(ckey)
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator_ckey == ckey)
			return AH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.ahelp_tickets.browse_tickets(current_state)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()

//
//TICKET DATUM
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name
	var/claimed_by
	var/heard_by_no_admins = FALSE

	var/list/_interactions	//use add_interaction() or, preferably, admin_ticket_log()

	var/obj/effect/statclick/ahelp/statclick
	var/error_screamed = FALSE

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign current_ticket
//msg is the title of the ticket: usually the ahelp text
//is_bwoink is TRUE if this ticket was started by an admin PM
/datum/admin_help/New(msg, client/C, is_bwoink)
	//clean the input msg
	msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket)	//This is a bug
		stack_trace("Multiple ahelp current_tickets")
		initiator.current_ticket.add_interaction("Ticket erroneously left open by code")
		initiator.current_ticket.close()
	initiator.current_ticket = src

	timeout_verb()

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink)
		add_interaction("<font color='blue'>[key_name_admin(usr)] PM'd [linked_reply_name()]</font>")
		message_admins("<font color='blue'>Ticket [ticket_href("#[id]")] created</font>")
		claimed_by = usr.key
	else
		message_no_recipient(msg)

		SSredbot.send_discord_message("admin", "Ticket #[id] created by [usr.ckey] ([usr.real_name]): [name]", "ticket")

		//send it to TGS if nobody is on and tell us how many were on
		var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [msg]")
		log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, span_notice("No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord."), confidential = TRUE)
			heard_by_no_admins = TRUE
	GLOB.ahelp_tickets.active_tickets += src

/datum/admin_help/Destroy()
	remove_active()
	QDEL_NULL(statclick)
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

/datum/admin_help/proc/add_interaction(formatted_message)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2tgs(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	_interactions += "[time_stamp()]: [formatted_message]"

//Removes the ahelp verb and returns it after 2 minutes
/datum/admin_help/proc/timeout_verb()
	remove_verb(initiator, /client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 1200, TIMER_STOPPABLE) //2 minute cooldown of admin helps

//private
/datum/admin_help/proc/full_monty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state == AHELP_ACTIVE)
		. += ticket_actions(ref_src)

		if (CONFIG_GET(flag/popup_admin_pm))
			. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];adminpopup=[REF(initiator)]'>POPUP</A>)"

//private
/datum/admin_help/proc/ticket_actions(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = "<br />"
	. += " ([ticket_href("REJT", ref_src, "reject")])"
	. += " ([ticket_href("IC", ref_src, "icissue")])"
	. += " ([ticket_href("SKILL", ref_src, "skillissue")])"
	. += " ([ticket_href("CLOSE", ref_src, "close")])"
	. += " ([ticket_href("RSLVE", ref_src, "resolve")])"
	. += " ([ticket_href("CLAIM", ref_src, "claim")])"

//private
/datum/admin_help/proc/linked_reply_name(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/ticket_href(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc/discord
/datum/admin_help/proc/message_no_recipient(msg)
	var/ref_src = "[REF(src)]"
	//Message to be sent to all admins
	var/admin_msg = span_adminnotice("[span_adminhelp("Ticket [ticket_href("#[id]", ref_src)]")]<b>: [linked_reply_name(ref_src)] [full_monty(ref_src)]:</b> [span_linkify("[keywords_lookup(msg)]")]")

	add_interaction("<font color='red'>[linked_reply_name(ref_src)]: [msg]</font>")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = MESSAGE_TYPE_ADMINPM,
			html = admin_msg,
			confidential = TRUE)

	//show it to the person adminhelping too
	to_chat(initiator,
		type = MESSAGE_TYPE_ADMINPM,
		html = span_adminnotice("PM to-<b>Admins</b>: [span_linkify("[msg]")]"),
		confidential = TRUE)
	SSblackbox.log_ahelp(id, "Ticket Opened", msg, null, initiator.ckey)

//Reopen a closed ticket
/datum/admin_help/proc/reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("This ticket is already open."), confidential = TRUE)
		return

	if(GLOB.ahelp_tickets.ckey2active_ticket(initiator_ckey))
		to_chat(usr, span_warning("This user already has an active ticket, cannot reopen this one."), confidential = TRUE)
		return

	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "closed")
		if(AHELP_RESOLVED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "resolved")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	add_interaction("<font color='purple'>Reopened by [key_name_admin(usr)]</font>")
	var/msg = span_adminhelp("Ticket [ticket_href("#[id]")] reopened by [key_name_admin(usr)].")
	message_admins(msg)
	log_admin_private(msg)
	SSblackbox.log_ahelp(id, "Reopened", "Reopened by [usr.key]", usr.ckey)
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "reopened")
	ticket_panel()	//can only be done from here, so refresh it

//private
/datum/admin_help/proc/remove_active()
	if(state != AHELP_ACTIVE)
		stack_trace("Attempt to remove non-active ticket")
		return
	closed_at = world.time
	GLOB.ahelp_tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null
	SEND_SIGNAL(src, COMSIG_ADMIN_HELP_MADE_INACTIVE)

/datum/admin_help/proc/claim(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return FALSE
	if(claimed_by && claimed_by != usr.key && alert(usr, "Ticket #[id] already claimed by [claimed_by]. Override?", "Adminhelp", "Yes", "No") != "Yes")
		return FALSE
	if(claimed_by == usr.key)
		return TRUE
	add_interaction(span_grey("Claimed by [key_name]."))
	to_chat(initiator, span_adminhelp("Your ticket has been claimed by an admin. Expect a response shortly."), confidential = TRUE)
	claimed_by = usr.key
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "claimed")
	var/msg = "Ticket [ticket_href("#[id]")] claimed by [key_name]."
	message_admins(msg)
	SSblackbox.log_ahelp(id, "Claimed", "Claimed by [usr.key]", null, usr.ckey)
	log_admin_private(msg)
	return TRUE

/datum/admin_help/proc/unclaim(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return
	if(claimed_by != usr.key)
		return
	add_interaction(span_grey("Unclaimed by [key_name]."))
	claimed_by = null
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "unclaimed")
	var/msg = "Ticket [ticket_href("#[id]")] unclaimed by [key_name]."
	message_admins(msg)
	SSblackbox.log_ahelp(id, "Unclaimed", "Unclaimed by [usr.key]", null, usr.ckey)
	log_admin_private(msg)

//Mark open ticket as closed/meme
/datum/admin_help/proc/close(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	remove_active()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.list_insert(src)
	add_interaction("<font color='red'>Closed by [key_name].</font>")
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "closed")
		var/msg = "Ticket [ticket_href("#[id]")] closed by [key_name]."
		message_admins(msg)
		SSblackbox.log_ahelp(id, "Closed", "Closed by [usr.key]", null, usr.ckey)
		log_admin_private(msg)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	remove_active()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.list_insert(src)

	addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 50)

	add_interaction("<font color='green'>Resolved by [key_name].</font>")
	to_chat(initiator, span_adminhelp("Your ticket has been resolved by an admin. The Adminhelp verb will be returned to you shortly."), confidential = TRUE)
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "resolved")
		var/msg = "Ticket [ticket_href("#[id]")] resolved by [key_name]"
		message_admins(msg)
		SSblackbox.log_ahelp(id, "Resolved", "Resolved by [usr.key]", null, usr.ckey)
		log_admin_private(msg)

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/reject(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- AdminHelp Rejected! -</b></font>", confidential = TRUE)
		to_chat(initiator, "<font color='red'><b>Your admin help was rejected.</b> The adminhelp verb has been returned to you so that you may try again.</font>", confidential = TRUE)
		to_chat(initiator, "Please try to be calm, clear, and descriptive in admin helps, do not assume the admin has seen any related events, and clearly state the names of anybody you are reporting.", confidential = TRUE)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "rejected")
	var/msg = "Ticket [ticket_href("#[id]")] rejected by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	add_interaction("Rejected by [key_name].")
	SSblackbox.log_ahelp(id, "Rejected", "Rejected by [usr.key]", null, usr.ckey)
	close(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ic_issue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- AdminHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'>Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "IC")
	msg = "Ticket [ticket_href("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	add_interaction("Marked as IC issue by [key_name]")
	SSblackbox.log_ahelp(id, "IC Issue", "Marked as IC issue by [usr.key]", null,  usr.ckey)
	resolve(silent = TRUE)

//Resolve ticket and inform user that they have a skill issue
/datum/admin_help/proc/skill_issue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- AdminHelp marked as skill issue! -</b></font><br>"
	msg += "<font color='red'>Your issue has been determined by an administrator to be a skill issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that involve being better at the game.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "Skill")
	msg = "Ticket [ticket_href("#[id]")] marked as skill issue by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	add_interaction("Marked as skill issue by [key_name]")
	SSblackbox.log_ahelp(id, "Skill Issue", "Marked as skill issue by [usr.key]", null,  usr.ckey)
	resolve(silent = TRUE)

//Show the ticket panel
/datum/admin_help/proc/ticket_panel()
	var/list/dat = list()
	var/ref_src = "[REF(src)]"
	dat += "<h4>Admin Help Ticket #[id]: [linked_reply_name(ref_src)] (Claimed by [claimed_by || "nobody"])</h4>"
	dat += "<b>State: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += "<font color='red'>OPEN</font>"
		if(AHELP_RESOLVED)
			dat += "<font color='green'>RESOLVED</font>"
		if(AHELP_CLOSED)
			dat += "CLOSED"
		else
			dat += "UNKNOWN"
	dat += "</b>[FOURSPACES][ticket_href("Refresh", ref_src)][FOURSPACES][ticket_href("Re-Title", ref_src, "retitle")]"
	if(state != AHELP_ACTIVE)
		dat += "[FOURSPACES][ticket_href("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Opened at: [game_timestamp(wtime = opened_at)] (Approx [DisplayTimeText(world.time - opened_at)] ago)"
	if(closed_at)
		dat += "<br>Closed at: [game_timestamp(wtime = closed_at)] (Approx [DisplayTimeText(world.time - closed_at)] ago)"
	dat += "<br><br>"
	if(initiator)
		dat += "<b>Actions:</b><br>[full_monty(ref_src)]<br>"
	else
		dat += "<b>DISCONNECTED</b>[ticket_actions(ref_src)]<br>"
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"

	var/datum/browser/popup = new(usr, "ahelp[id]", "Ticket #[id]", 620, 480)
	popup.set_content(dat.Join())
	popup.open()

/datum/admin_help/proc/retitle()
	var/new_title = input(usr, "Enter a title for the ticket", "Rename Ticket", name) as text|null
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [ticket_href("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin_private(msg)
	ticket_panel()	//we have to be here to do this

//Forwarded action from admin/Topic
/datum/admin_help/proc/action(mob/user, action)
	testing("Ahelp action: [action]")
	switch(action)
		if("claim")
			if(user.key == claimed_by)
				unclaim()
				return
			claim()
		if("ticket")
			ticket_panel()
		if("retitle")
			retitle()
		if("reject")
			reject()
		if("reply")
			if(!claim())
				return
			user.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ic_issue()
		if("skillissue")
			skill_issue()
		if("close")
			close()
		if("resolve")
			resolve()
		if("reopen")
			reopen()

//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/admin_help/ahelp_datum

/obj/effect/statclick/ahelp/Initialize(mapload, datum/admin_help/AH)
	ahelp_datum = AH
	. = ..()

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	ahelp_datum.ticket_panel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/giveadminhelpverb()
	add_verb(src, /client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

// Used for methods where input via arg doesn't work
/client/proc/get_adminhelp()
	var/msg = input(src, "Please describe your problem concisely and an admin will help as soon as they're able.", "Adminhelp contents") as message|null
	adminhelp(msg)

/client/verb/adminhelp(msg as message)
	set category = "Admin"
	set name = "Adminhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."), confidential = TRUE)
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("Error: Admin-PM: You cannot send adminhelps (Muted)."), confidential = TRUE)
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = trim(msg)

	if(!msg)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		if(alert(usr, "You already have a ticket open. Is this for the same issue?",,"Yes","No") != "No")
			if(current_ticket)
				current_ticket.message_no_recipient(msg)
				current_ticket.timeout_verb()
				return
			else
				to_chat(usr, span_warning("Ticket not found, creating new one..."), confidential = TRUE)
		else
			current_ticket.add_interaction("[key_name_admin(usr)] opened a new ticket.")
			current_ticket.close()

	//Extremely simple system of suggesting mentorhelp instead of adminhelp
	var/msg_lower = lowertext(msg)
	if((findtext(msg_lower, "how to") == 1 || findtext(msg_lower, "how do") == 1) && GLOB.mentors.len)
		if(alert("\"[msg]\" looks like a game mechanics question, would you like to ask in mentorhelp instead?", "Adminhelp?", "Yes, mentorhelp", "No, adminhelp") == "Yes, mentorhelp")
			mentorhelp(msg)
			return

	new /datum/admin_help(msg, src, FALSE)

//
// LOGGING
//

//Use this proc when an admin takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/admin_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_ticket)
		C.current_ticket.add_interaction(message)
		return C.current_ticket
	if(istext(what))	//ckey
		var/datum/admin_help/AH = GLOB.ahelp_tickets.ckey2active_ticket(what)
		if(AH)
			AH.add_interaction(message)
			return AH

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2tgs_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2tgs(source,final)
		send2otherserver(source,final)


/proc/send2tgs(msg,msg2)
	msg = format_text(msg)
	msg2 = format_text(msg2)
	world.TgsTargetedChatBroadcast(new /datum/tgs_message_content("[msg] | [msg2]"), TRUE)

/**
 * Sends a message to a set of cross-communications-enabled servers using world topic calls
 *
 * Arguments:
 * * source - Who sent this message
 * * msg - The message body
 * * type - The type of message, becomes the topic command under the hood
 * * target_servers - A collection of servers to send the message to, defined in config
 * * additional_data - An (optional) associated list of extra parameters and data to send with this world topic call
 */
/proc/send2otherserver(source, msg, type = "Ahelp", target_servers, list/additional_data = list())
	if(!CONFIG_GET(string/comms_key))
		debug2_world_log("Server cross-comms message not sent for lack of configured key")
		return

	var/our_id = CONFIG_GET(string/cross_comms_name)
	additional_data["message_sender"] = source
	additional_data["message"] = msg
	additional_data["source"] = "([our_id])"
	additional_data += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		if(I == our_id) //No sending to ourselves
			continue
		if(target_servers && !(I in target_servers))
			continue
		world.send_cross_comms(I, additional_data)

/// Sends a message to a given cross comms server by name (by name for security).
/world/proc/send_cross_comms(server_name, list/message, auth = TRUE)
	set waitfor = FALSE
	if (auth)
		var/comms_key = CONFIG_GET(string/comms_key)
		if(!comms_key)
			debug2_world_log("Server cross-comms message not sent for lack of configured key")
			return
		message["key"] = comms_key
	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	var/server_url = servers[server_name]
	if (!server_url)
		CRASH("Invalid cross comms config: [server_name]")
	world.Export("[server_url]?[list2params(message)]")


/proc/tgsadminwho()
	var/list/admin_keys = list()
	for(var/client/admin as anything in GLOB.admins)
		admin_keys += "[admin][admin.holder.fakekey ? "(Stealth)" : ""][admin.is_afk() ? "(AFK)" : ""]"

	return jointext(admin_keys, "\n")

/proc/keywords_lookup(msg,external)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(found.mind && found.mind.special_role)
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;[HrefToken(TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(external)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

/**
 * Checks a given message to see if any of the words are something we want to treat specially, as detailed below.
 *
 * There are 3 cases where a word is something we want to act on
 * 1. Admin pings, like @adminckey. Pings the admin in question, text is not clickable
 * 2. Datum refs, like @0x2001169 or @mob_23. Clicking on the link opens up the VV for that datum
 * 3. Ticket refs, like #3. Displays the status and ahelper in the link, clicking on it brings up the ticket panel for it.
 * Returns a list being used as a tuple. Index ASAY_LINK_NEW_MESSAGE_INDEX contains the new message text (with clickable links and such)
 * while index ASAY_LINK_PINGED_ADMINS_INDEX contains a list of pinged admin clients, if there are any.
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_asay_links(msg)
	var/list/msglist = splittext(msg, " ") //explode the input msg into a list
	var/list/pinged_admins = list() // if we ping any admins, store them here so we can ping them after
	var/modified = FALSE // did we find anything?

	var/i = 0
	for(var/word in msglist)
		i++
		if(!length(word))
			continue

		switch(word[1])
			if("@")
				var/stripped_word = ckey(copytext(word, 2))

				// first we check if it's a ckey of an admin
				var/client/client_check = GLOB.directory[stripped_word]
				if(client_check?.holder)
					msglist[i] = "<u>[word]</u>"
					pinged_admins[stripped_word] = client_check
					modified = TRUE
					continue

				// then if not, we check if it's a datum ref

				var/word_with_brackets = "\[[stripped_word]\]" // the actual memory address lookups need the bracket wraps
				var/datum/datum_check = locate(word_with_brackets)
				if(!istype(datum_check))
					continue
				msglist[i] = "<u><a href='?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[word_with_brackets]'>[word]</A></u>"
				modified = TRUE

			if("#") // check if we're linking a ticket
				var/possible_ticket_id = text2num(copytext(word, 2))
				if(!possible_ticket_id)
					continue

				var/datum/admin_help/ahelp_check = GLOB.ahelp_tickets?.ticket_by_id(possible_ticket_id)
				if(!ahelp_check)
					continue

				var/state_word
				switch(ahelp_check.state)
					if(AHELP_ACTIVE)
						state_word = "Active"
					if(AHELP_CLOSED)
						state_word = "Closed"
					if(AHELP_RESOLVED)
						state_word = "Resolved"

				msglist[i]= "<u><A href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[REF(ahelp_check)];ahelp_action=ticket'>[word] ([state_word] | [ahelp_check.initiator_key_name])</A></u>"
				modified = TRUE

	if(modified)
		var/list/return_list = list()
		return_list[ASAY_LINK_NEW_MESSAGE_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return_list[ASAY_LINK_PINGED_ADMINS_INDEX] = pinged_admins
		return return_list

/proc/get_mob_by_name(msg)
	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//who might fit the shoe
	var/list/potential_hits = list()

	for(var/i in GLOB.mob_list)
		var/mob/M = i
		var/list/nameWords = list()
		if(!M.mind)
			continue

		for(var/string in splittext(lowertext(M.real_name), " "))
			if(!(string in ignored_words))
				nameWords += string
		for(var/string in splittext(lowertext(M.name), " "))
			if(!(string in ignored_words))
				nameWords += string

		for(var/string in nameWords)
			testing("Name word [string]")
			if(string in msglist)
				potential_hits += M
				break

	return potential_hits
