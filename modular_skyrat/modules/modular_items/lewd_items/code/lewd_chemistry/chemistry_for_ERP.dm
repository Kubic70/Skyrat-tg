
#define SKINTONE2HEX(skin_tone) GLOB.skin_tones[skin_tone] || skin_tone //we creating new genitals when changing gender, need to color them.

//////////////////
///APHRODISIACS///
//////////////////

//Crocin. Basic aphrodisiac with no consequences

/datum/reagent/drug/crocin
	name = "Crocin"
	description = "Naturally found in the crocus and gardenia flowers, this drug acts as a natural and safe aphrodisiac."
	taste_description = "strawberries"
	color = "#FFADFF"//PINK, rgb(255, 173, 255)
	//can_synth = FALSE

/datum/reagent/drug/crocin/on_mob_life(mob/living/M)
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if((prob(min(current_cycle/2,5))))
			M.emote(pick("moan","blush"))
		if(prob(min(current_cycle/4,10)))
			var/aroused_message = pick("You feel frisky.", "You're having trouble suppressing your urges.", "You feel in the mood.")
			to_chat(M, "<span class='notice'>[aroused_message]</span>")
		if(ishuman(M))
			M.adjustArousal(1)
			for(var/obj/item/organ/genital/G)
				if(!G.aroused == AROUSAL_CANT)
					G.aroused = AROUSAL_FULL
					G.update_sprite_suffix()
			M.update_body()
	..()

//Hexacrocin. Advanced aphrodisiac that can cause brain traumas.

/datum/reagent/drug/hexacrocin
	name = "Hexacrocin"
	description = "Chemically condensed form of basic crocin. This aphrodisiac is extremely powerful and addictive in most animals.\
					Addiction withdrawals can cause brain damage and shortness of breath. Overdosage can lead to brain traumas."
	taste_description = "liquid desire"
	color = "#FF2BFF"//dark pink
	overdose_threshold = 25 //Heavy consequences. Supposed to be big value.

/datum/reagent/drug/hexacrocin/on_mob_life(mob/living/M)
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if(prob(5))
			if(prob(current_cycle))
				M.say(pick("Hnnnnngghh...", "Ohh...", "Mmnnn...","Ghhmph..."))
			else
				M.emote(pick("moan","blush"))
		if(prob(5))
			var/aroused_message
			if(current_cycle>25)
				aroused_message = pick("You need to fuck someone!", "You're bursting with sexual tension!", "You can't get sex off your mind!")
			else
				aroused_message = pick("You feel a bit hot.", "You feel strong sexual urges.", "You feel in the mood.", "You're ready to go down on someone.")
			to_chat(M, "<font color=purple>[aroused_message]</font>")
		if(ishuman(M))
			M.adjustArousal(2)
			M.adjustPleasure(1)
			M.adjustPain(0.2)
			for(var/obj/item/organ/genital/G)
				if(!G.aroused == AROUSAL_CANT)
					G.aroused = AROUSAL_FULL
					G.update_sprite_suffix()
			M.update_body()
	..()

/datum/reagent/drug/hexacrocin/overdose_process(mob/living/M)
	var/mob/living/carbon/human/H = M
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if(prob(5) && ishuman(M) && !HAS_TRAIT(M, TRAIT_BIMBO) && !HAS_TRAIT(M, TRAIT_SOBSESSED)/* && M.has_dna() && some shit about bimbofication*/) //yes, pal. an i'm the horseman of the Apocalypse that will make it work. Sorry.
			to_chat(M, "<font color=purple>Your libido is going haywire!</font>")
			H.gain_trauma(pick(/datum/brain_trauma/special/bimbo, /datum/brain_trauma/special/nymphomania), TRAUMA_RESILIENCE_LOBOTOMY) //what am i doing with my life.
	..()

//Dopamine. Generates in character after orgasm.

/datum/reagent/drug/dopamine
	name = "dopamine"
	description = "Pure happines"
	taste_description = "indescribable slightly sour taste, but something in it relaxes you, filling you with pleasure"
	color = "#97ffee"
	glass_name = "dopamine"
	glass_desc = "Delicious flavored reagent. You feel happy even looking at it."
	reagent_state = LIQUID
	overdose_threshold = 10
	overdosed = TRUE
	trippy = TRUE

/datum/reagent/drug/dopamine/on_mob_add(mob/living/M)
	to_chat(world, "dopamine adding")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_start", /datum/mood_event/orgasm, name)
	to_chat(world, "dopamine added")
	..()

