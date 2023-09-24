// SETUP

/proc/TopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("[WT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [WT] have the same keyword! Ignoring [WT]...")
		else if(keyword == "key")
			warning("[WT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = WT

// DATUM

/datum/world_topic
	var/keyword
	var/log = TRUE
	var/key_valid
	var/require_comms_key = FALSE

/datum/world_topic/proc/TryRun(list/input)
	key_valid = config && (CONFIG_GET(string/comms_key) == input["key"])
	input -= "key"
	if(require_comms_key && !key_valid)
		. = "Bad Key"
		if (input["format"] == "json")
			. = list("error" = .)
	else
		. = Run(input)
	if (input["format"] == "json")
		. = json_encode(.)
	else if(islist(.))
		. = list2params(.)

/datum/world_topic/proc/Run(list/input)
	CRASH("Run() not implemented for [type]!")

// TOPICS

/datum/world_topic/ping
	keyword = "ping"
	log = FALSE

/datum/world_topic/ping/Run(list/input)
	. = 0
	for (var/client/C in GLOB.clients)
		++.

/datum/world_topic/playing
	keyword = "playing"
	log = FALSE

/datum/world_topic/playing/Run(list/input)
	return GLOB.player_list.len

/datum/world_topic/pr_announce
	keyword = "announce"
	require_comms_key = TRUE
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round

/datum/world_topic/pr_announce/Run(list/input)
	var/list/payload = json_decode(input["payload"])
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = "<span class='announce'>PR: [input[keyword]]</span>"
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/datum/world_topic/ahelp_relay
	keyword = "Ahelp"
	require_comms_key = TRUE

/datum/world_topic/ahelp_relay/Run(list/input)
	relay_msg_admins("<span class='adminnotice'><b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b></span>")

/datum/world_topic/comms_console
	keyword = "Comms_Console"
	require_comms_key = TRUE

/datum/world_topic/comms_console/Run(list/input)
	// Reject comms messages from other servers that are not on our configured network,
	// if this has been configured. (See CROSS_COMMS_NETWORK in comms.txt)
	var/configured_network = CONFIG_GET(string/cross_comms_network)
	if (configured_network && configured_network != input["network"])
		return

	minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
	for(var/obj/machinery/computer/communications/CM in GLOB.machines)
		CM.override_cooldown()

/datum/world_topic/news_report
	keyword = "News_Report"
	require_comms_key = TRUE

/datum/world_topic/news_report/Run(list/input)
	minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

/datum/world_topic/server_hop
	keyword = "server_hop"

/datum/world_topic/server_hop/Run(list/input)
	var/expected_key = input[keyword]
	for(var/mob/dead/observer/O in GLOB.player_list)
		if(O.key == expected_key)
			new /atom/movable/screen/splash(O.client, TRUE)
			break

/datum/world_topic/adminmsg
	keyword = "adminmsg"
	require_comms_key = TRUE

/datum/world_topic/adminmsg/Run(list/input)
	return TgsPm(input[keyword], input["msg"], input["sender"])

/datum/world_topic/namecheck
	keyword = "namecheck"
	require_comms_key = TRUE

/datum/world_topic/namecheck/Run(list/input)
	//Oh this is a hack, someone refactor the functionality out of the chat command PLS
	var/datum/tgs_chat_command/namecheck/NC = new
	var/datum/tgs_chat_user/user = new
	user.friendly_name = input["sender"]
	user.mention = user.friendly_name
	return NC.Run(user, input["namecheck"])

/datum/world_topic/adminwho
	keyword = "adminwho"
	require_comms_key = TRUE

/datum/world_topic/adminwho/Run(list/input)
	return tgsadminwho()

/datum/world_topic/status
	keyword = "status"

/datum/world_topic/status/Run(list/input)
	. = list()
	.["version"] = GLOB.game_version
	.["mode"] = GLOB.master_mode
	.["respawn"] = config ? !CONFIG_GET(flag/norespawn) : FALSE
	.["enter"] = !LAZYACCESS(SSlag_switch.measures, DISABLE_NON_OBSJOBS)
	.["ai"] = CONFIG_GET(flag/allow_ai)
	.["host"] = world.host ? world.host : null
	.["round_id"] = GLOB.round_id
	.["players"] = GLOB.clients.len
	.["revision"] = GLOB.revdata.commit
	.["revision_date"] = GLOB.revdata.date
	.["hub"] = GLOB.hub_visibility


	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho

	var/list/mnt = get_mentor_counts()
	.["mentors"] = mnt["total"] // we don't have stealth mentors, so we can just use the total.

	.["gamestate"] = SSticker.current_state

	if(key_valid)
		.["active_players"] = get_active_player_count()
		if(SSticker.HasRoundStarted())
			.["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

	.["security_level"] = get_security_level()
	.["round_duration"] = SSticker ? round((world.time - SSticker.round_start_time)/10) : 0
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	.["time_dilation_current"] = SStime_track.time_dilation_current
	.["time_dilation_avg"] = SStime_track.time_dilation_avg
	.["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	.["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	//pop cap stats
	.["soft_popcap"] = CONFIG_GET(number/soft_popcap) || 0
	.["hard_popcap"] = CONFIG_GET(number/hard_popcap) || 0
	.["extreme_popcap"] = CONFIG_GET(number/extreme_popcap) || 0
	.["popcap"] = max(CONFIG_GET(number/soft_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/extreme_popcap)) //generalized field for this concept for use across ss13 codebases
	.["bunkered"] = CONFIG_GET(flag/panic_bunker) || FALSE
	.["interviews"] = CONFIG_GET(flag/panic_bunker_interview) || FALSE

/datum/world_topic/whois
	keyword = "whoIs"

/datum/world_topic/whois/Run(list/input)
	. = list("players" = list())
	for(var/client/client as anything in GLOB.clients)
		if(!client?.prefs.whois_visible) // fuck you byond
			continue
		.["players"] += client.ckey

	return list2params(.)

/datum/world_topic/whois_all
	keyword = "whoIsAll"

/datum/world_topic/whois_all/Run(list/input)
	if(!key_valid)
		return list()
	return list2params(list("players" = GLOB.clients))

/datum/world_topic/getadmins
	keyword = "getAdmins"

/datum/world_topic/getadmins/Run(list/input)
	. = list()
	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins
	.["admins"] += afkmins

	return list2params(.)

/datum/world_topic/ooc_relay
	keyword = "ooc_send"
	require_comms_key = TRUE

/datum/world_topic/ooc_relay/Run(list/input)
	if(GLOB.say_disabled || !GLOB.ooc_allowed)	//This is here to try to identify lag problems
		return "OOC is currently disabled."

	var/message = input["message"]

	SSredbot.send_discord_message("ooc", "**[input["sender"]]:** [message]")

	message = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)

	message = emoji_parse(message)

	for(var/client/C in GLOB.clients)
		if(C.prefs.chat_toggles & CHAT_OOC)
			if(GLOB.OOC_COLOR)
				to_chat(C, "<font color='[GLOB.OOC_COLOR]'><b><span class='prefix'>OOC:</span> <EM>[input["sender"]]:</EM> <span class='message linkify'>[message]</span></b></font>")
			else
				to_chat(C, "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[input["sender"]]:</EM> <span class='message linkify'>[message]</span></span>")

/datum/world_topic/asay_relay
	keyword = "asay_send"
	require_comms_key = TRUE

/datum/world_topic/asay_relay/Run(list/input)
	var/message = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[input["sender"]]</EM>: <span class='message linkify'>[input["message"]]</span></span>"
	message = emoji_parse(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = keywords_lookup(message)
	to_chat(GLOB.admins, message)

/datum/world_topic/manifest //Inspired by SunsetStation
	keyword = "manifest"
	require_comms_key = TRUE //not really needed, but I don't think any bot besides ours would need it

/datum/world_topic/manifest/Run(list/input)
	. = list()
	var/list/manifest = SSovermap.get_manifest()
	for(var/department in manifest)
		var/list/entries = manifest[department]
		var/list/dept_entries = list()
		for(var/entry in entries)
			var/list/entry_list = entry
			dept_entries += "[entry_list["name"]]: [entry_list["rank"]]"
		.[department] = dept_entries

	return list2params(.)

/datum/world_topic/reload_admins
	keyword = "reload_admins"
	require_comms_key = TRUE

/datum/world_topic/reload_admins/Run(list/input)
	ReloadAsync()
	log_admin("[input["sender"]] reloaded admins via chat command.")
	return "Admins reloaded."

/datum/world_topic/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/datum/world_topic/restart
	keyword = "restart"
	require_comms_key = TRUE

/datum/world_topic/restart/Run(list/input)
	var/active_admins = FALSE
	var/hard_reset = input["hard"]

	if (hard_reset && !world.TgsAvailable())
		hard_reset = FALSE

	for(var/client/C in GLOB.admins)
		if(!C.is_afk() && check_rights_for(C, R_SERVER))
			active_admins = TRUE
			break
	if(!active_admins)
		if(hard_reset)
			return world.Reboot(fast_track = TRUE)
		else
			return world.Reboot()
	else
		return "There are active admins on the server! Ask them to restart."
