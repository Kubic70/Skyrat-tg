/obj/item/clothing/under/costume/maid/lewdmaid
	name = "latex maid costume"
	desc = "Maid costume for fetish reasons."
	icon_state = "lewdmaid"
	inhand_icon_state = "lewdmaid"
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/costume/maid/lewdmaid/Initialize()
	. = ..()
	var/obj/item/clothing/accessory/maidapron/lewdapron/B = new (src)
	attach_accessory(B)

/obj/item/clothing/accessory/maidapron/lewdapron
	name = "shiny maid apron"
	desc = "The best part of a maid costume. Now with different colors!"
	icon_state = "lewdapron"
	inhand_icon_state = "lewdapron"
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	minimize_when_attached = FALSE
	attachment_slot = null
	var/color_changed = FALSE
	var/current_color = "red"
	var/static/list/apron_designs

//create radial menu
/obj/item/clothing/accessory/maidapron/lewdapron/proc/populate_apron_designs()
	apron_designs = list(
		"red" = image (icon = src.icon, icon_state = "lewdapron_red"),
		"green" = image (icon = src.icon, icon_state = "lewdapron_green"),
		"pink" = image (icon = src.icon, icon_state = "lewdapron_pink"),
		"teal" = image(icon = src.icon, icon_state = "lewdapron_teal"),
		"yellow" = image (icon = src.icon, icon_state = "lewdapron_yellow"))

//to update model lol
/obj/item/clothing/accessory/maidapron/lewdapron/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to change model
/obj/item/clothing/accessory/maidapron/lewdapron/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, apron_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change kinkphones's model
/obj/item/clothing/accessory/maidapron/lewdapron/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/accessory/maidapron/lewdapron/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(apron_designs))
		populate_apron_designs()

/obj/item/clothing/accessory/maidapron/lewdapron/update_icon_state()
	icon_state = icon_state = "[initial(icon_state)]_[current_color]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"
