/obj/structure/chair/milking_machine
	name = "Milking machine"
	desc = "Description here" // Lamella TODO: Description needed
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi'
	icon_state = "milking_pink_off"
	max_buckled_mobs = 1
	item_chair = null
	var/color_changed = FALSE
	var/static/list/milkingmachine_designs
	//////////////////////
	// Power management //
	//////////////////////
	var/obj/item/stock_parts/cell/cell = null
	// Lamella TODO: Values need to be calibrated to balance power management
	var/charge_rate = 200 // Power charge per tick devided by delta_time (always about ~2)
	var/power_draw_rate = 50 // Power draw per tick multiplied by delta_time (always about ~2)
	// Additional power consumption multiplier for different operating modes. Fractional value to reduce consumption
	var/power_draw_multiplier_list = list("off" = 0, "low" = 0.5, "medium" = 1, "hard" = 1.5)
	var/panel_open = FALSE

	/////////////////////////////
	// Machine operating modes //
	/////////////////////////////
	var/pump_state_list = list("pump_off","pump_on") // Удалить если не будет использоваться
	var/pump_state
	var/mode_list = list("off","low","medium","hard")
	var/current_mode

	/////////////////////////////////
	// Return sensation parameters //
	/////////////////////////////////
	// Values are returned every tick, without additional modifiers
	// Lamella TODO: Calibrate return sensation parameters for each mode of machine operation
	var/arousal_amounts = list("off" = 0, "low" = 1,"medium" = 2,"hard" = 3)
	var/pleasure_amounts = list("off" = 0, "low" = 1,"medium" = 2,"hard" = 3)
	var/pain_amounts = list("off" = 0, "low" = 0,"medium" = 1,"hard" = 2)

	//////////////////////
	// Fluid management //
	//////////////////////
	// Liquids are taken every tick, no additional modifiers
	// Lamella TODO: It is necessary to calibrate the values of the intake of liquids for all modes of operation of the machine
	var/milk_retrive_amount = list("off" = 0, "low" = 2,"medium" = 4,"hard" = 8)
	var/girlcum_retrive_amount = list("off" = 0, "low" = 2,"medium" = 4,"hard" = 8)
	var/semen_retrive_amount = list("off" = 0, "low" = 2,"medium" = 4,"hard" = 8)
	var/climax_retrive_multiplier = 2 // Climax intake volume multiplier

	//////////////////////////
	// Vessels and parameters //
	//////////////////////////
	var/max_vessel_capacity = 500
	var/obj/item/reagent_containers/current_milk
	var/obj/item/reagent_containers/current_girlcum
	var/obj/item/reagent_containers/current_semen
	var/obj/item/reagent_containers/current_vessel = null // Vessel selected in UI

	////////////////////////////////////////////
	// Work object link cache for the machine //
	////////////////////////////////////////////
	var/obj/item/organ/genital/current_organ = null // Organ selected in UI
	var/obj/item/reagent_containers/glass/beaker = null // Beaker inserted in machine
	var/mob/living/carbon/human/current_mob = null // Mob buckled to the machine
	var/obj/item/organ/genital/breasts/current_breasts = null // Buckled mob breasts
	var/obj/item/organ/genital/testicles/current_testicles = null // Buckled mob testicles
	var/obj/item/organ/genital/vagina/current_vagina = null // Buckled mob vagina

	// Variables for working with sizes and types of organs
	var/breasts_size = null
	var/breasts_count = null
	var/vagina_size = null
	var/testicles_size = null

	// Machine colors
	var/machine_color_list = list("pink","teal") // Применить ссылки на список везде, где можно
	var/machine_color

	//////////////////////////////////////////
	// Stuff for visualizing machine states //
	//////////////////////////////////////////
	// Cell power capacity indicator
	var/indicator_state_list = list("indicator_off","indicator_low","indicator_medium","indicator_high")
	var/indicator_state
	// Vessel capacity indicator
	var/vessel_state_list = list("liquid_empty","liquid_low","liquid_medium","liquid_high","liquid_full")
	var/vessel_state
	// Organ types and sizes
	var/organ_types = list()
	var/current_organ_type = null
	var/current_organ_size = null

	var/lock_state = "open"

	//////////////////////////
	// Overlay Object Cache //
	//////////////////////////
	var/mutable_appearance/vessel_overlay
	var/mutable_appearance/indicator_overlay
	var/mutable_appearance/locks_overlay
	var/mutable_appearance/panel_overlay
	var/mutable_appearance/cell_overlay
	var/mutable_appearance/organ_overlay
	var/organ_overlay_new_icon_state = "" // Organ overlay update optimization

	// Variables to block the rotation of the mob in the machine
	var/lastsaved_keybindings // Memory of the last saved binding list
	var/current_keybindings // Memory of the current binding list

