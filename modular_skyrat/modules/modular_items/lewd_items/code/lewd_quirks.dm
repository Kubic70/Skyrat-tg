//////////////////////////
///CODE FOR LEWD QUIRKS///
//////////////////////////

#define TRAIT_NYMPHOMANIA	"nymphomania"
#define TRAIT_MASOCHISM		"masochism"
#define TRAIT_BIMBO 		"bimbo"
#define TRAIT_NEVERBONER	"neverboner"

/////////////////
///NYMPHOMANIA///
/////////////////

/datum/quirk/nymphomania
	name = "Nymphomania"
	desc = "You have an overwhelming urge to have sex with someone. Constantly."
	value = -1 //This gives you uncomfortable stuff. But you can change it to 0. Don't change to positive values, it will be dumb.
	mob_trait = TRAIT_NYMPHOMANIA
	gain_text = "<font color=purple>You feel yourself much more hornier than before...</font>"
	lose_text = "<span class='notice'>A pleasant coolness spreads through the body. You are in control of your sexual desires again.</font>"
	medical_record_text = "Subject has nymphomania."
	var/obj/item/sextoy
	var/where

//nymphomania players need to satisfy lust, so they need "tools" to "cool" them from time to time. In case if there is NO PLAYERS AROUND.
/datum/quirk/nymphomania/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/sextoy_type
	var/obj/item/organ/genital/vagina = quirk_holder.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/genital/penis = quirk_holder.getorganslot(ORGAN_SLOT_PENIS)
	if(vagina && penis)
		sextoy_type = /obj/item/magic_wand
	else if(penis)
		sextoy_type = /obj/item/fleshlight
	else if(vagina)
		sextoy_type = /obj/item/dildo
	else
		sextoy_type = /obj/item/magic_wand

	sextoy = new sextoy_type(get_turf(quirk_holder))
	H.put_in_hands(sextoy)

/datum/quirk/nymphomania/post_add()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(/datum/brain_trauma/severe/nymphomania, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/nymphomania/remove()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	H?.cure_trauma_type(/datum/brain_trauma/severe/nymphomania, TRAUMA_RESILIENCE_ABSOLUTE)

//Nymphomania brain trauma code

/datum/brain_trauma/severe/nymphomania
	name = "Nymphomania"
	desc = "The patient constantly feels aroused and supposed to satisfy their sexual desires."
	scan_desc = "constant sexual arousal"
	gain_text = "<font color=purple>You feel yourself much more hornier than before...</font>"
	lose_text = "<span class='notice'>A pleasant coolness spreads through the body. You are in control of your sexual desires again.</font>"
	var/stress = 0
	var/dissatisfaction = 0

/datum/brain_trauma/severe/nymphomania/on_gain()
	..()
	if(check_arousal())
		to_chat(owner, "<font color=purple>You feel an intolerable desire...</font>")
	else
		to_chat(owner, "<span class='notice'>You feel satisfied... For now.</font>")

//character didn't got what he needed, so stress starts to raise. To stop it character need to cum

/datum/brain_trauma/severe/nymphomania/on_life(delta_time, times_fired)
	..()
	if(check_arousal())
		if(HAS_TRAIT(owner, TRAIT_MINDSHIELD))
			stress = min(stress + 0.25, 100)
			if(stress > 10)
				if(prob(20))
					stress_reaction()
		else
			stress = min(stress + 0.5, 100)
			if(stress > 10)
				if(prob(20))
					stress_reaction()
	else
		stress = max(stress - (2 * delta_time), 0)

//here we defining if character satisfied or not.

/datum/brain_trauma/severe/nymphomania/proc/check_arousal(delta_time, times_fired)
	..()
	if(owner.pleasure >= 100) //CHANGE IT TO CLIMAX BUFF BEFORE MERGING. IF NOT CHANGED - WE ARE DOOMED FOR BUGS.
		dissatisfaction = 0
		stress = 0

	if(HAS_TRAIT(owner, TRAIT_MINDSHIELD))
		dissatisfaction = min(dissatisfaction + 0.05, 100)
		if(dissatisfaction >= 100)
			return TRUE
	else
		dissatisfaction = min(dissatisfaction + 0.08, 100)
		if(dissatisfaction >= 100)
			return TRUE


/datum/brain_trauma/severe/nymphomania/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, "<font color=purple>You feel slightly aroused...</font>")
			else
				to_chat(owner, "<font color=purple>Lust spreads over your body!</font>")
				owner.emote("moan")
		if(2)
			if(!high_stress)
				to_chat(owner, "<font color=purple>You can't stop shaking...</font>")
				owner.dizziness += 20
				owner.add_confusion(20)
				owner.Jitter(20)
				owner.do_jitter_animation(20)
			else
				to_chat(owner, "<font color=purple>You feel hot and seduced!</font>")
				owner.dizziness += 20
				owner.add_confusion(20)
				owner.Jitter(20)
				owner.do_jitter_animation(20)
				owner.adjustStaminaLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, "<font color=purple>You bring your hips together in lust.</font>")
			else
				to_chat(owner, "<font color=purple>Desire driving you mad!</font>")
				owner.hallucination += 30

		if(5)
			if(!high_stress)
				to_chat(owner, "<font color=purple>You feel like your genitalias are burning...</font>")
				owner.adjustOxyLoss(8)
			else
				to_chat(owner, "<font color=purple>You need something to satisfy this desire! Something... Or someone?</font>")
				owner.adjustOxyLoss(16)
				owner.visible_message(pick("<font color=purple>[owner] seductively wags the hips.</font>\n",
								"<font color=purple>[owner] moans in lust!</font>\n",
								"<font color=purple>[owner] touches themselves in intimate places.</font>\n"))

