/obj/machinery/atmospherics/components/binary/thermomachine
	icon = 'icons/obj/atmospherics/components/thermomachine.dmi'
	icon_state = "freezer"

	name = "Temperature control unit"
	desc = "Heats or cools gas in connected pipes."

	density = TRUE
	max_integrity = 300
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 80, ACID = 30)
	layer = OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/thermomachine

	hide = TRUE

	move_resist = MOVE_RESIST_DEFAULT

	pipe_flags = PIPING_ONE_PER_TURF

	var/icon_state_off = "freezer"
	var/icon_state_on = "freezer_1"
	var/icon_state_open = "freezer-o"

	var/min_temperature = T20C //actual temperature will be defined by RefreshParts() and by the cooling var
	var/max_temperature = T20C //actual temperature will be defined by RefreshParts() and by the cooling var
	var/target_temperature = T20C
	var/heat_capacity = 0
	var/interactive = TRUE // So mapmakers can disable interaction.
	var/cooling = TRUE
	var/base_heating = 140
	var/base_cooling = 170
	var/obj/item/tank/holding
	var/use_enviroment_heat = FALSE
	var/skipping_work = FALSE
	var/auto_thermal_regulator = FALSE

/obj/machinery/atmospherics/components/binary/thermomachine/Initialize()
	. = ..()
	RefreshParts()
	update_appearance()

/obj/machinery/atmospherics/components/binary/thermomachine/isConnectable()
	if(!anchored || panel_open)
		return FALSE
	. = ..()

/obj/machinery/atmospherics/components/binary/thermomachine/getNodeConnects()
	return list(dir, turn(dir, 180))

/obj/machinery/atmospherics/components/binary/thermomachine/on_construction(obj_color, set_layer)
	var/obj/item/circuitboard/machine/thermomachine/board = circuit
	if(board)
		piping_layer = board.pipe_layer
		set_layer = piping_layer

	if(check_pipe_on_turf())
		deconstruct(TRUE)
		return
	return..()

/obj/machinery/atmospherics/components/binary/thermomachine/RefreshParts()
	var/calculated_bin_rating
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		calculated_bin_rating += bin.rating
	heat_capacity = 7500 * ((calculated_bin_rating - 1) ** 2)
	min_temperature = T20C
	max_temperature = T20C
	var/calculated_laser_rating
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		calculated_laser_rating += laser.rating
	min_temperature = max(T0C - (base_cooling + calculated_laser_rating * 15), TCMB) //73.15K with T1 stock parts
	max_temperature = T20C + (base_heating * calculated_laser_rating) //573.15K with T1 stock parts


/obj/machinery/atmospherics/components/binary/thermomachine/update_icon_state()
	if(cooling)
		icon_state_off = "freezer"
		icon_state_on = "freezer_1"
		icon_state_open = "freezer-o"
	else
		icon_state_off = "heater"
		icon_state_on = "heater_1"
		icon_state_open = "heater-o"
	if(panel_open)
		icon_state = icon_state_open
		return ..()
	if(on && is_operational)
		icon_state = icon_state_on
		return ..()
	icon_state = icon_state_off
	return ..()

/obj/machinery/atmospherics/components/binary/thermomachine/update_overlays()
	. = ..()
	. += getpipeimage(icon, "pipe", dir, COLOR_LIME, piping_layer)
	. += getpipeimage(icon, "pipe", turn(dir, 180), COLOR_MOSTLY_PURE_RED, piping_layer)
	if(holding)
		var/mutable_appearance/holding = mutable_appearance(icon, "holding")
		. += holding
	if(skipping_work && on)
		var/mutable_appearance/skipping = mutable_appearance(icon, "blinking")
		. += skipping

