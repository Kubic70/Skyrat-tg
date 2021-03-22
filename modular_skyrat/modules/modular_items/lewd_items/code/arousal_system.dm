#define AROUS_SYS_LITTLE 30
#define AROUS_SYS_STRONG 70
#define AROUS_SYS_READYTOCUM 90
#define PAIN_SYS_LIMIT 50
#define PLEAS_SYS_EDGE 85

///////////////////Reagents////////////////////

/datum/reagent/consumable/girlcum
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

/datum/reagent/consumable/breast_milk
	name = "breast milk"
	description = "This looks familiar... Wait, it's a milk!"
	taste_description = "warm and creamy"
	color = "#ffffffff"
	glass_name = "glass of Breast milk"
	glass_desc = "Almost like a normal milk."
	reagent_state = LIQUID

///datum/reagent/consumable/milk

/datum/reagent/drug/dopamine
	name = "dopamine"
	description = "Pure happines"
	taste_description = "passion fruit, banana and hint of apple"
	color = "#97ffee"
	glass_name = "dopamine"
	glass_desc = "Delicious flavored reagent. You feel happy even looking at it."
	reagent_state = LIQUID
	overdosed = TRUE
	trippy = TRUE

/*/datum/reagent/drug/dopamine/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)
	..()

/datum/reagent/drug/dopamine/overdose_process(mob/living/M)*/

///////////////////Reagent Containers////////////////////

/obj/item/organ/genital
	var/datum/reagents/internal_fluids

/obj/item/organ/genital/breasts/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/breasts_count = 0
	switch(genital_type)
		if("pair")
			breasts_count = 2
		if("quad")
			breasts_count = 4
		if("sextuple")
			breasts_count = 6
	internal_fluids = new /datum/reagents(DNA.features["breasts_size"] * breasts_count * 10)

/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	internal_fluids = new /datum/reagents(DNA.features["balls_size"] * 10)

/obj/item/organ/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	internal_fluids = new /datum/reagents(5)


///////////////////Stats////////////////////

/mob/living
	var/arousal = 0
	var/pleasure = 0
	var/pain = 0

	var/masohism = FALSE
	var/nymphomania = FALSE

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

/mob/living/carbon/human/Initialize()
	. = ..()
	if(!istype(src,/mob/living/carbon/human/species/monkey))
		set_masohism(FALSE)
		apply_status_effect(/datum/status_effect/aroused)
		//to_chat(world, "name = [src.name]")

/mob/living/carbon/human/verb/arousal_panel()
	set name = "Arousal panel"
	set category = "IC"
	show_arousal_panel()

/mob/living/carbon/human/proc/show_arousal_panel()
	var/obj/item/organ/genital/testicles/balls = getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/genital/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)

	var/list/dat = list()

	dat += "<div>"
	dat += {"<table style="float: left">"}
	dat += "<tr><td><label>Arousal:</lable></td><td><lable>[arousal]%</label></td></tr>"
	dat += "<tr><td><label>Pleasure:</lable></td><td><lable>[pleasure]%</label></td></tr>"
	dat += "<tr><td><label>Pain:</lable></td><td><lable>[pain]%</label></td></tr>"
	dat += "</table>"

	dat += {"<table style="float: left"; margin-left: 50px;>"}
	if(balls)
		dat += "<tr><td><label>Semen:</lable></td><td><lable>[balls.internal_fluids.total_volume]/[balls.internal_fluids.maximum_volume]</label></td></tr>"
	if(breasts)
		dat += "<tr><td><label>Milk:</lable></td><td><lable>[breasts.internal_fluids.total_volume]/[breasts.internal_fluids.maximum_volume]</label></td></tr>"
	if(vagina)
		dat += "<tr><td><label>GirlCum:</lable></td><td><lable>[vagina.internal_fluids.total_volume]/[vagina.internal_fluids.maximum_volume]</label></td></tr>"
	dat += "</table>"
	dat += "</div>"

	dat += "<A href='?src=[REF(usr)];mach_close=mob[REF(src)]'>Close</A>"
	dat += "<A href='?src=[REF(src)];refresh=1'>Refresh</A>"

	var/datum/browser/popup = new(usr, "mob[REF(src)]", "[src]", 440, 510)
	popup.title = "Arousal panel"
	popup.set_content(dat.Join())
	popup.open()

/mob/living/carbon/human/Topic(href, href_list)
	.=..()
	if(href_list["refresh"])
		var/mob/living/carbon/human/user = src
		user.show_arousal_panel()

/mob/living/carbon/human/proc/set_masohism(status) //TRUE or FALSE
	if(status == TRUE)
		masohism = status
		pain_limit = 80
	if(status == FALSE)
		masohism = status
		pain_limit = 50

/mob/living/carbon/human/proc/set_nymphomania(status) //TRUE or FALSE
	if(status == TRUE)
		nymphomania = TRUE
	if(status == FALSE)
		nymphomania = FALSE

