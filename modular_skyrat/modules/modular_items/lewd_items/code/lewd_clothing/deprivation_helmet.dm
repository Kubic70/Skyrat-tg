//seems like it kinda SPACE helmet. So probably abusable, but not really.
//If you want to make it less abusable and remove from helmet/space to just /helmet/ - please, add code that removes hair on use. Because we weren't able to do that.

/obj/item/clothing/head/helmet/space/deprivation_helmet
	name = "deprivation helmet"
	desc = "Сompletely cuts the wearer from the outside world."
	icon_state = "dephelmet"
	inhand_icon_state = "dephelmet"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_hats.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_hats.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_flags = SNUG_FIT
	var/color_changed = FALSE
	//these three vars needed to turn deprivation stuff on or off
	var/muzzle = FALSE
	var/earmuffs = FALSE
	var/prevent_vision = FALSE
		//
	var/current_helmet_color = "pink"
	var/static/list/helmet_designs
	var/static/list/functions

//create radial menu
/obj/item/clothing/head/helmet/space/deprivation_helmet/proc/populate_helmet_designs()
	helmet_designs = list(
		"pink" = image(icon = src.icon, icon_state = "dephelmet_pink"),
		"teal" = image(icon = src.icon, icon_state = "dephelmet_teal"),
		"pinkn" = image(icon = src.icon, icon_state = "dephelmet_pinkn"),
		"tealn" = image(icon = src.icon, icon_state = "dephelmet_tealn"))

/obj/item/clothing/head/helmet/space/deprivation_helmet/proc/populate_functions()
	functions = list(
		"muzzle" = image(icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_masks.dmi', icon_state = "ballgag_pink"),
		"earmuffs" = image(icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_ears.dmi', icon_state = "kinkphones_pink_off"),
		"prevent vision" = image(icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_eyes.dmi', icon_state = "kblindfold_pink"))

//to update model
/obj/item/clothing/head/helmet/space/deprivation_helmet/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to change model
/obj/item/clothing/head/helmet/space/deprivation_helmet/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, helmet_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_helmet_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change helmet's model
/obj/item/clothing/head/helmet/space/deprivation_helmet/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/head/helmet/space/deprivation_helmet/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(helmet_designs))
		populate_helmet_designs()
	if(!length(functions))
		populate_functions()

//updating both and icon in hands and icon worn
/obj/item/clothing/head/helmet/space/deprivation_helmet/update_icon_state()
	icon_state = icon_state = "[initial(icon_state)]_[current_helmet_color]"
	inhand_icon_state = "[initial(icon_state)]_[current_helmet_color]"

//here goes code that makes this thing prevent hearing || blocking vision || speaking
/obj/item/clothing/head/helmet/space/deprivation_helmet/attack_self(mob/user, obj/item/I)

//Ребята, сделайте тут коннект кнопок из списка с функциями которые я сделаю ниже пожшшалуйста.
//to change restrictions options
/obj/item/clothing/head/helmet/space/deprivation_helmet/attack_self(mob/user, obj/item/I)
//	if(color_changed == FALSE)
//		. = ..()
//		if(.)
//			return
//		var/choice = show_radial_menu(user,src, helmet_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
//		if(!choice)
//			return FALSE
//		current_helmet_color = choice
//		update_icon()
//		color_changed = TRUE
//	else
//		return

//Here goes code that applies stuff on the wearer
/obj/item/clothing/head/helmet/space/deprivation_helmet/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HEAD)
		return
	if(muzzle == TRUE)
		ADD_TRAIT(user, TRAIT_MUTE, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>Something gagged your mouth! You can't make a single a sound...</font>")
	if(earmuffs == TRUE)
		ADD_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>You can barely hear anything! Other sensations have escalated...</font>")
	if(prevent_vision == TRUE)
		ADD_TRAIT(user, TRAIT_BLIND, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>Helmet is blocking your vision! You feel yourself so helpless...</font>")

//Here goes code that heals the wearer after unequipping helmet
/obj/item/clothing/head/helmet/space/deprivation_helmet/dropped(mob/living/carbon/human/user)
	. = ..()
	if(muzzle == TRUE)
		REMOVE_TRAIT(user, TRAIT_MUTE, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>Your mouth is free. you breathe out with relief.</font>")
	if(earmuffs == TRUE)
		REMOVE_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>Finally you can hear the world around again.</font>")
	if(prevent_vision == TRUE)
		REMOVE_TRAIT(user, TRAIT_BLIND, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>Helmet no longer restricts your vision.</font>")
