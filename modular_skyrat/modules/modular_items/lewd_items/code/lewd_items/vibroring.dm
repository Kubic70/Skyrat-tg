///////////////
///Vibroring///
///////////////

/obj/item/clothing/sextoy/vibroring
	name = "vibrating ring"
	desc = "Used to keep erection"
	icon_state = "vibroring"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	var/toy_on = FALSE
	var/current_color = "pink"
	var/color_changed = FALSE
	var/static/list/vibroring_designs
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_PENIS

//create radial menu
/obj/item/clothing/sextoy/vibroring/proc/populate_vibroring_designs()
	vibroring_designs = list(
		"pink" = image(icon = src.icon, icon_state = "vibroring_pink_off"),
		"teal" = image(icon = src.icon, icon_state = "vibroring_teal_off"))

/obj/item/clothing/sextoy/vibroring/AltClick(mob/user, obj/item/I)
	if(color_changed == TRUE)
		toy_on = !toy_on
		to_chat(user, "<span class='notice'>You turned vibroring [toy_on? "on. Brrrr..." : "off."]</span>")
		playsound(user, toy_on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
		update_icon_state()
		update_icon()
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, vibroring_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change egg's model
/obj/item/clothing/sextoy/vibroring/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/sextoy/vibroring/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(vibroring_designs))
		populate_vibroring_designs()

/obj/item/clothing/sextoy/vibroring/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[toy_on? "on" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"

/obj/item/clothing/sextoy/vibroring/equipped(mob/user, slot, initial)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(src == H.penis)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibroring/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibroring/process(delta_time)
	. = ..()
	var/mob/living/carbon/human/U = loc
	var/obj/item/organ/genital/testicles/P = U.getorganslot(ORGAN_SLOT_PENIS)
	if(toy_on == TRUE)
		U.adjustArousal(1 * delta_time)
		U.adjustPleasure(1 * delta_time)
		if(P.aroused != AROUSAL_CANT)
			P.aroused = AROUSAL_FULL //Vibroring keep penis erected.
