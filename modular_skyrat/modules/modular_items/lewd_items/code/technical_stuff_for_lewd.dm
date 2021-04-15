//////////////////////////////////////////////////////////////////////////
//THIS IS NOT HERESY, DO NOT TOUCH IT IN THE NAME OF GOD//////////////////
//I made this file to prevent myself from touching normal files///////////
//////////////////////////////////////////////////////////////////////////

#define REQUIRE_NONE 0
#define REQUIRE_EXPOSED 1
#define REQUIRE_UNEXPOSED 2
#define REQUIRE_ANY 3

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////This code is supposed to be placed in "code/modules/mob/living/carbon/human/inventory.dm"/////////////
//If you are nice person you can transfer this part of code to it, but i didn't for modularisation reasons//
//////////////////////////////////////////for ball mittens//////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/human/equip_to_slot(obj/item/I, slot, initial = FALSE, redraw_mob = FALSE)
	. = ..()
	if(ITEM_SLOT_GLOVES)
		if(I)
			if(I.breakouttime) //when equipping a ball mittens
				ADD_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
				stop_pulling()
				update_action_buttons_icon() //certain action buttons will no longer be usable.
				return
			update_inv_gloves()

/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(I)
		if(I.breakouttime) //when unequipping a ball mittens
			REMOVE_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
			drop_all_held_items()
			update_action_buttons_icon() //certain action buttons may be usable again.
		I = null
		if(!QDELETED(src))
			update_inv_gloves()

/mob/living/carbon/human/resist_restraints()
	var/obj/item/clothing/gloves/G = usr.get_item_by_slot(ITEM_SLOT_GLOVES)
	if(G != null)
		if(istype(G, /obj/item/clothing/gloves/))
			if(G.breakouttime)
				to_chat(usr, "You try to unequip [G].")
				if(do_after(usr,G.breakouttime, usr))
					REMOVE_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
					usr.put_in_hands(G)
					drop_all_held_items()
					update_inv_gloves()
					to_chat(usr, "You succesefuly unequipped [src].")
				else
					to_chat(usr, "You failed to unequipped [G].")
					return
	..()
////////////////////////////////////////////////////////////////////////////////////////
///////i needed this code for ballgag, because it doesn't muzzle, it kinda voxbox///////
//wearer for moaning. So i really need it, don't touch or whole ballgag will be broken//
/////////////////////////for ballgag mute audible emotes////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

//adding is_ballgagged() proc here. Hope won't break anything important.
//This is kinda shitcode, but they said don't touch main code or they will break my knees.
//i love my knees, please merge.

//more shitcode can be found in code/datums/emotes.dm
//in /datum/emote/proc/select_message_type(mob/user, intentional) proc. Sorry for that, i had no other choise.

//false for default
/mob/proc/is_ballgagged()
	return FALSE

/mob/living/carbon/is_ballgagged()
	return(istype(src.wear_mask, /obj/item/clothing/mask/ballgag) || istype(src.wear_mask, /obj/item/clothing/mask/ballgag_phallic))

//////////////////////////////////////////////////////////////////////////////////
/////////this shouldn't be put anywhere, get your dirty hands off!////////////////
/////////////////////////////for dancing pole/////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/atom
	var/pseudo_z_axis

/atom/proc/get_fake_z()
	return pseudo_z_axis

/obj/structure/table
	pseudo_z_axis = 8

/turf/open/get_fake_z()
	var/objschecked
	for(var/obj/structure/structurestocheck in contents)
		objschecked++
		if(structurestocheck.pseudo_z_axis)
			return structurestocheck.pseudo_z_axis
		if(objschecked >= 25)
			break
	return pseudo_z_axis

/mob/living/Move(atom/newloc, direct)
	. = ..()
	if(.)
		pseudo_z_axis = newloc.get_fake_z()
		pixel_z = pseudo_z_axis

//////////////////////////////////////////////////////////////////////////////////
//this code needed to determine if human/m is naked in that part of body or not///
//////////////You can you for your own stuff if you want, haha.///////////////////
//////////////////////////////////////////////////////////////////////////////////


