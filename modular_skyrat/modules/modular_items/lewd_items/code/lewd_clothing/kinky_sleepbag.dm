/obj/item/clothing/suit/straight_jacket/kinky_sleepbag
	name = "latex sleepbag"
	desc = "Tight sleepbag made of shiny material. It's dangerous to put it on yourself."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_normal.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_normal.dmi'
	worn_icon_taur_snake = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_special.dmi'
	worn_icon_taur_paw = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_special.dmi'
	worn_icon_taur_hoof = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_special.dmi'
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
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 300
	breakouttime = 3000 //do not touch. First - It's contraband item, Second - It's damn expensive, Third - it's ERP item, so you can't legally use it on characters without enabled non-con.
	var/static/list/bag_inf_states
	var/list/bag_states = list("deflated" = "inflated", "inflated" = "deflated")
	var/state_thing = "deflated"
	var/mutable_appearance/bag_overlay
	slowdown = 2
	equip_delay_other = 300
	equip_delay_self = NONE
	worn_x_dimension = 64
	worn_y_dimension = 64
	clothing_flags = LARGE_WORN_ICON
	slot_flags = NONE

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
	switch(color_changed)
		if(FALSE)
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

		if(TRUE)
			if(bag_state == "deflated")
				fold()
				to_chat(user, "<span class='notice'>Sleepbag now is [bag_fold? "folded." : "unfolded."]</span>")
				update_icon()
				update_icon_state()
			else
				to_chat(user, "<span class='notice'>You can't inflate bag while it's folded")

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
	. = ..()
	icon_state = "[initial(icon_state)]_[bag_color]_[bag_state]_[bag_fold? "folded" : "unfolded"]"
	inhand_icon_state = "[initial(icon_state)]_[bag_color]_[bag_state]_[bag_fold? "folded" : "unfolded"]"

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/equipped(mob/user, slot)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(user) && slot == ITEM_SLOT_OCLOTHING)
		ADD_TRAIT(user, TRAIT_FLOORED, CLOTHING_TRAIT)
		if(bag_state == "inflated")
			to_chat(H,"<font color=purple>You realize that you can't move even an inch. Inflated sleepbag squeezes you from all sides.</font>")
			H.cut_overlay(H.overlays_standing[HEAD_LAYER])
		if(bag_state == "deflated")
			to_chat(H,"<font color=purple>You realize that moving now is much harder. You are fully restrainted, all struggles are useless.</font>")

		START_PROCESSING(SSobj, src)
		time_to_sound_left = time_to_sound
		H.remove_overlay(BODY_BEHIND_LAYER)
		H.remove_overlay(MUTATIONS_LAYER)
		H.remove_overlay(BODYPARTS_LAYER)

	appearance_update()
	. = ..()

	//Giving proper overlay
	bag_overlay.icon_state = icon_state
	update_overlays()
	. = ..()

//to inflate/deflate that thing
/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/attack_self(mob/user, obj/item/I)
	var/mob/living/carbon/human/H = user
	if(bag_fold == FALSE)
		toggle_mode()
		to_chat(H, "<span class='notice'>Sleepbag now is [bag_state? "inflated." : "deflated."]</span>")
		update_icon()
		update_icon_state()
	else
		to_chat(H, "<span class='notice'>You need to unfold the bag before inflating it.</span>")

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/fold(mob/user, src)
	bag_fold = !bag_fold
	playsound(user, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 40, TRUE)
	if(bag_fold == TRUE)
		w_class = WEIGHT_CLASS_SMALL
		slot_flags = NONE
	if(bag_fold == FALSE)
		w_class = WEIGHT_CLASS_HUGE
		slot_flags = ITEM_SLOT_OCLOTHING
	update_icon_state()
	update_icon()

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/toggle_mode()
	state_thing = bag_states[state_thing]
	switch(state_thing)
		if("deflated")
			bag_state = "deflated"
			breakouttime = 3000
			slowdown = 4 //moving like a caterpillar now
		if("inflated")
			bag_state = "inflated"
			breakouttime = 6000 //do not touch
			slowdown = 14 //it should be almost impossible to move in that thing, so this big slowdown have reasons.
	appearance_update()

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/dropped(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = usr
	if(src == H.wear_suit)
		REMOVE_TRAIT(user, TRAIT_FLOORED, CLOTHING_TRAIT)
		to_chat(usr,"<font color=purple>You are finally free! The tight bag no longer constricts your movements.</font>")
		STOP_PROCESSING(SSobj, src)
		H.apply_overlay(BODY_BEHIND_LAYER)
		H.apply_overlay(MUTATIONS_LAYER)
		H.apply_overlay(BODYPARTS_LAYER)
		H.add_overlay(H.overlays_standing[HEAD_LAYER])

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/process(delta_time)
	if(time_to_sound_left <= 0)
		if(tt <= 0)
			playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 100, TRUE)
			tt = rand(15,35) //to do random funny sounds when character inside that thing. haha.
		else
			tt -= delta_time
	else
		time_to_sound_left -= delta_time

/obj/item/clothing/suit/straight_jacket/kinky_sleepbag/proc/appearance_update()
	var/mob/living/carbon/human/H = usr
	if(H.dna.species.mutant_bodyparts["taur"])
		cut_overlay(bag_overlay)
		bag_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_special.dmi', "none", ABOVE_MOB_LAYER)
		add_overlay(bag_overlay)
		update_overlays()
	else
		cut_overlay(bag_overlay)
		bag_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/sleepbag_normal.dmi', "none", )
		add_overlay(bag_overlay)
		update_overlays()

	if(state_thing == "inflated" && src == H.wear_suit)
		H.remove_overlay(HAIR_LAYER)
		H.cut_overlay(H.overlays_standing[HEAD_LAYER])

//	if(state_thing == "deflated")
//		H.remove_overlay(HAIR_LAYER)
//		H.add_overlay(H.overlays_standing[HEAD_LAYER])
