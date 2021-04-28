#define AROUS_SYS_LITTLE 30
#define AROUS_SYS_STRONG 70
#define AROUS_SYS_READYTOCUM 90
#define PAIN_SYS_LIMIT 50
#define PLEAS_SYS_EDGE 85

#define CUM_MALE 1
#define CUM_FEMALE 2

///////////-----Decals-----//////////
/obj/effect/decal/cleanable/cum
	name = "cum"
	desc = "Uh... Gross."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
	icon_state = "cum_1"
	random_icon_states = list("cum_1", "cum_2", "cum_3", "cum_4")
	beauty = -50

/obj/effect/decal/cleanable/femcum
	name = "female cum"
	desc = "Uhh... Someone had fun.."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
	icon_state = "femcum_1"
	random_icon_states = list("femcum_1", "femcum_2", "femcum_3", "femcum_4")
	beauty = -50

///////////-----Reagents-----///////////
/datum/reagent/girlcum
	name = "girlcum"
	description = "Uhh... Someone had fun."
	taste_description = "astringent and sweetish"
	color = "#ffffffb0"
	glass_name = "glass of Girlcum"
	glass_desc = "Strange white liquid... Eww!"
	reagent_state = LIQUID

/datum/reagent/consumable/cum
	name = "cum"
	description = "Eww... Well, someone was having a good time."
	taste_description = "astringent and salty"
	color = "#ffffffff"
	glass_name = "glass of Cum"
	glass_desc = "Uhh... Do you really want to consume it?"
	reagent_state = LIQUID

/datum/reagent/consumable/milk/breast_milk
	name = "breast milk"
	description = "This looks familiar... Wait, it's a milk!"
	taste_description = "warm and creamy"
	color = "#ffffffff"
	glass_name = "glass of Breast milk"
	glass_desc = "Almost like a normal milk."
	reagent_state = LIQUID

/datum/reagent/drug/dopamine
	name = "dopamine"
	description = "Pure happines"
	taste_description = "passion fruit, banana and hint of apple"
	color = "#97ffee"
	glass_name = "dopamine"
	glass_desc = "Delicious flavored reagent. You feel happy even looking at it."
	reagent_state = LIQUID
	overdose_threshold = 10

/datum/reagent/drug/dopamine/on_mob_add(mob/living/M)
	//to_chat(world, "dopamine adding")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_start", /datum/mood_event/orgasm, name)
	//to_chat(world, "dopamine added")
	..()

/datum/reagent/drug/dopamine/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(2)
	if(prob(7))
		M.emote(pick("shaking","moan"))
	..()

/datum/reagent/drug/dopamine/overdose_start(mob/living/M)
	//to_chat(world, "overdose start")
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overgasm, name)
	//to_chat(world, "overdose end")
	return

/datum/reagent/drug/dopamine/overdose_process(mob/living/M)
	M.adjustArousal(0.5)
	M.adjustPleasure(0.3)
	M.adjustPain(-0.5)
	if(prob(2))
		M.emote(pick("moan","twitch_s"))
	//to_chat(world, "overdose processing...")
	return
		//say(message)

///////////-----Initilaze------///////////

/obj/item/organ/genital
	var/datum/reagents/internal_fluids
	var/list/contained_item
	var/obj/item/inserted_item //Used for toys

/obj/item/organ/genital/breasts/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/breasts_count = 0
	var/size = 0.5
	if(DNA.features["breasts_size"] > 0)
		size = DNA.features["breasts_size"]

	switch(genital_type)
		if("pair")
			breasts_count = 2
		if("quad")
			breasts_count = 2.5
		if("sextuple")
			breasts_count = 3
	internal_fluids = new /datum/reagents(size * breasts_count * 60)

/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/size = 0.5
	if(DNA.features["balls_size"] > 0)
		size = DNA.features["balls_size"]

	internal_fluids = new /datum/reagents(size * 20)

/obj/item/organ/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	internal_fluids = new /datum/reagents(10)

