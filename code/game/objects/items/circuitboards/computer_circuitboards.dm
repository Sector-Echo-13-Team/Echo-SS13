//Command

/obj/item/circuitboard/computer/aiupload
	name = "AI Upload (Computer Board)"
	icon_state = "command"
	build_path = /obj/machinery/computer/upload/ai

/obj/item/circuitboard/computer/borgupload
	name = "Cyborg Upload (Computer Board)"
	icon_state = "command"
	build_path = /obj/machinery/computer/upload/borg

/obj/item/circuitboard/computer/bsa_control
	name = "Bluespace Artillery Controls (Computer Board)"
	build_path = /obj/machinery/computer/bsa_control

/obj/item/circuitboard/computer/card
	name = "ID Console (Computer Board)"
	icon_state = "command"
	build_path = /obj/machinery/computer/card

/obj/item/circuitboard/computer/card/centcom
	name = "CentCom ID Console (Computer Board)"
	build_path = /obj/machinery/computer/card/centcom

/obj/item/circuitboard/computer/card/minor
	name = "Department Management Console (Computer Board)"
	build_path = /obj/machinery/computer/card/minor
	var/target_dept = 1
	var/list/dept_list = list("General","Security","Medical","Science","Engineering")

/obj/item/circuitboard/computer/card/minor/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		target_dept = (target_dept == dept_list.len) ? 1 : (target_dept + 1)
		to_chat(user, span_notice("You set the board to \"[dept_list[target_dept]]\"."))
	else
		return ..()

/obj/item/circuitboard/computer/card/minor/examine(user)
	..()
	to_chat(user, span_notice("Currently set to \"[dept_list[target_dept]]\"."))


//obj/item/circuitboard/computer/shield
//	name = "Shield Control (Computer Board)"
//	icon_state = "command"
//	build_path = /obj/machinery/computer/stationshield

//Engineering

/obj/item/circuitboard/computer/apc_control
	name = "\improper Power Flow Control Console (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/apc_control

/obj/item/circuitboard/computer/atmos_alert
	name = "Atmospheric Alert (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/computer/atmos_control
	name = "Atmospheric Monitor (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/atmos_control

/obj/item/circuitboard/computer/atmos_control/incinerator
	name = "Incinerator Air Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/incinerator

/obj/item/circuitboard/computer/atmos_control/toxinsmix
	name = "Toxins Mixing Air Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/toxinsmix

/obj/item/circuitboard/computer/atmos_control/tank
	name = "Tank Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank

/obj/item/circuitboard/computer/atmos_control/tank/oxygen_tank
	name = "Oxygen Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/oxygen_tank

/obj/item/circuitboard/computer/atmos_control/tank/toxin_tank
	name = "Plasma Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/toxin_tank

/obj/item/circuitboard/computer/atmos_control/tank/air_tank
	name = "Mixed Air Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/air_tank

/obj/item/circuitboard/computer/atmos_control/tank/mix_tank
	name = "Gas Mix Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/mix_tank

/obj/item/circuitboard/computer/atmos_control/tank/nitrous_tank
	name = "Nitrous Oxide Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/nitrous_tank

/obj/item/circuitboard/computer/atmos_control/tank/nitrogen_tank
	name = "Nitrogen Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/nitrogen_tank

/obj/item/circuitboard/computer/atmos_control/tank/carbon_tank
	name = "Carbon Dioxide Supply Control (Computer Board)"
	build_path = /obj/machinery/computer/atmos_control/tank/carbon_tank

/obj/item/circuitboard/computer/auxillary_base
	name = "Auxillary Base Management Console (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/auxillary_base

/obj/item/circuitboard/computer/comm_monitor
	name = "Telecommunications Monitor (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/telecomms/monitor

/obj/item/circuitboard/computer/comm_server
	name = "Telecommunications Server Monitor (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/telecomms/server

/obj/item/circuitboard/computer/communications
	name = "Communications (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/communications

/obj/item/circuitboard/computer/message_monitor
	name = "Message Monitor (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/message_monitor

/obj/item/circuitboard/computer/powermonitor
	name = "Power Monitor (Computer Board)"  //name fixed 250810
	icon_state = "engineering"
	build_path = /obj/machinery/computer/monitor

/obj/item/circuitboard/computer/powermonitor/secret
	name = "Outdated Power Monitor (Computer Board)" //Variant used on ruins to prevent them from showing up on PDA's.
	icon_state = "engineering"
	build_path = /obj/machinery/computer/monitor/secret

/obj/item/circuitboard/computer/sat_control
	name = "Satellite Network Control (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/sat_control

/obj/item/circuitboard/computer/solar_control
	name = "Solar Control (Computer Board)"  //name fixed 250810
	icon_state = "engineering"
	build_path = /obj/machinery/computer/solar_control

/obj/item/circuitboard/computer/stationalert
	name = "Station Alerts (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/computer/turbine_computer
	name = "Turbine Computer (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/turbine_computer

/obj/item/circuitboard/computer/turbine_control
	name = "Turbine control (Computer Board)"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/turbine_computer

//Generic

/obj/item/circuitboard/computer/arcade/amputation
	name = "Mediborg's Amputation Adventure (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/arcade/amputation

/obj/item/circuitboard/computer/arcade/battle
	name = "Arcade Battle (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/arcade/battle

/obj/item/circuitboard/computer/arcade/orion_trail
	name = "Orion Trail (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/arcade/orion_trail

