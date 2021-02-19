///////////////////Reagents////////////////////

/datum/reagent/girlcum
	name = "Girlcum"
	description = "NEED DESCRIPTION!!!"
	taste_description = "NEED TASTE DESCRIPTION!!!"
	color = "#ffffffb0"
	glass_name = "NEED GLASS NAME"
	glass_desc = "NEED DESCRIPTION IN GLASS"
	reagent_state = LIQUID

/datum/reagent/cum
	name = "Cum"
	description = "NEED DESCRIPTION!!!"
	taste_description = "NEED TASTE DESCRIPTION!!!"
	color = "#ffffffff"
	glass_name = "NEED GLASS NAME"
	glass_desc = "NEED DESCRIPTION IN GLASS"
	reagent_state = LIQUID

///datum/reagent/consumable/milk

/datum/reagent/drug/dopamine
	name = "Dopamine"
	description = "NEED DESCRIPTION!!!"
	taste_description = "NEED TASTE DESCRIPTION!!!"
	color = "#97ffee"
	glass_name = "NEED GLASS NAME"
	glass_desc = "NEED DESCRIPTION IN GLASS"
	reagent_state = LIQUID
	overdosed = TRUE
	trippy = TRUE

/*/datum/reagent/drug/dopamine/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)
	..()

/datum/reagent/drug/dopamine/overdose_process(mob/living/M)*/

///////////////////Reagent Containers////////////////////

/obj/item/organ/genital/breasts
	var/obj/item/reagent_containers/milk_container

/obj/item/organ/genital/breasts/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	milk_container = new /obj/item/reagent_containers
	var/breasts_count = 0
	switch(genital_type)
		if("pair")
			breasts_count = 2
		if("quad")
			breasts_count = 4
		if("sextuple")
			breasts_count = 6
	if(DNA.features["breasts_lactation"])
		milk_container.volume = DNA.features["breasts_size"] * breasts_count * 10
		milk_container.list_reagents = list(/datum/reagent/consumable/milk = milk_container.volume / 2)
	else
		milk_container.volume = 0
	//to_chat(world,"Breasts: genital_type = [genital_type] / breasts_count = [breasts_count] / breasts_size = [DNA.features["breasts_size"]] / milk_max_vol = [milk_container.volume]")

/obj/item/organ/genital/testicles
	var/obj/item/reagent_containers/semen_container

/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	semen_container = new /obj/item/reagent_containers
	semen_container.volume = DNA.features["balls_size"] * 10
	semen_container.list_reagents = list(/datum/reagent/cum = semen_container.volume / 2)
	//to_chat(world,"Balls: genital_type = [genital_type] / balls_size = [DNA.features["balls_size"]] / semen_max_vol = [semen_container.volume]")

/obj/item/organ/genital/vagina
	var/obj/item/reagent_containers/girlcum_container

/obj/item/organ/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	girlcum_container = new /obj/item/reagent_containers
	girlcum_container.volume = 5
	girlcum_container.list_reagents = list(/datum/reagent/girlcum = 0)
	//to_chat(world,"Vagina: girlcum_max_vol = [girlcum_container.volume]")


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

/mob/living/carbon/human/proc/set_masohism(status) //TRUE or FALSE
	if(status)
		masohism = status
		pain_limit = 80
	if(!status)
		masohism = status
		pain_limit = 50

/mob/living/carbon/human/proc/set_nymphomania(status) //TRUE or FALSE
	if(status)
		nymphomania = TRUE
	if(!status)
		nymphomania = FALSE

/mob/living/proc/adjustArous(arous = 0, pleas = 0, pn = 0)
	arousal += arous
	pleasure += pleas
	pain += pn

	if(nymphomania)
		arousal = min(max(arousal,0),100)
	else
		arousal = min(max(arousal,20),100)
	pleasure = min(max(pleasure,0),100)
	pain = min(max(pain,0),100)

	var/arousal_flag = AROUSAL_NONE
	if(arousal >= 30)
		arousal_flag = AROUSAL_PARTIAL
	else if(arousal >= 70)
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
	var/temp_arousal = -0.1
	var/temp_pleasure = -0.5
	var/temp_pain = -0.5

	if(owner.masohism)
		temp_pain -= 0.5
	if(owner.nymphomania)
		temp_pleasure += 0.25
		temp_arousal += 0.05

	if(balls.semen_container.volume <= balls.semen_container.reagents.total_volume)
		temp_arousal += 0.1

	if(owner.pain > owner.pain_limit)
		temp_arousal -= 0.1
		if(prob(10))
			owner.emote("scream")
		//SCREAM!!!
	if(owner.arousal >= 70)
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