/datum/reagent/drug/dopamine/on_mob_life(mob/living/M)
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		M.set_drugginess(5)
		if(prob(7))
			M.emote(pick("twitch","drool","moan","giggle","shaking"))
	..()

/datum/reagent/drug/dopamine/overdose_start(mob/living/M)
	to_chat(M, "<font color=purple>You feel yourself so happy!</font>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overgasm, name)

/datum/reagent/drug/dopamine/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
		M.adjustArousal(0.5)
		M.adjustPleasure(0.3)
		M.adjustPain(-0.5)
		if(prob(2))
			M.emote(pick("moan","twitch_s"))
	..()

////////////////////
///ANAPHRODISIACS///
////////////////////

//Camphor. Used to reduce libido.

/datum/reagent/drug/camphor
	name = "Camphor"
	description = "Naturally found in some species of evergreen trees, camphor is a waxy substance. When injested by most animals, it acts as an anaphrodisiac\
					, reducing libido and calming them. Non-habit forming and not addictive."
	taste_description = "dull bitterness"
	taste_mult = 2
	color = "#D9D9D9"//rgb(157, 157, 157)
	reagent_state = SOLID

/datum/reagent/drug/camphor/on_mob_life(mob/living/M)
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if(ishuman(M))
			M.adjustArousal(-3)
			if(M.arousal <= 0)
				to_chat(M, "<span class='notice'>You no longer feel aroused.</span>")
	..()

//Pentacamphor. Used to PERMANENTLY reduce libido. Possibly can cure bimbofication. I wrote this with a straight face, what am i doing?

/datum/reagent/drug/pentacamphor
	name = "Pentacamphor"
	description = "Chemically condensed camphor. Causes an extreme reduction in libido and a permanent one if overdosed. Non-addictive."
	taste_description = "tranquil celibacy"
	color = "#D9D9D9"//rgb(255, 255, 255)
	reagent_state = SOLID
	overdose_threshold = 20

/datum/reagent/drug/pentacamphor/on_mob_life(mob/living/M)
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if(ishuman(M))
			M.adjustArousal(-6)
			M.adjustPleasure(-3)
			if(M.arousal <= 0)
				to_chat(M, "<span class='notice'>You no longer feel aroused.</span>")
	..()

/datum/reagent/drug/pentacamphor/overdose_process(mob/living/M)
	var/mob/living/carbon/human/H = M
	if(M.client && (M.client.prefs.skyrat_toggles & APHRO_PREF))
		if(!HAS_TRAIT(M, TRAIT_BIMBO))
			to_chat(M, "<span class='userlove'>You feel like you'll never feel aroused again...</span>") //Go to horny jail *bonk*
			ADD_TRAIT(M,TRAIT_NEVERBONER,APHRO_TRAIT)

		if(HAS_TRAIT(M, TRAIT_BIMBO))
			if(prob(30))
				H.cure_trauma_type(/datum/brain_trauma/special/bimbo, TRAUMA_RESILIENCE_LOBOTOMY)
				to_chat(M, "<span class='notice'>Your mind is free from purple liquid substance. Your thoughts are pure and innocent again.")
		if(HAS_TRAIT(M, TRAIT_NYMPHOMANIA))
			if(prob(30))
				H.cure_trauma_type(/datum/brain_trauma/special/nymphomania, TRAUMA_RESILIENCE_LOBOTOMY)
				to_chat(M, "<span class='notice'>Your mind is free from purple liquid substance. Your thoughts are pure and innocent again.")
	..()

///////////////////////////////////
///GENITAL ENLARGEMENT CHEMICALS///
///////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//										BREAST ENLARGE
///////////////////////////////////////////////////////////////////////////////////////////////////
//Other files that are relivant:
//modular_citadel/code/datums/status_effects/chems.dm
//modular_citadel/code/modules/arousal/organs/breasts.dm

//breast englargement
//Honestly the most requested chems
//I'm not a very kinky person, sorry if it's not great
//I tried to make it interesting..!!

//Normal function increases your breast size by 0.05, 10units = 1 cup.
//If you get stupid big, it presses against your clothes, causing brute and oxydamage. Then rips them off.
//If you keep going, it makes you slower, in speed and action.
//decreasing your size will return you to normal.
//(see the status effect in chem.dm)
//Overdosing on (what is essentially space estrogen) makes you female, removes balls and shrinks your dick.
//OD is low for a reason. I'd like fermichems to have low ODs, and dangerous ODs, and since this is a meme chem that everyone will rush to make, it'll be a lesson learnt early.

//КУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИКУБИКПРОЧТИ//
//Кубик, надо сделать добавление груди т.к сейчас она не отображается и не наследует цвет от тела.
//А также проверить уменьшение гениталий от этой штуки и сделать тоже самое для таблеток, увеличивающих пенис
//Которых пока нет, сделай их по аналогичному принципу. Оставить маленькую грудь, убрать все что ниже пояса и приделать пару шаров с палкой.


/datum/reagent/breast_enlarger
	name = "Succubus milk"
	description = "A volatile collodial mixture derived from milk that encourages mammary production via a potent estrogen mix."
	color = "#E60584" // rgb: 96, 0, 255
	taste_description = "a milky ice cream like flavour."
	overdose_threshold = 17
	metabolization_rate = 0.25
	var/message_spam = FALSE

/datum/reagent/breast_enlarger/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!ishuman(M)) //The monkey clause
		if(volume >= 15) //To prevent monkey breast farms
			var/turf/T = get_turf(M)
			var/obj/item/organ/genital/breasts/B = new /obj/item/organ/genital/breasts(T)
			M.visible_message("<span class='warning'>A pair of breasts suddenly fly out of the [M]!</b></span>")
			var/T2 = get_random_station_turf()
			M.adjustBruteLoss(25)
			M.Paralyze(50)
			M.Stun(50)
			B.throw_at(T2, 8, 1)
		M.reagents.del_reagent(type)
		return
