/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "telecommunication relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	netspeed = 5
	long_range_link = 1
	circuit = /obj/item/circuitboard/machine/telecomms/relay
	var/broadcasting = 1
	var/receiving = 1

/obj/machinery/telecomms/relay/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	// Add our map zones and send it back
	var/turf/T = get_turf(src)
	var/datum/map_zone/mapzone = T.get_map_zone()
	if(can_send(signal) && mapzone)
		signal.map_zones |= mapzone

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return FALSE
	if(!is_freq_listening(signal))
		return FALSE
	return TRUE

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return receiving

//Preset Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/Initialize(mapload)
	. = ..()
	if(autolinkers.len) //We want lateloaded presets to autolink (lateloaded aways/ruins/shuttles)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/telecomms/relay/preset/station
	id = "Vessel Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = FALSE
	autolinkers = list("r_relay")

/obj/machinery/telecomms/relay/preset/nanotrasen
	freq_listening = list(FREQ_COMMAND, FREQ_NANOTRASEN, FREQ_COMMON)
	id = "Nanotrasen Relay"
	network = "nt_commnet"

/obj/machinery/telecomms/relay/preset/inteq
	freq_listening = list(FREQ_COMMAND, FREQ_INTEQ, FREQ_COMMON)
	id = "IRMG Relay"
	network = "irmg_commnet"

/obj/machinery/telecomms/relay/preset/minutemen
	freq_listening = list(FREQ_COMMAND, FREQ_MINUTEMEN, FREQ_COMMON)
	id = "CLIP Relay"
	network = "clip_commnet"

/obj/machinery/telecomms/relay/preset/solgov
	freq_listening = list(FREQ_COMMAND, FREQ_SOLGOV, FREQ_COMMON)
	id = "SolGov Relay"
	network = "solgov_commnet"

/obj/machinery/telecomms/relay/preset/syndicate
	freq_listening = list(FREQ_COMMAND, FREQ_SYNDICATE, FREQ_COMMON)
	id = "Syndicate Relay"
	network = "synd_commnet"

/obj/machinery/telecomms/relay/preset/frontiersmen
	freq_listening = list(FREQ_COMMAND, FREQ_PIRATE, FREQ_COMMON)
	id = "Frontiersmen Relay"
	network = "frontier_commnet"

//Generic preset relay
/obj/machinery/telecomms/relay/preset/auto
	hide = TRUE
	autolinkers = list("autorelay")
