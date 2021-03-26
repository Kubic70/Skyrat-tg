//////////////////////////
///CODE FOR PILLOW ITEM///
//////////////////////////

/obj/item/pillow
	name = "pillow"
	desc = "Big and soft pillow."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "pillow"
	inhand_icon_state = "pillow"
	var/datum/effect_system/feathers/pillow_feathers
	var/current_color = "pink"
	var/color_changed = FALSE
	var/current_form = "round"
	var/form_changed = FALSE
	var/static/list/pillow_colors
	var/static/list/pillow_forms
	w_class = WEIGHT_CLASS_SMALL

//create radial menu
/obj/item/pillow/proc/populate_pillow_colors()
	pillow_colors = list(
		"pink" = image (icon = src.icon, icon_state = "pillow_pink_round"),
		"teal" = image(icon = src.icon, icon_state = "pillow_teal_round"))

//create radial menu, BUT for forms. I'm smort
/obj/item/pillow/proc/populate_pillow_forms()
	pillow_forms = list(
		"square" = image (icon = src.icon, icon_state = "pillow_pink_square"),
		"round" = image(icon = src.icon, icon_state = "pillow_pink_round"))

/obj/item/pillow/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, pillow_colors, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	if(color_changed == TRUE)
		if(form_changed == FALSE)
			. = ..()
			if(.)
				return
			var/choice = show_radial_menu(user,src, pillow_forms, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
			if(!choice)
				return FALSE
			current_form = choice
			update_icon()
			form_changed = TRUE
	else
		return

//to check if we can change pillow's model
/obj/item/pillow/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/pillow/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(pillow_colors))
		populate_pillow_colors()
	if(!length(pillow_forms))
		populate_pillow_forms()
	//part of code for feathers spawn on hit
	pillow_feathers = new
	pillow_feathers.set_up(2, 0, src)
	pillow_feathers.attach(src)

/obj/item/pillow/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[current_form]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]_[current_form]"

//feathers effect on hit

/obj/effect/temp_visual/feathers
	name = "feathers"
	icon_state = "feathers"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
	duration = 14

/datum/effect_system/feathers
	effect_type = /obj/effect/temp_visual/feathers

/obj/item/pillow/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	if(prob(1.5)) // 1.5% chance of special tickling feather spawning. No idea why, i was thinking that this is funny idea. Do not erase it plz
		new /obj/item/tickle_feather(loc)

//and there is code for successful check, so we are hitting someone with a pillow
	pillow_feathers.start()
	switch(user.zone_selected) //to let code know what part of body we gonna hit

		if(BODY_ZONE_HEAD)
			var/message = ""
			message = (user == M) ? pick("Hits themselves with a [src]", "Hits their head with a pillow ") : pick("Hits [M] with a [src]", "Hits [M]'s head with a pillow! Lucky the pillow is soft.")
			if(prob(30))
				M.emote(pick("laugh","giggle"))
			user.visible_message("<font>[user] [message].</font>")
			playsound(loc,'modular_skyrat/modules/modular_items/lewd_items/sounds/hug.ogg', 50, 1, -1)

		if(BODY_ZONE_CHEST)
			var/message = ""
			message = (user == M) ? pick("Challenges the pillow battle, hitting themselves with [src].","Hits themselves with a [src]") : pick("Hits [M]'s chest with a [src]!", "Playfully hits [M]'s chest with a [src].","Hits [M]'s chest with a pillow.")
			if(prob(30))
				M.emote(pick("laugh","giggle"))
			user.visible_message("<font>[user] [message].</font>")
			playsound(loc,'modular_skyrat/modules/modular_items/lewd_items/sounds/hug.ogg', 50, 1, -1)

		else
			var/message = ""
			message = (user == M) ? pick("Hits themselves with [src].","Playfully hits themselves with a [src]", "Grabs a pillow, then hitting themselves with it.") : pick("Hits [M] with a [src]!", "Playfully hits [M] with a [src].","Hits [M] with a pillow. They having fun!")
			if(prob(30))
				M.emote(pick("laugh","giggle"))
			user.visible_message("<font>[user] [message].</font>")
			playsound(loc,'modular_skyrat/modules/modular_items/lewd_items/sounds/hug.ogg', 50, 1, -1)
		else
			return

