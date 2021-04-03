//Ok, shortly the idea is - almost all forms similar EXCEPT ONE THING - polychromic form.
//It changes the whole item and it's stuff. Why? Because i dumb and stupid, i don't want to make 2-th dildo item.

/obj/item/dildo
	name = "dildo"
	desc = "Uhh... What a jiggly thing."
	icon_state = "dildo"
	inhand_icon_state = "dildo"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	var/poly_size = "small"
	var/is_polychromic = FALSE
	var/list/poly_colors = list("FFF", "F88", "888")
	var/current_color = "pink"
	var/color_changed = FALSE
	var/size_changed = FALSE
	var/static/list/dildo_designs
	var/static/list/dildo_sizes
	w_class = WEIGHT_CLASS_TINY

//radial menu for sizes
/obj/item/dildo/proc/populate_dildo_sizes()
	dildo_sizes = list(
		"small" = image (icon = src.icon, icon_state = "dildo_poly_small"),
		"medium" = image(icon = src.icon, icon_state = "dildo_poly_medium"),
		"big" = image(icon = src.icon, icon_state = "dildo_poly_big"))

//create radial menu
/obj/item/dildo/proc/populate_dildo_designs()
	dildo_designs = list(
		"avian" = image (icon = src.icon, icon_state = "dildo_avian"),
		"canine" = image(icon = src.icon, icon_state = "dildo_canine"),
		"equine" = image(icon = src.icon, icon_state = "dildo_equine"),
		"dragon" = image(icon = src.icon, icon_state = "dildo_dragon"),
		"human" = image(icon = src.icon, icon_state = "dildo_human"),
		"tentacle" = image(icon = src.icon, icon_state = "dildo_tentacle"))

/obj/item/dildo/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, dildo_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	if(color_changed == TRUE)
		if(size_changed == FALSE)
			. = ..()
			if(.)
				return
			var/choice = show_radial_menu(user,src, dildo_sizes, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
			if(!choice)
				return FALSE
			poly_size = choice
			update_icon()
			size_changed = TRUE
	else
		return

//for that one cool polychromic form.
//i hate polychromics, hue-shifting better, but they wanted it - i made it.
/obj/item/dildo/ComponentInitialize()
	. = ..()
	if(is_polychromic == TRUE)
		AddElement(/datum/element/polychromic, poly_colors)

//to check if we can change vibrator's model
/obj/item/dildo/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/dildo/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(dildo_designs))
		populate_dildo_designs()
	if(!length(dildo_sizes))
		populate_dildo_sizes()

/obj/item/dildo/update_icon_state()
	. = ..()
	switch(is_polychromic)
		if(FALSE)
			icon_state = "[initial(icon_state)]_[current_color]"
			inhand_icon_state = "[initial(icon_state)]_[current_color]"
		if(TRUE)
			icon_state = "[initial(icon_state)]_[current_color]_[poly_size]"
			inhand_icon_state = "[initial(icon_state)]_[current_color]_[poly_size]"

/obj/item/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	switch(user.zone_selected) //to let code know what part of body we gonna tickle
		if(BODY_ZONE_PRECISE_GROIN)
			if(M.is_bottomless())
				var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
				if(vagina)
					message = (user == M) ? pick("rubs their vagina with the [src]","gently jams their pussy with [src]","fucks their vagina with a [src]") : pick("delicately rubs [M]'s vagina with [src]", "uses [src] to fuck [M]'s vagina","jams [M]'s pussy with a [src]", "teasing [M]'s pussy with a [src]")
					//M.adjustArous(6,8)
					M.adjustArousal(6)
					M.adjustPleasure(8)

					if(prob(40))
						M.emote(pick("twitch_s","moan"))
					user.visible_message("<font color=purple>[user] [message].</font>")
					playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 60, TRUE)
				else
					user.visible_message("<span class='danger'>Looks like [M] don't have suitable organs for that!</span>")
					return

			else
				user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
				return

		if(BODY_ZONE_HEAD) //Mouth only. Sorry, perverts. No eye/ear penetration for you today.
			if(!M.is_mouth_covered())
				message = (user == M) ? pick("sucks [src] with their mouth","licks [src], then slowly inserting it into their throat") : pick("fucks [M]'s mouth with [src]", "choking [M] by inserting [src] into [M]'s throat", "forcing [M] to suck a [src]", "inserts [src] into [M]'s throat")
				//M.adjustArous(4,1)
				M.adjustArousal(4)
				M.adjustPleasure(1)
				M.adjustOxyLoss(3)
				if(prob(70))
					M.emote(pick("gasp","moan"))
				user.visible_message("<font color=purple>[user] [message].</font>")
				playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 40, TRUE)

			else
				user.visible_message("<span class='danger'>Looks like [M]'s mouth is covered!</span>")
				return

		else
			if(M.is_bottomless())
				message = (user == M) ? pick("puts [src] into their anus","slowly inserts [src] into their ass") : pick("fucks [M]'s ass with a [src]", "uses [src] to fuck [M]'s anus", "jams [M]'s ass with a [src]", "roughly fucks [M]'s ass with a [src], making [M] roll eyes up")
				//M.adjustArous(5,5)
				M.adjustArousal(5)
				M.adjustPleasure(5)
				if(prob(60))
					M.emote(pick("twitch_s","moan","shiver"))
				user.visible_message("<font color=purple>[user] [message].</font>")
				playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
									'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 100, TRUE)

			else
				user.visible_message("<span class='danger'>Looks like [M]'s mouth is covered!</span>")
				return
