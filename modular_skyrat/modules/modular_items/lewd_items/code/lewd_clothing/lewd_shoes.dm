//heels item
/obj/item/clothing/shoes/latexheels
	name = "latex heels"
	desc = "Lace up before use. Pretty hard to walk in these."
	icon_state = "latexheels"
	inhand_icon_state = "latexheels"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes_digi.dmi'
	var/discomfort = 0
	var/messagewas = FALSE
	var/messagewas2 = FALSE
	strip_delay = 120
	slowdown = 4

//it takes time to put them off, do not touch
/obj/item/clothing/shoes/latexheels/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.shoes)
			if(!do_after(C, 40, target = src))
				return
	. = ..()

///obj/item/clothing/shoes/latexheels/equipped(mob/user, slot)
//	. = ..()
//	var/mob/living/carbot/human/C = user
//	if(src == C.shoes)
//		START_PROCESSING(SSobj, src)


//we dropping item so we not deaf now. hurray.
/obj/item/clothing/shoes/latexheels/dropped(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	STOP_PROCESSING(SSobj, src)
	messagewas = FALSE
	messagewas2 = FALSE
	if(discomfort >= 80)
		to_chat(H,"<font color=purple>Painful heels no longer hurts you</font>")
	discomfort = 0

//TO GEMINEE, DELETE AFTER COMPLETING CODE
// Привет, Джемини. Надо сделать так чтобы каждые 4 секунды дискомфорт увеличивался на 1 если персонаж надел балетки.
// Затем увеличивался параметр adjustPain на 2 единицы, при пресечении 80 ед дискомфорта выводилось одно сообщение, при 100 - другое
// Оставь там затычки, я все это доделаю. Тебе нужно лишь сделать то что выше.

// Heels pain processor
///obj/item/clothing/shoes/latexheels/process(delta_time)
//	var/mob/living/carbon/human/U = loc
//	if(discomfort >= 100)
//		discomfort += 1

	//Pain effect
//	if(discomfort >= 80)
//		if(messagewas = FALSE)
//			messagewas = TRUE

//	if(discomfort >=100)
//		if(messagewas2 = FALSE)
//			messagewas2 = TRUE

//to make sound when we walking in this
/obj/item/clothing/shoes/latexheels/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_skyrat/modules/modular_items/lewd_items/sounds/highheel1.ogg' = 1,'modular_skyrat/modules/modular_items/lewd_items/sounds/highheel2.ogg' = 1), 70)

/////////////////
///Latex socks///
/////////////////

/obj/item/clothing/shoes/latex_socks
	name = "latex socks"
	desc = "Splitting toe shiny socks made of some strange material."
	icon_state = "latexsocks"
	inhand_icon_state = "latexsocks"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes_digi.dmi'

//////////////////
///Domina heels///
//////////////////

/obj/item/clothing/shoes/dominaheels //added for Kubic request
	name = "dominant heels"
	desc = "A pair of aesthetically pleasing heels ."
	icon_state = "dominaheels"
	inhand_icon_state = "dominaheels"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes_digi.dmi'
	equip_delay_other = 60
	strip_delay = 60
	slowdown = 1

//it takes time to put them off, do not touch
/obj/item/clothing/shoes/dominaheels/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.shoes)
			if(!do_after(C, 20, target = src))
				return
	. = ..()

//to make sound when we walking in this
/obj/item/clothing/shoes/dominaheels/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_skyrat/modules/modular_items/lewd_items/sounds/highheel1.ogg' = 1,'modular_skyrat/modules/modular_items/lewd_items/sounds/highheel2.ogg' = 1), 70)
