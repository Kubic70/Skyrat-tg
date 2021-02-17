/obj/item/leatherwhip
	name = "leather whip"
	desc = "A tool that used for domination. Hurts in a way you like it."
	icon_state = "leather"
	inhand_icon_state = "leather"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/whip.ogg'
	var/color_changed = FALSE
	var/form_changed = FALSE
	var/current_whip_color = "pink"
	var/current_whip_form = "whip"
	var/current_whip_type = "hard"
	var/static/list/whip_designs
	var/static/list/whip_forms
	var/static/list/whip_types
	var/list/modes = list("hard" = "weak", "weak" = "hard")
	var/mode = "hard"

//create radial menu
/obj/item/leatherwhip/proc/populate_whip_designs()
	whip_designs = list(
		"pink" = image (icon = src.icon, icon_state = "leather_whip_pink_hard"),
		"teal" = image(icon = src.icon, icon_state = "leather_whip_teal_hard"))

//radial menu for changing form
/obj/item/leatherwhip/proc/populate_whip_forms()
	whip_forms = list(
		"whip" = image (icon = src.icon, icon_state = "leather_whip_pink_hard"),
		"crotch" = image(icon = src.icon, icon_state = "leather_crotch_pink_hard"))

//radial menu for changing type
/obj/item/leatherwhip/proc/populate_whip_types()
	whip_types = list(
		"weak" = image (icon = src.icon, icon_state = "leather_whip_pink_weak"),
		"hard" = image(icon = src.icon, icon_state = "leather_crotch_pink_hard"))

//to update model lol
/obj/item/leatherwhip/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to change color
/obj/item/leatherwhip/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, whip_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_whip_color = choice
		update_icon()
		update_icon_state()
		color_changed = TRUE

	if(color_changed == TRUE)
		if(form_changed == FALSE)
			. = ..()
			if(.)
				return
			var/choice = show_radial_menu(user,src, whip_forms, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
			if(!choice)
				return FALSE
			current_whip_form = choice
			update_icon()
			update_icon_state()
			form_changed = TRUE
	else
		return

//to check if we can change whip's model
/obj/item/leatherwhip/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/leatherwhip/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(whip_designs))
		populate_whip_designs()
	if(!length(whip_forms))
		populate_whip_forms()
	if(!length(whip_types))
		populate_whip_types()

/obj/item/leatherwhip/update_icon_state()
	to_chat(usr,"[initial(icon_state)]_[current_whip_form]_[current_whip_color]_[current_whip_type]")
	icon_state = icon_state = "[initial(icon_state)]_[current_whip_form]_[current_whip_color]_[current_whip_type]"
	inhand_icon_state = "[initial(icon_state)]_[current_whip_form]_[current_whip_color]_[current_whip_type]"

//safely discipline someone without damage
/obj/item/leatherwhip/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return
//and there is code for successful check, so we are whipping someone
	switch(user.zone_selected) //to let code know what part of body we gonna whip

		if(BODY_ZONE_L_LEG || BODY_ZONE_R_LEG)
			if(M.has_feet())
				if(M.is_feets_uncovered())
					if(current_whip_type == "hard")
						var/message = ""
						message = (user == M) ? pick("Knocks themselves down with [src]", "Uses [src] to knock themselves on the ground") : pick("Hardly drops [M] on the ground with [src]", "Uses [src] to put [M] on the knees")
						M.emote(pick("gasp","shiver"))
						M.Paralyze(1)//don't fucking touch it. It's domination tool, it should have ability to put someone on kneels. I already inserted check for boots YOU CAN'T ABUSE THIS ITEM
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'sound/weapons/whip.ogg', 100)

					if(current_whip_type == "weak")
						var/message = ""
						message = (user == M) ? pick("Knocks themselves down with [src]", "Gently uses [src] to knock themselves on the ground") : pick("Gently drops [M] on the ground with [src]", "Uses [src] to slowly put [M] on the knees")
						M.emote(pick("gasp","shiver"))
						M.Paralyze(1)//don't fucking touch it. It's domination tool, it should have ability to put someone on kneels. I already inserted check for boots YOU CAN'T ABUSE THIS ITEM
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'sound/weapons/whip.ogg', 100)
				else
					user.visible_message("<span class='danger'>Looks like [M]'s legs is covered!</span>")
					return

		if(BODY_ZONE_HEAD)
			var/message = ""
			message = (user == M) ? pick("Chokes themselves with [src]", "Uses [src] to choke themselves") : pick("Chokes [M] with [src]", "Twines a [src] around [M]'s neck!")
			M.emote(pick("gasp","choke", "moan"))
			M.adjustOxyLoss(1)//DON'T TOUCH THIS TOO, IT DEALS REALLY LOW DAMAGE. I DARE YOU!
			user.visible_message("<font color=purple>[user] [message].</font>")

		else
			if(current_whip_type == "hard")
				var/message = ""
				message = (user == M) ? pick("Disciplines themselves with [src]","Uses [src] to lash themselves") : pick("Lashes [M]'s body with [src]","Uses [src] to discipline [M]", "Disciplines with [M] with [src]")
				M.emote(pick("moan","twitch","twitch_s","scream"))
				M.do_jitter_animation()
				user.visible_message("<font color=purple>[user] [message].</font>")
				playsound(loc, 'sound/weapons/whip.ogg', 100)

			if(current_whip_type == "weak")
				var/message = ""
				message = (user == M) ? pick("Whips themselves with [src]","Uses [src] to lash themselves") : pick("Playfully lashes [M]'s body with [src]","Uses [src] to discipline [M]", "Gently lashes [M] with [src]")
				M.emote(pick("moan","twitch"))
				M.do_jitter_animation()
				user.visible_message("<font color=purple>[user] [message].</font>")
				playsound(loc, 'sound/weapons/whip.ogg', 60)
			else
				return

//toggle low pain mode. Because sometimes screaming isn't good
/obj/item/leatherwhip/attack_self(mob/user, obj/item/I)
	toggle_mode()
	to_chat(user, "<span class='notice'>Whip now is [current_whip_type? "weak. Easy mode!" : "hard. Someone need to be punished!"]</span>")
	update_icon()
	update_icon_state()

//pain mode switch
/obj/item/leatherwhip/proc/toggle_mode()
	mode = modes[mode]
	switch(mode)
		if("hard")
			current_whip_type = "hard"
		if("weak")
			current_whip_type = "weak"
