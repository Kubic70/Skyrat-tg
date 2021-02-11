/obj/item/electropack/shockcollar
	name = "shock collar"
	desc = "A reinforced metal collar. It seems to have some form of wiring near the front. Strange.."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "shockcollar"
	inhand_icon_state = "shockcollar"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_SMALL
	strip_delay = 60
	equip_delay_other = 60
	custom_materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)

	var/tagname = null

/datum/design/electropack/shockcollar
	name = "Shockcollar"
	id = "shockcollar"
	build_type = AUTOLATHE
	build_path = /obj/item/electropack/shockcollar
	materials = list(/datum/material/iron = 5000, /datum/material/glass =2000)
	category = list("hacked", "Misc")

/obj/item/electropack/shockcollar/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(ITEM_SLOT_NECK))
		to_chat(user, "<span class='warning'>The collar is fastened tight! You'll need help taking this off!</span>")
		return
	return ..()

/obj/item/electropack/shockcollar/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return

	if(isliving(loc) && on)
		if(shock_cooldown == TRUE)
			return
		shock_cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 100)
		var/mob/living/L = loc
		step(L, pick(GLOB.cardinals))

		to_chat(L, "<span class='danger'>You feel a sharp shock from the collar!</span>")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, L)
		s.start()

		L.Paralyze(30)

	if(master)
		master.receive_signal()
	return

/obj/item/electropack/shockcollar/attackby(obj/item/W, mob/user, params) //moves it here because on_click is being bad
	if(istype(W, /obj/item/pen))
		var/t = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", tagname ? tagname : "Spot", MAX_NAME_LEN)
		if(t)
			tagname = t
			name = "[initial(name)] - [t]"
	else
		return ..()

/obj/item/electropack/shockcollar/ui_interact(mob/user) //on_click calls this
	var/dat = {"
<TT>
<B>Frequency/Code</B> for shock collar:<BR>
Frequency:
[format_frequency(src.frequency)]
<A href='byond://?src=[REF(src)];set=freq'>Set</A><BR>
Code:
[src.code]
<A href='byond://?src=[REF(src)];set=code'>Set</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/electropack/shockcollar
	var/random = TRUE

/obj/item/electropack/shockcollar/Initialize()
	if (random)
		code = rand(1,100)
		frequency = rand(MIN_FREE_FREQ, MAX_FREE_FREQ)
		if(ISMULTIPLE(frequency, 2))//signaller frequencies are always uneven!
			frequency++
	. = ..()
