/obj/machinery/vending/wardrobe/lustwish
	name = "LustWish"
	desc = "A vending machine for erotic games or even BDSM"
	icon_state = "lustwish"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/lustwish.dmi'
	age_restrictions = TRUE
	product_ads = "Try me!;Kinky!;Don't by shy, we all do that;Lewd, but fun!"
	vend_reply = "Enjoy!;We glad to satisfly your desires!"
	products = list(/obj/item/clothing/gloves/ball_mittens = 8,
					/obj/item/clothing/mask/ballgag = 8,
					/obj/item/clothing/under/misc/latex_catsuit = 8,
					/obj/item/clothing/shoes/latexheels = 5,
					/obj/item/clothing/under/rank/civilian/janitor/maid = 5,
					/obj/item/clothing/head/maid = 5,
					/obj/item/clothing/under/costume/maid = 5,
					/obj/item/clothing/gloves/evening = 5,
					/obj/item/clothing/glasses/blindfold = 5,
					/obj/item/restraints/handcuffs/lewd = 8)
	premium = list(	/obj/item/clothing/suit/straight_jacket/latex_straight_jacket = 5,
					/obj/item/clothing/mask/gas/bdsm_mask = 5,)
	contraband = list(/obj/item/clothing/glasses/hypno = 4,
					/obj/item/electropack/shockcollar = 4,
					/obj/item/assembly/signaler = 4)
	refill_canister = /obj/item/vending_refill/wardrobe/lustwish
	payment_department = ACCOUNT_SRV
	default_price = PAYCHECK_ASSISTANT * 2
	extra_price = PAYCHECK_COMMAND * 0.5
/obj/item/vending_refill/wardrobe/lustwish
	machine_name = "LustWish"
	icon_state = "lustwish_refill"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
