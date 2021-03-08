/obj/structure/chair/pillow_small
	name = "small pillow pile"
	desc = "Small pile of pillows. Looks as comfortable seat, especially for taurs and nagas."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi'
	icon_state = "pillowpile_small"
	var/current_color = "pink"
	var/mutable_appearance/armrest

/obj/structure/chair/pillow_small/Initialize()
	update_icon_state()
	update_icon()
	armrest = GetArmrest()
	armrest.layer = ABOVE_MOB_LAYER
	return ..()

/obj/structure/chair/pillow_small/proc/GetArmrest()
	if(current_color == "pink")
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_small_pink_overlay")
	if(current_color == "teal")
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/pillows.dmi', "pillowpile_small_teal_overlay")

/obj/structure/chair/pillow_small/Destroy()
	QDEL_NULL(armrest)
	return ..()

/obj/structure/chair/pillow_small/post_buckle_mob(mob/living/M)
	. = ..()
	update_armrest()
	density = TRUE
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y + 4.9

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

/////////////////////
///pillow bed code///
/////////////////////

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
