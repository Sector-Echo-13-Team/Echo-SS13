/obj/item/mecha_parts/mecha_equipment/weapon
	name = "exosuit weapon"
	range = MECHA_RANGED
	destroy_sound = 'sound/mecha/weapdestr.ogg'
	var/projectile
	var/fire_sound
	var/projectiles_per_shot = 1
	var/variance = 0
	var/randomspread = FALSE //use random spread for machineguns, instead of shotgun scatter
	var/projectile_delay = 0
	var/firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect	//the visual effect appearing when the weapon is fired.
	var/kickback = TRUE //Will using this weapon in no grav push mecha back.
	var/full_auto = FALSE // whether this gun is full auto.
	var/mode = 0
	var/eject_casings = FALSE
	var/one_casing = FALSE // for shotgun type weapons so it doesnt throw out more casings than it's suppossed too
	var/casing_type

	var/scoped = FALSE //whether this weapon is scoped
	var/zoom_mod = 6
	var/zoom_out_mod = 2

/obj/item/mecha_parts/mecha_equipment/weapon/can_attach(obj/mecha/M)
	if(!..())
		return FALSE
	if(istype(M, /obj/mecha/combat))
		return TRUE
	if((locate(/obj/item/mecha_parts/weapon_bay) in M.contents) && !(locate(/obj/item/mecha_parts/mecha_equipment/weapon) in M.equipment))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/proc/get_shot_amount()
	return projectiles_per_shot

/obj/item/mecha_parts/mecha_equipment/weapon/action(atom/target, params)
	if(!action_checks(target))
		return 0

	var/turf/curloc = get_turf(chassis)
	var/turf/targloc = get_turf(target)

	var/modifiers = params2list(params)

	if (!targloc || !istype(targloc) || !curloc)
		return 0
	if (targloc == curloc)
		return 0

	var/eject_done = FALSE
	for(var/i=1 to get_shot_amount())
		var/obj/projectile/A = new projectile(curloc)
		A.firer = chassis.occupant
		A.original = target
		if(!A.suppressed && firing_effect_type)
			new firing_effect_type(get_turf(src), chassis.dir)

		var/spread = 0
		if(variance)
			if(randomspread)
				spread = round((rand() - 0.5) * variance)
			else
				spread = round((i / projectiles_per_shot - 0.5) * variance)
		A.preparePixelProjectile(target, chassis.occupant, modifiers, spread)

		A.fire()
		playsound(chassis, fire_sound, 50, TRUE)
		if(eject_casings && !eject_done)
			var/obj/item/ammo_casing/ejected = new casing_type(src)
			ejected.on_eject(chassis)
			if(one_casing)
				eject_done = TRUE

		sleep(max(0, projectile_delay))

	if(kickback)
		chassis.newtonian_move(turn(chassis.dir,180))
	chassis.log_message("Fired from [src.name], targeting [target].", LOG_MECHA)
	return 1