// Additional examine text
/obj/structure/chair/milking_machine/examine(mob/user)
	. = ..()
	. +="<span class='notice'>Examine text here</span>" // Lamella TODO: Write examine text

// Object initialization
/obj/structure/chair/milking_machine/Initialize()
	. = ..()
	machine_color = machine_color_list[1]

	pump_state = pump_state_list[1]
	current_mode = mode_list[1]
	indicator_state = indicator_state_list[1]
	vessel_state = vessel_state_list[1]

	current_milk = new()
	current_milk.name = "MilkContainer"
	current_milk.reagents.maximum_volume = max_vessel_capacity
	current_girlcum = new()
	current_girlcum.name = "GirlcumContainer"
	current_girlcum.reagents.maximum_volume = max_vessel_capacity
	current_semen = new()
	current_semen.name = "SemenContainer"
	current_semen.reagents.maximum_volume = max_vessel_capacity
	current_vessel = current_milk

	vessel_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "liquid_empty", LYING_MOB_LAYER)
	vessel_overlay.name = "vessel_overlay"
	indicator_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "indicator_empty", ABOVE_MOB_LAYER + 0.1)
	indicator_overlay.name = "indicator_overlay"
	locks_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "locks_open", BELOW_MOB_LAYER)
	locks_overlay.name = "locks_overlay"
	panel_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "milking_panel_closed", LYING_MOB_LAYER)
	panel_overlay.name = "panel_overlay"
	cell_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "milking_cell_empty", ABOVE_MOB_LAYER)
	cell_overlay.name = "cell_overlay"
	organ_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi', "none", ABOVE_MOB_LAYER)
	organ_overlay.name = "organ_overlay"

	add_overlay(locks_overlay)
	add_overlay(vessel_overlay)

	update_all_visuals()
	populate_milkingmachine_designs()
	START_PROCESSING(SSobj, src)

////////////////////////////////
// Managing object appearance //
////////////////////////////////
// Define color options for the menu
/obj/structure/chair/milking_machine/proc/populate_milkingmachine_designs()
	milkingmachine_designs = list(
		"pink" = image(icon = src.icon, icon_state = "milking_pink_off"),
		"teal" = image(icon = src.icon, icon_state = "milking_teal_off"))

