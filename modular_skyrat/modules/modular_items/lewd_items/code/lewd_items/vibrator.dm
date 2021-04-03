/obj/item/vibrator
	name = "vibrator"
	desc = "Woah. What an... Interesting item. I wonder what this red button does..."
	icon_state = "vibrator"
	inhand_icon_state = "vibrator"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	var/toy_on = FALSE
	var/current_color = "pink"
	var/color_changed = FALSE
	var/vibration_mode = "low"
	var/list/modes = list("low" = "medium", "medium" = "hard", "hard" = "low")
	var/mode = "low"
	var/static/list/vibrator_designs
	w_class = WEIGHT_CLASS_TINY

//create radial menu
/obj/item/vibrator/proc/populate_vibrator_designs()
	vibrator_designs = list(
		"pink" = image (icon = src.icon, icon_state = "vibrator_pink_low_on"),
		"teal" = image(icon = src.icon, icon_state = "vibrator_teal_low_on"),
		"red" = image(icon = src.icon, icon_state = "vibrator_red_low_on"),
		"yellow" = image(icon = src.icon, icon_state = "vibrator_yellow_low_on"),
		"green" = image(icon = src.icon, icon_state = "vibrator_green_low_on"))

/obj/item/vibrator/AltClick(mob/user, obj/item/I)
	if(color_changed == TRUE)
		toy_on = !toy_on
		to_chat(user, "<span class='notice'>You turn the vibrator [toy_on? "on. Brrrr..." : "off."]</span>")
		playsound(user, toy_on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
		update_icon_state()
		update_icon()
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, vibrator_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change vibrator's model
/obj/item/vibrator/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/vibrator/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(vibrator_designs))
		populate_vibrator_designs()

