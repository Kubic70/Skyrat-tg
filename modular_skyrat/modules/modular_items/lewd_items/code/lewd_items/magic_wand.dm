/*/obj/item/magic_wand
	name = "magic wand"
	desc = "Not sure where is magic in this thing, but if you press button - it makes funny vibrations"
	icon_state = "magicwand"
	inhand_icon_state = "magicwand"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	var/wand_on = FALSE
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
    icon_state = "[initial(icon_state)]_[wand_on? "on" : "off"]"

/obj/item/magic_wand/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	var/obj/item/organ/genital/penis = M.getorganslot(ORGAN_SLOT_PENIS)
//here need code to check what organ character have
	if(wand_on == TRUE)
		switch(user.zone_selected) //to let code know what part of body we gonna tickle
			if(BODY_ZONE_PRECISE_GROIN)
				if(M.is_bottomless())
					if(M.has_penis())
						if(penis.is_exposed(REQUIRE_EXPOSED))
							message = (user == M) ? pick("Teases themselves with the [src]","Gently teases their crotch with [src]") : pick("Teases [M]'s belly with [src]", "Uses [src] to tickle [M]'s belly","Tickles [M] with [src]")
							to_chat(user, "penis")
							M.emote(pick("laugh","giggle","twitch","twitch_s"))
							user.visible_message("<font color=purple>[user] [message].</font>")
							playsound(loc, pick('sound/items/handling/cloth_drop.ogg', 					//i duplicate this part of code because im useless shitcoder that can't make it work properly without tons of repeating code blocks
			            			            'sound/items/handling/cloth_pickup.ogg',				//if you can make it better - go ahead, modify it, please.
			        	       	    		    'sound/items/handling/cloth_pickup.ogg'), 70, 1, -1)	//selfdestruction - 100
						else
							user.visible_message("<span class='danger'>Looks like [M]'s genitals is covered!</span>")
							return

					if(M.has_vagina())
						message = (user == M) ? pick("Teases themselves with the [src]","Gently teases their crotch with [src]") : pick("Teases [M]'s belly with [src]", "Uses [src] to tickle [M]'s belly","Tickles [M] with [src]")
						to_chat(user, "vagina")
						M.emote(pick("laugh","giggle","twitch","twitch_s"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, pick('sound/items/handling/cloth_drop.ogg', 					//i duplicate this part of code because im useless shitcoder that can't make it work properly without tons of repeating code blocks
		            			            'sound/items/handling/cloth_pickup.ogg',				//if you can make it better - go ahead, modify it, please.
		        	       	    		    'sound/items/handling/cloth_pickup.ogg'), 70, 1, -1)	//selfdestruction - 100

				else
					user.visible_message("<span class='danger'>Looks like [M]'s groin is covered!</span>")
					return

			if(BODY_ZONE_CHEST)
				if(M.is_topless())
					message = (user == M) ? pick("tickles themselves with the [src]","Gently teases their nipples with [src]") : pick("Teases [M]'s nipples with [src]", "Uses [src] to tickle [M]'s left nipple", "Uses [src] to tickle [M]'s right nipple")
					M.emote(pick("laugh","giggle","twitch","twitch_s","moan",))
					user.visible_message("<font color=purple>[user] [message].</font>")
					playsound(loc, pick('sound/items/handling/cloth_drop.ogg',
	            			            'sound/items/handling/cloth_pickup.ogg',
	        	       	    		    'sound/items/handling/cloth_pickup.ogg'), 70, 1, -1)
				else
					user.visible_message("<span class='danger'>Looks like [M]'s chest is covered!</span>")
					return
	else
		to_chat(user, "<span class='notice'>You must turn on the toy, to use it!</span>")
		return
*/
