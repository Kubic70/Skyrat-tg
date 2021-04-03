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
		if(gloves?.breakouttime) //when equipping a ball mittens
			ADD_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
			stop_pulling()
			update_action_buttons_icon() //certain action buttons will no longer be usable.
		update_inv_gloves()

/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	. = ..() //See mob.dm for an explanation on this and some rage about people copypasting instead of calling ..() like they should.
	if(I == gloves)
		if(gloves?.breakouttime) //when unequipping a ball mittens
			REMOVE_TRAIT(src, TRAIT_RESTRAINED, SUIT_TRAIT)
			drop_all_held_items()
			update_action_buttons_icon() //certain action buttons may be usable again.
		gloves = null
		if(!QDELETED(src))
			update_inv_gloves()

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
	return(istype(src.wear_mask, /obj/item/clothing/mask/ballgag))

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

///////////////////
///Lewd slurring///
///////////////////

/*
/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/static/regex/lizard_kss = new(@"(\w)x", "g")
	/* // SKYRAT EDIT: REMOVAL
	var/static/regex/lizard_kSS = new(@"(\w)X", "g")
	*/
	var/static/regex/lizard_ecks = new(@"\bx([\-|r|R]|\b)", "g")
	var/static/regex/lizard_eckS = new(@"\bX([\-|r|R]|\b)", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
		message = lizard_kss.Replace(message, "$1kss")
		/* // SKYRAT EDIT: REMOVAL
		message = lizard_kSS.Replace(message, "$1KSS")
		*/
		message = lizard_ecks.Replace(message, "ecks$1")
		message = lizard_eckS.Replace(message, "ECKS$1")
	speech_args[SPEECH_MESSAGE] = message
*/

