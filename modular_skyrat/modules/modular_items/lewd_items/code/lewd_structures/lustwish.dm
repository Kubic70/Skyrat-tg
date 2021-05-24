/obj/machinery/vending/lustwish
	name = "LustWish"
	desc = "A vending machine with various toys from light erotic to BDSM"
	icon_state = "lustwish"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/lustwish.dmi'
	light_mask = "lustwish-light-mask"
	age_restrictions = TRUE
	var/card_used = FALSE
	var/current_color = "pink"
	var/static/list/vend_designs
	product_ads = "Try me!;Kinky!;Lewd, but fun!;Hey you, yeah you... wanna take a look at my collection?;Come on, take a look!;Remember, always adhere to Nanotrasen corporate policy!"
	vend_reply = "Enjoy!;We glad to satisfly your desires!"

	//STUFF SOLD HERE//
	products = list(/obj/item/clothing/gloves/ball_mittens = 8,
					/obj/item/electropack/signalvib = 8,
					/obj/item/eggvib = 8,
					/obj/item/vibroring = 6,
					/obj/item/clothing/mask/ballgag = 8,
					/obj/item/clothing/mask/ballgag_phallic = 8,
					/obj/item/clothing/suit/corset = 8,
					/obj/item/clothing/under/misc/latex_catsuit = 8,
					/obj/item/clothing/shoes/latexheels = 5,
					/obj/item/clothing/head/domina_cap = 5,
					/obj/item/storage/belt/erpbelt = 5,
					/obj/item/clothing/glasses/nice_goggles = 1,
					/obj/item/clothing/neck/kink_collar = 8,
					/obj/item/clothing/under/rank/civilian/janitor/maid = 5,
					/obj/item/clothing/head/maid = 5,
					/obj/item/clothing/gloves/latex_gloves = 8,
					/obj/item/clothing/under/costume/lewdmaid = 5,
					/obj/item/clothing/glasses/blindfold/kinky = 5,
					/obj/item/clothing/ears/kinky_headphones = 5,
					/obj/item/clothing/suit/straight_jacket/shackles = 3,
					/obj/item/clothing/gloves/evening = 5,
					/obj/item/clothing/under/stripper_outfit = 5,
					/obj/item/reagent_containers/pill/crocin = 20,
					/obj/item/condom_pack = 20,
					/obj/item/reagent_containers/pill/camphor = 10,
					/obj/item/dildo = 8,
					/obj/item/tickle_feather = 8,
					/obj/item/fleshlight = 8,
					/obj/item/kinky_shocker = 4,
					/obj/item/clothing/mask/leatherwhip = 4,
					/obj/item/magic_wand = 4,
					/obj/item/clothing/under/misc/gear_harness = 4,
					/obj/item/bdsm_candle = 4,
					/obj/item/spanking_pad = 4,
					/obj/item/vibrator = 4,
					/obj/item/serviette_pack = 10,
					/obj/item/restraints/handcuffs/lewd = 8,
					/obj/item/leash = 4,
					/obj/item/pillow = 6)

	premium = list(	/obj/item/clothing/suit/straight_jacket/latex_straight_jacket = 5,
					/obj/item/clothing/mask/gas/bdsm_mask = 5,
					/obj/item/clothing/head/helmet/space/deprivation_helmet = 5,
					/obj/item/bdsm_bed_kit = 3,
					/obj/item/polepack = 3)

	contraband = list(/obj/item/clothing/glasses/hypno = 4,
					/obj/item/electropack/shockcollar = 4,
					/obj/item/assembly/signaler = 4,
					/obj/item/clothing/neck/kink_collar/locked = 4,
					/obj/item/clothing/suit/straight_jacket/kinky_sleepbag = 2,
					/obj/item/reagent_containers/pill/hexacrocin = 10,
					/obj/item/reagent_containers/pill/pentacamphor = 5,
					/obj/item/reagent_containers/glass/bottle/breast_enlarger = 6)

	refill_canister = /obj/item/vending_refill/lustwish
	payment_department = ACCOUNT_SRV
	default_price = PAYCHECK_ASSISTANT * 2
	extra_price = PAYCHECK_COMMAND * 0.5

//Secret vending machine skin. Don't touch plz
/obj/machinery/vending/lustwish/proc/populate_vend_designs()
    vend_designs = list(
        "pink" = image (icon = src.icon, icon_state = "lustwish_pink"),
        "teal" = image(icon = src.icon, icon_state = "lustwish_teal"))

//Changing special secret var
/obj/machinery/vending/lustwish/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/lustwish_discount))
		user.visible_message("<span class='boldnotice'>After clicking something changes in the LustWish vending machine</span>")
		card_used = !card_used
		switch(card_used)
			if(TRUE)
				default_price = 0
				extra_price = 0
			if(FALSE)
				default_price = PAYCHECK_ASSISTANT * 2
				extra_price = PAYCHECK_COMMAND * 0.5
	else
		return

//using multitool on pole
/obj/machinery/vending/lustwish/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(card_used == TRUE)
		var/choice = show_radial_menu(user,src, vend_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 50, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
	else
		return

/obj/machinery/vending/lustwish/proc/check_menu(mob/living/user, obj/item/multitool)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!multitool || !user.is_holding(multitool))
		return FALSE
	return TRUE

/obj/machinery/vending/lustwish/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(vend_designs))
		populate_vend_designs()

/obj/machinery/vending/lustwish/update_icon_state()
	..()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]_[current_color]-broken"
	else
		icon_state = "[initial(icon_state)]_[current_color][powered() ? null : "-off"]"


//Refill item
/obj/item/vending_refill/lustwish
	machine_name = "LustWish"
	icon_state = "lustwish_refill"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