/mob/living/proc/adjustArous(arous = 0, pleas = 0, pn = 0)
	arousal += arous
	pleasure += pleas
	pain += pn

	if(nymphomania == TRUE)
		arousal = min(max(arousal,0),100)
	else
		arousal = min(max(arousal,20),100)
	pleasure = min(max(pleasure,0),100)
	pain = min(max(pain,0),100)

	var/arousal_flag = AROUSAL_NONE
	if(arousal >= AROUS_SYS_LITTLE)
		arousal_flag = AROUSAL_PARTIAL
	else if(arousal >= AROUS_SYS_STRONG)
		arousal_flag = AROUSAL_FULL

	if(arousal_status != arousal_flag)
		arousal_status = arousal_flag
		if(istype(src,/mob/living/carbon/human))
			var/mob/living/carbon/human/M = src
			for(var/i=1,i<=M.internal_organs.len,i++)
				//to_chat(src, "<span class='warning'>[M.internal_organs[i]]</span>")
				if(istype(M.internal_organs[i],/obj/item/organ/genital))
					if(!M.internal_organs[i].aroused == AROUSAL_CANT)
						M.internal_organs[i].aroused = arousal_status
						M.internal_organs[i].update_sprite_suffix()
			M.update_body()

/datum/status_effect/aroused
	id = "aroused"
	duration = -1
	alert_type = null

/datum/status_effect/aroused/tick()
	var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)

	var/temp_arousal = -0.1
	var/temp_pleasure = -0.5
	var/temp_pain = -0.5

	if(owner.masohism)
		temp_pain -= 0.5
	if(owner.nymphomania)
		temp_pleasure += 0.25
		temp_arousal += 0.05

//////////REGENERATE Fluids//////////////////
	if(balls)
		if(balls.internal_fluids.total_volume >= balls.internal_fluids.maximum_volume)
			temp_arousal += 0.1
		if(owner.arousal >= AROUS_SYS_LITTLE)
			balls.internal_fluids.add_reagent(/datum/reagent/consumable/cum, 0.1)

	if(breasts)
		if(breasts.lactates == TRUE)
			var/regen = ((owner.nutrition / (NUTRITION_LEVEL_WELL_FED/100))/100) * (breasts.internal_fluids.maximum_volume/2000)
			breasts.internal_fluids.add_reagent(/datum/reagent/consumable/breast_milk, regen)

	if(vagina)
		if(owner.arousal >= AROUS_SYS_LITTLE)
			vagina.internal_fluids.add_reagent(/datum/reagent/consumable/girlcum, 0.1)

//////////REGENERATE Fluids//////////////////

	if(owner.pain > owner.pain_limit)
		temp_arousal -= 0.1
		if(prob(10))
			owner.emote("scream")
		//SCREAM!!!
	if(owner.arousal >= AROUS_SYS_STRONG)
		if(prob(10))
			owner.emote("moan")
		temp_pleasure += 0.1
		//moan
	if(owner.pleasure > 50)
		if(prob(10))
			owner.emote("moan")
		//moan x2


	owner.adjustArous(temp_arousal, temp_pleasure, temp_pain)

/*/atom/movable/screen/alert/status_effect/aroused
	name = "Aroused"
	//desc = "Our wounds are rapidly healing. <i>This effect is prevented if we are on fire.</i>"
	//icon_state = "fleshmend"
	*/
/*
///////////////////some foundamental stuff////////////////////

#define REQUIRE_NONE 0
#define REQUIRE_EXPOSED 1
#define REQUIRE_UNEXPOSED 2
#define REQUIRE_ANY 3

/mob/living
	var/has_penis = FALSE
	var/has_vagina = FALSE
	var/has_breasts = FALSE
	var/has_testicles = FALSE

////////////////some foundamental stuff ended/////////////////


///////////////////Determining what kind of organ character have////////////////////

/mob/living/proc/has_penis(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(issilicon(src) && C.has_penis)
		return TRUE
	if(istype(C))
		var/obj/item/organ/genital/penis = C.getorganslot(ORGAN_SLOT_PENIS)
		if(penis)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(penis.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!penis.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_balls(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(issilicon(src) && C.has_testicles)
		return TRUE
	if(istype(C))
		var/obj/item/organ/genital/testicles = C.getorganslot(ORGAN_SLOT_TESTICLES)
		if(testicles)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(testicles.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!testicles.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_vagina(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(issilicon(src) && C.has_vagina)
		return TRUE
	if(istype(C))
		var/obj/item/organ/genital/vagina = C.getorganslot(ORGAN_SLOT_VAGINA)
		if(vagina)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(vagina.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!vagina.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_breasts(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(issilicon(src) && C.has_breasts)
		return TRUE
	if(istype(C))
		var/obj/item/organ/genital/breasts = C.getorganslot(ORGAN_SLOT_BREASTS)
		if(breasts)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(breasts.is_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!breasts.is_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_anus(var/nintendo = REQUIRE_ANY)
	if(issilicon(src))
		return TRUE
	switch(nintendo)
		if(REQUIRE_EXPOSED)
			if(is_bottomless())
				return TRUE
			else
				return FALSE
		if(REQUIRE_ANY)
			return TRUE
		if(REQUIRE_UNEXPOSED)
			if(!is_bottomless())
				return TRUE
			else
				return FALSE
		else
			return TRUE



///////////////////To make is_exposed proc work////////////////////


//Кубик, эта штука должна определять открыта ли конкретная гениталия в меню expose/hide genitals. Она работает некорректно и всегда выдает FALSE. После моих исправлений она не работает совсем. Почини пожалуйста.
/obj/item/organ/genital/proc/is_exposed()
//	if(genital_list & (GENITAL_HIDDEN_BY_CLOTHES|GENITAL_NEVER_SHOW))
		return FALSE
	else
		return TRUE
*/
