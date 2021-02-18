/obj/item/clothing/suit/straight_jacket/kinky_sleepbag
	name = "latex sleepbag"
	desc = "Tight sleepbag made of shiny material. It's dangerous to put it on yourself."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	worn_icon_taur_snake = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	worn_icon_taur_paw = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	worn_icon_taur_hoof = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	mutant_variants = STYLE_DIGITIGRADE|STYLE_TAUR_ALL
	icon_state = "sleepbag"
	inhand_icon_state = "sleepbag"
	w_class = WEIGHT_CLASS_SMALL
	var/bag_state = "deflated"
	var/bag_fold = TRUE
	var/bag_color = "pink"
	var/color_changed = FALSE
	var/time_to_sound = 20
	var/time_to_sound_left
	var/time = 2
	var/tt
	var/static/list/bag_colors
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDEHAIR
	equip_delay_self = 300
	strip_delay = 300
	breakouttime = 3000 //do not touch. First - It's contraband item, Second - It's damn expensive, Third - it's ERP item, so you can't legally use it on characters without enabled non-con.
	var/static/list/bag_inf_states
	var/list/bag_states = list("deflated" = "inflated", "inflated" = "deflated")
	var/state_thing = "deflated"
	slowdown = 2
	actions_types = list(/datum/action/item_action/fold_bag)

//create radial menu
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/populate_bag_colors()
	bag_colors = list(
		"pink" = image (icon = src.icon, icon_state = "sleepbag_pink_deflated_folded"),
		"teal" = image(icon = src.icon, icon_state = "sleepbag_teal_deflated_folded"))

//radial menu for changing type
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/populate_bag_inf_states()
	bag_inf_states = list(
		"inflated" = image (icon = src.icon, icon_state = "sleepbag_pink_deflated_folded"),
		"deflated" = image(icon = src.icon, icon_state = "sleepbag_teal_deflated_folded"))

//to update model lol
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to change model
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, bag_colors, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		bag_color = choice
		update_icon()
		update_icon_state()
		color_changed = TRUE
	else
		return

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(bag_colors))
		populate_bag_colors()
	if(!length(bag_inf_states))
		populate_bag_inf_states()

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/update_icon_state()
	icon_state = "[initial(icon_state)]_[bag_color]_[bag_state]_[bag_fold? "folded" : "unfolded"]"
	inhand_icon_state = "[initial(icon_state)]_[bag_color]_[bag_state]_[bag_fold? "folded" : "unfolded"]"

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(user, TRAIT_FLOORED, CLOTHING_TRAIT)
		if(bag_state == "inflated")
			to_chat(usr,"<font color=purple>You realize that you can't move even an inch. Inflated sleepbag squeezes you from all sides.</font>")

		if(bag_state == "deflated")
			to_chat(usr,"<font color=purple>You realize that moving now is much harder. You are fully restrainted, all struggles are useless.</font>")

		START_PROCESSING(SSobj, src)
			time_to_sound_left = time_to_sound

//to inflate/deflate that thing
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/attack_self(mob/user, obj/item/I)
	if(bag_fold == FALSE)
		toggle_mode()
		to_chat(user, "<span class='notice'>Sleepbag now is [bag_state? "inflated." : "deflated."]</span>")
		update_icon()
		update_icon_state()
	else
		to_chat(usr, "<span class ='notice'> You can't infalte bag while its folded! </span>")
		return

//to fold that thing
/datum/action/item_action/fold_bag
    name = "Fold sleepbag"
    desc = "You can fold it to save space"

/datum/action/item_action/fold_bag/Trigger()
	var/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/H = target
	if(istype(H))
		H.check_fold()

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/check_fold()
	var/mob/living/carbon/human/C = usr
	var/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/H = src
	if(src == C.wear_suit)
		to_chat(usr, "<span class ='notice'> You can't fold bag when you strapped inside it! </span>")
	if(bag_state == "inflated")
		to_chat(usr, "<span class ='notice'> Sleepbag is inflated, you can't fold it! </span>")
	else
		fold(H)

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/fold(mob/user, src)
	bag_fold = !bag_fold
	to_chat(user, "<span class='notice'>Sleepbag now is [bag_fold? "folded." : "unfolded."]</span>")
	playsound(user, bag_fold ? 'sound/items/handling/cloth_pickup.ogg' : 'sound/items/handling/cloth_drop.ogg', 40, TRUE)
	if(bag_fold == TRUE)
		w_class = WEIGHT_CLASS_SMALL
	if(bag_fold == FALSE)
		w_class = WEIGHT_CLASS_HUGE
	update_icon_state()
	update_icon()

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/toggle_mode()
	state_thing = bag_states[state_thing]
	switch(state_thing)
		if("deflated")
			bag_state = "deflated"
			breakouttime = 3000
			slowdown = 2
		if("inflated")
			bag_state = "inflated"
			breakouttime = 6000 //do not touch
			slowdown = 10 //it should be almost impossible to move in that thing, so this big slowdown have reasons.

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_FLOORED, CLOTHING_TRAIT)
	to_chat(usr,"<font color=purple>You are finally free! The tight bag no longer constricts your movements.</font>")
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/process(delta_time)
	var/mob/living/U = loc
	if(time_to_sound_left <= 0)
		if(tt <= 0)
			playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 100, TRUE)
			tt = rand(15,35) //to do random funny sounds when character inside that thing. haha.
		else
			tt -= delta_time
	else
		time_to_sound_left -= delta_time
