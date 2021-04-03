/obj/item/clothing/ears/kinky_headphones
	name = "kinky_headphones"
	desc = "Protects your hearing from loud noises, looks like it have switch on right side..."
	icon_state = "kinkphones"
	inhand_icon_state = "kinkphones"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_ears.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_ears.dmi'
	strip_delay = 15
	equip_delay_other = 25
	custom_price = PAYCHECK_ASSISTANT * 2
	var/kinky_headphones_on = FALSE
	var/current_kinkphones_color = "pink"
	var/color_changed = FALSE
	var/static/list/kinkphones_designs
	actions_types = list(/datum/action/item_action/toggle_kinky_headphones)
	slot_flags = ITEM_SLOT_EARS | ITEM_SLOT_HEAD | ITEM_SLOT_NECK
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'

//create radial menu
/obj/item/clothing/ears/kinky_headphones/proc/populate_kinkphones_designs()
	kinkphones_designs = list(
		"pink"    = image (icon = src.icon, icon_state = "kinkphones_pink_on"),
		"teal"      = image(icon = src.icon, icon_state = "kinkphones_teal_on"))

//to prevent hearing and e.t.c
/obj/item/clothing/ears/kinky_headphones/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/earhealing)
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
	AddElement(/datum/element/update_icon_updates_onmob)

//to change model
/obj/item/clothing/ears/kinky_headphones/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, kinkphones_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_kinkphones_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change kinkphones's model
/obj/item/clothing/ears/kinky_headphones/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

//we equipping it so we deaf now
/obj/item/clothing/ears/kinky_headphones/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_EARS)
		if(kinky_headphones_on == FALSE)
			ADD_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
			to_chat(usr,"<font color=purple>You can barely hear anything! Other sensations have escalated...</font>")
		if(kinky_headphones_on == TRUE)
			ADD_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
			to_chat(usr,"<font color=purple>Strange, but relaxing music fills your mind. You feel so... Calm.</font>")

//we dropping item so we not deaf now. hurray.
/obj/item/clothing/ears/kinky_headphones/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
	to_chat(usr,"<font color=purple>Finally you can hear the world around again.</font>")


//to make it change model on click

/obj/item/clothing/ears/kinky_headphones/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(kinkphones_designs))
		populate_kinkphones_designs()

/obj/item/clothing/ears/kinky_headphones/proc/update_icon_state()
	. = ..()
	update_icon_state()
	icon_state = "[initial(icon_state)]_[current_kinkphones_color]_[kinky_headphones_on? "on" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[current_kinkphones_color]_[kinky_headphones_on? "on" : "off"]"

/obj/item/clothing/ears/kinky_headphones/proc/toggle(owner)
	kinky_headphones_on = !kinky_headphones_on
	update_icon()
	to_chat(owner, "<span class='notice'>You turn the music [kinky_headphones_on? "on. It plays relaxing music" : "off."]</span>")

/datum/action/item_action/toggle_kinky_headphones
	name = "Toggle kinky headphones"
	desc = "Plays some nice relaxing music"

/datum/action/item_action/toggle_kinky_headphones/Trigger()
	var/obj/item/clothing/ears/kinky_headphones/H = target
	if(istype(H))
		H.toggle(owner)
