#define AROUS_SYS_LITTLE 30
#define AROUS_SYS_STRONG 70
#define AROUS_SYS_READYTOCUM 90
#define PAIN_SYS_LIMIT 50
#define PLEAS_SYS_EDGE 85


///////////-----Reagents------///////////
/datum/reagent/consumable/girlcum
	name = "Girlcum"
	description = "NEED DESCRIPTION!!!"
	taste_description = "NEED TASTE DESCRIPTION!!!"
	color = "#ffffffb0"
	glass_name = "NEED GLASS NAME"
	glass_desc = "NEED DESCRIPTION IN GLASS"
	reagent_state = LIQUID

/datum/reagent/consumable/cum
	name = "Cum"
	description = "NEED DESCRIPTION!!!"
	taste_description = "NEED TASTE DESCRIPTION!!!"
	color = "#ffffffff"
	glass_name = "NEED GLASS NAME"
	glass_desc = "NEED DESCRIPTION IN GLASS"
	reagent_state = LIQUID

/datum/reagent/consumable/breast_milk
	name = "Breasts milk"
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

///////////-----Reagent holders------///////////
/obj/item/organ/genital
	var/datum/reagents/internal_fluids

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


///////////-----Initilaze------///////////
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
		set_nymphomania(FALSE)
		apply_status_effect(/datum/status_effect/aroused)
		apply_status_effect(/datum/status_effect/body_fluid_regen)
		//to_chat(world, "name = [src.name]")


///////////-----Verbs------///////////
/mob/living/carbon/human/verb/arousal_panel()
	set name = "Arousal panel"
	set category = "IC"
	show_arousal_panel()

/mob/living/carbon/human/verb/climax_panel()
	set name = "Climax"
	set category = "IC"
	to_chat(world,"climax under cunstruct")

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

	dat += "<div>"
	dat += "<A href='?src=[REF(usr)];mach_close=mob[REF(src)]'>Close</A>"
	dat += "<A href='?src=[REF(src)];refresh=1'>Refresh</A>"
	dat += "</div>"

	var/datum/browser/popup = new(usr, "mob[REF(src)]", "[src]", 440, 510)
	popup.title = "Arousal panel"
	popup.set_content(dat.Join())
	popup.open()

/mob/living/carbon/human/Topic(href, href_list)
	.=..()
	if(href_list["refresh"])
		var/mob/living/carbon/human/user = src
		user.show_arousal_panel()


///////////-----Procs------///////////
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
		arousal = min(max(arousal,20),100)
	else
		arousal = min(max(arousal,0),100)
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
				if(istype(M.internal_organs[i],/obj/item/organ/genital))
					if(!M.internal_organs[i].aroused == AROUSAL_CANT)
						M.internal_organs[i].aroused = arousal_status
						M.internal_organs[i].update_sprite_suffix()
			M.update_body()


///////////-----Status effects------///////////
/datum/status_effect/aroused
	id = "aroused"
	tick_interval = 10
	duration = -1
	alert_type = null

/datum/status_effect/body_fluid_regen
	id = "body fluid regen"
	tick_interval = 50
	duration = -1
	alert_type = null


///////////-----Status effects tiks------///////////
/datum/status_effect/body_fluid_regen/tick()
	if(owner.stat != DEAD)
		//to_chat(world,"Name:[owner.name]")
		var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
		var/obj/item/organ/genital/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/obj/item/organ/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)

		var/interval = 5	// = tick_interval / 10
		if(balls)
			if(owner.arousal >= AROUS_SYS_LITTLE)
				var/regen = (owner.arousal/100) * (balls.internal_fluids.maximum_volume/235) * interval
				balls.internal_fluids.add_reagent(/datum/reagent/consumable/cum, regen)
				//to_chat(world,"Cum regen:[regen]")

		if(breasts)
			if(breasts.lactates == TRUE)
				var/regen = ((owner.nutrition / (NUTRITION_LEVEL_WELL_FED/100))/100) * (breasts.internal_fluids.maximum_volume/11000) * interval
				breasts.internal_fluids.add_reagent(/datum/reagent/consumable/breast_milk, regen)
				//to_chat(world,"Milk regen:[regen]")

		if(vagina)
			if(owner.arousal >= AROUS_SYS_LITTLE)
				var/regen = (owner.arousal/100) * (vagina.internal_fluids.maximum_volume/250) * interval
				vagina.internal_fluids.add_reagent(/datum/reagent/consumable/girlcum, regen)
				if(vagina.internal_fluids.holder_full() && regen >= 0.15)
					regen = regen // place for drool
			else
				vagina.internal_fluids.remove_any(0.05)
				owner.adjustArous()


/datum/status_effect/aroused/tick()
	if(owner.stat != DEAD)
		var/temp_arousal = -0.1
		var/temp_pleasure = -0.5
		var/temp_pain = -0.5

		var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
		if(balls)
			if(balls.internal_fluids.holder_full())
				temp_arousal += 0.08

		if(owner.masohism)
			temp_pain -= 0.5
		if(owner.nymphomania)
			temp_pleasure += 0.25
			temp_arousal += 0.05

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
		if(owner.pleasure >= PLEAS_SYS_EDGE)
			if(prob(10))
				owner.emote("moan")
			//moan x2


		owner.adjustArous(temp_arousal, temp_pleasure, temp_pain)