/obj/machinery/atmospherics/components/binary/thermomachine/examine(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		. += span_notice("Something seems wrong with [src]'s thermal safeties.")
	. += span_notice("With the panel open:")
	. += span_notice("-use a wrench with left-click to rotate [src] and right-click to unanchor it.")
	. += span_notice("-use a multitool with left-click to change the piping layer and right-click to change the piping color.")
	. += span_notice("The thermostat is set to [target_temperature]K ([(T0C-target_temperature)*-1]C).")
	if(in_range(user, src) || isobserver(user))
		. += span_notice("Heat capacity at <b>[heat_capacity] Joules per Kelvin</b>.")
		. += span_notice("Temperature range <b>[min_temperature]K - [max_temperature]K ([(T0C-min_temperature)*-1]C - [(T0C-max_temperature)*-1]C)</b>.")

/obj/machinery/atmospherics/components/binary/thermomachine/AltClick(mob/living/user)
	if(!can_interact(user))
		return
	target_temperature = T20C
	investigate_log("was set to [target_temperature] K by [key_name(user)]", INVESTIGATE_ATMOS)
	balloon_alert(user, "temperature reset to [target_temperature] K")

/** Performs heat calculation for the freezer. The full equation for this whole process is:
 * T3 = (C1*T1  +  (C1*C2)/(C1+C2)*(T2-T1)*E) / C1.
 * T4 = (C1*T1  -  (C1*C2)/(C1+C2)*(T2-T1)*E  +  M) / C1.
 * C1 is main port heat capacity, T1 is the temp.
 * C2 and T2 is for the heat capacity of the freezer and temperature that we desire respectively.
 * T3 is the temperature we get, T4 is the exchange target (heat reservoir).
 * M is the motor heat.
 * E is the efficiency variable. At E=1 and M=0 it works out to be ((C1*T1)+(C2*T2))/(C1+C2).
 */
/obj/machinery/atmospherics/components/binary/thermomachine/process_atmos()
	if(!is_operational || !on)  //if it has no power or its switched off, dont process atmos
		on = FALSE
		update_appearance()
		return

	var/turf/local_turf = get_turf(src)
	if(!local_turf)
		on = FALSE
		update_appearance()
		return
	var/datum/gas_mixture/enviroment = local_turf.return_air()

	var/datum/gas_mixture/main_port = airs[1]
	var/datum/gas_mixture/thermal_exchange_port = airs[2]
	var/main_heat_capacity = main_port.heat_capacity()
	var/thermal_heat_capacity = thermal_exchange_port.heat_capacity()
	var/temperature_delta = main_port.temperature - target_temperature
	if(auto_thermal_regulator)
		cooling = temperature_delta > 0
	else
		temperature_delta = cooling ? max(temperature_delta, 0) : min(temperature_delta, 0) //no cheesy strats

	var/motor_heat = 2500
	if(abs(temperature_delta) < 1.5) //allow the machine to work more finely
		motor_heat = 0

	// Automatic Switching. Longer if check to prevent unecessary update_appearances.
	if ((cooling && temperature_target_delta > 0) || (!cooling && temperature_target_delta < 0))
		cooling = temperature_target_delta <= 0 // Thermomachines that reached the target will default to cooling.
		update_appearance()

	skipping_work = FALSE

	if (main_port.total_moles() < 0.01)
		skipping_work = TRUE
		return

	// Efficiency should be a proc level variable, but we need it for the ui.
	// This is to reset the value when we are heating.
	efficiency = 1

	if(cooling)
		var/datum/gas_mixture/exchange_target
		// Exchange target is the thing we are paired with, be it enviroment or the red port.
		if(use_enviroment_heat)
			exchange_target = local_turf.return_air()
		else
			exchange_target = airs[2]

		if (exchange_target.total_moles() < 0.01)
			skipping_work = TRUE
			return

		// The hotter the heat reservoir is, the larger the malus.
		var/temperature_exchange_delta = exchange_target.temperature - main_port.temperature
		// Log 1 is already 0, going any lower will result in a negative number.
		efficiency = clamp(1 - log(10, max(1, temperature_exchange_delta)) * 0.08, 0.65, 1)
		// We take an extra efficiency malus for enviroments where the mol is too low.
		// Cases of log(0) will be caught by the early return above.
		if (use_enviroment_heat)
			efficiency *= clamp(log(1.55, exchange_target.total_moles()) * 0.15, 0.65, 1)

		if (exchange_target.temperature > THERMOMACHINE_SAFE_TEMPERATURE && safeties)
			on = FALSE
			visible_message(span_warning("The heat reservoir has reached critical levels, shutting down..."))
			update_appearance()
			update_parents()
			return
		temperature_difference = enviroment.temperature - main_port.temperature
		temperature_difference = cooling ? temperature_difference : 0
		if(temperature_difference > 0)
			efficiency = max(1 - log(10, temperature_difference) * 0.08, 0.65)
		main_port.temperature = max(main_port.temperature - (heat_amount * efficiency * enviroment_efficiency) / main_heat_capacity + motor_heat / main_heat_capacity, TCMB)
		skip_tick = FALSE

		else if(exchange_target.temperature > THERMOMACHINE_SAFE_TEMPERATURE && !safeties)
			if((REALTIMEOFDAY - lastwarning) / 5 >= WARNING_DELAY)
				lastwarning = REALTIMEOFDAY
				visible_message(span_warning("The heat reservoir has reached critical levels!"))
				if(check_explosion(exchange_target.temperature))
					explode()
					return PROCESS_KILL //We're dying anyway, so let's stop processing

		exchange_target.temperature = max((THERMAL_ENERGY(exchange_target) - (heat_amount * efficiency) + motor_heat) / exchange_target.heat_capacity(), TCMB)

	main_port.temperature = max((THERMAL_ENERGY(main_port) + (heat_amount * efficiency)) / main_port.heat_capacity(), TCMB)

	heat_amount = abs(heat_amount)
	var/power_usage = 0
	if(temperature_delta  > 1)
		power_usage = (heat_amount * 0.35 + idle_power_usage) ** (1.25 - (5e7 * efficiency) / (max(5e7, heat_amount)))
	else
		power_usage = idle_power_usage
	if(power_usage > 1e6)
		power_usage *= efficiency

	use_power(power_usage)
	update_appearance()
	update_parents()

/obj/machinery/atmospherics/components/binary/thermomachine/attackby(obj/item/item, mob/user, params)
	if(!on && !holding)
		if(!anchored)
			to_chat(user, span_notice("Anchor [src] first!"))
			return
		if(default_deconstruction_screwdriver(user, icon_state_open, icon_state_off, item))
			change_pipe_connection(panel_open)
			return
	if(default_change_direction_wrench(user, item))
		return
	if(default_deconstruction_crowbar(item))
		return

	if(panel_open && item.tool_behaviour == TOOL_MULTITOOL)
		piping_layer = (piping_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (piping_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [piping_layer]."))
		update_appearance()

	return ..()

/obj/machinery/atmospherics/components/binary/thermomachine/default_change_direction_wrench(mob/user, obj/item/I)
	if(!..())
		return FALSE
	SetInitDirections()
	return TRUE

/obj/machinery/atmospherics/components/binary/thermomachine/proc/change_pipe_connection(disconnect)
	if(disconnect)
		disconnect_pipes()
		return
	connect_pipes()

/obj/machinery/atmospherics/components/binary/thermomachine/proc/connect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]
	atmosinit()
	node1 = nodes[1]
	if(node1)
		node1.atmosinit()
		node1.addMember(src)
	node2 = nodes[2]
	if(node2)
		node2.atmosinit()
		node2.addMember(src)
	SSair.add_to_rebuild_queue(src)

/obj/machinery/atmospherics/components/binary/thermomachine/proc/disconnect_pipes()
	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]
	if(node1)
		if(src in node1.nodes) //Only if it's actually connected. On-pipe version would is one-sided.
			node1.disconnect(src)
		nodes[1] = null
	if(node2)
		if(src in node2.nodes) //Only if it's actually connected. On-pipe version would is one-sided.
			node2.disconnect(src)
		nodes[2] = null
	if(parents[1])
		nullifyPipenet(parents[1])
	if(parents[2])
		nullifyPipenet(parents[2])

/obj/machinery/atmospherics/components/binary/thermomachine/attackby_secondary(obj/item/item, mob/user, params)
	. = ..()
	if(panel_open && item.tool_behaviour == TOOL_WRENCH && !check_pipe_on_turf())
		if(default_unfasten_wrench(user, item))
			return SECONDARY_ATTACK_CONTINUE_CHAIN
	return SECONDARY_ATTACK_CONTINUE_CHAIN

/obj/machinery/atmospherics/components/binary/thermomachine/proc/check_pipe_on_turf()
	for(var/obj/machinery/atmospherics/device in get_turf(src))
		if(device == src)
			continue
		if(device.piping_layer == piping_layer)
			visible_message(span_warning("A pipe is hogging the ports, remove the obstruction or change the machine piping layer."))
			return TRUE
	return FALSE

/obj/machinery/atmospherics/components/binary/thermomachine/multitool_act(mob/living/user, obj/item/multitool/multitool)
	if(!istype(multitool))
		return
	if(panel_open && !anchored)
		piping_layer = (piping_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (piping_layer + 1)
		to_chat(user, span_notice("You change the circuitboard to layer [piping_layer]."))
		update_appearance()

/obj/machinery/atmospherics/components/binary/thermomachine/emag_act(mob/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		if(!do_after(user, 1 SECONDS, src))
			return
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(5, 0, src)
		sparks.attach(src)
		sparks.start()
		obj_flags |= EMAGGED
		user.visible_message(span_warning("You emag [src], overwriting thermal safety restrictions."))
		log_game("[key_name(user)] emagged [src] at [AREACOORD(src)], overwriting thermal safety restrictions.")

/obj/machinery/atmospherics/components/binary/thermomachine/emp_act()
	. = ..()
	if(!(obj_flags & EMAGGED))
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(5, 0, src)
		sparks.attach(src)
		sparks.start()
		obj_flags |= EMAGGED
		safeties = FALSE

/obj/machinery/atmospherics/components/binary/thermomachine/proc/check_explosion(temperature)
	if(temperature < THERMOMACHINE_SAFE_TEMPERATURE + 2000)
		return FALSE
	if(holding)
		user.put_in_hands(holding)
		holding = null
	if(new_tank)
		holding = new_tank
	update_appearance()
	return TRUE

/obj/machinery/atmospherics/components/binary/thermomachine/ui_status(mob/user)
	if(interactive)
		return ..()
	return UI_CLOSE

/obj/machinery/atmospherics/components/binary/thermomachine/ui_interact(mob/user, datum/tgui/ui)
	if(panel_open)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThermoMachine", name)
		ui.open()

/obj/machinery/atmospherics/components/binary/thermomachine/ui_data(mob/user)
	var/list/data = list()
	data["on"] = on
	data["cooling"] = cooling

	data["min"] = min_temperature
	data["max"] = max_temperature
	data["target"] = target_temperature
	data["initial"] = initial(target_temperature)

	var/datum/gas_mixture/air1 = airs[1]
	data["temperature"] = air1.temperature
	data["pressure"] = air1.return_pressure()

	data["holding"] = holding ? TRUE : FALSE
	data["tank_gas"] = FALSE
	if(holding && holding.air_contents.total_moles())
		data["tank_gas"] = TRUE
	data["use_env_heat"] = use_enviroment_heat
	data["skipping_work"] = skipping_work
	data["auto_thermal_regulator"] = auto_thermal_regulator
	return data

/obj/machinery/atmospherics/components/binary/thermomachine/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			use_power = on ? ACTIVE_POWER_USE : IDLE_POWER_USE
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("cooling")
			cooling = !cooling
			investigate_log("was changed to [cooling ? "cooling" : "heating"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("target")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("Set new target ([min_temperature]-[max_temperature] K):", name, target_temperature) as num|null
				if(!isnull(target))
					. = TRUE
			else if(adjust)
				target = target_temperature + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, min_temperature, max_temperature)
				investigate_log("was set to [target_temperature] K by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("pumping")
			if(holding && nodes[2])
				var/datum/gas_mixture/thermal_exchange_port = airs[2]
				var/datum/gas_mixture/remove = holding.air_contents.remove(holding.air_contents.total_moles())
				thermal_exchange_port.merge(remove)
				. = TRUE
		if("eject")
			if(holding)
				replace_tank(usr)
				. = TRUE
		if("use_env_heat")
			use_enviroment_heat = !use_enviroment_heat
			. = TRUE
		if("auto_thermal_regulator")
			auto_thermal_regulator = !auto_thermal_regulator
			. = TRUE

	update_appearance()

/obj/machinery/atmospherics/components/binary/thermomachine/CtrlClick(mob/living/user)
	if(!panel_open)
		if(!can_interact(user))
			return
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
		return
	. = ..()

/obj/machinery/atmospherics/components/binary/thermomachine/freezer
	icon_state = "freezer"
	icon_state_off = "freezer"
	icon_state_on = "freezer_1"
	icon_state_open = "freezer-o"
	cooling = TRUE

/obj/machinery/atmospherics/components/binary/thermomachine/freezer/on
	on = TRUE
	icon_state = "freezer_1"

/obj/machinery/atmospherics/components/binary/thermomachine/freezer/on/Initialize()
	. = ..()
	if(target_temperature == initial(target_temperature))
		target_temperature = min_temperature

/obj/machinery/atmospherics/components/binary/thermomachine/freezer/on/coldroom
	name = "Cold room temperature control unit"

/obj/machinery/atmospherics/components/binary/thermomachine/freezer/on/coldroom/Initialize()
	. = ..()
	target_temperature = COLD_ROOM_TEMP

/obj/machinery/atmospherics/components/binary/thermomachine/heater
	icon_state = "heater"
	icon_state_off = "heater"
	icon_state_on = "heater_1"
	icon_state_open = "heater-o"
	cooling = FALSE

/obj/machinery/atmospherics/components/binary/thermomachine/heater/on
	on = TRUE
	icon_state = "heater_1"