//Base energy weapon type
/obj/item/mecha_parts/mecha_equipment/weapon/energy
	name = "general energy weapon"
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/item/mecha_parts/mecha_equipment/weapon/energy/get_shot_amount()
	return min(round(chassis.cell.charge / energy_drain), projectiles_per_shot)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/start_cooldown()
	set_ready_state(0)
	chassis.use_power(energy_drain*get_shot_amount())
	addtimer(CALLBACK(src, PROC_REF(set_ready_state), 1), equip_cooldown)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/carbine
	equip_cooldown = 2
	name = "\improper CH-PS \"Downpour\" energy carbine"
	desc = "A weapon for combat exosuits. A rapid fire energy carbine with both lethal and disabler modes."
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/projectile/beam/laser
	fire_sound = 'sound/weapons/laser.ogg'
	harmful = TRUE
	full_auto = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/carbine/Topic(href, href_list)
	. = ..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		switch(mode)
			//laser mode
			if(0)
				occupant_message(span_notice("Carbine now set to laser."))
				energy_drain = initial(energy_drain)
				projectile = /obj/projectile/beam/laser
				harmful = TRUE
				fire_sound = 'sound/weapons/laser.ogg'
			//disabler mode
			if(1)
				occupant_message(span_notice("Carbine now set to disable."))
				energy_drain = (initial(energy_drain))/2
				projectile = /obj/projectile/beam/disabler
				harmful = FALSE
				fire_sound = 'sound/weapons/taser2.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/carbine/get_equip_info()
	return "[..()] \[<a href='?src=[REF(src)];mode=0'>Laser</a>|<a href='?src=[REF(src)];mode=1'>Disabler</a>\]"

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 16
	name = "\improper CH-LC \"Solaris\" beam sniper"
	desc = "A scoped weapon for combat exosuits. Shoots long range heavy beam lasers."
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/projectile/beam/emitter/hitscan
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	full_auto = FALSE
	scoped = TRUE
	zoom_mod = 10
	zoom_out_mod = 3

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 20
	name = "\improper MKIV ion heavy cannon"
	desc = "A weapon for combat exosuits. Shoots technology-disabling ion beams. Don't catch yourself in the blast!"
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/projectile/ion
	fire_sound = 'sound/weapons/laser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/tesla
	equip_cooldown = 35
	name = "\improper MKI Tesla Cannon"
	desc = "A weapon for combat exosuits. Fires bolts of electricity similar to the experimental tesla engine."
	icon_state = "mecha_ion"
	energy_drain = 500
	projectile = /obj/projectile/energy/tesla/cannon
	fire_sound = 'sound/magic/lightningbolt.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	equip_cooldown = 4
	name = "eZ-13 MK2 heavy pulse rifle"
	desc = "A scoped weapon for combat exosuits. Shoots powerful destructive blasts capable of demolishing obstacles."
	icon_state = "mecha_pulse"
	energy_drain = 120
	projectile = /obj/projectile/beam/pulse/heavy
	fire_sound = 'sound/weapons/marauder.ogg'
	harmful = TRUE
	full_auto = TRUE
	scoped = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma
	equip_cooldown = 10
	name = "217-D Heavy Plasma Cutter"
	desc = "A device that shoots resonant plasma bursts at extreme velocity. The blasts are capable of crushing rock and demolishing solid obstacles."
	icon_state = "mecha_plasmacutter"
	item_state = "plasmacutter"
	lefthand_file = GUN_LEFTHAND_ICON
	righthand_file = GUN_RIGHTHAND_ICON
	energy_drain = 30
	projectile = /obj/projectile/plasma/adv/mech
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma/can_attach(obj/mecha/working/M)
	if(..()) //combat mech
		return 1
	else if(M.equipment.len < M.max_equip && istype(M))
		return 1
	return 0

//Exosuit-mounted kinetic accelerator
/obj/item/mecha_parts/mecha_equipment/weapon/energy/mecha_kineticgun
	equip_cooldown = 10
	name = "Exosuit Proto-kinetic Accelerator"
	desc = "An exosuit-mounted mining tool that does increased damage in low pressure. Drawing from an onboard power source allows it to project further than the handheld version."
	icon_state = "mecha_kineticgun"
	energy_drain = 30
	projectile = /obj/projectile/kinetic/mech
	fire_sound = 'sound/weapons/kenetic_accel.ogg'
	harmful = TRUE

//attachable to all mechas, like the plasma cutter
/obj/item/mecha_parts/mecha_equipment/weapon/energy/mecha_kineticgun/can_attach(obj/mecha/working/Mech)
	if(..()) //combat mech
		return TRUE
	else if(Mech.equipment.len < Mech.max_equip && istype(Mech))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	name = "\improper PBT \"Pacifier\" mounted taser"
	desc = "A weapon for combat exosuits. Shoots non-lethal stunning electrodes."
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/projectile/energy/electrode
	fire_sound = 'sound/weapons/taser.ogg'

//Base ballistic weapon type
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic
	name = "general ballistic weapon"
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	var/projectiles
	var/projectiles_max //maximum amount of projectiles that can be chambered.
	var/projectiles_cache //ammo to be loaded in, if possible.
	var/projectiles_cache_max
	var/projectile_energy_cost
	var/disabledreload //For weapons with no cache (like the rockets) which are reloaded by hand
	var/ammo_type
	casing_type = /obj/item/ammo_casing/spent/mecha

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/Initialize() //initial(projectiles) prevented me from making mech weapons start empty TODO: PORT ALL OF TG MECH IMPROVEMENTS
	. = ..()
	projectiles_max ||= projectiles

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/get_shot_amount()
	if(one_casing)
		return projectiles_per_shot
	else
		return min(projectiles, projectiles_per_shot)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/action_checks(target)
	if(!..())
		return 0
	if(projectiles <= 0)
		return 0
	return 1

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/get_equip_info()
	return "[..()] \[[src.projectiles][projectiles_cache_max &&!projectile_energy_cost?"/[projectiles_cache]":""]\][!disabledreload &&(src.projectiles < projectiles_max)?" - <a href='?src=[REF(src)];rearm=1'>Rearm</a>":null]"


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/rearm()
	if(projectiles < projectiles_max)
		var/projectiles_to_add = projectiles_max - projectiles

		if(projectile_energy_cost)
			while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
				projectiles++
				projectiles_to_add--
				chassis.use_power(projectile_energy_cost)

		else
			if(!projectiles_cache)
				return FALSE
			if(projectiles_to_add <= projectiles_cache)
				projectiles = projectiles + projectiles_to_add
				projectiles_cache = projectiles_cache - projectiles_to_add
			else
				projectiles = projectiles + projectiles_cache
				projectiles_cache = 0

		send_byjax(chassis.occupant,"exosuit.browser","[REF(src)]",src.get_equip_info())
		log_message("Rearmed [src.name].", LOG_MECHA)
		return TRUE


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/needs_rearm()
	. = !(projectiles > 0)



