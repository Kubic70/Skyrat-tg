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

/obj/item/bdsm_candle/proc/check_menu(mob/living/user)
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

/obj/item/bdsm_candle/proc/update_icon_state()
	. = ..()
	update_icon_state()
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

	var/message = ""
	if(lit == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna tickle
			if(BODY_ZONE_PRECISE_GROIN)
				if(M.is_bottomless())
					var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
					var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
					if(M.gender == MALE)
						if(vagina && penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, he moans in pleasure","drips some wax on themselves, letting it reach his penis. he moans in pleasure.","drips some wax on themselves, letting it reach his vagina. He moans in pleasure.","drips some wax on the [M]'s pussy, he moans in pleasure") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, he slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made him moan.","drips some wax on the [M]'s vagina, he moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made him moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, he moans in pleasure","drips some wax on themselves, letting it reach his penis. he moans in pleasure.") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, he slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made him moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(vagina)
							message = (user == M) ? pick("drips some wax on themselves, letting it reach his vagina. He moans in pleasure.","drips some wax on the [M]'s pussy, he moans in pleasure") : pick("drips some wax on the [M]'s vagina, he moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made him moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on themselves, letting it reach his belly. He moans in pleasure.","drips some wax on the [M]'s tummy, he moans in pleasure") : pick("drips some wax on the [M]'s belly, he moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s tummy.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s groin, made him moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)

					if(M.gender == FEMALE)
						if(vagina && penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, she moans in pleasure","drips some wax on themselves, letting it reach her penis. she moans in pleasure.","drips some wax on themselves, letting it reach her vagina. She moans in pleasure.","drips some wax on the [M]'s pussy, she moans in pleasure") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, she slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made her moan.","drips some wax on the [M]'s vagina, she moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made her moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, she moans in pleasure","drips some wax on themselves, letting it reach her penis. She moans in pleasure.") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, she slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made her moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(vagina)
							message = (user == M) ? pick("drips some wax on themselves, letting it reach her vagina. She moans in pleasure.","drips some wax on the [M]'s pussy, she moans in pleasure") : pick("drips some wax on the [M]'s vagina, she moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made her moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on themselves, letting it reach her belly. She moans in pleasure.","drips some wax on the [M]'s tummy, she moans in pleasure") : pick("drips some wax on the [M]'s belly, she moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s tummy.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s groin, made her moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)

					else
						if(vagina && penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, it moans in pleasure","drips some wax on themselves, letting it reach it's penis. It moans in pleasure.","drips some wax on themselves, letting it reach it's vagina. It moans in pleasure.","drips some wax on the [M]'s pussy, it moans in pleasure") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, it slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made it moan.","drips some wax on the [M]'s vagina, it moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made it moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(penis)
							message = (user == M) ? pick("drips some wax on the [M]'s penis, it moans in pleasure","drips some wax on themselves, letting it reach it's penis. It moans in pleasure.") : pick("drips wax right on [M]'s penis. It slightly itches.","drips hot wax from the [src] on the [M]'s penis, it slightly shivers.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s penis, made it moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else if(vagina)
							message = (user == M) ? pick("drips some wax on the [M]'s vagina, it moans in pleasure","drips some wax on themselves, letting it reach it's vagina. It moans in pleasure.") : pick("drips some wax on the [M]'s vagina, it moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s vagina.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s pussy, made it moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on themselves, letting it reach it's belly. It moans in pleasure.","drips some wax on the [M]'s tummy. It moans in pleasure") : pick("drips some wax on the [M]'s belly, it moans in pleasure","tilts the candle. Wax slowly goes down, reaching the [M]'s tummy.","tilts the candle. Drops of wax, dripping right from [src] right on the [M]'s groin, made it moan.")
							//M.adjustArous(0,0,9)
							M.adjustPain(9)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
					return

			if(BODY_ZONE_CHEST)
				if(M.is_topless())
					var/obj/item/organ/genital/breasts = M.getorganslot(ORGAN_SLOT_BREASTS)
					if(M.gender == MALE)
						if(breasts)
							message = (user == M) ? pick("drips some wax on his breasts, releasing all his lustness","drips some wax right on his tits, made him become faint.") : pick("pours the wax that is slowly dripping from the [src] on the [M]'s breasts, he shows pure enjoyment.","tilts the candle. Right in the moment when wax drips on [M]'s breasts, he shivers","tilts the candle. Just when hot drops of wax fell on the [M]'s breasts, he quietly moans in pleasure")
							//M.adjustArous(0,0,6)
							M.adjustPain(6)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on his nipples, releasing all his lustness","drips some wax right on his chest, made him become faint.") : pick("drips wax from [src], that falls right on the [M]'s chest, he all shivers in pleasure.","tilts the candle. Right in the moment when wax drips on [M]'s nipples, he shivers","tilts the candle. Just when hot drops of wax fell on the [M]'s chest, he quietly moans in pleasure")
							//M.adjustArous(0,0,4)
							M.adjustPain(4)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)

					if(M.gender == FEMALE)
						if(breasts)
							message = (user == M) ? pick("drips some wax on her breasts, releasing all her lustness","drips some wax right on her tits, made her become faint.") : pick("pours the wax that is slowly dripping from the [src] on the [M]'s breasts, she shows pure enjoyment.","tilts the candle. Right in the moment when wax drips on [M]'s breasts, she shivers","tilts the candle. Just when hot drops of wax fell on the [M]'s breasts, she quietly moans in pleasure")
							//M.adjustArous(0,0,6)
							M.adjustPain(6)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on her nipples, releasing all her lustness","drips some wax right on her chest, made her become faint.") : pick("drips wax from [src], that falls right on the [M]'s chest, she all shivers in pleasure.","tilts the candle. Right in the moment when wax drips on [M]'s nipples, she shivers", "tilts the candle. Just when hot drops of wax fell on the [M]'s chest, she quietly moans in pleasure")
							//M.adjustArous(0,0,4)
							M.adjustPain(4)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
					else
						if(breasts)
							message = (user == M) ? pick("drips some wax on it's breasts, releasing all it's lustness","drips some wax right on it's tits, made it become faint.") : pick("pours the wax that is slowly dripping from the [src] on the [M]'s breasts, it shows pure enjoyment.","tilts the candle. Right in the moment when wax drips on [M]'s breasts, it shivers","tilts the candle. Just when hot drops of wax fell on the [M]'s breasts, it quietly moans in pleasure")
							//M.adjustArous(0,0,6)
							M.adjustPain(6)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)
						else
							message = (user == M) ? pick("drips some wax on it's nipples, releasing all it's lustness","drips some wax right on it's chest, made it become faint.") : pick("drips wax from [src], that falls right on the [M]'s chest, it all shivers in pleasure.","tilts the candle. Right in the moment when wax drips on [M]'s nipples, it shivers", "tilts the candle. Just when hot drops of wax fell on the [M]'s chest, it quietly moans in pleasure")
							//M.adjustArous(0,0,4)
							M.adjustPain(4)
							M.do_jitter_animation()
							if(prob(50))
								M.emote(pick("twitch_s","choke","gasp","shiver"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/vax1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/vax2.ogg'), 70, TRUE)

				else
					user.visible_message("<span class='danger'>Looks like [M]'s chest is covered!</span>")
					return
	else
		user.visible_message("<span class='danger'>Candle should be lit to produce hot liquid wax!</span>")
		return

#undef CANDLE_LUMINOSITY