// Radial menu handler for color selection
/obj/structure/chair/milking_machine/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		if(.)
			return
		var/choice = show_radial_menu(user,src, milkingmachine_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		machine_color = choice
		update_icon()
		color_changed = TRUE
		return
	. = ..()

// Checking if we can use the menu
/obj/structure/chair/milking_machine/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

//////////////////////////////////////////////////////////
// Override block to change the standard chair behavior //
//////////////////////////////////////////////////////////
// Object cannot rotate
/obj/structure/chair/milking_machine/can_be_rotated(mob/user)
	return FALSE
// User cannot rotate the object
/obj/structure/chair/milking_machine/can_user_rotate(mob/user)
	return FALSE
// Another plug to disable rotation
/obj/structure/chair/milking_machine/attack_tk(mob/user)
	return FALSE
// Get the organs of the mob and visualize the change in machine
/obj/structure/chair/milking_machine/post_buckle_mob(mob/living/M)
	current_mob = M

	current_breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
	if(current_breasts)
		breasts_size = current_breasts.genital_size

	current_testicles = M.getorganslot(ORGAN_SLOT_TESTICLES)
	if(current_testicles)
		testicles_size = current_testicles.genital_size

	current_vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
	if(current_vagina)
		vagina_size = current_vagina.genital_size

	cut_overlay(locks_overlay)
	locks_overlay.icon_state = "locks_closed"
	locks_overlay.layer = ABOVE_MOB_LAYER
	add_overlay(locks_overlay)

	lastsaved_keybindings = M.client.movement_keys
	M.client.movement_keys = null
	var/mob/living/carbon/N = M
	N.set_usable_hands(0)

	update_overlays()
	M.layer = BELOW_MOB_LAYER
	update_all_visuals()
	return

// Clear the cache of the organs of the mob and update the state of the machine
/obj/structure/chair/milking_machine/post_unbuckle_mob(mob/living/M)

	current_mob = null
	current_organ = null
	current_breasts = null
	current_testicles = null
	current_vagina = null

	breasts_size = null
	breasts_count = null
	vagina_size = null
	testicles_size = null

	cut_overlay(organ_overlay)
	organ_overlay.icon_state = "none"

	cut_overlay(locks_overlay)
	locks_overlay.icon_state = "locks_open"
	locks_overlay.layer = BELOW_MOB_LAYER
	add_overlay(locks_overlay)

	current_mode = mode_list[1]
	pump_state = pump_state_list[1]

	M.client.movement_keys = lastsaved_keybindings
	current_keybindings = null
	lastsaved_keybindings = null

	var/mob/living/carbon/N = M

	N.set_usable_hands(2)

	M.layer = initial(M.layer)
	update_all_visuals()
	return

/obj/structure/chair/milking_machine/user_unbuckle_mob(mob/living/M, mob/user, check_loc = TRUE)

	if(M)
		if(M == user)
			// Have difficulty unbuckling if overly aroused
			if(M.arousal >= 60)
				if(current_mode != mode_list[1])
					to_chat(M, "You're too horny to get out on your own")
					// // Uncomment/Comment the block if you need to be able/unable to get out with high arousal
					// // Lamella TODO: Place for text about starting an attempt to get out when very aroused
					// if(do_after(user, 120 SECONDS,user))
					// 	unbuckle_mob(buckled_mobs[1])
					// 	// Lamella TODO: Place for text, after a successful attempt to get out with strong arousal from a switched on machine
					// 	return
					// else
					// 	// Lamella TODO: Place for text after a failed attempt to get out of the machine with great arousal
					// 	return
				else
					// Lamella TODO: Place for text about starting an attempt to get out when very aroused, but the machine is turned off

					if(do_after(M, 60 SECONDS,M))

						unbuckle_mob(M)
						// Lamella TODO: Place for text, after a successful attempt to get out of a turned off machine with strong arousal
						return
					else

						// Lamella TODO: Place for text after failing to get out of a turned off machine with great arousal
						return
			else
				// Lamella TODO: Place for text about starting an attempt to get out without being too aroused


				if(do_after(M, 5 SECONDS,M))
					unbuckle_mob(M)
					// Lamella TODO: Place for a text about successfully freeing yourself without being too aroused
					return
				else

					// Lamella TODO: Place for text about an unsuccessful attempt to get out of the machine without great arousal
					return
		else
			// unbuckle_mob(M)
	else
		.=..()
		return

//////////////////////////////////////
// Milking machine main logic block //
//////////////////////////////////////
// Empty Hand Attack Handler
/obj/structure/chair/milking_machine/attack_hand(mob/user)
	// If the panel is open and the hand is empty, then we take out the battery, otherwise standard processing
	if(panel_open && cell)
		user.put_in_hands(cell)
		cell.add_fingerprint(user)
		user.visible_message("<span class='notice'>[user] removes [cell] from [src].</span>", "<span class='notice'>You remove [cell] from [src].</span>")
		removecell()
		update_all_visuals()
		return
	// Block the ability to open the interface of the car if we are attached to it
	if(LAZYLEN(buckled_mobs))
		if(user == buckled_mobs[1])
			user_unbuckle_mob(user,user)
			return
	// Standard processing, open the machine interface
	. = ..()
	if(.)
		return
	return

// Attack handler for various item
/obj/structure/chair/milking_machine/attackby(obj/item/W, mob/user)
	// Beaker attack check
	if(istype(W, /obj/item/reagent_containers) && !(W.item_flags & ABSTRACT) && W.is_open_container())
		. = TRUE // No afterattack
		if(panel_open)
			to_chat(user, "<span class='warning'>You can't use the [src.name] while its panel is opened!</span>")
			return
		var/obj/item/reagent_containers/B = W
		. = TRUE // No afterattack
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add [B] to [src].</span>")
		updateUsrDialog()
	// Cell attack check
	if(istype(W, /obj/item/stock_parts/cell))
		if(panel_open)
			if(!anchored)
				to_chat(user, "<span class='warning'>[src] isn't attached to the ground!</span>")
				return
			if(cell)
				to_chat(user, "<span class='warning'>There is already a cell in [src]!</span>")
				return
			else
				var/area/a = loc.loc // Gets our locations location, like a dream within a dream
				if(!isarea(a))
					return
				if(!user.transferItemToLoc(W,src))
					cut_overlay(cell_overlay)
					cell_overlay.icon_state = "milking_cell_empty"
					update_all_visuals()
					return

				cell = W
				cut_overlay(cell_overlay)
				cell_overlay.icon_state = "milking_cell"
				add_overlay(cell_overlay)
				user.visible_message("<span class='notice'>[user] inserts a cell into [src].</span>", "<span class='notice'>You insert a cell into [src].</span>")
				update_all_visuals()
		else
			to_chat(user, "<span class='warning'>Maintenance panel [src] isn't opened!</span>")
			return
	else
		if(default_deconstruction_screwdriver(user, icon_state, icon_state, W))
			return
		if(default_deconstruction_crowbar(W))
			return
		if(!cell && default_unfasten_wrench(user, W))
			return
		return ..()

// Battery removal handler
/obj/structure/chair/milking_machine/proc/removecell()
	cell.update_icon()
	cell = null
	cut_overlay(cell_overlay)
	cut_overlay(indicator_overlay)
	cell_overlay.icon_state = "milking_cell_empty"
	current_mode = mode_list[1]
	pump_state = pump_state_list[1]
	update_all_visuals()

// Beaker change handler
/obj/structure/chair/milking_machine/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
		to_chat(user, "You took the beaker out of the machine")
	if(new_beaker)
		beaker = new_beaker
		to_chat(user, "You put the beaker in the machine")
	return TRUE

// We will try to take the item in our hand, if it doesn’t work, then drop it into the car tile
/obj/structure/chair/milking_machine/proc/try_put_in_hand(obj/object, mob/living/user)
	if(!issilicon(user) && in_range(src, user))
		user.put_in_hands(object)
	else
		object.forceMove(drop_location())

// Handler for opening the panel with a screwdriver for maintenance
/obj/structure/chair/milking_machine/proc/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/I)
	if(!(flags_1 & NODECONSTRUCT_1) && I.tool_behaviour == TOOL_SCREWDRIVER)
		I.play_tool_sound(src, 50)
		if(!panel_open)
			panel_open = TRUE
			cut_overlay(indicator_overlay)
			if(cell != null)
				cut_overlay(cell_overlay)
				cell_overlay.icon_state = "milking_cell"
				add_overlay(cell_overlay)
				update_all_visuals()
			cut_overlay(panel_overlay)
			panel_overlay.icon_state = "milking_panel"
			add_overlay(panel_overlay)
			to_chat(user, "<span class='notice'>You open the maintenance hatch of [src].</span>")
		else
			panel_open = FALSE
			cut_overlay(panel_overlay)
			panel_overlay.icon_state = "milking_panel_closed"
			update_all_visuals()
			add_overlay(indicator_overlay)
			cut_overlay(cell_overlay)
			cell_overlay.icon_state = "milking_cell_empty"

			to_chat(user, "<span class='notice'>You close the maintenance hatch of [src].</span>")

		return TRUE
	return FALSE