/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/Topic(href, href_list)
	..()
	if (href_list["rearm"])
		src.rearm()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/action(atom/target)
	if(..())
		if(one_casing)
			projectiles--
		else
			projectiles -= get_shot_amount()
		send_byjax(chassis.occupant,"exosuit.browser","[REF(src)]",src.get_equip_info())
		return 1

/obj/item/ammo_casing/spent/mecha
	name = "bullet casing"
	desc = "A bullet casing designed to fired from exosuit mounted weapons."
	projectile_type = null
	icon_state = "rifle-brass"
	transform = matrix(1.3, 0, 0, 0, 1.3, 0)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/carbine
	name = "\improper FNX-99 \"Phoenix\" Exosuit Carbine"
	desc = "A weapon for combat exosuits. Shoots incendiary bullets."
	icon_state = "mecha_carbine"
	equip_cooldown = 10
	projectile = /obj/projectile/bullet/incendiary/fnx99
	projectiles = 24
	projectiles_cache = 24
	projectiles_cache_max = 96
	harmful = TRUE
	ammo_type = "incendiary"
	eject_casings = TRUE
	casing_type = /obj/item/ammo_casing/spent/mecha/carbine

/obj/item/ammo_casing/spent/mecha/carbine
	name = "FNX-99 5.56mm Incendiary bullet"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX-10 \"Scattershot\" Heavy Shotgun"
	desc = "A weapon for combat exosuits. Shoots a spread of pellets."
	icon_state = "mecha_scatter"
	equip_cooldown = 10
	projectile = /obj/projectile/bullet/pellet/scattershot
	projectiles = 12
	projectiles_cache = 24
	projectiles_cache_max = 72
	projectiles_per_shot = 8
	variance = 25
	harmful = TRUE
	ammo_type = "scattershot"
	eject_casings = TRUE
	one_casing = TRUE
	casing_type = /obj/item/ammo_casing/spent/mecha/scattergun

/obj/item/ammo_casing/spent/mecha/scattergun
	name = "8ga scattergun shell"
	icon_state = "buckshot"
	bounce_sfx_override = 'sound/weapons/gun/general/bulletcasing_shotgun_bounce.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper UMG-2 Mounted Machine Gun"
	desc = "A weapon for combat exosuits. A fully automatic mounted machine gun with an impressive rate of fire and capacity."
	icon_state = "mecha_uac2"
	equip_cooldown = 2
	projectile = /obj/projectile/bullet/lmg
	projectiles = 100
	projectiles_cache = 200
	projectiles_cache_max = 600
	variance = 6
	randomspread = TRUE
	harmful = TRUE
	ammo_type = "lmg"
	full_auto = TRUE
	eject_casings = TRUE
	casing_type = /obj/item/ammo_casing/spent/mecha/umg

