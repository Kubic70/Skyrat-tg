/obj/item/clothing/head/domina_cap
	name = "dominant cap"
	desc = "For special types of inspections."
	icon_state = "dominacap"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_hats.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_hats.dmi'

//message when equipping that thing
/obj/item/clothing/head/domina_cap/equipped(mob/user, slot)
	. = ..()
	if(victim.head == src)
		user.visible_message("<font color=purple>You feel much more determined.</font>")
	else
		return

//message when unequipping that thing
/obj/item/clothing/head/domina_cap/dropped(mob/user)
	. = ..()
	user.visible_message("<font color=purple>BDSM session ended, huh?</font>")