// Object disassembly handler by crowbar
/obj/structure/chair/milking_machine/proc/default_deconstruction_crowbar(obj/item/I, ignore_panel = 0)
	. = (panel_open || ignore_panel) && !(flags_1 & NODECONSTRUCT_1) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		deconstruct(TRUE)

// Machine Workflow Processor
/obj/structure/chair/milking_machine/process(delta_time)

	// We take away from the player the ability to move and rotate the mob
	mob_control_handler()

	// Battery self-charging process processing
	if (cell == null)
		current_mode = mode_list[1]
		pump_state = pump_state_list[1]
		update_all_visuals()
		return
	cell.give(charge_rate / delta_time)

	// Check if the machine should work
	if(!current_mob)
		update_all_visuals()
		return // Doesn't work without a mob
	if(current_organ == null || current_mode == mode_list[1])
		update_all_visuals()
		return // Does not work if an organ is not connected OR the machine is not switched to On
	if(istype(current_organ,/obj/item/organ/genital/breasts))
		if(current_milk.reagents.total_volume == max_vessel_capacity)
			current_mode = mode_list[1]
			pump_state = pump_state_list[1]
			update_all_visuals()
			return
	if(istype(current_organ,/obj/item/organ/genital/vagina))
		if(current_girlcum.reagents.total_volume == max_vessel_capacity)
			current_mode = mode_list[1]
			pump_state = pump_state_list[1]
			update_all_visuals()
			return
	if(istype(current_organ,/obj/item/organ/genital/testicles))
		if(current_semen.reagents.total_volume == max_vessel_capacity)
			current_mode = mode_list[1]
			pump_state = pump_state_list[1]
			update_all_visuals()
			return
	if(current_mode == mode_list[1])
		pump_state = pump_state_list[1]
		update_all_visuals()
		return
	// The machine can work

	if(cell != null && current_mode != mode_list[1])
		pump_state = pump_state_list[2]
		retrive_liquids()
		return_influence()
		draw_power(delta_time)
	else
		current_mode = mode_list[1]
		pump_state = pump_state_list[1]
	update_all_visuals()

