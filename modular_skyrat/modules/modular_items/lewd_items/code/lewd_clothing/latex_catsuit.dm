/obj/item/clothing/under/misc/latex_catsuit
	name = "latex catsuit"
	desc = "Shiny uniform, that fits snugly to the skin"
	icon_state = "latex_catsuit_female"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-digi.dmi'
	worn_icon_taur_snake = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-snake.dmi'
	worn_icon_taur_paw = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-paw.dmi'
	worn_icon_taur_hoof = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-hoof.dmi'
	inhand_icon_state = "latex_catsuit"
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	can_adjust = FALSE
	equip_delay_other = 80
	equip_delay_self = 80
	strip_delay = 80
	mutant_variants = STYLE_DIGITIGRADE|STYLE_TAUR_ALL
	// fitted = NO_FEMALE_UNIFORM
	// var/suit_gender = "male"
	// gender = PLURAL

// //to update icon on mob
// /obj/item/clothing/under/misc/latex_catsuit/ComponentInitialize()
// 	. = ..()
// 	AddElement(/datum/element/update_icon_updates_onmob)

// //to spawn catsuit with sprite
// /obj/item/clothing/under/misc/latex_catsuit/Initialize()
// 	. = ..()
// 	update_icon_state()
// 	update_icon()

// /obj/item/clothing/under/misc/latex_catsuit/update_icon()

// //need to correctly change sprite
// /obj/item/clothing/under/misc/latex_catsuit/update_icon_state()
// 	icon_state = "[initial(icon_state)]_[suit_gender]"
// 	worn_icon_state = icon_state
// 	update_icon()
// 	// update_inv_w_uniform()

//this fragment of code makes unequipping not instant
/obj/item/clothing/under/misc/latex_catsuit/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/human/C = user
		if(src == C.w_uniform)
			if(!do_after(C, 60, target = src))
				return
	. = ..()

// //some gender identification magic
/obj/item/clothing/under/misc/latex_catsuit/equipped(mob/living/U, slot)
	var/mob/living/carbon/human/C = U
	if(src == C.w_uniform)
		if(U.gender == FEMALE)
			to_chat(U,"gender female")
			icon_state = "latex_catsuit_female"
			// update_icon()
			// update_icon_state()
			U.update_inv_w_uniform()

		if(U.gender == MALE)
			icon_state = "latex_catsuit_male"
			// update_icon()
			// update_icon_state()
			U.update_inv_w_uniform()
		. = ..()



