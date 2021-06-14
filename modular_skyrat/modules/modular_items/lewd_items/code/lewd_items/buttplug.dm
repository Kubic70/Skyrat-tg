/obj/item/clothing/sextoy/buttplug
	name = "buttplug"
	desc = "Uhh... Again, WHERE i supposed to put that?!"
	icon_state = "buttplug"
	worn_icon_state = "buttplug"
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	slot_flags = ITEM_SLOT_ANUS|ITEM_SLOT_VAGINA
	var/current_color = "pink"
	var/current_size = "small"
	light_color = LIGHT_COLOR_ELECTRIC_GREEN
	var/color_changed = FALSE
	var/form_changed = FALSE
	var/static/list/buttplug_designs
	var/static/list/buttplug_forms
	w_class = WEIGHT_CLASS_TINY

//create radial menu
/obj/item/clothing/sextoy/buttplug/proc/populate_buttplug_designs()
	buttplug_designs = list(
		"pink" = image(icon = src.icon, icon_state = "buttplug_pink_small"),
		"teal" = image(icon = src.icon, icon_state = "buttplug_teal_small"),
		"tail" = image(icon = src.icon, icon_state = "buttplug_tail_small"),
		"yellow" = image(icon = src.icon, icon_state = "buttplug_yellow_small"),
		"metal" = image(icon = src.icon, icon_state = "buttplug_metal_small"),
		"green" = image(icon = src.icon, icon_state = "buttplug_green_small"))

/obj/item/clothing/sextoy/buttplug/proc/populate_buttplug_forms()
	buttplug_forms = list(
		"small" = image(icon = src.icon, icon_state = "buttplug_pink_small"),
		"medium" = image(icon = src.icon, icon_state = "buttplug_pink_medium"),
		"big" = image(icon = src.icon, icon_state = "buttplug_pink_big"))

/obj/item/clothing/sextoy/buttplug/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, buttplug_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		if(choice == "green")
			set_light(1)
			update_light()
		color_changed = TRUE
	if(color_changed == TRUE)
		if(form_changed == FALSE)
			. = ..()
			if(.)
				return
			var/choice = show_radial_menu(user,src, buttplug_forms, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
			if(!choice)
				return FALSE
			current_size = choice
			update_icon()
			form_changed = TRUE
	else
		return

//to check if we can change buttplug model
/obj/item/clothing/sextoy/buttplug/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/sextoy/buttplug/Initialize()
	. = ..()
	set_light(0)
	update_light()
	update_icon_state()
	update_icon()
	if(!length(buttplug_designs))
		populate_buttplug_designs()
	if(!length(buttplug_forms))
		populate_buttplug_forms()

/obj/item/clothing/sextoy/buttplug/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[current_size]"
	worn_icon_state = "[initial(icon_state)]_[current_color]"