/obj/item/organ/genital/vagina
	contained_item = list(/obj/item/eggvib)

/obj/item/organ/genital/penis
	contained_item = list(/obj/item/eggvib)

/obj/item/organ/genital/breasts
	contained_item = list(/obj/item/eggvib)

/mob/living
	var/arousal = 0
	var/pleasure = 0
	var/pain = 0

	var/masochism = FALSE
	var/nymphomania = FALSE
	var/neverboner = FALSE

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

	var/list/contained_item = list(/obj/item/eggvib, /obj/item/buttplug)
	var/obj/item/inserted_item //Used for vibrators

/mob/living/carbon/human/Initialize()
	. = ..()
	if(!istype(src,/mob/living/carbon/human/species/monkey))
		set_masochism(FALSE)
		set_neverboner(FALSE)
		set_nymphomania(FALSE)
		apply_status_effect(/datum/status_effect/aroused)
		apply_status_effect(/datum/status_effect/body_fluid_regen)
		//to_chat(world, "name = [src.name]")


///////////-----Verbs------///////////
/mob/living/carbon/human/verb/arousal_panel()
	set name = "Arousal panel"
	set category = "IC"
//	set src in view(1)
	show_arousal_panel()

/mob/living/carbon/human/proc/show_arousal_panel()
	var/obj/item/organ/genital/testicles/balls = getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/genital/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/penis/penis = getorganslot(ORGAN_SLOT_PENIS)

	var/list/dat = list()

	if(usr == src)
		dat += "<div>"
		dat += {"<table style="float: left">"}
		dat += "<tr><td><label>Arousal:</lable></td><td><lable>[round(arousal)]%</label></td></tr>"
		dat += "<tr><td><label>Pleasure:</lable></td><td><lable>[round(pleasure)]%</label></td></tr>"
		dat += "<tr><td><label>Pain:</lable></td><td><lable>[round(pain)]%</label></td></tr>"
		dat += "</table>"

		dat += {"<table style="float: left"; margin-left: 50px;>"}
		if(balls && balls.internal_fluids.holder_full())
			//dat += "<tr><td><label>Semen:</lable></td><td><lable>[balls.internal_fluids.total_volume]/[balls.internal_fluids.maximum_volume]</label></td></tr>"
			dat += "<tr><td><lable>You balls is full!</label></td></tr>"
		if(breasts && (breasts.internal_fluids.total_volume / breasts.internal_fluids.maximum_volume) > 0.9)
			//dat += "<tr><td><label>Milk:</lable></td><td><lable>[breasts.internal_fluids.total_volume]/[breasts.internal_fluids.maximum_volume]</label></td></tr>"
			dat += "<tr><td><lable>You breasts full of milk!</label></td></tr>"
		if(vagina && vagina.internal_fluids.holder_full())
			//dat += "<tr><td><label>GirlCum:</lable></td><td><lable>[vagina.internal_fluids.total_volume]/[vagina.internal_fluids.maximum_volume]</label></td></tr>"
			dat += "<tr><td><lable>You so wet!</label></td></tr>"
		dat += "</table>"
		dat += "</div>"

		dat += "<div>"
		dat += {"<table style="float: left">"}
		dat += "<tr><td><label>Anus:</lable></td><td><A href='?src=[REF(src)];anus=1'>[(inserted_item ? inserted_item.name : "None")]</A></td></tr>"
		if(breasts)
			dat += "<tr><td><label>Nipples:</lable></td><td><A href='?src=[REF(src)];breasts=1'>[(breasts.inserted_item ? breasts.inserted_item.name : "None")]</A></td></tr>"
		if(penis)
			dat += "<tr><td><label>Penis:</lable></td><td><A href='?src=[REF(src)];penis=1'>[(penis.inserted_item ? penis.inserted_item.name : "None")]</A></td></tr>"
		if(vagina)
			dat += "<tr><td><label>Vagina:</lable></td><td><A href='?src=[REF(src)];vagina=1'>[(vagina.inserted_item ? vagina.inserted_item.name : "None")]</A></td></tr>"
		dat += "</table>"
		dat += "</div>"

		dat += "<div>"
		dat += "<A href='?src=[REF(src)];climax=1'>Climax</A>"

	else
		dat += "<div>"
		dat += {"<table style="float: left">"}
		dat += "<tr><td><label>Anus:</lable></td><td><A href='?src=[REF(src)];anus=1'>[(inserted_item ? inserted_item.name : "None")]</A></td></tr>"
		if(breasts)
			dat += "<tr><td><label>Nipples:</lable></td><td><A href='?src=[REF(src)];breasts=1'>[(breasts.inserted_item ? breasts.inserted_item.name : "None")]</A></td></tr>"
		if(penis)
			dat += "<tr><td><label>Penis:</lable></td><td><A href='?src=[REF(src)];penis=1'>[(penis.inserted_item ? penis.inserted_item.name : "None")]</A></td></tr>"
		if(vagina)
			dat += "<tr><td><label>Vagina:</lable></td><td><A href='?src=[REF(src)];vagina=1'>[(vagina.inserted_item ? vagina.inserted_item.name : "None")]</A></td></tr>"
		dat += "</table>"
		dat += "</div>"

		dat += "<div>"

	dat += "<A href='?src=[REF(usr)];mach_close=mob[REF(src)]'>Close</A>"
	dat += "<A href='?src=[REF(src)];refresh=1'>Refresh</A>"
	dat += "</div>"

	var/datum/browser/popup = new(usr, "mob[REF(src)]", "[src]", 440, 510)
	popup.title = "[src] Arousal panel"
	popup.set_content(dat.Join())
	popup.open()

