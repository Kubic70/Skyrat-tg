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

/obj/item/magic_wand/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	if(wand_on == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna... Yeah.
			if(BODY_ZONE_PRECISE_GROIN)
				var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
				var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
				if(vibration_mode == "low")
					if(vagina && penis)
						if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW && penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","gently teases their penis with [src]","massages their pussy with the [src]","gently teases their pussy with [src]") : pick("delicately massages [M]'s penis with [src]", "uses [src] to gently massage [M]'s penis","leans the vibrator against [M]'s penis","delicately massages [M]'s pussy with [src]", "uses [src] to gently massage [M]'s pussy","leans the vibrator against [M]'s pussy")
							M.adjustArousal(4)
							M.adjustPleasure(2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

						else if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","gently teases their penis with [src]") : pick("delicately massages [M]'s penis with [src]", "uses [src] to gently massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(4)
							M.adjustPleasure(2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

						else if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their pussy with the [src]","gently teases their pussy with [src]") : pick("delicately massages [M]'s pussy with [src]", "uses [src] to gently massage [M]'s pussy","leans the vibrator against [M]'s pussy")
							M.adjustArousal(4)
							M.adjustPleasure(2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(penis)
						if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","gently teases their penis with [src]") : pick("delicately massages [M]'s penis with [src]", "uses [src] to gently massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(4)
							M.adjustPleasure(2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(vagina)
						if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their pussy with the [src]","gently teases their pussy with [src]") : pick("delicately massages [M]'s pussy with [src]", "uses [src] to gently massage [M]'s pussy","leans the vibrator against [M]'s pussy")
							M.adjustArousal(4)
							M.adjustPleasure(2)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

				if(vibration_mode == "medium")
					if(vagina && penis)
						if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW && vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","teases teases their penis with [src]","massages their vagina with the [src]","gently teases their pussy with [src]") : pick("massages [M]'s penis with [src]", "uses [src] to massage [M]'s penis","leans the vibrator against [M]'s penis","massages [M]'s vagina with [src]", "uses [src] to massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(5)
							M.adjustPleasure(5)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

						else if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their vagina with the [src]","gently teases their pussy with [src]") : pick("massages [M]'s vagina with [src]", "uses [src] to massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(5)
							M.adjustPleasure(5)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

						else if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","teases teases their penis with [src]") : pick("massages [M]'s penis with [src]", "uses [src] to massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(5)
							M.adjustPleasure(5)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)

						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(penis)
						if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","teases teases their penis with [src]") : pick("massages [M]'s penis with [src]", "uses [src] to massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(5)
							M.adjustPleasure(5)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(vagina)
						if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their vagina with the [src]","gently teases their pussy with [src]") : pick("massages [M]'s vagina with [src]", "uses [src] to massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(5)
							M.adjustPleasure(5)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

				if(vibration_mode == "hard")
					if(vagina && penis)
						if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW && vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","hardly teases their penis with [src]","massages their vagina with the [src]","hardly teases their pussy with [src]") : pick("leans vibrator tight to [M]'s penis with [src]", "uses [src] to agressively massage [M]'s penis","leans the vibrator against [M]'s penis","leans vibrator tight to [M]'s vagina with [src]", "uses [src] to agressively massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(8)
							M.adjustPleasure(10)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

						else if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their vagina with the [src]","hardly teases their pussy with [src]") : pick("leans vibrator tight to [M]'s vagina with [src]", "uses [src] to agressively massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(8)
							M.adjustPleasure(10)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

						else if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","hardly teases their penis with [src]") : pick("leans vibrator tight to [M]'s penis with [src]", "uses [src] to agressively massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(8)
							M.adjustPleasure(10)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)

						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(penis)
						if(M.is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their penis with the [src]","hardly teases their penis with [src]") : pick("leans vibrator tight to [M]'s penis with [src]", "uses [src] to agressively massage [M]'s penis","leans the vibrator against [M]'s penis")
							M.adjustArousal(8)
							M.adjustPleasure(10)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

					else if(vagina)
						if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their vagina with the [src]","hardly teases their pussy with [src]") : pick("leans vibrator tight to [M]'s vagina with [src]", "uses [src] to agressively massage [M]'s crotch","leans the vibrator against [M]'s pussy")
							M.adjustArousal(8)
							M.adjustPleasure(10)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
							return

			if(BODY_ZONE_CHEST)
				var/obj/item/organ/genital/breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
				if(vibration_mode == "low")
					if(breasts)
						if(M.is_topless() || breasts.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their breasts with the [src]","gently teases their tits with [src]") : pick("delicately teases [M]'s breasts with [src]", "uses [src] to slowly massage [M]'s tits", "uses [src] to tease [M]'s boobs", "rubs [M]'s tits with [src]")
							M.adjustArousal(3)
							M.adjustPleasure(1)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
							return
					else
						if(M.is_topless())
							message = (user == M) ? pick("massages their nipples with the [src]","gently teases their nipples with [src]") : pick("delicately teases [M]'s nipples with [src]", "uses [src] to slowly massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArousal(2)
							M.adjustPleasure(1)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
							return

				if(vibration_mode == "medium")
					if(breasts)
						if(M.is_topless() || breasts.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their breasts with the [src]","teases their tits with [src]") : pick("teases [M]'s breasts with [src]", "uses [src] to massage [M]'s tits", "uses [src] to tease [M]'s boobs", "rubs [M]'s tits with [src]")
							M.adjustArousal(4)
							M.adjustPleasure(4)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
							return
					else
						if(M.is_topless())
							message = (user == M) ? pick("massages their nipples with the [src]","teases their nipples with [src]") : pick("teases [M]'s nipples with [src]", "uses [src] to massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArousal(4)
							M.adjustPleasure(4)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 20, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
							return

				if(vibration_mode == "hard")
					if(breasts)
						if(M.is_topless() || breasts.visibility_preference == GENITAL_ALWAYS_SHOW)
							message = (user == M) ? pick("massages their breasts with the [src]","hardly teases their tits with [src]") : pick("leans vibrator tight against [M]'s breasts with [src]", "uses [src] to massage [M]'s tits", "uses [src] to tease [M]'s boobs", "rubs [M]'s tits with [src]")
							M.adjustArousal(7)
							M.adjustPleasure(9)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
							return

					else
						if(M.is_topless())
							message = (user == M) ? pick("massages their nipples with the [src]","hardly teases their nipples with [src]") : pick("leans vibrator tight against [M]'s nipples with [src]", "uses [src] to massage [M]'s nipples", "uses [src] to tease [M]'s nipples")
							M.adjustArousal(7)
							M.adjustPleasure(9)
							if(prob(30))
								M.emote(pick("twitch_s","moan"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 30, TRUE)
						else
							to_chat(user, "<span class='danger'>Looks like [M]'s chest is covered!</span>")
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
		to_chat(usr, "<span class ='notice'> You cannot switch modes while the vibrator is turned off.</span>")
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
