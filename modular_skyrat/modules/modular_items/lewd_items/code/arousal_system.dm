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

/*/obj/item/organ/genital/breasts/Initialize()
	. = ..()
	var/breasts_count = 0
	switch(genital_type)
		if("pair")
			breasts_count = 2
		if("quad")
			breasts_count = 4
		if("sextuple")
			breasts_count = 6
	to_chat(world,"breast_count:[breasts_count]/Genital_size:[genital_size]/lactates:[lactates]")

	milk_container = new /obj/item/reagent_containers
	milk_container.volume = genital_size * breasts_count * 10
	if(lactates)
		milk_container.list_reagents = list(/datum/reagent/consumable/milk = milk_container.volume/2)
	else
		milk_container.list_reagents = list(/datum/reagent/consumable/milk = 0)*/

/mob/living/carbon/human/Initialize()
	. = ..()
	//var/obj/item/organ/genital/breasts/B
	to_chat(world,"owner = [usr] / organs = [internal_organs.len/internal_organs[0]]")

/obj/item/organ/genital/testicles
	var/obj/item/reagent_containers/semen_container

/obj/item/organ/genital/testicles/Initialize()
	. = ..()
	semen_container = new /obj/item/reagent_containers
	semen_container.volume = genital_size * 20
	semen_container.list_reagents = list(/datum/reagent/consumable/milk = semen_container.volume/2)

///////////////////Stats////////////////////

/mob/living/carbon/human
	var/arousal = 0

