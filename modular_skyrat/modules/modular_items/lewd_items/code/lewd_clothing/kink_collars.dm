//To determine what kind of stuff we can put in collar.

/datum/component/storage/concrete/pockets/small/kink_collar
	max_items = 1

/datum/component/storage/concrete/pockets/small/kink_collar/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar))

/datum/component/storage/concrete/pockets/small/kink_collar/locked/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar,
	/obj/item/key/kink_collar))

//Here goes code for normal collar

/obj/item/clothing/neck/kink_collar
	name = "collar"
	desc = "Nice and tight collar, that fits perfectly to skin"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "collar_cyan"
	inhand_icon_state = "collar_cyan"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_SMALL
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/kink_collar
	var/tagname = null
	var/treat_path = /obj/item/food/cookie
	unique_reskin = list("Cyan" = "collar_cyan",
						"Yellow" = "collar_yellow",
						"Green" = "collar_green",
						"Red" = "collar_red",
						"Latex" = "collar_latex",
						"Orange" = "collar_orange",
						"White" = "collar_white",
						"Purple" = "collar_purple",
						"Black" = "collar_black",
						"Black-teal" = "collar_tealblack",
						"Spike" = "collar_spike")

//spawn thing in collar

/obj/item/clothing/neck/kink_collar/Initialize()
	. = ..()
	var/Key
	if(treat_path)
		Key = new treat_path(src)
		if(istype(Key,/obj/item/key/kink_collar))
			var/id = rand(111111,999999)
			var/obj/item/clothing/neck/kink_collar/locked/L = src
			var/obj/item/key/kink_collar/K = Key
			L.key_id = id
			K.key_id = id

//reskin code

/obj/item/clothing/neck/kink_collar/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)

//rename collar code

/obj/item/clothing/neck/kink_collar/attack_self(mob/user)
	tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//Here goes code for lockable version

/obj/item/clothing/neck/kink_collar/locked
	name = "locked collar"
	desc = "Tight collar. Looks like it have some kind of key lock on it."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "lock_collar_cyan"
	inhand_icon_state = "lock_collar_cyan"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/kink_collar/locked
	treat_path = /obj/item/key/kink_collar
	var/lock = FALSE
	var/broke = FALSE
	var/key_id = null //Adding unique id to collar
	unique_reskin = list("Cyan" = "lock_collar_cyan",
						"Yellow" = "lock_collar_yellow",
						"Green" = "lock_collar_green",
						"Red" = "lock_collar_red",
						"Latex" = "lock_collar_latex",
						"Orange" = "lock_collar_orange",
						"White" = "lock_collar_white",
						"Purple" = "lock_collar_purple",
						"Black" = "lock_collar_black",
						"Black-teal" = "lock_collar_tealblack",
						"Spike" = "lock_collar_spike")

//spawn thing in collar

//reskin code

/obj/item/clothing/neck/kink_collar/locked/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)


//locking or unlocking collar code

/obj/item/clothing/neck/kink_collar/locked/proc/IsLocked(var/L,mob/user)
	if(!broke)
		if(L == TRUE)
			to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
			lock = TRUE
			ADD_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
		if(L == FALSE)
			to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
			lock = FALSE
			REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
	else
		to_chat(user, "<span class='warning'>Looks like the lock is broken. Now it is an ordinary collar.</span>")
		lock = FALSE
		REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)

/obj/item/clothing/neck/kink_collar/locked/attackby(obj/item/K, mob/user, params)
	var/obj/item/clothing/neck/kink_collar/locked/collar = src
	//to_chat(world,"K=[K]/user=[user]/atakby=[src]")
	if(istype(K, /obj/item/key/kink_collar))
		var/obj/item/key/kink_collar/key = K
		if(key.key_id==collar.key_id)
			if(lock != FALSE)
				//to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
				IsLocked(FALSE,user)
			else
				//to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
				IsLocked(TRUE,user)
		else
			to_chat(user,"<span class='warning'>Looks like it's a wrong key!</span>")
	return

//this code prevents wearer from taking collar off if it's locked. Have fun!