// Mob player control handler
/obj/structure/chair/milking_machine/proc/mob_control_handler()

	if(LAZYLEN(buckled_mobs))
		var/mob/living/M = buckled_mobs[1]
		current_keybindings = M.client.movement_keys
		if(current_keybindings == null)
			return
		else
			lastsaved_keybindings = current_keybindings
			M.client.movement_keys = null
			return

// Liquid intake handler
/obj/structure/chair/milking_machine/proc/retrive_liquids()
	// Climax check
	var/X = 1
	if(current_mob != null)
		if(current_mob.has_status_effect(/datum/status_effect/climax))
			X = climax_retrive_multiplier

	if(istype(current_organ, /obj/item/organ/genital/breasts))
		if(current_organ.reagents.total_volume > 0)
			current_organ.internal_fluids.trans_to(current_milk, milk_retrive_amount[current_mode] * X)
		else
			return
	else if (istype(current_organ, /obj/item/organ/genital/vagina))
		if(current_organ.reagents.total_volume > 0)
			current_organ.internal_fluids.trans_to(current_girlcum, girlcum_retrive_amount[current_mode] * X)
		else
			return
	else if (istype(current_organ, /obj/item/organ/genital/testicles))
		if(current_organ.reagents.total_volume > 0)
			current_organ.internal_fluids.trans_to(current_semen, semen_retrive_amount[current_mode] * X)
		else
			return
	else
		// A place for a handler for missing genitals
		return

// Handling the process of the impact of the machine on the organs of the mob
/obj/structure/chair/milking_machine/proc/return_influence()
	src.current_mob.adjustArousal(src.arousal_amounts[src.current_mode])
	src.current_mob.adjustPleasure(src.pleasure_amounts[src.current_mode])
	src.current_mob.adjustPain(src.pain_amounts[src.current_mode])