///////////////
///MASOCHISM///
///////////////

/datum/quirk/masochism
	name = "Masochism"
	desc = "Pain brings you indescribable pleasure."
	value = 0 //ERP Traits don't have price. They are priceless. Ba-dum-tss
	mob_trait = TRAIT_MASOCHISM
	gain_text = "<span class='danger'>You feel youself much more perverted to pain...</font>"
	lose_text = "<span class='notice'>Ouch! Pain is... Painful again! Ou-ou-ouch!</font>"
	medical_record_text = "Subject has masochism."

//All this stuff calculated in arousal_system.dm, by transfering pain into pleasure.

//////////////////
///EMPATH BOUNS///
//////////////////
/mob/living/carbon/human/examine(mob/user)
	.=..()
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_is = p_are()
	var/mob/living/U = user

	if(stat != DEAD && !HAS_TRAIT(src, TRAIT_FAKEDEATH) && src != U)
		if(src != user)
			if(HAS_TRAIT(U, TRAIT_EMPATH))
				switch(arousal)
					if(11 to 21)
						. += "<font color=purple>[t_He] [t_is] excited.</font>\n"
					if(21.01 to 41)
						. += "<font color=purple>[t_He] [t_is] slightly blushed.</font>\n"
					if(41.01 to 51)
						. += "<font color=purple>[t_He] [t_is] quite aroused and seems to be stirring up lewd thoughts in [t_his] head.</font>\n"
					if(51.01 to 61)
						. += "<font color=purple>[t_He] [t_is] very aroused and [t_his] movements are seducing.</font>\n"
					if(61.01 to 91)
						. += "<font color=purple>[t_He] looks aroused as hell.</font>\n"
					if(91.01 to INFINITY)
						. += "<font color=purple>[t_He] [t_is] extremely excited, exhausting from entolerable desire.</font>\n"

///////////////////////
///BIMBO CURSE STUFF///
///////////////////////

/*ADD BIMBO CURSE HERE
Заменять любую речь на стоны
Постоянное поддерживание возбуждения на 100.
Изредка сообщения в чат о развратных микродействиях проклятого персонажа
*/