///mob/living/carbon/human/Topic(href, href_list)
//	.=..()
//	var/mob/living/carbon/human/user = src
//
//	if(!(usr in view(1)))
//		to_chat(world, "Not in range")
//		return
//
//	if(href_list["refresh"])
//		to_chat(world, "usr = [usr] / src = [src]")
//		user.show_arousal_panel()
//
//	if(href_list["climax"])
//		climax(TRUE)
//
//	if(href_list["anus"])
//		if(!extract_item(user, "anus"))
//			to_chat(user, "<span class='notice'>You cant put [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] in anus.</span>")
//		user.show_arousal_panel()
//
//	if(href_list["vagina"])
//		if(!extract_item(user, "vagina"))
//			to_chat(user, "<span class='notice'>You cant put [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] in vagina.</span>")
//		user.show_arousal_panel()
//
//	if(href_list["breasts"])
//		if(!extract_item(user, "nipples"))
//			to_chat(user, "<span class='notice'>You cant attach [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] to nipple.</span>")
//		user.show_arousal_panel()
//
//	if(href_list["penis"])
//		if(!extract_item(user, "penis"))
//			to_chat(user, "<span class='notice'>You cant attach [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] to penis.</span>")
//		user.show_arousal_panel()

///////////-----Procs------///////////
/mob/living/proc/extract_item(user, slotName)
	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/O = src
	var/slotText = slotName

	if(slotText == "vagina" || slotText == "nipples" || slotText == "penis")
		var/obj/item/organ/genital/organ = null
		var/list/wList = null
		if(slotText == "vagina")
			organ = O.getorganslot(ORGAN_SLOT_VAGINA)
		else if(slotText == "nipples")
			organ = O.getorganslot(ORGAN_SLOT_BREASTS)
		else if(slotText == "penis")
			organ = O.getorganslot(ORGAN_SLOT_PENIS)
		else
			return FALSE

		wList = organ.contained_item
		if(!isnull(organ.inserted_item))
			U.put_in_hands(organ.inserted_item)
			organ.inserted_item = null
			return TRUE
		else
			var/obj/item/I = U.get_active_held_item()
			if(!I)
				return FALSE
			for(var/T in wList)
				if(istype(I,T))
					//equip_to_slot_if_possible(I, slotText)
					if(!transferItemToLoc(I, organ.inserted_item))
						return FALSE
					organ.inserted_item = I
					return TRUE

	else if(slotText == "anus")
		if(!isnull(O.inserted_item))
			U.put_in_hands(O.inserted_item)
			O.inserted_item = null
			return TRUE
		else
			var/obj/item/I = U.get_active_held_item()
			if(!I)
				return FALSE
			for(var/T in O.contained_item)
				if(istype(I,T))
					if(!transferItemToLoc(I, O.inserted_item))
						return FALSE
					O.inserted_item = I
					return TRUE
	else
		return FALSE