/*	var/mob/living/carbon/human/H = M
	if(!H.getorganslot(ORGAN_SLOT_BREASTS) && H.emergent_genital_call())
		H.genital_override = TRUE */

/datum/reagent/breast_enlarger/on_mob_life(mob/living/carbon/human/M) //Increases breast size
	if(!ishuman(M))//Just in case
		return..()

	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	if(M.breast_enlarger_amount >= 100)
		if(B.genital_size <= 16)
			B.genital_size += 1
		else
			return
		B.update_sprite_suffix()
		M.update_body()
		M.breast_enlarger_amount = 0
	M.breast_enlarger_amount += 5

	var/mob/living/carbon/human/H = M
	//If they've opted out, then route processing though liver.
	if(!(H.client.prefs.skyrat_toggles && BREAST_ENLARGEMENT))
		var/obj/item/organ/liver/L = H.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		else
			H.adjustToxLoss(1)
		return..()

	//otherwise proceed as normal

	if (ISINRANGE_EX(B.genital_size, 8.5, 9) && (H.w_uniform || H.wear_suit))
		var/target = H.get_bodypart(BODY_ZONE_CHEST)
		if(!message_spam)
			to_chat(H, "<span class='danger'>Your breasts begin to strain against your clothes tightly!</b></span>")
			message_spam = TRUE
		H.adjustOxyLoss(5, 0)
		H.apply_damage(1, BRUTE, target)
	return ..()

/datum/reagent/breast_enlarger/overdose_process(mob/living/carbon/human/M) //Turns you into a female if character is male, doesn't touch nonbinary and object genders.
	var/obj/item/organ/genital/penis/P = M.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/genital/testicles/T = M.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/genital/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
	if(!(M.client?.prefs.skyrat_toggles & FORCED_FEM))
		var/obj/item/organ/liver/L = M.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.applyOrganDamage(0.25)
		return ..()

	if(!B)
		B = new
		M.dna.species.mutant_bodyparts["breasts"] = B
		if(M.dna.species.use_skintones)
			B.color = SKINTONE2HEX(M.skin_tone)
		else if(M.dna.features["breasts_color"])
			B.color = "#[M.dna.features["breasts_color"]]"
		else
			B.color = SKINTONE2HEX(M.skin_tone)
		to_chat(M, "<span class='warning'>Your chest feels warm, tingling with newfound sensitivity.</b></span>")
		B.Insert(M)
		M.update_body()
		B.update_sprite_suffix()

	if(M.gender == MALE)
		M.set_gender(FEMALE)

	if(P)
		if(P.genital_size >=2)
			return
		else
			(P.genital_size -=3)
	if(T)
		qdel(T)

	return ..()

////////////////////////
///CHEMICAL REACTIONS///
////////////////////////

/datum/chemical_reaction/crocin
	results = list(/datum/reagent/drug/crocin = 6)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/oxygen = 2, /datum/reagent/water = 1)
	required_temp = 400
	mix_message = "The mixture boils off a pink vapor..."//The water boils off, leaving the crocin