// Energy consumption processor
/obj/structure/chair/milking_machine/proc/draw_power(delta_time)
	if(cell == null)
		current_mode = mode_list[1]
		pump_state = pump_state_list[1]
		return

	var/amount_power_draw =  power_draw_rate * delta_time * power_draw_multiplier_list[current_mode]
	if (cell.charge > amount_power_draw) // There is enough charge
		cell.use(amount_power_draw) // Power consumption
		return
	else
		cell.charge = 0 // At this tick, the charge dropped to zero
		current_mode = mode_list[1]	// Turn off the machine
		pump_state = pump_state_list[1]
		return

// Drag and drop mob buckle handler into the machine
/obj/structure/chair/milking_machine/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(.)
		if(istype(src, /mob/living/) && istype(over_object, /obj/structure/chair/milking_machine))
			var/mob/living/M = src
			var/obj/structure/chair/milking_machine/MM = over_object
			if(M.getorganslot(ORGAN_SLOT_TESTICLES))
				MM.current_testicles = M.getorganslot(ORGAN_SLOT_TESTICLES)
			if(M.getorganslot(ORGAN_SLOT_VAGINA))
				MM.current_vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
			if(M.getorganslot(ORGAN_SLOT_BREASTS))
				MM.current_breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
			else
				// A place for the handler when the mob doesn't have the genitals it needs
				return
		else
			// A place to handle the case when a non-living mob was dragged
			return
	else
		// The mob for some reason did not get buckled, we do nothing
		return

// Machine deconstruction process handler
/obj/structure/chair/milking_machine/deconstruct()
	if(LAZYLEN(buckled_mobs))
		var/mob/living/M = buckled_mobs[1]
		M.client.movement_keys = lastsaved_keybindings
		var/mob/living/carbon/N = M
		// N.set_handcuffed(null)
		N.set_usable_hands(2)
	replace_beaker()
	STOP_PROCESSING(SSobj, src)
	if(cell)
		cell.forceMove(drop_location())
		adjust_item_drop_location(cell)
		cell = null
		update_all_visuals()
	return ..()

// Handler of the process of dispensing a glass from a machine to a tile
/obj/structure/chair/milking_machine/proc/adjust_item_drop_location(atom/movable/AM)
	if (AM == beaker)
		AM.pixel_x = AM.base_pixel_x - 8
		AM.pixel_y = AM.base_pixel_y + 8
		return null
	else if (AM == cell)
		AM.pixel_x = AM.base_pixel_x - 8
		AM.pixel_y = AM.base_pixel_y - 8
		return null
	else
		var/md5 = md5(AM.name)
		for (var/i in 1 to 32)
			. += hex2num(md5[i])
		. = . % 9
		AM.pixel_x = AM.base_pixel_x + ((.%3)*6)
		AM.pixel_y = AM.base_pixel_y - 8 + (round( . / 3)*8)