/obj/item/clothing/neck/kink_collar/locked/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(ITEM_SLOT_NECK) && lock != FALSE)
		to_chat(user, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
		return
	add_fingerprint(usr)
	..()

/obj/item/clothing/neck/kink_collar/locked/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(loc == usr && usr.get_item_by_slot(ITEM_SLOT_NECK) && lock != FALSE && istype(over_object, /atom/movable/screen/inventory/hand))
		to_chat(usr, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
		return
	var/atom/movable/screen/inventory/hand/H = over_object
	if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
		add_fingerprint(usr)
	..()

//And here some code for key thingy

/obj/item/key/kink_collar
	name = "kink collar key"
	desc = "A key for a tiny lock on a collar or bag."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "collar_key"
	var/keyname = null//name of our key. It's null by default.
	var/key_id = null //Adding same unique id to key
	unique_reskin = list("Cyan" = "collar_key_blue",
						"Yellow" = "collar_key_yellow",
						"Green" = "collar_key_green",
						"Red" = "collar_key_red",
						"Latex" = "collar_key_latex",
						"Orange" = "collar_key_orange",
						"White" = "collar_key_white",
						"Purple" = "collar_key_purple",
						"Black" = "collar_key_black",
						"Metal" = "collar_key",
						"Black-teal" = "collar_key_tealblack")

//changing color of key in case if we using multiple collars
/obj/item/key/kink_collar/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)

//changing name of key in case if we using multiple collars with same color
/obj/item/key/kink_collar/attack_self(mob/user)
	keyname = stripped_input(user, "Would you like to change the name on the key?", "Renaming key", "Key", MAX_NAME_LEN)
	name = "[initial(name)] - [keyname]"

//we checking if we can open collar with THAT KEY with SAME ID as the collar.
/obj/item/key/kink_collar/attack(mob/living/M, mob/living/user, params)
	. = ..()
	//to_chat(world,"target=[M]/user=[user]/atakby=[src]")
	var/mob/living/carbon/target = M
	if(istype(target.wear_neck,/obj/item/clothing/neck/kink_collar/locked/))
		var/obj/item/key/kink_collar/key = src
		var/obj/item/clothing/neck/kink_collar/locked/collar = target.wear_neck
		if(collar.key_id == key.key_id)
			if(collar.lock != FALSE)
				//to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
				collar.IsLocked(FALSE,user)
			else
				//to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
				collar.IsLocked(TRUE,user)
		else
			to_chat(user,"<span class='warning'>Looks like it's a wrong key!</span>")
	return

/obj/item/circular_saw/attack(mob/living/M, mob/living/user, params)
	. = ..()
	//to_chat(world,"target=[M]/user=[user]/atakby=[src]")
	var/mob/living/carbon/target = M
	if(istype(target.wear_neck,/obj/item/clothing/neck/kink_collar/locked/))
		var/obj/item/clothing/neck/kink_collar/locked/collar = target.wear_neck
		if(!collar.broke)
			if(target != user)
				to_chat(user, "<span class='warning'>You try to cut collar lock!</span>")
				if(do_after(user, 20, target))
					collar.broke = TRUE
					collar.IsLocked(FALSE,user)
					if(rand(0,2) == 0) //chance to get damage
						to_chat(user, "<span class='warning'>You broke the collar lock, but [target.name] have sevaral cuts!</span>")
						target.apply_damage(rand(1,4),BRUTE,BODY_ZONE_HEAD,wound_bonus=10)
					else
						to_chat(user, "<span class='warning'>You broke the collar lock!</span>")
			else
				to_chat(user, "<span class='warning'>You try to cut collar lock!</span>")
				if(do_after(user, 30, target))
					if(rand(0,2) == 0)
						to_chat(user, "<span class='warning'>You broke the collar lock and got sevaral cuts!</span>")
						collar.broke = TRUE
						collar.IsLocked(FALSE,user)
						target.apply_damage(rand(2,4),BRUTE,BODY_ZONE_HEAD,wound_bonus=10)
					else
						to_chat(user, "<span class='warning'>You you didn't break the collar lock and got sevaral cuts!</span>")
						target.apply_damage(rand(3,5),BRUTE,BODY_ZONE_HEAD,wound_bonus=30)
		else
			to_chat(user, "<span class='warning'>Looks like the lock is broken.</span>")