//spawning pillow on the ground when clicking on pillow	by LBM

/obj/item/pillow/attack_self(mob/user)
	if(IN_INVENTORY)
		to_chat(user, "<span class='notice'>You put pillow on the floor.</span>")
		var/obj/structure/bed/pillow_tiny/C = new(get_turf(src))
		switch(current_form)
			if("square")
				C.current_form = "square"
			if("round")
				C.current_form = "round"
		switch(current_color)
			if("teal")
				C.current_color = "teal"
			if("pink")
				C.current_color = "pink"
		if(color_changed == TRUE)
			C.color_changed1 = TRUE
		if(form_changed == TRUE)
			C.form_changed1 = TRUE
		C.update_icon_state()
		C.update_icon()
		del(src)
	return

////////////////////////////////////
///CODE FOR TINY PILLOW FURNITURE///
////////////////////////////////////

/obj/structure/bed/pillow_tiny
	name = "pillow"
	desc = "Large pillow lying on the floor"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi'
	icon_state = "pillow"
	var/current_color = "pink"
	var/current_form = "round"
	//Stuff required for picking up pillow with saving some info about vars
	var/color_changed1 = FALSE
	var/form_changed1 = FALSE

/obj/structure/bed/pillow_tiny/Initialize()
	.=..()
	update_icon_state()
	update_icon()

/obj/structure/bed/pillow_tiny/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[current_form]"

//"picking up" the pillow

/obj/structure/bed/pillow_tiny/AltClick(mob/user)

	to_chat(user, "<span class='notice'>You lifted pillow off the floor.</span>")
	var/obj/item/pillow/W = new()
	user.put_in_hands(W)
	switch(current_form)
		if("square")
			W.current_form = "square"
		if("round")
			W.current_form = "round"
	switch(current_color)
		if("teal")
			W.current_color = "teal"
		if("pink")
			W.current_color = "pink"
	if(color_changed1 == TRUE)
		W.color_changed = TRUE
	if(form_changed1 == TRUE)
		W.form_changed = TRUE
	W.update_icon_state()
	W.update_icon()
	del(src)

//when we lay on it

/obj/structure/bed/pillow_tiny/post_buckle_mob(mob/living/M)
	. = ..()
	density = TRUE
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y + 2

/obj/structure/bed/pillow_tiny/post_unbuckle_mob(mob/living/M)
	. = ..()
	density = FALSE
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y

//What is it? Tiny pillow is evolving!
//Actually just code for upgrading it to pile.

/*
/obj/structure/bed/pillow_tiny/attackby(mob/user, obj/item/I)
	if(istype(I, /obj/item/pillow))
		var/obj/item/pillow/P = I
		switch(current_color)
			if("teal")
				switch(P.current_color)
					if("teal")
						var/obj/structure/chair/pillow_small/C = new(get_turf(src))
						C.current_color = "teal"
						to_chat(user, "<span class='notice'>You put pillow on other pillow. Somehow it looks like a pile of pillows. How strange.</span>")
						switch(P.current_form)
							if("square")
								C.pillow2_form = "square"
							if("round")
								C.pillow2_form = "round"
						if(P.color_changed == TRUE)
							C.color_changed2 = TRUE
						if(P.form_changed == TRUE)
							C.form_changed2 = TRUE
						switch(current_form)
							if("square")
								C.pillow1_form = "square"
							if("round")
								C.pillow1_form = "round"
						if(color_changed1 == TRUE)
							C.color_changed1 = TRUE
						if(form_changed1 == TRUE)
							C.form_changed1 = TRUE
						C.update_icon_state()
						C.update_icon()
						del(src)
						return
					if("pink")
						return
			if("pink")
				switch(current_color)
					if("pink")
						var/obj/structure/chair/pillow_small/C = new(get_turf(src))
						C.current_color = "pink"
						to_chat(user, "<span class='notice'>You put pillow on other pillow. Somehow it looks like a pile of pillows. How strange.</span>")
						switch(P.current_form)
							if("square")
								C.pillow2_form = "square"
							if("round")
								C.pillow2_form = "round"
						if(P.color_changed == TRUE)
							C.color_changed2 = TRUE
						if(P.form_changed == TRUE)
							C.form_changed2 = TRUE
						switch(current_form)
							if("square")
								C.pillow1_form = "square"
							if("round")
								C.pillow1_form = "round"
						if(color_changed1 == TRUE)
							C.color_changed1 = TRUE
						if(form_changed1 == TRUE)
							C.form_changed1 = TRUE
						C.update_icon_state()
						C.update_icon()
						del(src)
						return
					if("teal")
						return
*/