/datum/chemical_reaction/hexacrocin
	results = list(/datum/reagent/drug/hexacrocin = 1)
	required_reagents = list(/datum/reagent/drug/crocin = 6, /datum/reagent/phenol = 1)
	required_temp = 600 //hexacrocin now more dangerous, so higher temperature to prevent clowns making it in ghetto and using smokemachine with it.
	mix_message = "The mixture rapidly condenses and darkens in color..."

/datum/chemical_reaction/camphor
	results = list(/datum/reagent/drug/camphor = 6)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/oxygen = 2, /datum/reagent/sulfur = 1)
	required_temp = 400
	mix_message = "The mixture boils off a yellow, smelly vapor..."//Sulfur burns off, leaving the camphor

/datum/chemical_reaction/pentacamphor //liquid horny jail
	results = list(/datum/reagent/drug/pentacamphor = 1)
	required_reagents = list(/datum/reagent/drug/pentacamphor = 5, /datum/reagent/acetone = 1)
	required_temp = 500
	mix_message = "The mixture thickens and heats up slighty..."

///////////////////////
///BOTTLES AND PILLS///
///////////////////////

//bottles

/obj/item/reagent_containers/glass/bottle/crocin
	name = "Crocin bottle"
	desc = "A bottle of mild aphrodisiac. Increases libido."
	list_reagents = list(/datum/reagent/drug/crocin = 30)

/obj/item/reagent_containers/glass/bottle/hexacrocin
	name = "Hexacrocin bottle"
	desc = "A bottle of strong aphrodisiac. Increases libido. Potentially  dangerous."
	list_reagents = list(/datum/reagent/drug/hexacrocin = 30)

/obj/item/reagent_containers/glass/bottle/dopamine //this one is hard to obtain.
	name = "Hexacrocin bottle"
	desc = "Pure pleasure and happines in a bottle."
	list_reagents = list(/datum/reagent/drug/dopamine = 30)

/obj/item/reagent_containers/glass/bottle/camphor
	name = "Camphor bottle"
	desc = "A bottle of mild anaphrodisiac. Reduces libido."
	list_reagents = list(/datum/reagent/drug/camphor = 30)

/obj/item/reagent_containers/glass/bottle/pentacamphor
	name = "Hexacamphor bottle"
	desc = "A bottle of strong anaphrodisiac. Reduces libido."
	list_reagents = list(/datum/reagent/drug/pentacamphor = 30)

/obj/item/reagent_containers/glass/bottle/breast_enlarger
	name = "Succubus milk bottle"
	desc = "A bottle of strong breast enlargement reagent."
	list_reagents = list(/datum/reagent/breast_enlarger/ = 30)

//pills

/obj/item/reagent_containers/pill/crocin
	name = "crocin pill (10u)"
	desc = "I've fallen, and I can't get it up!"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon_state = "crocin"
	list_reagents = list(/datum/reagent/drug/crocin = 10)

/obj/item/reagent_containers/pill/hexacrocin
	name = "hexacrocin pill (10u)"
	desc = "Pill in creepy heart form."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon_state = "hexacrocin"
	list_reagents = list(/datum/reagent/drug/hexacrocin = 10)

/obj/item/reagent_containers/pill/dopamine
	name = "dopamine pill (5u)"
	desc = "Feelings from orgasm, contained in a pill... Weird."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon_state = "dopamine"
	list_reagents = list(/datum/reagent/drug/dopamine = 5)

/obj/item/reagent_containers/pill/camphor
	name = "camphor pill (10u)"
	desc = "For the early bird."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon_state = "camphor"
	list_reagents = list(/datum/reagent/drug/camphor = 10)

/obj/item/reagent_containers/pill/pentacamphor
	name = "pentacamphor pill (10u)"
	desc = "The chemical equivalent of horny jail."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_pills.dmi'
	icon_state = "pentacamphor"
	list_reagents = list(/datum/reagent/drug/pentacamphor = 10)

//keg

/obj/structure/reagent_dispensers/keg/aphro
	name = "keg of aphrodisiac"
	desc = "A keg of aphrodisiac."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/kegs.dmi'
	icon_state = "crocin"
	reagent_id = /datum/reagent/drug/crocin
	tank_volume = 150

/obj/structure/reagent_dispensers/keg/aphro/strong
	name = "keg of strong aphrodisiac"
	desc = "A keg of strong and addictive aphrodisiac."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/kegs.dmi'
	icon_state = "hexacrocin"
	reagent_id = /datum/reagent/drug/hexacrocin
	tank_volume = 120
