/obj/item/magic_wand
	name = "magic wand"
	desc = "Not sure where is magic in this thing, but if you press button - it makes funny vibrations"
	icon_state = "magicwand"
	inhand_icon_state = "magicwand"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	var/wand_on = FALSE
	var/vibration_mode = "low"
	var/list/modes = list("low" = "medium", "medium" = "hard", "hard" = "low")
	var/mode = "low"
	w_class = WEIGHT_CLASS_TINY

/obj/item/magic_wand/AltClick(mob/user)
    wand_on = !wand_on
    to_chat(user, "<span class='notice'>You turn the vibrator [wand_on? "on. Brrrr..." : "off."]</span>")
    playsound(user, wand_on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
    update_icon_state()
    update_icon()

/obj/item/magic_wand/Initialize()
	. = ..()
	update_icon_state()
	update_icon()

/obj/item/magic_wand/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[vibration_mode]_[wand_on? "on" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[vibration_mode]_[wand_on? "on" : "off"]"

/obj/item/magic_wand/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	if(wand_on == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna tickle
			if(BODY_ZONE_PRECISE_GROIN)
				if(M.is_bottomless())
					var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
					var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
					if(vibration_mode == "low")
						if(penis)
							message = (user == M) ? pick("Massages their penis with the [src]","Gently teases their penis with [src]") : pick("Massages [M]'s penis with [src]", "Uses [src] to massage [M]'s penis","Leans the massager against [M]'s penis")
							M.adjustArous(4,2)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

						if(vagina)
							message = (user == M) ? pick("Massages their vagina with the [src]","Gently teases their pussy with [src]") : pick("Massages [M]'s vagina with [src]", "Uses [src] to massage [M]'s crotch","Leans the massager against [M]'s pussy")
							M.adjustArous(4,2)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

					if(vibration_mode == "medium")
						if(penis)
							message = (user == M) ? pick("Massages their penis with the [src]","Gently teases their penis with [src]") : pick("Massages [M]'s penis with [src]", "Uses [src] to massage [M]'s penis","Leans the massager against [M]'s penis")
							M.adjustArous(5,5)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

						if(vagina)
							message = (user == M) ? pick("Massages their vagina with the [src]","Gently teases their pussy with [src]") : pick("Massages [M]'s vagina with [src]", "Uses [src] to massage [M]'s crotch","Leans the massager against [M]'s pussy")
							M.adjustArous(5,5)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

					if(vibration_mode == "hard")
						if(penis)
							message = (user == M) ? pick("Massages their penis with the [src]","Gently teases their penis with [src]") : pick("Massages [M]'s penis with [src]", "Uses [src] to massage [M]'s penis","Leans the massager against [M]'s penis")
							M.adjustArous(8,10)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

						if(vagina)
							message = (user == M) ? pick("Massages their vagina with the [src]","Gently teases their pussy with [src]") : pick("Massages [M]'s vagina with [src]", "Uses [src] to massage [M]'s crotch","Leans the massager against [M]'s pussy")
							M.adjustArous(8,10)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
					return

			if(BODY_ZONE_CHEST)
				if(M.is_topless())
					var/obj/item/organ/genital/breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
					if(vibration_mode == "low")
						if(breasts)
							message = (user == M) ? pick("Massages their breasts with the [src]","Gently teases their nipples with [src]") : pick("Teases [M]'s nipples with [src]", "Uses [src] to massage [M]'s tits", "Uses [src] to tease [M]'s nipples")
							M.adjustArous(3,1)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

					if(vibration_mode == "medium")
						if(breasts)
							message = (user == M) ? pick("Massages their breasts with the [src]","Gently teases their nipples with [src]") : pick("Teases [M]'s nipples with [src]", "Uses [src] to massage [M]'s tits", "Uses [src] to tease [M]'s nipples")
							M.adjustArous(4,4)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

					if(vibration_mode == "hard")
						if(breasts)
							message = (user == M) ? pick("Massages their breasts with the [src]","Gently teases their nipples with [src]") : pick("Teases [M]'s nipples with [src]", "Uses [src] to massage [M]'s tits", "Uses [src] to tease [M]'s nipples")
							M.adjustArous(7,9)
							M.emote(pick("twitch_w","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s chest is covered!</span>")
					return
	else
		to_chat(user, "<span class='notice'>You must turn on the toy, to use it!</span>")
		return

/obj/item/magic_wand/attack_self(mob/user, obj/item/I)
	if(wand_on == TRUE)
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
		to_chat(usr, "<span class ='notice'> You cannot switch modes while the massager is turned off.</span>")
		return

/obj/item/magic_wand/proc/toggle_mode()
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
