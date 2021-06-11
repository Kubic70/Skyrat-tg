/obj/item/storage/belt/erpbelt
	name = "leather belt"
	desc = "Used to hold sex toys. Looks pretty good."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_belts.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_belts.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "erpbelt"
	inhand_icon_state = "erpbelt"
	worn_icon_state = "erpbelt"
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'

/obj/item/storage/belt/erpbelt/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 21
	STR.set_holdable(list(
		/obj/item/clothing/mask/ballgag,
		/obj/item/clothing/mask/ballgag_phallic,
		/obj/item/clothing/glasses/hypno,
		/obj/item/clothing/neck/kink_collar,
		/obj/item/clothing/neck/kink_collar/locked,
		/obj/item/clothing/glasses/blindfold/kinky,
		/obj/item/clothing/ears/kinky_headphones,
		/obj/item/electropack/shockcollar,
		/obj/item/eggvib,
		/obj/item/electropack/signalvib,
		/obj/item/buttplug,
		/obj/item/tickle_feather,
		/obj/item/kinky_shocker,
		/obj/item/clothing/mask/leatherwhip,
		/obj/item/magic_wand,
		/obj/item/restraints/handcuffs/lewd,
		/obj/item/bdsm_candle,
		/obj/item/vibrator))