// General handler for calling redrawing of the current state of the machine
/obj/structure/chair/milking_machine/proc/update_all_visuals()

	if(current_organ != null)
		cut_overlay(organ_overlay)
		organ_overlay_new_icon_state = null
		if(istype(current_organ, /obj/item/organ/genital/breasts))
			if(current_organ.genital_type == "pair")
				current_organ_type = "double_breast"
				current_organ_size = current_organ.genital_size
			if(current_organ.genital_type == "quad")
				current_organ_type = "quad_breast"
				current_organ_size = current_organ.genital_size
			if(current_organ.genital_type == "sextuple")
				current_organ_type = "six_breast"
				current_organ_size = current_organ.genital_size
			if (current_mode == mode_list[1])
				pump_state = pump_state_list[1]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]_[current_organ_size]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state
			else
				pump_state = pump_state_list[2]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]_[current_organ_size]_[current_mode]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state

		if(istype(current_organ, /obj/item/organ/genital/testicles))
			current_organ_type = "penis"
			current_organ_size = current_organ.genital_size
			if(current_mode == mode_list[1])
				pump_state = pump_state_list[1]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state
			else
				pump_state = pump_state_list[2]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]_[current_mode]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state

		if(istype(current_organ, /obj/item/organ/genital/vagina))
			current_organ_type = "vagina"
			current_organ_size = current_organ.genital_size
			if(current_mode == mode_list[1])
				pump_state = pump_state_list[1]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state
			else
				pump_state = pump_state_list[2]
				organ_overlay_new_icon_state = "[current_organ_type]_[pump_state]_[current_mode]"
				if(organ_overlay.icon_state != organ_overlay_new_icon_state)
					organ_overlay.icon_state = organ_overlay_new_icon_state
		add_overlay(organ_overlay)
	else
		cut_overlay(organ_overlay)
		organ_overlay.icon_state = "none"

	// Processing changes in the capacity overlay
	// Lamella TODO: Calibrate vessel indicator value ranges
	cut_overlay(vessel_overlay)
	var/T = (current_milk.reagents.total_volume + current_girlcum.reagents.total_volume + current_semen.reagents.total_volume) / 3
	if(T == 0)
		if(vessel_overlay.icon_state != vessel_state_list[1])
			vessel_overlay.icon_state = vessel_state_list[1]
	if(T >= 0 && T < 50)
		if(vessel_overlay.icon_state != vessel_state_list[2])
			vessel_overlay.icon_state = vessel_state_list[2]
	if(T >= 50 && T < 350)
		if(vessel_overlay.icon_state != vessel_state_list[3])
			vessel_overlay.icon_state = vessel_state_list[3]
	if(T >= 350 && T < 500)
		if(vessel_overlay.icon_state != vessel_state_list[4])
			vessel_overlay.icon_state = vessel_state_list[4]
	if(T == 500)
		if(vessel_overlay.icon_state != vessel_state_list[5])
			vessel_overlay.icon_state = vessel_state_list[5]
	add_overlay(vessel_overlay)

	// Indicator state control
	if(cell != null)
		// Lamella TODO: Calibrate indicator ranges of values
		var/X = round(cell.charge / cell.maxcharge, 0.01)*100
		if(X >= 0 && X < 25)
			if(indicator_overlay.icon_state != indicator_state_list[2])
				cut_overlay(indicator_overlay)
				indicator_overlay.icon_state = indicator_state_list[2]
				if(!panel_open)
					add_overlay(indicator_overlay)
		if(X >= 25 && X < 75)
			if(indicator_overlay.icon_state != indicator_state_list[3])
				cut_overlay(indicator_overlay)
				indicator_overlay.icon_state = indicator_state_list[3]
				if(!panel_open)
					add_overlay(indicator_overlay)
		if(X >= 75 && X <= 100)
			if(indicator_overlay.icon_state != indicator_state_list[4])
				cut_overlay(indicator_overlay)
				indicator_overlay.icon_state = indicator_state_list[4]
				if(!panel_open)
					add_overlay(indicator_overlay)
	else
		cut_overlay(indicator_overlay)

	icon_state = "milking_[machine_color]_[current_mode]"

	update_overlays()
	update_icon_state()
	update_icon()

////////////////////////////////////////////////////
/// Milking machine interface handler block ///
////////////////////////////////////////////////////
// Handler for clicking an empty hand on a machine
/obj/structure/chair/milking_machine/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	// // Standard behavior. Uncomment for UI debugging
	// if(!ui)
	// 	ui = new(user, src, "MilkingMachine", name)
	// 	ui.open()
	// ///////////////////////////////////////////////////////////

	//Block the interface if we are in the machine. Use in production
	if(LAZYLEN(buckled_mobs))
		if(user != src.buckled_mobs[1])
			if(!ui)
				ui = new(user, src, "MilkingMachine", name)
				ui.open()
				return
		else if(ui)
			ui.close()
			return
	else if(!ui)
		ui = new(user, src, "MilkingMachine", name)
		ui.open()
		return
	///////////////////////////////////////