/mob/living/proc/set_masochism(status) //TRUE or FALSE
	if(status == TRUE)
		masochism = status
		pain_limit = 80
	if(status == FALSE)
		masochism = status
		pain_limit = 20

/mob/living/proc/set_nymphomania(status) //TRUE or FALSE
	if(status == TRUE)
		nymphomania = TRUE
	if(status == FALSE)
		nymphomania = FALSE

/mob/living/proc/set_neverboner(status) //TRUE or FALSE
	if(status == TRUE)
		neverboner = TRUE
	if(status == FALSE)
		neverboner = FALSE

////////////
///FLUIDS///
////////////

/datum/status_effect/body_fluid_regen
	id = "body fluid regen"
	tick_interval = 50
	duration = -1
	alert_type = null

/datum/status_effect/body_fluid_regen/tick()
	if(owner.stat != DEAD)
		var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
		var/obj/item/organ/genital/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/obj/item/organ/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)

		var/interval = 5	// = tick_interval / 10
		if(balls)
			if(owner.arousal >= AROUS_SYS_LITTLE)
				var/regen = (owner.arousal/100) * (balls.internal_fluids.maximum_volume/235) * interval
				balls.internal_fluids.add_reagent(/datum/reagent/cum, regen)

		if(breasts)
			if(breasts.lactates == TRUE)
				var/regen = ((owner.nutrition / (NUTRITION_LEVEL_WELL_FED/100))/100) * (breasts.internal_fluids.maximum_volume/11000) * interval
				breasts.internal_fluids.add_reagent(/datum/reagent/consumable/milk, regen)
				if(!breasts.internal_fluids.holder_full())
					owner.adjust_nutrition(regen / 2)
				else
					regen = regen // Need to add eximine text for wet clothing

		if(vagina)
			if(owner.arousal >= AROUS_SYS_LITTLE)
				var/regen = (owner.arousal/100) * (vagina.internal_fluids.maximum_volume/250) * interval
				vagina.internal_fluids.add_reagent(/datum/reagent/girlcum, regen)
				if(vagina.internal_fluids.holder_full() && regen >= 0.15)
					regen = regen // Need to add sprite of girlcum on floor
			else
				vagina.internal_fluids.remove_any(0.05)

/////////////
///AROUSAL///
/////////////
/mob/living/proc/get_arousal()
	return arousal

/mob/living/proc/adjustArousal(arous = 0)
	if(stat != DEAD)
		arousal += arous

		var/arousal_flag = AROUSAL_NONE
		if(arousal >= AROUS_SYS_STRONG)
			arousal_flag = AROUSAL_FULL
		else if(arousal >= AROUS_SYS_LITTLE)
			arousal_flag = AROUSAL_PARTIAL

		if(arousal_status != arousal_flag) // Set organ arousal status
			arousal_status = arousal_flag
			if(istype(src,/mob/living/carbon/human))
				var/mob/living/carbon/human/M = src
				for(var/i=1,i<=M.internal_organs.len,i++)
					if(istype(M.internal_organs[i],/obj/item/organ/genital))
						var/obj/item/organ/genital/G = M.internal_organs[i]
						if(!G.aroused == AROUSAL_CANT)
							G.aroused = arousal_status
							G.update_sprite_suffix()
				M.update_body()
	else
		arousal -= abs(arous)

	if(nymphomania == TRUE)
		arousal = min(max(arousal,20),100)
	else
		arousal = min(max(arousal,0),100)