/obj/item/circuitboard/computer/libraryconsole
	name = "Library Visitor Console (Computer Board)"
	build_path = /obj/machinery/computer/libraryconsole

/obj/item/circuitboard/computer/libraryconsole/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(build_path == /obj/machinery/computer/bookmanagement)
			name = "Library Visitor Console (Computer Board)"
			build_path = /obj/machinery/computer/libraryconsole
			to_chat(user, span_notice("Defaulting access protocols."))
		else
			name = "Book Inventory Management Console (Computer Board)"
			build_path = /obj/machinery/computer/bookmanagement
			to_chat(user, span_notice("Access protocols successfully updated."))
	else
		return ..()

/obj/item/circuitboard/computer/olddoor
	name = "DoorMex (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/computer/pod
	name = "Massdriver control (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/pod

/obj/item/circuitboard/computer/slot_machine
	name = "Slot Machine (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/slot_machine

/obj/item/circuitboard/computer/swfdoor
	name = "Magix (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/computer/syndicatedoor
	name = "ProComp Executive (Computer Board)"
	icon_state = "generic"
	build_path = /obj/machinery/computer/pod/old/syndicate

//Medical

/obj/item/circuitboard/computer/crew
	name = "Crew Monitoring Console (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/crew

/obj/item/circuitboard/computer/med_data
	name = "Medical Records Console (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/med_data

/obj/item/circuitboard/computer/operating
	name = "Operating Computer (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/operating

/obj/item/circuitboard/computer/pandemic
	name = "PanD.E.M.I.C. 2200 (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/pandemic

/obj/item/circuitboard/computer/scan_consolenew
	name = "DNA Machine (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/scan_consolenew

/obj/item/circuitboard/computer/cloning
	name = "Cloning (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/cloning

/obj/item/circuitboard/computer/prototype_cloning
	name = "Prototype Cloning (Computer Board)"
	icon_state = "medical"
	build_path = /obj/machinery/computer/prototype_cloning

//Science

/obj/item/circuitboard/computer/aifixer
	name = "AI Integrity Restorer (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/aifixer

/obj/item/circuitboard/computer/launchpad_console
	name = "Launchpad Control Console (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/launchpad

/obj/item/circuitboard/computer/mech_bay_power_console
	name = "Exosuit Bay Power Control Console (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/mech_bay_power_console

/obj/item/circuitboard/computer/mecha_control
	name = "Exosuit Control Console (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/computer/nanite_chamber_control
	name = "Nanite Chamber Control (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/nanite_chamber_control

/obj/item/circuitboard/computer/nanite_cloud_controller
	name = "Nanite Cloud Control (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/nanite_cloud_controller

/obj/item/circuitboard/computer/rdconsole
	name = "R&D Console (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/computer/rdconsole/production
	name = "R&D Console Production Only (Computer Board)"
	build_path = /obj/machinery/computer/rdconsole/production

/obj/item/circuitboard/computer/research
	name = "Research Monitor (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/security/research

/obj/item/circuitboard/computer/robotics
	name = "Robotics Control (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/robotics

/obj/item/circuitboard/computer/teleporter
	name = "Teleporter (Computer Board)"
	icon_state = "science"
	build_path = /obj/machinery/computer/teleporter

//Security

/obj/item/circuitboard/computer/gulag_teleporter_console
	name = "Labor Camp teleporter console (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/prisoner/gulag_teleporter_computer

/obj/item/circuitboard/computer/prisoner
	name = "Prisoner Management Console (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/prisoner/management

/obj/item/circuitboard/computer/secure_data
	name = "Security Records Console (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/secure_data

/obj/item/circuitboard/computer/warrant
	name = "Security Warrant Viewer (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/warrant

/obj/item/circuitboard/computer/security
	name = "Security Cameras (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/security

/obj/item/circuitboard/computer/advanced_camera
	name = "Advanced Camera Console (Computer Board)"
	icon_state = "security"
	build_path = /obj/machinery/computer/camera_advanced/syndie

//Service

//Supply

/obj/item/circuitboard/computer/mission
	name = "\improper Outpost Mission Console (Computer Board)"
	icon_state = "supply"
	build_path = /obj/machinery/computer/mission

/obj/item/circuitboard/computer/cargo
	name = "Outpost Comms Console (Computer Board)"
	icon_state = "supply"
	build_path = /obj/machinery/computer/cargo
	var/contraband = FALSE

/obj/item/circuitboard/computer/cargo/multitool_act(mob/living/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		contraband = !contraband
		to_chat(user, span_notice("Receiver spectrum set to [contraband ? "Broad" : "Standard"]."))
	else
		to_chat(user, span_alert("The spectrum chip is unresponsive."))

/obj/item/circuitboard/computer/cargo/emag_act(mob/living/user)
	if(!(obj_flags & EMAGGED))
		contraband = TRUE
		obj_flags |= EMAGGED
		to_chat(user, span_notice("You adjust [src]'s routing and receiver spectrum, unlocking special supplies and contraband."))

/obj/item/circuitboard/computer/mining
	name = "Outpost Status Display (Computer Board)"
	icon_state = "supply"
	build_path = /obj/machinery/computer/security/mining

/obj/item/circuitboard/computer/shuttle/helm
	name = "Shuttle Helm (Computer Board)"
	build_path = /obj/machinery/computer/helm
