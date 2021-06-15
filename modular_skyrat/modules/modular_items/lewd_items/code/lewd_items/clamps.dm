/obj/item/clothing/sextoy/nipple_clamps
	name = "nipple clamps"
	desc = "Causing pain to nipples"
	icon_state = "clamps"
	worn_icon_state = "clamps"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_NIPPLES

	var/breast_type
	var/breast_size

/obj/item/clothing/sextoy/nipple_clamps/update_icon_state()
	. = ..()
	worn_icon_state = "[initial(icon_state)]_[breast_type]_[breast_size]"

/obj/item/clothing/sextoy/nipple_clamps/equipped(mob/user, slot, initial)
	. = ..()
	var/mob/living/carbon/human/U = user
	var/obj/item/organ/genital/breasts/B = U.getorganslot(ORGAN_SLOT_BREASTS)

	if(B?.genital_type == "pair")
		breast_type = "pair"
		breast_size = B?.genital_size
	if(B?.genital_type == "quad")
		breast_type = "quad"
		breast_size = B?.genital_size
	if(B?.genital_type == "sextuple")
		breast_type = "sextuple"
		breast_size = B?.genital_size
	else //character don't have tits, but male character should suffer too!
		breast_type = "pair"
		breast_size = 0

	if(slot == "nipples")
		START_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/nipple_clamps/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	var/mob/living/carbon/human/C = user
	C.update_inv_nipples()
	C.hud_used.hidden_inventory_update()

/obj/item/clothing/sextoy/nipple_clamps/process(delta_time)
	. = ..()
	var/mob/living/carbon/human/U = loc
	var/obj/item/organ/genital/breasts/B = U.getorganslot(ORGAN_SLOT_BREASTS)
	var/bzz = 0
	bzz = 0.5
	U.adjustArousal(bzz * delta_time)
	if(U.pain >= 30) //To prevent maxing pain by just pair of clamps.
		U.adjustPain(bzz * delta_time)
	if(B.aroused != AROUSAL_CANT)
		B.aroused = AROUSAL_FULL //Clamps keeping nipples aroused