/obj/item/vibrator/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[vibration_mode]_[toy_on? "on" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"

/obj/item/vibrator/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	if(toy_on == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna tickle
			if(BODY_ZONE_PRECISE_GROIN)
				if(M.is_bottomless())
					var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
					var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
					if(vibration_mode == "low")
						if(vagina && penis)
							message = (user == M) ? pick("massages their vagina with the [src]","gently their pussy with [src]","massages their penis with the [src]","gently teases their penis with [src]") : pick("delicately massages [M]'s vagina with [src]", "uses [src] to gently massage [M]'s crotch","leans the massager against [M]'s pussy","delicately massages [M]'s penis with [src]", "uses [src] to gently massage [M]'s penis","leans the massager against [M]'s penis")
							M.adjustArous(4,2)
							if(prob(50))
								M.emote(pick("twitch_s","moan","blush"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else if(penis)
							message = (user == M) ? pick("massages their penis with the [src]","gently teases their penis with [src]") : pick("delicately massages [M]'s penis with [src]", "uses [src] to gently massage [M]'s penis","leans the massager against [M]'s penis")
							M.adjustArous(4,2)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else if(vagina)
							message = (user == M) ? pick("massages their vagina with the [src]","gently their pussy with [src]") : pick("delicately massages [M]'s vagina with [src]", "uses [src] to gently massage [M]'s crotch","leans the massager against [M]'s pussy")
							M.adjustArous(4,2)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							user.visible_message("<span class='danger'>Looks like [M] don't have suitable organs for that!</span>")
							return

					if(vibration_mode == "medium")
						if(vagina && penis)
							message = (user == M) ? pick("massages their penis with the [src]","teases teases their penis with [src]","massages their vagina with the [src]","teases teases their pussy with [src]") : pick("massages [M]'s penis with [src]", "uses [src] to massage [M]'s penis","leans the massager against [M]'s penis","massages [M]'s vagina with [src]", "uses [src] to massage [M]'s crotch","leans the massager against [M]'s pussy")
							M.adjustArous(5,5)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else if(penis)
							message = (user == M) ? pick("massages their penis with the [src]","teases teases their penis with [src]") : pick("massages [M]'s penis with [src]", "uses [src] to massage [M]'s penis","leans the massager against [M]'s penis")
							M.adjustArous(5,5)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else if(vagina)
							message = (user == M) ? pick("massages their vagina with the [src]","teases teases their pussy with [src]") : pick("massages [M]'s vagina with [src]", "uses [src] to massage [M]'s crotch","leans the massager against [M]'s pussy")
							M.adjustArous(5,5)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							user.visible_message("<span class='danger'>Looks like [M] don't have suitable organs for that!</span>")
							return

					if(vibration_mode == "hard")
						if(vagina && penis)
							message = (user == M) ? pick("massages their penis with the [src]","hardly teases their penis with [src]","massages their vagina with the [src]","hardly teases their pussy with [src]") : pick("leans massager tight to [M]'s penis with [src]", "uses [src] to agressively massage [M]'s penis","leans the massager against [M]'s penis","leans massager tight to [M]'s vagina with [src]", "uses [src] to agressively massage [M]'s crotch","leans the massager against [M]'s pussy")
							M.adjustArous(8,10)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else if(penis)
							message = (user == M) ? pick("massages their penis with the [src]","hardly teases their penis with [src]") : pick("leans massager tight to [M]'s penis with [src]", "uses [src] to agressively massage [M]'s penis","leans the massager against [M]'s penis")
							M.adjustArous(8,10)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else if(vagina)
							message = (user == M) ? pick("massages their vagina with the [src]","hardly teases their pussy with [src]") : pick("leans massager tight to [M]'s vagina with [src]", "uses [src] to agressively massage [M]'s crotch","leans the massager against [M]'s pussy")
							M.adjustArous(8,10)
							if(prob(50))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							user.visible_message("<span class='danger'>Looks like [M] don't have suitable organs for that!</span>")
							return
				else
					user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
					return

			if(BODY_ZONE_CHEST)
				if(M.is_topless())
					var/obj/item/organ/genital/breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
					if(vibration_mode == "low")
						if(breasts)
							message = (user == M) ? pick("massages their breasts with the [src]","gently teases their tits with [src]") : pick("delicately teases [M]'s breasts with [src]", "uses [src] to slowly massage [M]'s tits", "uses [src] to tease [M]'s boobs", "rubs [M]'s tits with [src]")
							M.adjustArous(4,1)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							message = (user == M) ? pick("massages their nipples with the [src]","gently teases their nipples with [src]") : pick("delicately teases [M]'s nipples with [src]", "uses [src] to slowly massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArous(2,1)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)


					if(vibration_mode == "medium")
						if(breasts)
							message = (user == M) ? pick("massages their breasts with the [src]","teases their nipples with [src]") : pick("teases [M]'s nipples with [src]", "uses [src] to massage [M]'s tits", "uses [src] to tease [M]'s nipples")
							M.adjustArous(5,4)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							message = (user == M) ? pick("massages their nipples with the [src]","teases their nipples with [src]") : pick("teases [M]'s nipples with [src]", "uses [src] to massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArous(3,1)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

					if(vibration_mode == "hard")
						if(breasts)
							message = (user == M) ? pick("massages their breasts with the [src]","hardly teases their nipples with [src]") : pick("leans massager tight against [M]'s nipples with [src]", "uses [src] to massage [M]'s tits", "uses [src] to tease [M]'s nipples")
							M.adjustArous(7,9)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							message = (user == M) ? pick("massages their nipples with the [src]","hardly teases their nipples with [src]") : pick("leans massager tight against [M]'s nipples with [src]", "uses [src] to massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArous(4,2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s chest is covered!</span>")
					return
	else
		to_chat(user, "<span class='notice'>You must turn on the toy, to use it!</span>")
		return

/obj/item/vibrator/attack_self(mob/user, obj/item/I)
	if(toy_on == TRUE)
		toggle_mode()
		if(vibration_mode == "low")
			to_chat(user, "<span class='notice'>Vibration mode now is low. Bzzz...</span>")
		if(vibration_mode == "medium")
			to_chat(user, "<span class='notice'>Vibration mode now is medium. Bzzzz!</span>")
		if(vibration_mode == "hard")
			to_chat(user, "<span class='notice'>Vibration mode now is hard. Careful with that thing.</span>")
		update_icon()
		update_icon_state()
	else
		to_chat(usr, "<span class ='notice'> You cannot switch modes while the vibrator is turned off.</span>")
		return

/obj/item/vibrator/proc/toggle_mode()
	mode = modes[mode]
	switch(mode)
		if("low")
			vibration_mode = "low"
			playsound(loc, 'sound/weapons/magin.ogg', 20, TRUE)
		if("medium")
			vibration_mode = "medium"
			playsound(loc, 'sound/weapons/magin.ogg', 20, TRUE)
		if("hard")
			vibration_mode = "hard"
			playsound(loc, 'sound/weapons/magin.ogg', 20, TRUE)
