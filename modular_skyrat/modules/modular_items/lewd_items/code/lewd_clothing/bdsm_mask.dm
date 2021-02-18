//preparing sutff for moans thing
/obj/item/clothing/mask/gas/bdsm_mask
	var/list/moans ///phrases to be said when the player attempts to talk when speech modification / voicebox is enabled.
	var/list/moans_alt ///lower probability phrases to be said when talking.
	var/moans_alt_probability ///probability for alternative sounds to play.

/obj/item/clothing/mask/gas/bdsm_mask
	name = "latex gasmask"
	desc = "Toned gas mask. Completely muffles the wearer, making even breathing really hard with this on."
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_masks.dmi'
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_masks.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "mask"
	inhand_icon_state = "mask"
	var/mask_on = FALSE //lights model turned off
	var/current_mask_color = "pink"
	var/breath_status = TRUE
	var/time_to_choke = 6	//how long can breath hold
	var/time_to_choke_left	//time left before start choking
	var/time = 2			//interval for emotes
	var/tt					//interval timer
	var/color_changed = FALSE
	var/static/list/mask_designs
	actions_types = list(/datum/action/item_action/toggle_breathcontrol,
						 /datum/action/item_action/mask_inhale)
	moans = list("Mmmph...", "Hmmphh", "Mmmfhg", "Gmmmh...")
	moans_alt = list("Mhgm...", "Hmmmp!...", "GMmmhp!")
	moans_alt_probability = 5

//we can only moan with that thing on
/obj/item/clothing/mask/gas/bdsm_mask
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/gas/bdsm_mask/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_MESSAGE] = pick((prob(moans_alt_probability) && LAZYLEN(moans_alt)) ? moans_alt : moans)

//create radial menu
/obj/item/clothing/mask/gas/bdsm_mask/proc/populate_mask_designs()
	mask_designs = list(
		"pink" = image (icon = src.icon, icon_state = "mask_pink_off"),
		"cyan" = image(icon = src.icon, icon_state = "mask_cyan_off"))

//using multitool on pole
obj/item/clothing/mask/gas/bdsm_mask/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, mask_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_mask_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change mask's model
/obj/item/clothing/mask/gas/bdsm_mask/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

//initializing stuff
/obj/item/clothing/mask/gas/bdsm_mask/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(mask_designs))
		populate_mask_designs()

//to update icon by magic
/obj/item/clothing/mask/gas/bdsm_mask/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

//to update icon state properly
/obj/item/clothing/mask/gas/bdsm_mask/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_mask_color]_[mask_on? "on" : "off"]"
	inhand_icon_state = "[initial(icon_state)]_[current_mask_color]_[mask_on? "on" : "off"]"

//to make in unremovable without helping when mask is on
/obj/item/clothing/mask/gas/bdsm_mask/attack_hand(mob/user)
	if(iscarbon(user))
		if(mask_on == TRUE)
			var/mob/living/carbon/C = user
			if(C.wear_mask == src)
				to_chat(user, "<span class='warning'>You need help taking this off!</span>")
				return
	add_fingerprint(usr)
	. = ..()

//to make in unremovable without helping when mask is on (for MouseDrop)
/obj/item/clothing/mask/gas/bdsm_mask/MouseDrop(atom/over_object)
	var/mob/M = usr
	var/mob/living/carbon/human/C = usr
	if(ismecha(M.loc)) // stops inventory actions in a mech
		return
	if(!M.incapacitated())
		if(loc == M)
			if(istype(over_object, /atom/movable/screen/inventory/hand))
				var/atom/movable/screen/inventory/hand/H = over_object
				if(iscarbon(usr))
					if(mask_on == TRUE)
						if(src == C.wear_mask || . == C.wear_mask)
							to_chat(usr, "<span class='warning'>You need help taking this off!</span>")
							return
				if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
					add_fingerprint(usr)
				. = ..()

//Breathing valve control button
/datum/action/item_action/toggle_breathcontrol
    name = "Toggle breath controlling filter"
    desc = "Makes incredebly hard to breath in this mask. Use with caution"