/mob/living/proc/is_topless()
    if(istype(src, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = src
        if((H.wear_suit?.body_parts_covered & CHEST)||(H.w_uniform?.body_parts_covered & CHEST))
            return FALSE
    return TRUE

/mob/living/proc/is_bottomless()
    if(istype(src, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = src
        if((H.wear_suit?.body_parts_covered & GROIN)||(H.w_uniform?.body_parts_covered & GROIN))
            return FALSE
    return TRUE

/mob/living/proc/is_feets_uncovered()
    if(istype(src, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = src
        if(H.shoes?.body_parts_covered & FEET)
            return FALSE
    return TRUE

/mob/living/proc/is_hands_uncovered()
    if(istype(src, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = src
        if(H.gloves?.body_parts_covered & ARMS)
            return FALSE
    return TRUE

/mob/living/proc/is_head_uncovered()
    if(istype(src, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = src
        if(H.head?.body_parts_covered & HEAD)
            return FALSE
    return TRUE

/mob/living/proc/has_feet(var/nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/feetcount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/l_leg/L in C.bodyparts)
			feetcount++
		for(var/obj/item/bodypart/r_leg/R in C.bodyparts)
			feetcount++
		if(C.get_item_by_slot(ITEM_SLOT_FEET))
			var/obj/item/clothing/shoes/S = C.get_item_by_slot(ITEM_SLOT_FEET)
			covered = S.body_parts_covered
		if(covered & FEET)
			iscovered = TRUE
		switch(nintendo)
			if(REQUIRE_ANY)
				return feetcount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return feetcount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return feetcount
			else
				return feetcount
	return FALSE

/mob/living/proc/has_arms(var/nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/armscount = 0
		var/covered = 0
		var/iscovered = FALSE
		for(var/obj/item/bodypart/l_arm/L in C.bodyparts)
			armscount++
		for(var/obj/item/bodypart/r_arm/R in C.bodyparts)
			armscount++
		if(C.get_item_by_slot(ITEM_SLOT_GLOVES))
			var/obj/item/clothing/gloves/S = C.get_item_by_slot(ITEM_SLOT_GLOVES)
			covered = S.body_parts_covered
		if(covered & ARMS)
			iscovered = TRUE
		switch(nintendo)
			if(REQUIRE_ANY)
				return armscount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return armscount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return armscount
			else
				return armscount
	return FALSE

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////This code needed for neckleash//////////////////////////
//////////////////////////////////////////////////////////////////////////////////

/datum/component/redirect
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/list/signals
	var/datum/callback/turfchangeCB

/datum/component/redirect/Initialize(list/_signals, flags=NONE)
	//It's not our job to verify the right signals are registered here, just do it.
	if(!LAZYLEN(_signals))
		return COMPONENT_INCOMPATIBLE
	if(flags & REDIRECT_TRANSFER_WITH_TURF && isturf(parent))
		// If they also want to listen to the turf change then we need to set it up so both callbacks run
		if(_signals[COMSIG_TURF_CHANGE])
			turfchangeCB = _signals[COMSIG_TURF_CHANGE]
			if(!istype(turfchangeCB))
				. = COMPONENT_INCOMPATIBLE
				CRASH("Redirect components must be given instanced callbacks, not proc paths.")
		_signals[COMSIG_TURF_CHANGE] = CALLBACK(src, .proc/turf_change)

	signals = _signals

/datum/component/redirect/RegisterWithParent()
	for(var/signal in signals)
		RegisterSignal(parent, signal, signals[signal])

/datum/component/redirect/UnregisterFromParent()
	UnregisterSignal(parent, signals)

/datum/component/redirect/proc/turf_change(datum/source, path, new_baseturfs, flags, list/transfers)
	transfers += src
	return turfchangeCB?.InvokeAsync(arglist(args))

///////////////////////////////////////////////////////////////
///This code needed for changing character's gender by chems///
///////////////////////////////////////////////////////////////

/mob/living/proc/set_gender(ngender = NEUTER, silent = FALSE, update_icon = TRUE, forced = FALSE)
	if(forced || (!ckey || client?.prefs.skyrat_toggles & (ngender == FEMALE ? FORCED_FEM : FORCED_MALE)))
		gender = ngender
		return TRUE
	return FALSE

/mob/living/carbon/set_gender(ngender = NEUTER, silent = FALSE, update_icon = TRUE, forced = FALSE)
	var/bender = !(gender == ngender)
	. = ..()
	if(!.)
		return
	if(dna && bender)
		if(ngender == MALE || ngender == FEMALE)
			dna.features["body_model"] = ngender
			if(!silent)
				var/adj = ngender == MALE ? "masculine" : "feminine"
				visible_message("<span class='boldnotice'>[src] suddenly looks more [adj]!</span>", "<span class='boldwarning'>You suddenly feel more [adj]!</span>")
		else if(ngender == NEUTER)
			dna.features["body_model"] = MALE
	if(update_icon)
		update_body()

/////////////////////////////
///Breasts enlarging chems///
/////////////////////////////

/mob/living/carbon/human
	var/breast_enlarger_amount = 0

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// INVENTORY SYSTEM EXTENTION //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////
// ERP INVENTORY ITEM SLOTS //
//////////////////////////////

/// Vagina slot
#define ITEM_SLOT_VAGINA (1<<21)
/// Anus slot
#define ITEM_SLOT_ANUS (1<<22)
/// Nipples slot
#define ITEM_SLOT_NIPPLES (1<<23)
/// Penis slot
#define ITEM_SLOT_PENIS (1<<20)

//SLOT GROUP HELPERS
#define ITEM_SLOT_ERP_INSERTABLE (ITEM_SLOT_VAGINA|ITEM_SLOT_ANUS)
#define ITEM_SLOT_ERP_ATTACHABLE (ITEM_SLOT_NIPPLES|ITEM_SLOT_PENIS)

////////////////////////////////////////////
// Define some GLOBAL_LISTS for ERP stuff //
////////////////////////////////////////////

// Allowed items for vagina slot
GLOBAL_LIST_INIT(vagina_items_allowed, typecacheof(list(
	/obj/item/eggvib,
	/obj/item/vibrator
	)))

// Allowed items for anus slot
GLOBAL_LIST_INIT(anus_items_allowed, typecacheof(list(
	/obj/item/eggvib,
	/obj/item/vibrator,
	/obj/item/buttplug
	)))

// Allowed items for nipples slot
GLOBAL_LIST_INIT(nipples_items_allowed, typecacheof(list(
	// /obj/item/eggvib,
	/obj/item/vibrator
	)))

// Allowed items for peins slot
GLOBAL_LIST_INIT(peins_items_allowed, typecacheof(list(
	// /obj/item/eggvib,
	/obj/item/vibrator
	)))

// From type2type.dm
/slot2body_zone(slot)
	switch(slot)
		if(ITEM_SLOT_PENIS, ITEM_SLOT_VAGINA, ITEM_SLOT_ANUS)
			return BODY_ZONE_PRECISE_GROIN

		if(ITEM_SLOT_NIPPLES)
			return BODY_ZONE_CHEST
	..()

// Defines of UI offsets
#define ui_vagina "WEST+1:8,SOUTH+4:14"
#define ui_vagina_down "WEST+1:8,SOUTH+1:8"
#define ui_anus "WEST+2:10,SOUTH+4:14"
#define ui_anus_down "WEST+2:10,SOUTH+1:8"
#define ui_nipples "WEST:6,SOUTH+5:17"
#define ui_nipples_down "WEST:6,SOUTH+2:11"
#define ui_penis "WEST+1:8,SOUTH+5:17"
#define ui_penis_down "WEST+1:8,SOUTH+2:11"
#define ui_erp_inventory "WEST:6,SOUTH+1:8"
#define ui_erp_inventory_up "WEST:6,SOUTH+4:14"


////////////////////////////////////
// OUTFIT SYSTEM ERP SLOT SUPPORT //
////////////////////////////////////

// Variables for ERP slots
/datum/outfit
	/// Type path of item for vagina slot
	var/vagina = null
	/// Type path of item for anus slot
	var/anus = null
	/// Type path of item for nipples slot
	var/nipples = null
	/// Type path of item for penis slot
	var/penis = null

// Complementing the equipment procedure
/datum/outfit/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(.)
		pre_equip(H, visualsOnly)
		if(vagina)
			H.equip_to_slot_or_del(new vagina(H),ITEM_SLOT_VAGINA, TRUE)
		if(anus)
			H.equip_to_slot_or_del(new anus(H),ITEM_SLOT_ANUS, TRUE)
		if(nipples)
			H.equip_to_slot_or_del(new nipples(H),ITEM_SLOT_NIPPLES, TRUE)
		if(penis)
			H.equip_to_slot_or_del(new penis(H),ITEM_SLOT_PENIS, TRUE)
		post_equip(H, visualsOnly)
		H.update_body()
	return TRUE


// Support fingerprints when working with ERP slots
/datum/outfit/apply_fingerprints(mob/living/carbon/human/H)
	. = ..()
	if(.)
		if(!istype(H))
			return
		if(H.vagina)
			H.vagina.add_fingerprint(H,1)
		if(H.anus)
			H.anus.add_fingerprint(H,1)
		if(H.nipples)
			H.nipples.add_fingerprint(H,1)
		if(H.penis)
			H.penis.add_fingerprint(H,1)
	return 1

// Supplementing the data structure whith ERP slot data
/datum/outfit/get_json_data()
	var/list/L = ..()

	L["vagina"] = vagina
	L["anus"] = anus
	L["nipples"] = nipples
	L["penis"] = penis

// Supplementing the data structure whith ERP slot data
/datum/outfit/load_from(list/outfit_data)
	vagina = text2path(outfit_data["vagina"])
	anus = text2path(outfit_data["anus"])
	nipples = text2path(outfit_data["nipples"])
	penis = text2path(outfit_data["penis"])
	..()

// Just by analogy with the TG code. No ideas for what this is.
/mob/proc/update_inv_vagina()
	return
/mob/proc/update_inv_anus()
	return
/mob/proc/update_inv_nipples()
	return
/mob/proc/update_inv_penis()
	return

// Add variables for slots to the Carbon class
/mob/living/carbon/
	var/obj/item/vagina = null
	var/obj/item/anus = null
	var/obj/item/nipples = null
	var/obj/item/penis = null

// Supplement a procedure for getting an item by ERP slot for carbon class
/mob/living/carbon/get_item_by_slot(slot_id)
	. = ..()
	if(. == null)
		switch(slot_id)
			if(ITEM_SLOT_VAGINA)
				return vagina
			if(ITEM_SLOT_ANUS)
				return anus
			if(ITEM_SLOT_NIPPLES)
				return nipples
			if(ITEM_SLOT_PENIS)
				return penis
	return null

// Supplement a procedure for equipping an ERP item in ERP slot
/mob/living/carbon/equip_to_slot(obj/item/I, slot, initial = FALSE, redraw_mob = FALSE)
	var/not_handled = ..()
	if(not_handled)
		if(!slot)
			return
		if(!istype(I))
			return
		switch(slot)
			if(ITEM_SLOT_VAGINA)
				if(vagina)
					return
				vagina = I
				update_inv_vagina()
			if(ITEM_SLOT_ANUS)
				if(anus)
					return
				anus = I
				update_inv_anus()
			if(ITEM_SLOT_NIPPLES)
				if(nipples)
					return
				nipples = I
				update_inv_nipples()
			if(ITEM_SLOT_PENIS)
				if(penis)
					return
				penis = I
				update_inv_penis()
			else
				not_handled = TRUE
	return not_handled

// Extention can_equip checks for ERP slots
/datum/species/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	. = ..()
	if(!.)
		if(I.slot_flags & slot)
			switch(slot)
				if(ITEM_SLOT_VAGINA)
					for(var/L in GLOB.vagina_items_allowed)
						if(istype(I,L))
							return equip_delay_self_check(I, H, bypass_equip_delay_self)
					return FALSE
				if(ITEM_SLOT_ANUS)
					for(var/L in GLOB.anus_items_allowed)
						if(istype(I,L))
							return equip_delay_self_check(I, H, bypass_equip_delay_self)
					return FALSE
				if(ITEM_SLOT_NIPPLES)
					for(var/L in GLOB.nipples_items_allowed)
						if(istype(I,L))
							return equip_delay_self_check(I, H, bypass_equip_delay_self)
					return FALSE
				if(ITEM_SLOT_PENIS)
					for(var/L in GLOB.peins_items_allowed)
						if(istype(I,L))
							return equip_delay_self_check(I, H, bypass_equip_delay_self)
					return FALSE
				else
					return FALSE
		else
			return FALSE
	return TRUE

// Supplement a procedure for getting an item by ERP slot for human class (may be not needed if carbon class has this code to)
/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_VAGINA)
			return vagina
		if(ITEM_SLOT_ANUS)
			return anus
		if(ITEM_SLOT_NIPPLES)
			return nipples
		if(ITEM_SLOT_PENIS)
			return penis
	..()

// Supplement a procedure for getting a ERP body slots
/mob/living/carbon/human/get_body_slots()
	var/list/L = ..()

	L.Add(vagina)
	L.Add(anus)
	L.Add(nipples)
	L.Add(penis)
	return L

// Extention equipping procedure for ERP slot
/mob/living/carbon/human/equip_to_slot(obj/item/I, slot, initial = FALSE, redraw_mob = FALSE)
	var/not_handled = ..()
	if(!.)
		switch(slot)
			if(ITEM_SLOT_VAGINA)
				if(vagina)
					return
				vagina = I
				update_inv_vagina()
			if(ITEM_SLOT_ANUS)
				if(anus)
					return
				anus = I
				update_inv_anus()
			if(ITEM_SLOT_NIPPLES)
				if(nipples)
					return
				nipples = I
				update_inv_nipples()
			if(ITEM_SLOT_PENIS)
				if(penis)
					return
				penis = I
				update_inv_penis()
	else
		return not_handled

// Extention unequipping procedure for ERP slot
/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	. = ..()
	if(I == vagina)
		vagina = null
		if(!QDELETED(src))
			update_inv_vagina()
	else if(I == anus)
		anus = null
		if(!QDELETED(src))
			update_inv_anus()
	else if(I == nipples)
		nipples = null
		if(!QDELETED(src))
			update_inv_nipples()
	else if(I == penis)
		penis = null
		if(!QDELETED(src))
			update_inv_penis()
	update_equipment_speed_mods()

/////////////////////////////
// ICON UPDATING EXTENTION //
/////////////////////////////

// Regenerate ERP icons to
/mob/living/carbon/human/regenerate_icons()
	.=..()
	update_inv_vagina()
	update_inv_anus()
	update_inv_nipples()
	update_inv_penis()

//
/mob/living/carbon/human/update_inv_vagina()
	var/datum/hud/human/H = src.hud_used
	if(client && H)
		var/atom/movable/screen/inventory/inv = H.inv_slots[TOBITSHIFT(ITEM_SLOT_VAGINA) + 1]
		inv.update_appearance()
		if(vagina)
			if(usr.hud_used.inventory_shown && src.hud_used)
				vagina.screen_loc = ui_vagina
			else
				vagina.screen_loc = ui_vagina_down
			if(H.hud_shown)
				client.screen += vagina
			update_observer_view(vagina)

//
/mob/living/carbon/human/update_inv_anus()
	var/datum/hud/human/H = src.hud_used
	if(client && H)
		var/atom/movable/screen/inventory/inv = H.inv_slots[TOBITSHIFT(ITEM_SLOT_ANUS) + 1]
		inv.update_appearance()
		if(anus)
			if(usr.hud_used.inventory_shown && src.hud_used)
				anus.screen_loc = ui_anus
			else
				anus.screen_loc = ui_anus_down
			if(H.hud_shown)
				client.screen += anus
			update_observer_view(anus)

//
/mob/living/carbon/human/update_inv_nipples()
	var/datum/hud/human/H = src.hud_used
	if(client && H)
		var/atom/movable/screen/inventory/inv = H.inv_slots[TOBITSHIFT(ITEM_SLOT_NIPPLES) + 1]
		inv.update_appearance()
		if(nipples)
			if(usr.hud_used.inventory_shown && src.hud_used)
				nipples.screen_loc = ui_nipples
			else
				nipples.screen_loc = ui_nipples_down
			if(H.hud_shown)
				client.screen += nipples
			update_observer_view(nipples)

//
/mob/living/carbon/human/update_inv_penis()
	var/datum/hud/human/H = src.hud_used
	if(client && H)
		var/atom/movable/screen/inventory/inv = H.inv_slots[TOBITSHIFT(ITEM_SLOT_PENIS) + 1]
		inv.update_appearance()
		if(penis)
			if(usr.hud_used.inventory_shown && src.hud_used)
				penis.screen_loc = ui_penis
			else
				penis.screen_loc = ui_penis_down
			if(src.hud_used.hud_shown)
				client.screen += penis
			update_observer_view(penis)

//
/mob/living/carbon/human/update_hud_vagina(obj/item/I)
	I.screen_loc = ui_vagina
	if(client && src.hud_used?.hud_shown)
		if(src.hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//
/mob/living/carbon/human/update_hud_anus(obj/item/I)
	I.screen_loc = ui_anus
	if(client && src.hud_used?.hud_shown)
		if(src.hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//
/mob/living/carbon/human/update_hud_nipples(obj/item/I)
	I.screen_loc = ui_nipples
	if(client && src.hud_used?.hud_shown)
		if(src.hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//
/mob/living/carbon/human/update_hud_penis(obj/item/I)
	I.screen_loc = ui_penis
	if(client && src.hud_used?.hud_shown)
		if(src.hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

// Update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_vagina(obj/item/I)
	return

// Update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_anus(obj/item/I)
	return

// Update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_nipples(obj/item/I)
	return

// Update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_penis(obj/item/I)
	return

//
/obj/item/update_slot_icon()
	. = ..()

	var/mob/owner = loc
	var/flags = slot_flags

	if(flags & ITEM_SLOT_VAGINA)
		owner.update_inv_vagina()
	if(flags & ITEM_SLOT_ANUS)
		owner.update_inv_anus()
	if(flags & ITEM_SLOT_NIPPLES)
		owner.update_inv_nipples()
	if(flags & ITEM_SLOT_PENIS)
		owner.update_inv_penis()

//////////////////////////////////
// UI CONSTRUCTION AND HANDLING //
//////////////////////////////////

//
/datum/hud
	var/list/ERP_toggleable_inventory = list() //the screen ERP objects which can be hidden
	var/ERP_inventory_shown = FALSE //Equipped item ERP inventory

//
/atom/movable/screen/human/ERP_toggle
	name = "ERP_toggle"
	icon_state = "toggle"

/atom/movable/screen/human/ERP_toggle/Click()

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.ERP_inventory_shown && targetmob.hud_used)
		usr.hud_used.ERP_inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.ERP_toggleable_inventory
	else
		usr.hud_used.ERP_inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.ERP_toggleable_inventory

	targetmob.hud_used.hidden_inventory_update(usr)

//
/atom/movable/screen/human/toggle/Click()
	. = ..()
	var/mob/targetmob = usr

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		for (var/atom/movable/screen/human/using in targetmob.hud_used.static_inventory)
			if(using.screen_loc == ui_erp_inventory)
				using.screen_loc = ui_erp_inventory_up
		for (var/atom/movable/screen/inventory/inv in targetmob.hud_used.ERP_toggleable_inventory)
			if(inv.screen_loc == ui_vagina_down)
				inv.screen_loc = ui_vagina
			if(inv.screen_loc == ui_anus_down)
				inv.screen_loc = ui_anus
			if(inv.screen_loc == ui_nipples_down)
				inv.screen_loc = ui_nipples
			if(inv.screen_loc == ui_penis_down)
				inv.screen_loc = ui_penis
	else
		for (var/atom/movable/screen/human/using in targetmob.hud_used.static_inventory)
			if(using.screen_loc == ui_erp_inventory_up)
				using.screen_loc = ui_erp_inventory
		for (var/atom/movable/screen/inventory/inv in targetmob.hud_used.ERP_toggleable_inventory)
			if(inv.screen_loc == ui_vagina)
				inv.screen_loc = ui_vagina_down
			if(inv.screen_loc == ui_anus)
				inv.screen_loc = ui_anus_down
			if(inv.screen_loc == ui_nipples)
				inv.screen_loc = ui_nipples_down
			if(inv.screen_loc == ui_penis)
				inv.screen_loc = ui_penis_down



//
/datum/hud/human/New(mob/living/carbon/human/owner)
	..()

	var/atom/movable/screen/inventory/inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "vagina"
	inv_box.icon = ui_style
	inv_box.icon_state = "template"
	inv_box.screen_loc = ui_vagina_down
	inv_box.slot_id = ITEM_SLOT_VAGINA
	inv_box.hud = src
	ERP_toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "anus"
	inv_box.icon = ui_style
	inv_box.icon_state = "template"
	inv_box.screen_loc = ui_anus_down
	inv_box.slot_id = ITEM_SLOT_ANUS
	inv_box.hud = src
	ERP_toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "nipples"
	inv_box.icon = ui_style
	inv_box.icon_state = "template"
	inv_box.screen_loc = ui_nipples_down
	inv_box.slot_id = ITEM_SLOT_NIPPLES
	inv_box.hud = src
	ERP_toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "penis"
	inv_box.icon = ui_style
	inv_box.icon_state = "template"
	inv_box.screen_loc = ui_penis_down
	inv_box.slot_id = ITEM_SLOT_PENIS
	inv_box.hud = src
	ERP_toggleable_inventory += inv_box

	var/atom/movable/screen/using
	using = new /atom/movable/screen/human/ERP_toggle()
	using.icon = ui_style
	using.screen_loc = ui_erp_inventory
	using.hud = src
	static_inventory += using

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory + ERP_toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_appearance()

	update_locked_slots()

//
/datum/hud/human/update_locked_slots()
	. = ..()

	var/mob/living/carbon/human/H = mymob
	var/datum/species/S = H.dna.species

	for(var/atom/movable/screen/inventory/inv in ERP_toggleable_inventory)
		if(inv.slot_id)
			if(inv.slot_id in S.no_equip)
				inv.alpha = 128
			else
				inv.alpha = initial(inv.alpha)

//
/datum/hud/human/hidden_inventory_update(mob/viewer)
	.=..()
	// if(!mymob)
	// 	return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.ERP_inventory_shown && screenmob.hud_used.hud_shown)
		if(H.vagina)
			if(screenmob.hud_used.inventory_shown && screenmob.hud_used)
				H.vagina.screen_loc = ui_vagina
			else
				H.vagina.screen_loc = ui_vagina_down
			screenmob.client.screen += H.vagina
		if(H.anus)
			if(screenmob.hud_used.inventory_shown && screenmob.hud_used)
				H.anus.screen_loc = ui_anus
			else
				H.anus.screen_loc = ui_anus_down
			screenmob.client.screen += H.anus
		if(H.nipples)
			if(screenmob.hud_used.inventory_shown && screenmob.hud_used)
				H.nipples.screen_loc = ui_nipples
			else
				H.nipples.screen_loc = ui_nipples_down
			screenmob.client.screen += H.nipples
		if(H.penis)
			if(screenmob.hud_used.inventory_shown && screenmob.hud_used)
				H.penis.screen_loc = ui_penis
			else
				H.penis.screen_loc = ui_penis_down
			screenmob.client.screen += H.penis
	else
		if(H.vagina) screenmob.client.screen -= H.vagina
		if(H.anus) screenmob.client.screen -= H.anus
		if(H.nipples) screenmob.client.screen -= H.nipples
		if(H.penis) screenmob.client.screen -= H.penis

//
/datum/hud/human/persistent_inventory_update(mob/viewer)
	.=..()
	// if(!mymob)
	// 	return
	// ..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.vagina)
				H.vagina.screen_loc = ui_vagina
				screenmob.client.screen += H.vagina
			if(H.anus)
				H.anus.screen_loc = ui_anus
				screenmob.client.screen += H.anus
			if(H.nipples)
				H.nipples.screen_loc = ui_nipples
				screenmob.client.screen += H.nipples
			if(H.penis)
				H.penis.screen_loc = ui_penis
				screenmob.client.screen += H.penis
		else
			if(H.vagina)
				screenmob.client.screen -= H.vagina
			if(H.anus)
				screenmob.client.screen -= H.anus
			if(H.nipples)
				screenmob.client.screen -= H.nipples
			if(H.penis)
				screenmob.client.screen -= H.penis

//
/datum/hud/show_hud(version = 0, mob/viewmob)
	. = ..()
	var/display_hud_version = version
	if(!display_hud_version) //If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS) //If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1
	var/mob/screenmob = viewmob || mymob
	switch(display_hud_version)
		if(HUD_STYLE_STANDARD) //Default HUD
			hud_shown = TRUE //Governs behavior of other procs
			if(ERP_toggleable_inventory.len && screenmob.hud_used && screenmob.hud_used.ERP_inventory_shown)
				screenmob.client.screen += ERP_toggleable_inventory

		if(HUD_STYLE_REDUCED) //Reduced HUD
			hud_shown = FALSE //Governs behavior of other procs
			if(ERP_toggleable_inventory.len)
				screenmob.client.screen -= ERP_toggleable_inventory

		if(HUD_STYLE_NOHUD) //No HUD
			hud_shown = FALSE //Governs behavior of other procs
			if(toggleable_inventory.len)
				screenmob.client.screen -= ERP_toggleable_inventory

	hud_version = display_hud_version
	persistent_inventory_update(screenmob)
	screenmob.update_action_buttons(1)
	reorganize_alerts(screenmob)
	screenmob.reload_fullscreen()
	update_parallax_pref(screenmob)

	// ensure observers get an accurate and up-to-date view
	if (!viewmob)
		plane_masters_update()
		for(var/M in mymob.observers)
			show_hud(hud_version, M)
	else if (viewmob.hud_used)
		viewmob.hud_used.plane_masters_update()

	return TRUE

//
/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null

	QDEL_NULL(hide_actions_toggle)
	QDEL_NULL(module_store_icon)
	QDEL_LIST(static_inventory)

	inv_slots.Cut()
	action_intent = null
	zone_select = null
	pull_icon = null

	QDEL_LIST(toggleable_inventory)
	QDEL_LIST(ERP_toggleable_inventory)
	QDEL_LIST(hotkeybuttons)
	throw_icon = null
	QDEL_LIST(infodisplay)

	healths = null
	healthdoll = null
	wanted_lvl = null
	internals = null
	spacesuit = null
	lingchemdisplay = null
	lingstingdisplay = null
	blobpwrdisplay = null
	alien_plasma_display = null
	alien_queen_finder = null
	combo_display = null

	QDEL_LIST_ASSOC_VAL(plane_masters)
	QDEL_LIST_ASSOC_VAL(plane_master_controllers)
	QDEL_LIST(screenoverlays)
	mymob = null

	QDEL_NULL(screentip_text)

	return ..()

//
/datum/hud/update_ui_style(new_ui_style)
	if (initial(ui_style) || ui_style == new_ui_style)
		return

	for(var/atom/item in  ERP_toggleable_inventory)
		if (item.icon == ui_style)
			item.icon = new_ui_style

	..()

//
