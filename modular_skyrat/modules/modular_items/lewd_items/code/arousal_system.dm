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
	beauty = -150

///////////-----Reagents-----///////////
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

	var/masohism = FALSE
	var/nymphomania = FALSE

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

	var/list/contained_item = list(/obj/item/eggvib, /obj/item/buttplug)
	var/obj/item/inserted_item //Used for vibrators

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
	set src in view(1)
	show_arousal_panel(usr)

/mob/living/carbon/human/proc/show_arousal_panel(mob/user)
	var/obj/item/organ/genital/testicles/balls = getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	var/obj/item/organ/genital/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/penis/penis = getorganslot(ORGAN_SLOT_PENIS)

	var/list/dat = list()

	if(user == src)
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
		dat += "<A href='?src=[REF(usr)];mach_close=mob[REF(src)]'>Close</A>"
		dat += "<A href='?src=[REF(src)];refresh=1'>Refresh</A>"
		dat += "</div>"
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
	popup.title = "Arousal panel"
	popup.set_content(dat.Join())
	popup.open()

/mob/living/carbon/human/Topic(href, href_list)
	.=..()
	var/mob/living/carbon/human/user = usr
	if(href_list["refresh"])
		user.show_arousal_panel(src)

	if(href_list["climax"])
		climax(TRUE)

	if(href_list["anus"])
		if(!extract_item(user, "anus"))
			to_chat(user, "<span class='notice'>You cant put [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] in anus.</span>")
		user.show_arousal_panel(src)

	if(href_list["vagina"])
		if(!extract_item(user, "vagina"))
			to_chat(user, "<span class='notice'>You cant put [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] in vagina.</span>")
		user.show_arousal_panel(src)

	if(href_list["breasts"])
		if(!extract_item(user, "breasts"))
			to_chat(user, "<span class='notice'>You cant attach [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] to nipple.</span>")
		user.show_arousal_panel(src)

	if(href_list["penis"])
		if(!extract_item(user, "penis"))
			to_chat(user, "<span class='notice'>You cant attach [user.get_active_held_item() ? user.get_active_held_item() : "nothing"] to penis.</span>")
		user.show_arousal_panel(src)

///////////-----Procs------///////////
/mob/living/proc/extract_item(user, slotName)
	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/O = src
	var/slotText = slotName

	if(slotText == "vagina" || slotText == "breasts" || slotText == "penis")
		var/obj/item/organ/genital/organ = null
		var/list/wList = null
		if(slotText == "vagina")
			organ = O.getorganslot(ORGAN_SLOT_VAGINA)
		else if(slotText == "breasts")
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


/mob/living/proc/set_masohism(status) //TRUE or FALSE
	if(status == TRUE)
		masohism = status
		pain_limit = 80
	if(status == FALSE)
		masohism = status
		pain_limit = 20

/mob/living/proc/set_nymphomania(status) //TRUE or FALSE
	if(status == TRUE)
		nymphomania = TRUE
	if(status == FALSE)
		nymphomania = FALSE


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
				balls.internal_fluids.add_reagent(/datum/reagent/consumable/cum, regen)

		if(breasts)
			if(breasts.lactates == TRUE)
				var/regen = ((owner.nutrition / (NUTRITION_LEVEL_WELL_FED/100))/100) * (breasts.internal_fluids.maximum_volume/11000) * interval
				breasts.internal_fluids.add_reagent(/datum/reagent/consumable/breast_milk, regen)
				if(!breasts.internal_fluids.holder_full)
					owner.adjust_nutrition(regen / 2)
				else
					regen = regen // place for drool

		if(vagina)
			if(owner.arousal >= AROUS_SYS_LITTLE)
				var/regen = (owner.arousal/100) * (vagina.internal_fluids.maximum_volume/250) * interval
				vagina.internal_fluids.add_reagent(/datum/reagent/consumable/girlcum, regen)
				if(vagina.internal_fluids.holder_full() && regen >= 0.15)
					regen = regen // place for drool
			else
				vagina.internal_fluids.remove_any(0.05)
				owner.adjustArous()

/////////////
///AROUSAL///
/////////////
/mob/living/proc/get_arousal()
	return arousal

/mob/living/proc/get_pain()
	return pain

/mob/living/proc/get_pleasure()
	return pleasure

/mob/living/proc/adjustArous(arous = 0, pleas = 0, pn = 0)
	if(stat != DEAD)
		arousal += arous
		pleasure += pleas

		if(pain > pain_limit || pn > pain_limit / 10) // pain system
			arousal -= pn
			if(prob(2) && pain > pain_limit)
				emote(pick("scream","shiver")) //SCREAM!!!
		else
			arousal += pn
			if(masohism == TRUE)
				pleasure += pn / 2
		pain += pn

	else
		arousal -= abs(arous)
		pleasure -= abs(pleas)
		pain -= abs(pn)

	if(nymphomania == TRUE)
		arousal = min(max(arousal,20),100)
	else
		arousal = min(max(arousal,0),100)
	pleasure = min(max(pleasure,0),100)
	pain = min(max(pain,0),100)

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

	if(pleasure >= 100) // lets cum
		climax(FALSE)