/////////////////////////////////////
///CODE FOR SMALL PILLOW FURNITURE///
/////////////////////////////////////

/obj/structure/chair/pillow_small
	name = "small pillow pile"
	desc = "Small pile of pillows. Looks as comfortable seat, especially for taurs and nagas."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi'
	icon_state = "pillowpile_small"
	var/current_color = "pink"
	var/mutable_appearance/armrest
	//here comes some magic shitcode, that required for saving pillow's info about form and color. Very useful, yes..
	var/pillow1_form = "round"
	var/pillow2_form = "round"
	var/color_changed1 = FALSE
	var/color_changed2 = FALSE
	var/form_changed1 = FALSE
	var/form_changed2 = FALSE

/obj/structure/chair/pillow_small/Initialize()
	update_icon_state()
	update_icon()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	return ..()

/obj/structure/chair/pillow_small/proc/GetArmrest()
	switch(current_color)
		if("pink")
			return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_small_pink_overlay")
		if("teal")
			return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_small_teal_overlay")

/obj/structure/chair/pillow_small/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/chair/pillow_small/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()
	density = TRUE
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y + 4.9 //Yes. Exactly 4.9. Not 4.8, not 5. Do not touch.

/obj/structure/chair/pillow_small/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/chair/pillow_small/post_unbuckle_mob(mob/living/M)
	. = ..()
	update_armrest()
	density = FALSE
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/chair/pillow_small/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"

//code for taking pillows BACC
/*
/obj/structure/chair/pillow_small/AltClick(mob/user)

	to_chat(user, "<span class='notice'>You took pillow from pile.</span>")
	var/obj/item/pillow/W = new()
	user.put_in_hands(W)
	var/obj/structure/bed/pillow_tiny/C = new(get_turf(src))
	//to save things for pillow, that leaved on the ground
	switch(pillow1_form)
		if("square")
			C.current_form = "square"
		if("round")
			C.current_form = "round"
	switch(current_color)
		if("teal")
			C.current_color = "teal"
		if("pink")
			C.current_color = "pink"
	if(color_changed1 == TRUE)
		C.color_changed1 = TRUE
	if(form_changed1 == TRUE)
		C.form_changed1 = TRUE
	//and for inhand item.
	switch(pillow2_form)
		if("square")
			W.current_form = "square"
		if("round")
			W.current_form = "round"
	switch(current_color)
		if("teal")
			W.current_color = "teal"
		if("pink")
			W.current_color = "pink"
	if(color_changed2 == TRUE)
		W.color_changed = TRUE
	if(form_changed2 == TRUE)
		W.form_changed = TRUE
	W.update_icon_state()
	W.update_icon()
	del(src)
*/

/////////////////////////
///CODE FOR PILLOW BED///
/////////////////////////

/obj/structure/bed/pillow_large
	name = "large pillow pile"
	desc = "Large pile of pillows. Jump on it!"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi'
	icon_state = "pillowpile_large"
	var/current_color = "pink"
	var/mutable_appearance/armrest

/obj/structure/bed/pillow_large/Initialize()
	update_icon_state()
	update_icon()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	return ..()

/obj/structure/bed/pillow_large/proc/GetArmrest()
	if(current_color == "pink")
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_large_pink_overlay")
	if(current_color == "teal")
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_large_teal_overlay")

/obj/structure/bed/pillow_large/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/bed/pillow_large/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()
	density = TRUE
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y + 0.5

/obj/structure/bed/pillow_large/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/bed/pillow_large/post_unbuckle_mob(mob/living/M)
	. = ..()
	update_armrest()
	density = FALSE
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/bed/pillow_large/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