/datum/status_effect/aroused
	id = "aroused"
	tick_interval = 10
	duration = -1
	alert_type = null

/datum/status_effect/aroused/tick()
	var/temp_arousal = -0.1
	var/temp_pleasure = -0.5
	var/temp_pain = -0.5
	if(owner.stat != DEAD)

		var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
		if(balls)
			if(balls.internal_fluids.holder_full())
				temp_arousal += 0.08

		if(owner.masochism)
			temp_pain -= 0.5
		if(owner.nymphomania)
			temp_pleasure += 0.25
			temp_arousal += 0.05
		if(owner.neverboner)
			temp_pleasure -= 50
			temp_arousal -= 50

		if(owner.pain > owner.pain_limit)
			temp_arousal -= 0.1
		if(owner.arousal >= AROUS_SYS_STRONG)
			if(prob(3))
				owner.emote(pick("moan","blush"))
			temp_pleasure += 0.1
			//moan
		if(owner.pleasure >= PLEAS_SYS_EDGE)
			if(prob(3))
				owner.emote(pick("moan","twitch_s"))
			//moan x2

	owner.adjustArousal(temp_arousal)
	owner.adjustPleasure(temp_pleasure)
	owner.adjustPain(temp_pain)

////Pain////
/mob/living/proc/get_pain()
	return pain

/mob/living/proc/adjustPain(pn = 0)
	if(stat != DEAD)
		if(pain > pain_limit || pn > pain_limit / 10) // pain system
			if(masochism == TRUE)
				var/p = pn - (pain_limit / 10)
				if(p > 0)
					adjustArousal(-p)
			else
				if(pn > 0)
					adjustArousal(-pn)
			if(prob(2) && pain > pain_limit && pn > pain_limit / 10)
				emote(pick("scream","shiver")) //SCREAM!!!
		else
			if(pn > 0)
				adjustArousal(pn)
			if(masochism == TRUE)
				var/p = pn / 2
				adjustPleasure(p)
		pain += pn
	else
		pain -= abs(pn)
	pain = min(max(pain,0),100)

////Pleasure////
/mob/living/proc/get_pleasure()
	return pleasure

/mob/living/proc/adjustPleasure(pleas = 0)
	if(stat != DEAD)
		pleasure += pleas
		if(pleasure >= 100) // lets cum
			climax(FALSE)
	else
		pleasure -= abs(pleas)
	pleasure = min(max(pleasure,0),100)

// get damage for pain system
/datum/species/apply_damage(damage, damagetype, def_zone, blocked, mob/living/carbon/human/H, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness)
	. = ..()
	var/hit_percent = (100-(blocked+armor))/100
	hit_percent = (hit_percent * (100-H.physiology.damage_resistance))/100
	switch(damagetype)
		if(BRUTE)
			var/amount = forced ? damage : damage * hit_percent * brutemod * H.physiology.brute_mod
			H.adjustPain(amount)
		if(BURN)
			var/amount = forced ? damage : damage * hit_percent * burnmod * H.physiology.burn_mod
			H.adjustPain(amount)

////////////
///CLIMAX///
////////////

//This is cool modularised proc that required for determining if character can cum. Yes, it's obvious.
//actually i need it for hexacamphor (permanent anaphrodisiac)
//and for cooldown on climax.
/mob/living/proc/character_can_cum(mob/living/carbon/human/M)
	if(M.neverboner == TRUE)
		return FALSE
	else
		return TRUE

/datum/mood_event/orgasm
	description = "<font color=purple>Woah... This pleasant tiredness... I love it.</font>\n"
	mood_change = 8 //yes, +8. Well fed buff gives same amount. This is Fair (tm).
	timeout = 5 MINUTES