// get damage for pain system
/datum/species/apply_damage(damage, damagetype, def_zone, blocked, mob/living/carbon/human/H, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness)
	. = ..()
	var/hit_percent = (100-(blocked+armor))/100
	hit_percent = (hit_percent * (100-H.physiology.damage_resistance))/100
	switch(damagetype)
		if(BRUTE)
			var/amount = forced ? damage : damage * hit_percent * brutemod * H.physiology.brute_mod
			H.adjustArous(pn = amount)
		if(BURN)
			var/amount = forced ? damage : damage * hit_percent * burnmod * H.physiology.burn_mod
			H.adjustArous(pn = amount)


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

		if(owner.masohism)
			temp_pain -= 0.5
		if(owner.nymphomania)
			temp_pleasure += 0.25
			temp_arousal += 0.05

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

	owner.adjustArous(temp_arousal, temp_pleasure, temp_pain)

////////////
///CLIMAX///
////////////

/mob/living/proc/climax(manual = TRUE)
	if(manual == TRUE && arousal > 90 && !has_status_effect(/datum/status_effect/climax))
		apply_status_effect(/datum/status_effect/climax)
		return TRUE
	else if(manual == FALSE)
		apply_status_effect(/datum/status_effect/climax)
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
	var/obj/item/organ/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)

	if(balls)
		balls.reagents.remove_all(balls.reagents.total_volume * 0.6)
		//NEED ADD SPRITE

	if(vagina)
		vagina.reagents.remove_all()
		//NEED ADD SPRITE

	owner.adjustArous(temp_arousal, temp_pleasure, 0)

/*

Вот список того что должно быть при оргазме:
Персонаж делает анимацию дёргтания
Получает кучу стаминаурона
Получает удовольствие как от наркотиков.
Кол-во реагентов в его органах уменьшается до 0 в соответствующих гениталиях
На полу появляется спрайт соответствующий вышедшим жидкостям персонажа, если персонаж не "сух"
В чат игрока и в локальный выводится какое-нибудь извращенное сообщение
Значение arousal и pleasure падает до 0.
Добавляется бонус к настроению.
КД на оргазм в 2-3 минуты. Персонажу нужно "Охладиться".
Если персонаж "сух" - не спавнить ничего и вывести другое сообщение для оргазма.

/mob/living/carbon/human/proc/climax(mob/living/carbon/human/M, distance = 1, cum_type = CUM_MALE)
//effects on character + messages in chat and sound effect.
	if(character_can_cum())
		M.set_drugginess(rand(40, 80))
		M.adjustStaminaLoss(60) //character should get tired. Potentionally abusable, but i hope cooldown will prevent this. Also ERP abuse is bad.
		M.Paralyze(80)
		if(!is_bottomless()) //Giving correct mood effect here
			visible_message("<font color=purple>[src] cums in their underwear!</font>", \
							"<font color=purple>You cum in your underwear! Eww.</font>")
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "climax", /datum/mood_event/climaxself)
			distance = 0
		else
			visible_message("<font color=purple>[src] cumming!</font>", "<font color=purple>You cumming!</font>")
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "climax", /datum/mood_event/climax)
		//Determining what kind of sound we getting when cumming
		switch(M.gender)
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

//We checking if character can cum, or he/she "dry".
		var/turf/T = get_turf(src)
		for(var/i=0 to distance)
			if(T)
				if(current_semen.reagents.total_volume > 0 && current_girlcum.reagents.total_volume > 0) //Whatever-the-fuck-you-are case. No, i didn't sprited special decal for this. Penis and vagina on same spot are you fucking kidding me? Biological abomination.
					T.add_cum_floor(src, cum_type)
					current_semen.reagents.total_volume = 0
					current_girlcum.reagents.total_volume = 0
				else if(current_semen.reagents.total_volume > 0) //Male case
					T.add_cum_floor(src, cum_type)
					current_semen.reagents.total_volume = 0
				else if(current_girlcum.reagents.total_volume > 0) //Female case
					cum_type = CUM_FEMALE
					T.add_cum_floor(src, cum_type)
					current_girlcum.reagents.total_volume = 0
				else //Dry case
					return

			T = get_step(T, dir)
			if (T?.is_blocked_turf())
				break
		return TRUE

	else
		visible_message("<font color=purple>[src] twitches, trying to cum, but with no result.</font>", \
						"<font color=purple>You can't have an orgasm!</font>")

//This is cool modularised proc that required for determining if character can cum. Yes, it's obvious.
//actually i need it for hexacamphor (permanent anaphrodisiac)
//and for cooldown on climax.
/mob/living/carbon/human/proc/character_can_cum(mob/living/carbon/human/M)
	return TRUE

//Mood events

/datum/mood_event/climax
	description = "<font color=purple>Woah... This pleasant tiredness... I love it.</font>\n"
	mood_change = 8 //yes, +8. Well fed buff gives same amount. This is Fair (tm).
	timeout = 5 MINUTES

/datum/mood_event/climaxself
	description = "<font color=purple>I just came in my own underwear. Messy.</font>\n"
	mood_change = -2
	timeout = 4 MINUTES

//Прости кубик, тут не до конца доведено, может не работать.
//adding cum on floor. What am i doing in my life?
/turf/proc/add_cum_floor(mob/living/M, cum_type = NONE)
	var/obj/effect/decal/cleanable/cum/V = new /obj/effect/decal/cleanable/cum()
	if (QDELETED(V))
		V = locate() in src
	if(!V)
		return
	// Apply the proper icon and name set based on cum type
	if(cum_type == CUM_FEMALE)
		V.name = "female cum"
		V.desc = "Guhh... We need to call janitors."
		V.icon_state = "femcum_[pick(1,4)]"

	else if (cum_type == CUM_MALE)
		V.name = "male cum"
		V.desc = "Eww! Gross..."
		V.icon_state = "cum_[pick(1,4)]"
*/