//trigger thing for manual breath
/datum/action/item_action/toggle_breathcontrol/Trigger()
	var/obj/item/clothing/mask/gas/bdsm_mask/H = target
	if(istype(H))
		H.check()

/datum/action/item_action/mask_inhale
    name = "Inhale oxygen"
    desc = "You must inhale oxygen!"
  //TODO: icon_icon = make icon for inhaling

//Open the valve when press the button
/datum/action/item_action/mask_inhale/Trigger()
	if(istype(target, /obj/item/clothing/mask/gas/bdsm_mask))
		var/obj/item/clothing/mask/gas/bdsm_mask/M = target
		if(M.breath_status == FALSE)
			M.time_to_choke_left = M.time_to_choke
			M.breath_status = TRUE
			var/mob/living/carbon/C = usr
			C.emote("inhale")
		return
	..()

//adding breath_manually on equip
/obj/item/clothing/mask/gas/bdsm_mask/equipped(/mob/user, slot)
	. = ..()
	var/mob/living/carbon/C = usr
	var/I = usr.get_item_by_slot(ITEM_SLOT_MASK)
	if(I==src)
		if(mask_on)
			if(breath_status == FALSE)
				time_to_choke_left = time_to_choke
				breath_status = TRUE
				C.emote("inhale")
			to_chat(usr,"<font color=purple>You suddenly realize that breathing has become much harder!.</font>")
			START_PROCESSING(SSobj, src)
			time_to_choke_left = time_to_choke

//We unequipped mask, now we can breath without buttons
/obj/item/clothing/mask/gas/bdsm_mask/dropped(mob/user)
	. = ..()
	if(mask_on == TRUE)
		STOP_PROCESSING(SSobj, src)

//to check if player already have this mask on and trying to change mode
/obj/item/clothing/mask/gas/bdsm_mask/proc/check()
	var/mob/living/carbon/C = usr
	if(src == C.wear_mask)
		to_chat(usr, "<span class ='notice'> You can't reach the air filter switch! </span>")
	else
		toggle(C)

//Switch the mask valve to the opposite state
/obj/item/clothing/mask/gas/bdsm_mask/proc/toggle(user)
	mask_on = !mask_on
	to_chat(user, "<span class='notice'>You turn the air filter [mask_on? "on. Use with caution!" : "off. Now it's safe to wear"]</span>")
	playsound(user, mask_on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 40, TRUE)
	update_icon_state()
	update_icon()
	var/mob/living/carbon/C = usr
	if(mask_on)
		if(src == C.wear_mask)
			START_PROCESSING(SSobj, src)
			time_to_choke_left = time_to_choke
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/gas/bdsm_mask/process(delta_time)
	var/mob/living/U = loc
	if(time_to_choke_left < time_to_choke/2 && breath_status == TRUE)
		U.emote("exhale")
		breath_status = FALSE
		if(rand(0,3) == 0)
			U.emote("moan")

	if(time_to_choke_left <= 0)
		if(tt <= 0)
			U.adjustOxyLoss(rand(4,8)) //oxy dmg
			U.emote(pick("gasp","choke","moan"))
			tt = time
		else
			tt -= delta_time
	else
		time_to_choke_left -= delta_time

////////////////////////////////
//////////---FILTERS---/////////
////////////////////////////////

//here goes code for lewd gasmask filter
/obj/item/lewd_filter
	name = "gasmask filter"
	desc = "Strange looking air filter. Maybe it's not good idea to put it on..."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "filter_pink"
	unique_reskin = list("pink" = "filter_pink",
						"teal" = "filter_teal")
	w_class = WEIGHT_CLASS_SMALL
	var/volume = 50
	var/list/list_reagents = list(/datum/reagent/drug/space_drugs = 50)

///obj/item/lewd_filter/proc/spray_reagent(mob/user, obj/item/lewd_filter/filter)

//i just wanted to add 2th color variation. Because.
/obj/item/lewd_filter/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)