/datum/mood_event/climaxself
	description = "<font color=purple>I just came in my own underwear. Messy.</font>\n"
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/overgasm
	description = "<span class='warning'>Uhh... I don't feel like i want to be horny anymore.</span>\n" //Me too, buddy. Me too.
	mood_change = -6
	timeout = 10 MINUTES

/mob/living/proc/climax(manual = TRUE)
	var/obj/item/organ/genital/penis = getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/genital/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(manual == TRUE && arousal > 90 && !has_status_effect(/datum/status_effect/climax))
		if(character_can_cum())
			switch(gender)
				if(MALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)
				if(FEMALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE)
				else
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)

			if(vagina && penis)
				if(is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
				else
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cums in their underwear!</font>", \
								"<font color=purple>You cum in your underwear! Eww.</font>")
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/climaxself)

			if(vagina)
				if(is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
				else
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cums in their underwear!</font>", \
								"<font color=purple>You cum in your underwear! Eww.</font>")
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/climaxself)

			if(penis)
				if(is_bottomless() || penis.visibility_preference == GENITAL_ALWAYS_SHOW)
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
				else
					apply_status_effect(/datum/status_effect/climax)
					visible_message("<font color=purple>[src] cums in their underwear!</font>", \
								"<font color=purple>You cum in your underwear! Eww.</font>")
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/climaxself)

			else
				apply_status_effect(/datum/status_effect/climax)
				visible_message("<font color=purple>[src] twitches in orgasm!</font>", \
								"<font color=purple>You are cumming! Eww.</font>")

		else
			visible_message("<font color=purple>[src] twitches, trying to cum, but with no result.</font>", \
							"<font color=purple>You can't have an orgasm!</font>")
		return TRUE

	else if(manual == FALSE)
		if(character_can_cum())
			switch(gender)
				if(MALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)
				if(FEMALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE)
				else
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)
			if(is_bottomless())
				apply_status_effect(/datum/status_effect/climax)
				visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
			else
				apply_status_effect(/datum/status_effect/climax)
				visible_message("<font color=purple>[src] cums in their underwear!</font>", \
								"<font color=purple>You cum in your underwear! Eww.</font>")
				SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/climaxself)
		else
			visible_message("<font color=purple>[src] twitches, trying to cum, but with no result.</font>", \
							"<font color=purple>You can't have an orgasm!</font>")
		return TRUE

	else
		return FALSE

/datum/status_effect/climax
	id = "climax"
	tick_interval =  10
	duration = 100
	alert_type = null

/datum/status_effect/climax/tick()
	var/temp_arousal = -12
	var/temp_pleasure = -12
	var/temp_stamina = -12
	var/obj/item/organ/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)

	if(balls)
		balls.reagents.remove_all(balls.reagents.total_volume * 0.6)
		var/obj/effect/decal/cleanable/cum/V = new /obj/effect/decal/cleanable/cum()
		if (QDELETED(V))
			V = locate() in src
		if(!V)
			return

	if(vagina)
		vagina.reagents.remove_all()
		var/obj/effect/decal/cleanable/femcum/V = new /obj/effect/decal/cleanable/femcum()
		if (QDELETED(V))
			V = locate() in src
		if(!V)
			return

	owner.reagents.add_reagent(/datum/reagent/drug/dopamine, 0.5)
	owner.adjustStaminaLoss(temp_stamina)
	owner.adjustArousal(temp_arousal)
	owner.adjustPleasure(temp_pleasure)
	owner.Paralyze(2)
	owner.adjustStaminaLoss(8)

////////////////////////
///SPANKING PROCEDURE///
////////////////////////

//Hips are red after spanking
/datum/status_effect/spanked
	id = "spanked"
	duration = 300 SECONDS
	alert_type = null