// Interface data filling handler
/obj/structure/chair/milking_machine/ui_data(mob/user)
	var/list/data = list()
	data["mobName"] = current_mob ? current_mob.name : null
	data["mobCanLactate"] = current_breasts ? current_breasts.lactates : null
	data["cellName"] = cell ? cell.name : null
	data["cellMaxCharge"] = cell ? cell.maxcharge : null
	data["cellCurrentCharge"] = cell ? cell.charge : null
	data["beaker"] = beaker ? beaker : null
	data["BeakerName"] = beaker ? beaker.name : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["mode"] = current_mode
	data["milkTankMaxVolume"] = max_vessel_capacity
	data["milkTankCurrentVolume"] = current_milk ? current_milk.reagents.total_volume : null
	data["girlcumTankMaxVolume"] = max_vessel_capacity
	data["girlcumTankCurrentVolume"] = current_girlcum ? current_girlcum.reagents.total_volume : null
	data["semenTankMaxVolume"] = max_vessel_capacity
	data["semenTankCurrentVolume"] = current_semen ? current_semen.reagents.total_volume : null
	data["current_vessel"] = current_vessel ? current_vessel : null
	data["current_organ"] = current_organ ? current_organ : null
	data["current_organ_name"] = current_organ ? current_organ.name : null
	data["current_breasts"] = current_breasts ? current_breasts : null
	data["current_testicles"] = current_testicles ? current_testicles : null
	data["current_vagina"] = current_vagina ? current_vagina : null
	data["machine_color"] = machine_color
	updateUsrDialog()
	return data

// User action handler in the interface
/obj/structure/chair/milking_machine/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "ejectCreature")
		unbuckle_mob(current_mob)
		to_chat(usr,"You ecject creature from the machine") //Lamella TODO
		return TRUE

	if(action == "ejectBeaker")
		replace_beaker(usr)
		update_all_visuals()
		return TRUE

	if(action == "setOffMode")
		current_mode = mode_list[1]
		pump_state = pump_state_list[1]
		update_all_visuals()
		to_chat(usr,"You turn off the machine")
		return TRUE

	if(action == "setLowMode")
		current_mode = mode_list[2]
		pump_state = pump_state_list[2]
		update_all_visuals()
		to_chat(usr,"You switched the machine in Low mode")
		return TRUE

	if(action == "setMediumMode")
		current_mode = mode_list[3]
		pump_state = pump_state_list[2]
		update_all_visuals()
		to_chat(usr,"You switched the machine in Medium mode")
		return TRUE

	if(action == "setHardMode")
		current_mode = mode_list[4]
		pump_state = pump_state_list[2]
		update_all_visuals()
		to_chat(usr,"You switched the machine in Hard mode")
		return TRUE

	if(action == "unplug")
		cut_overlay(organ_overlay)
		current_mode = mode_list[1]
		pump_state = pump_state_list[1]
		current_organ = null
		update_all_visuals()
		to_chat(usr,"You detach liner from organs")
		return TRUE

	if(action == "setBreasts")
		current_organ = current_breasts
		update_all_visuals()
		to_chat(usr,"You attach liner to the breasts")
		return TRUE

	if(action == "setVagina")
		current_organ = current_vagina
		update_all_visuals()
		to_chat(usr,"You attach liner to the vagina")
		return TRUE

	if(action == "setTesticles")
		current_organ = current_testicles
		update_all_visuals()
		to_chat(usr,"You attach liner to the testicles")
		return TRUE

	if(action == "setMilk")
		current_vessel = current_milk
		update_all_visuals()
		return TRUE

	if(action == "setGirlcum")
		current_vessel = current_girlcum
		update_all_visuals()
		return TRUE

	if(action == "setSemen")
		current_vessel = current_semen
		update_all_visuals()
		return TRUE

	if(action == "transfer")
		if (!beaker)
			return FALSE

		var/amount = text2num(params["amount"])
		current_vessel.reagents.trans_to(beaker, amount)
		current_milk.reagents.reagent_list[1].name
		update_all_visuals()
		to_chat(usr,"You transfer [amount] of [current_milk.reagents.reagent_list[1].name] to [beaker.name]")
		return TRUE

