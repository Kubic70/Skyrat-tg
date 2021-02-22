#define CANDLE_LUMINOSITY	2
/obj/item/bdsm_candle
	name = "soy candle"
	desc = "A candle with low melting temperature."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "candle"
	inhand_icon_state = "candle"
	w_class = WEIGHT_CLASS_TINY
	light_color = LIGHT_COLOR_FIRE
	heat = 600
	var/current_color = "pink"
	var/color_changed = FALSE
	var/lit = FALSE
	var/start_lit = FALSE
	var/static/list/candle_designs
	var/static/list/candlelights = list(
                                "pink" = LIGHT_COLOR_FIRE,
                                "teal" = COLOR_CYAN)//list of colors to choose

//to change color of candle
//create radial menu
/obj/item/bdsm_candle/proc/populate_candle_designs()
    candle_designs = list(
        "pink" = image (icon = src.icon, icon_state = "candle_pink_lit"),
        "teal" = image(icon = src.icon, icon_state = "candle_teal_lit"))

/obj/item/bdsm_candle/proc/update_brightness()
    set_light_on(lit)
    update_light()

/obj/item/bdsm_candle/proc/check_menu(mob/living/user, obj/item/multitool)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/bdsm_candle/Initialize()
	. = ..()
	update_icon()
	update_icon_state()
	if(start_lit)
		light()
	if(!length(candle_designs))
		populate_candle_designs()

/obj/item/bdsm_candle/update_icon_state()
	icon_state = "[initial(icon_state)]_[current_color]_[lit ? "lit" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]_[lit ? "lit" : "off"]"

/obj/item/bdsm_candle/attackby(obj/item/W, mob/user, params)
	var/msg = W.ignition_effect(src, user)
	update_brightness()
	if(msg)
		light(msg)
	else
		return ..()

/obj/item/bdsm_candle/fire_act(exposed_temperature, exposed_volume)
	if(!lit)
		light()
		update_brightness()
	return ..()

/obj/item/bdsm_candle/get_temperature()
	return lit * heat

/obj/item/bdsm_candle/proc/light(show_message)
	if(!lit)
		lit = TRUE
		if(show_message)
			usr.visible_message(show_message)
		set_light(CANDLE_LUMINOSITY)
		START_PROCESSING(SSobj, src)
		update_icon()
		update_brightness()

/obj/item/bdsm_candle/proc/put_out_candle()
	if(!lit)
		return
	lit = FALSE
	update_icon()
	set_light(0)
	return TRUE

/obj/item/bdsm_candle/extinguish()
	put_out_candle()
	return ..()

/obj/item/bdsm_candle/process(delta_time)
	if(!lit)
		return PROCESS_KILL
	open_flame()
	update_brightness()

/obj/item/bdsm_candle/attack_self(mob/user, obj/item/I)
	if(lit == FALSE)
		if(color_changed == FALSE)
			var/choice = show_radial_menu(user,src, candle_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
			if(!choice)
				return FALSE
			current_color = choice
			light_color = candlelights[choice]
			update_icon()
			update_brightness()
			color_changed = TRUE
	if(lit == TRUE)
		if(put_out_candle())
			user.visible_message("<span class='notice'>[user] snuffs [src].</span>")

///////////////////////////////////////////////////
//here goes things that required for wax dropping//
///////////////////////////////////////////////////

/obj/item/bdsm_candle/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return
//Поменять сообщения при капании воска на части тела.
	var/message = ""
	if(lit == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna tickle
			if(BODY_ZONE_PRECISE_GROIN)
				if(M.is_bottomless())
					var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
					var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
					if(penis)
						message = (user == M) ? pick("Dripping wax on their penis with [src]","Tilts the candle their penis, letting hot wax drip on it") : pick("Tilts [src] over [M]'s penis, letting hot wax drip on it", "Uses [src] to drip wax on [M]'s penis","Leans the vibrator against [M]'s penis")
						M.adjustArous(0,0,9)
						M.do_jitter_animation()
						M.emote(pick("twitch_w","choke","gasp","shiver"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

					if(vagina)
						message = (user == M) ? pick("Massages their pussy with the [src]","Gently teases their pussy with [src]") : pick("Delicately massages [M]'s pussy with [src]", "Uses [src] to gently massage [M]'s pussy","Leans the vibrator against [M]'s pussy")
						M.adjustArous(0,0,9)
						M.do_jitter_animation()
						M.emote(pick("twitch_w","choke","gasp","shiver"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
					return

			if(BODY_ZONE_CHEST)
				if(M.is_topless())
					var/obj/item/organ/genital/breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts) //Тут на грудь
						message = (user == M) ? pick("Massages their breasts with the [src]","Gently teases their nipples with [src]") : pick("Delicately teases [M]'s nipples with [src]", "Uses [src] to slowly massage [M]'s tits", "Uses [src] to tease [M]'s nipples")
						M.adjustArous(0,0,6)
						M.do_jitter_animation()
						M.emote(pick("twitch_w","choke","gasp","shiver"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
					else //Тут будет на грудную клетку
						message = (user == M) ? pick("Massages their breasts with the [src]","Gently teases their nipples with [src]") : pick("Delicately teases [M]'s nipples with [src]", "Uses [src] to slowly massage [M]'s tits", "Uses [src] to tease [M]'s nipples")
						M.adjustArous(0,0,4)
						M.do_jitter_animation()
						M.emote(pick("twitch_w","choke","gasp","shiver"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/vibrate.ogg', 10, TRUE)
				else
					user.visible_message("<span class='danger'>Looks like [M]'s chest is covered!</span>")
					return
	else
		user.visible_message("<span class='danger'>Candle should be lit to produce hot liquid wax!</span>")
		return

#undef CANDLE_LUMINOSITY
