////////////
///CONDOM///
////////////

//Packaged condom

/obj/item/condom_pack
	name = "condom_pack"
	desc = "Don't worry, i have protection."
	icon_state = "condom_pack"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "pink"
	var/color_changed = FALSE
	var/static/list/condom_colors

/obj/item/condom_pack/Initialize()
	. = ..()
	//color chosen randomly when item spawned
	if(prob(50))
		current_color = "teal"
	else
		current_color = "pink"
	update_icon_state()
	update_icon()


/obj/item/condom_pack/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"

//Opened condom

/obj/item/condom
	name = "condom"
	desc = "I wonder if i can put this on head..."
	icon_state = "condom"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "pink"
	var/condom_state = "unused"
	var/equipped = FALSE
	slot_flags = ITEM_SLOT_PENIS

/obj/item/condom/Initialize()
	. = ..()
	update_icon_state()
	update_icon()

/obj/item/condom/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]_[equipped? "used" : "unused"]"

//When condom equipped we doing stuff

/obj/item/condom/equipped(mob/user, slot, initial)
	. = ..()
	if(slot == ITEM_SLOT_PENIS)
		equipped = TRUE
		update_icon_state()
		update_icon()

//used condom
/obj/item/condom_used
	name = "used condom"
	desc = "Eww! Throw it in trash!"
	icon_state = "condom_dirty"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "pink"
	slot_flags = ITEM_SLOT_PENIS //To keep it on organ after... Use.

/obj/item/condom_used/Initialize()
	. = ..()
	update_icon_state()
	update_icon()

/obj/item/condom_used/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