/mob/living/carbon/human/examine(mob/user)
	.=..()
	var/t_his = p_their()
	var/mob/living/U = user

	if(stat != DEAD && !HAS_TRAIT(src, TRAIT_FAKEDEATH) && src != U)
		if(src != user)
			if(has_status_effect(/datum/status_effect/spanked) && is_bottomless())
				. += "<font color=purple>[t_his] thighs turned red.</font>\n"

//Mood boost for masochist
/datum/mood_event/perv_spanked
	description = "<font color=purple>Ah, yes! More! Punish me!</font>\n"
	mood_change = 3
	timeout = 5 MINUTES

/*

Вот список того что должно быть при оргазме:
Персонаж делает анимацию дёргания
Получает кучу стаминаурона
На полу появляется спрайт соответствующий вышедшим жидкостям персонажа, если персонаж не "сух"
В чат игрока и в локальный выводится какое-нибудь извращенное сообщение
Значение arousal и pleasure падает до 0.
Добавляется бонус к настроению.
КД на оргазм в 2-3 минуты. Персонажу нужно "Охладиться".
Если персонаж "сух" - не спавнить ничего и вывести другое сообщение для оргазма.

*/

// /mob/living/carbon/human/proc/climax(mob/living/carbon/human/M, distance = 1, cum_type = CUM_MALE)
//	if(character_can_cum())
//		M.adjustStaminaLoss(60) //character should get tired. Potentionally abusable, but i hope cooldown will prevent this. Also ERP abuse is bad.
//		M.Paralyze(40)
//	//Giving correct mood effect here
//		if(!is_bottomless())
//			visible_message("<font color=purple>[src] cums in their underwear!</font>",
//							"<font color=purple>You cum in your underwear! Eww.</font>")
//			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/climaxself)
//		else
//			visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
//			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "orgasm", /datum/mood_event/orgasm)
//
//	//Determining what kind of sound we getting when cumming
//		switch(M.gender)
//			if(MALE)
//				playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)
//			if(FEMALE)
//				playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE)
//			else
//				playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
//											'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE)
//
//We checking if character can cum, or he/she "dry".
/*		var/turf/T = get_turf(src)
		for(var/i=0 to distance)
			if(T)
				if(M.current_semen.reagents.total_volume > 0 && M.current_girlcum.reagents.total_volume > 0) //Whatever-the-fuck-you-are case. No, i didn't sprited special decal for this. Penis and vagina on same spot are you kidding me? Biological abomination.
					if(prob(50))
						cum_type = CUM_MALE
					else
						cum_type = CUM_FEMALE
					T.add_cum_floor(src, cum_type)
					M.current_semen.reagents.total_volume = 0
					M.current_girlcum.reagents.total_volume = 0

				else if(M.current_semen.reagents.total_volume > 0) //Male case
					cum_type = CUM_MALE
					T.add_cum_floor(src, cum_type)
					M.current_semen.reagents.total_volume = 0

				else if(M.current_girlcum.reagents.total_volume > 0) //Female case
					cum_type = CUM_FEMALE
					T.add_cum_floor(src, cum_type)
					M.current_girlcum.reagents.total_volume = 0

				else //Dry case
					return

			T = get_step(T, dir)
			if (T?.is_blocked_turf())
				break
		return TRUE

//
//	else
//		visible_message("<font color=purple>[src] twitches, trying to cum, but with no result.</font>", \
//						"<font color=purple>You can't have an orgasm!</font>")

//adding cum on floor. What am i doing in my life?
/turf/proc/add_cum_floor(mob/living/M, cum_type = NONE)
	if(cum_type == CUM_FEMALE)
		var/obj/effect/decal/cleanable/femcum/V = new /obj/effect/decal/cleanable/femcum()
		if (QDELETED(V))
			V = locate() in src
		if(!V)
			return

	else if (cum_type == CUM_MALE)
		var/obj/effect/decal/cleanable/cum/V = new /obj/effect/decal/cleanable/cum()
		if (QDELETED(V))
			V = locate() in src
		if(!V)
			return
*/
