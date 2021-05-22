/obj/item/clothing/strapon
	name = "strapon"
	desc = "Sometimes you need special way to humiliate someone."
	icon_state = "strapon"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	slot_flags = ITEM_SLOT_BELT
	var/in_hands = FALSE
	var/type_changed = FALSE
	var/strapon_type = "human"
	var/obj/item/strapon_dildo/W
	var/static/list/strapon_types
	actions_types = list(/datum/action/item_action/take_strapon)

//create radial menu
/obj/item/clothing/strapon/proc/populate_strapon_types()
	strapon_types = list(
		"avian" = image (icon = src.icon, icon_state = "strapon_avian"),
		"canine" = image (icon = src.icon, icon_state = "strapon_canine"),
		"dragon" = image (icon = src.icon, icon_state = "strapon_dragon"),
		"equine" = image (icon = src.icon, icon_state = "strapon_equine"),
		"human" = image (icon = src.icon, icon_state = "strapon_human"))

//to update model
/obj/item/clothing/strapon/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to change model
/obj/item/clothing/strapon/AltClick(mob/user, obj/item/I)
	if(type_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, strapon_types, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		strapon_type = choice
		update_icon()
		type_changed = TRUE
	else
		return

//Check if we can change strapon's model
/obj/item/clothing/strapon/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/strapon/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	update_action_buttons_icons()
	if(!length(strapon_types))
		populate_strapon_types()

/obj/item/clothing/strapon/update_icon_state()
	.=..()
	icon_state = "[initial(icon_state)]_[strapon_type]"

/obj/item/clothing/strapon/dropped()
	.=..()
	if(W && !ismob(loc) && in_hands == TRUE)
		qdel(W)
		in_hands = FALSE

//Functionality stuff
/obj/item/clothing/strapon/proc/update_action_buttons_icons()
	var/datum/action/item_action/M
	if(istype(M, /datum/action/item_action/take_strapon))
		M.button_icon_state = "dildo_[strapon_type]"
		M.icon_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	update_icon()

//button stuff
/datum/action/item_action/take_strapon
    name = "Take strapon dildo in hand"
    desc = "You need to take this thing in your hand to use it properly"

/datum/action/item_action/take_strapon/Trigger()
	var/obj/item/clothing/strapon/H = target
	if(istype(H))
		H.check()

/obj/item/clothing/strapon/proc/check()
	var/mob/living/carbon/human/C = usr
	if(src == C.belt)
		toggle(C)
	else
		to_chat(C, "<span class='warning'>You need to equip strapon before using!</span>")

/obj/item/clothing/strapon/proc/toggle(user)
	var/mob/living/carbon/human/C = usr
	playsound(C, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 40, TRUE)
	var/obj/item/held = C.get_active_held_item()
	var/obj/item/unheld = C.get_inactive_held_item()
	if(in_hands == FALSE)
		if(src == C.belt)
			//CODE FOR PUTTING STRAPON IN HANDS
			if(held || unheld)
				if(!((held.name =="strapon" && held.item_flags == ABSTRACT | HAND_ITEM) || (unheld.name =="strapon" && unheld.item_flags == ABSTRACT | HAND_ITEM)))
					W = new()
					C.put_in_hands(W)
					W.strapon_type = strapon_type
					W.update_icon_state()
					W.update_icon()
					C.visible_message("<span class='notice'>[user] takes a strapon in their hand. Looks menacingly</span>")
				else
					qdel(W)
			else
				W = new()
				C.put_in_hands(W)
				W.strapon_type = strapon_type
				W.update_icon_state()
				W.update_icon()
				C.visible_message("<span class='notice'>[user] takes a strapon in their hand. Looks menacingly</span>")
			//END
	else
		//CODE FOR PUTTING STRAPON BACK
		if(((held.name =="strapon" && held.item_flags == ABSTRACT | HAND_ITEM) || (unheld.name =="strapon" && unheld.item_flags == ABSTRACT | HAND_ITEM)))
			qdel(W)
			C.visible_message("<span class='notice'>[user] put strapon back</span>")
	in_hands = !in_hands
		//END

/obj/item/strapon_dildo
	name = "strapon"
	desc = "You looking menacingly and merciless"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "dildo"
	inhand_icon_state = "nothing"
	force = 1 //I mean like... You can beat someone with dildo in saints row, ok? 1 is enough, don't touch it plz.
	throwforce = 0
	item_flags = ABSTRACT | HAND_ITEM
	var/strapon_type = "human" //Default var, but we always getting var from strapon_type from item on top

/obj/item/strapon_dildo/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	ADD_TRAIT(src, TRAIT_NODROP, STRAPON_TRAIT)

/obj/item/strapon_dildo/update_icon_state()
	.=..()
	icon_state = "[initial(icon_state)]_[strapon_type]"

/obj/item/strapon_dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	. = ..()
	if(!istype(M, /mob/living/carbon/human))
		return

	var/message = ""
	var/obj/item/organ/genital/vagina = M.getorganslot(ORGAN_SLOT_VAGINA)
	if(M.client?.prefs.erp_pref == "Yes")
		switch(user.zone_selected) //to let code know what part of body we gonna fuck
			if(BODY_ZONE_PRECISE_GROIN)
				if(vagina)
					if(M.is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
						message = (user == M) ? pick("rubs their vagina with the [src]","gently jams their pussy with [src]","fucks their vagina with a [src]") : pick("delicately rubs [M]'s vagina with [src]", "uses [src] to fuck [M]'s vagina","jams [M]'s pussy with a [src]", "teasing [M]'s pussy with a [src]")
						M.adjustArousal(6)
						M.adjustPleasure(8)
						if(prob(40))
							M.emote(pick("twitch_s","moan"))
						user.visible_message("<font color=purple>[user] [message].</font>")
						playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
											'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
											'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
											'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
											'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
											'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 60, TRUE)
					else
						to_chat(user, "<span class='danger'>Looks like [M]'s groin is covered!</span>")
						return
				else
					to_chat(user, "<span class='danger'>Looks like [M] don't have suitable organs for that!</span>")
					return

			if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES) //Mouth only. Sorry, perverts. No eye/ear penetration for you today.
				if(!M.is_mouth_covered())
					message = (user == M) ? pick("sucks [src] with their mouth","licks [src], then slowly inserting it into their throat") : pick("fucks [M]'s mouth with [src]", "choking [M] by inserting [src] into [M]'s throat", "forcing [M] to suck a [src]", "inserts [src] into [M]'s throat")
					M.adjustArousal(4)
					M.adjustPleasure(1)
					M.adjustOxyLoss(1.5)
					if(prob(70))
						M.emote(pick("gasp","moan"))
					user.visible_message("<font color=purple>[user] [message].</font>")
					playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 40, TRUE)

				else
					to_chat(user, "<span class='danger'>Looks like [M]'s mouth is covered!</span>")
					return

			else
				if(M.is_bottomless())
					message = (user == M) ? pick("puts [src] into their anus","slowly inserts [src] into their ass") : pick("fucks [M]'s ass with a [src]", "uses [src] to fuck [M]'s anus", "jams [M]'s ass with a [src]", "roughly fucks [M]'s ass with a [src], making [M] roll eyes up")
					M.adjustArousal(5)
					M.adjustPleasure(5)
					if(prob(60))
						M.emote(pick("twitch_s","moan","shiver"))
					user.visible_message("<font color=purple>[user] [message].</font>")
					playsound(loc, pick('modular_skyrat/modules/modular_items/lewd_items/sounds/bang1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang3.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang4.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang5.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/bang6.ogg'), 100, TRUE)

				else
					to_chat(user, "<span class='danger'>Looks like [M]'s anus is covered!</span>")
					return
	else
		to_chat(user, "<span class='danger'>Looks like [M] don't want you to do that.</span>")
		return