/obj/item/ammo_casing/spent/mecha/umg
	name = "UMG 7.5x50mm bullet"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/mounted
	name = "\improper Mounted Heavy Machine Gun"
	desc = "A heavy calibre machine gun commonly used by motorized forces, famed for it's ability to give people on the recieving end more holes than normal. It is modified to be attached to vehicles"
	projectile = /obj/projectile/bullet/lmg
	fire_sound = 'sound/weapons/gun/hmg/hmg.ogg'
	projectiles = 0
	projectiles_max = 100
	projectiles_cache = 0
	projectiles_cache_max = 100
	equip_cooldown = 1 SECONDS

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	name = "\improper SRM-8 missile rack"
	desc = "A weapon for combat exosuits. Launches light explosive missiles."
	icon_state = "mecha_missilerack"
	projectile = /obj/projectile/bullet/a84mm_he
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	projectiles = 8
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	equip_cooldown = 60
	harmful = TRUE
	ammo_type = "missiles_he"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/tank
	name = "\improper tank gun"
	desc = "A long barreled cannon modified to shoot rockets."
	fire_sound = 'sound/weapons/gun/general/tank_cannon.ogg'
	projectiles_max = 8
	projectiles = 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/breaching
	name = "\improper BRM-6 missile rack"
	desc = "A weapon for combat exosuits. Launches low-explosive breaching missiles designed to explode only when striking a sturdy target."
	icon_state = "mecha_missilerack_six"
	projectile = /obj/projectile/bullet/a84mm_br
	fire_sound = 'sound/weapons/gun/general/rocket_launch.ogg'
	projectiles = 6
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	equip_cooldown = 60
	harmful = TRUE
	ammo_type = "missiles_br"


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher
	var/missile_speed = 2
	var/missile_range = 30
	var/diags_first = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/action(target)
	if(!action_checks(target))
		return
	var/obj/O = new projectile(chassis.loc)
	playsound(chassis, fire_sound, 50, TRUE)
	log_message("Launched a [O.name] from [name], targeting [target].", LOG_MECHA)
	projectiles--
	proj_init(O)
	O.throw_at(target, missile_range, missile_speed, chassis.occupant, FALSE, diagonals_first = diags_first)
	return 1

//used for projectile initilisation (priming flashbang) and additional logging
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/proc/proj_init(obj/O)
	return


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang
	name = "\improper SGL-6 grenade launcher"
	desc = "A weapon for combat exosuits. Launches primed flashbangs."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/flashbang
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	projectiles_cache = 6
	projectiles_cache_max = 24
	missile_speed = 1.5
	equip_cooldown = 60
	var/det_time = 20
	ammo_type = "flashbang"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/proj_init(obj/item/grenade/flashbang/F)
	var/turf/T = get_turf(src)
	message_admins("[ADMIN_LOOKUPFLW(chassis.occupant)] fired a [src] in [ADMIN_VERBOSEJMP(T)]")
	log_game("[key_name(chassis.occupant)] fired a [src] in [AREACOORD(T)]")
	F.preprime(delayoverride = det_time)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/clusterbang //Because I am a heartless bastard -Sieve //Heartless? for making the poor man's honkblast? - Kaze
	name = "\improper SOB-3 grenade launcher"
	desc = "A weapon for combat exosuits. Launches primed clusterbangs. You monster."
	projectiles = 3
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	projectile = /obj/item/grenade/clusterbuster
	equip_cooldown = 90
	ammo_type = "clusterbang"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar
	name = "banana mortar"
	desc = "Equipment for clown exosuits. Launches banana peels."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/grown/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/can_attach(obj/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar
	name = "mousetrap mortar"
	desc = "Equipment for clown exosuits. Launches armed mousetraps."
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/assembly/mousetrap/armed
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 10

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar/can_attach(obj/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/mousetrap_mortar/proj_init(obj/item/assembly/mousetrap/armed/M)
	M.secured = 1


//Classic extending punching glove, but weaponised!
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove
	name = "\improper Oingo Boingo Punch-face"
	desc = "Equipment for clown exosuits. Delivers fun right to your face!"
	icon_state = "mecha_punching_glove"
	energy_drain = 250
	equip_cooldown = 20
	range = MECHA_MELEE|MECHA_RANGED
	missile_range = 5
	projectile = /obj/item/punching_glove
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 10
	projectile_energy_cost = 500
	diags_first = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/can_attach(obj/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/action(target)
	. = ..()
	if(.)
		chassis.occupant_message("<font color='red' size='5'>HONK</font>")

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/punching_glove/proj_init(obj/item/punching_glove/PG)
	if(!istype(PG))
		return
	//has to be low sleep or it looks weird, the beam doesn't exist for very long so it's a non-issue
	chassis.Beam(PG, icon_state = "chain", time = missile_range * 20, maxdistance = missile_range + 2)

/obj/item/punching_glove
	name = "punching glove"
	desc = "INCOMING HONKS"
	throwforce = 35
	icon_state = "punching_glove"

/obj/item/punching_glove/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		if(ismovable(hit_atom))
			var/atom/movable/AM = hit_atom
			AM.safe_throw_at(get_edge_target_turf(AM,get_dir(src, AM)), 7, 2)
		qdel(src)
