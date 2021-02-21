/obj/structure/bed/bdsm_bed
	name = "bdsm bed"
	desc = "This is a latex bed with D-rings on sides. Looks comfortable."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	icon_state = "bdsm_bed"

/obj/item/bdsm_bed_kit
	name = "bdsm bed construction kit"
	desc = "A wrench is required to construct."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	throwforce = 0
	icon_state = "bdsm_bed_kit"
	var/unwrapped = 0
	w_class = WEIGHT_CLASS_HUGE

/obj/item/bdsm_bed_kit/attackby(obj/item/P, mob/user, params) //constructing a bed here.
	add_fingerprint(user)
	if(istype(P, /obj/item/wrench))
		if (!(item_flags & IN_INVENTORY))
			to_chat(user, "<span class='notice'>You start to fasten the frame to the floor and inflating latex pillows...</span>")
			if(P.use_tool(src, user, 8 SECONDS, volume=50))
				to_chat(user, "<span class='notice'>You construct the bdsm bed!</span>")
				var/obj/structure/bed/bdsm_bed/C = new
				C.loc = loc
				del(src)
			return

/obj/structure/bed/bdsm_bed/attackby(obj/item/P, mob/user, params) //deconstructing a bed. Aww(
	add_fingerprint(user)
	if(istype(P, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You start to unfastening the frame of bed...</span>")
		if(P.use_tool(src, user, 8 SECONDS, volume=50))
			to_chat(user, "<span class='notice'>You take down the bdsm bed!</span>")
			var/obj/item/bdsm_bed_kit/C = new
			C.loc = loc
			del(src)
		return

/obj/structure/bed/bdsm_bed/post_buckle_mob(mob/living/M)
	density = TRUE
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/bed/bdsm_bed/post_unbuckle_mob(mob/living/M)
	density = FALSE
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset

/////////////////////
//X-Stand code here//
/////////////////////

/obj/structure/bed/x_stand
	name = "x stand"
	desc = "Why you even call it X stand? It doesn't even in X form. Anyway you can buckle someone to it"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	icon_state = "xstand"
	var/stand_state = "open"
	var/stand_open = FALSE
	var/list/stand_states = list("open" = "close", "close" = "open")
	var/state_thing = "open"
	var/static/mutable_appearance/xstand_overlay = mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi', "xstand_overlay", LYING_MOB_LAYER)

/obj/structure/bed/x_stand/update_icon_state()
    . = ..()
    icon_state = "[initial(icon_state)]_[stand_state? "open" : "close"]"

//to close and open x stand by LBM
/obj/structure/bed/x_stand/attack_hand(mob/living/user)
	user.visible_message("<font color=purple>[user] locked the locks on the [src]!</font>")
	toggle_mode()
	if(stand_state == "open")
		to_chat(user, "<span class='notice'>Stand is open now.</span>")
	if(stand_state == "close")
		to_chat(user, "<span class='notice'>Stand is closed now!</span>")
	update_icon()
	update_icon_state()

//to make it have model when we constructing the thingy
/obj/structure/bed/x_stand/Initialize()
	. = ..()
	update_icon_state()
	update_icon()

//toggle_mode() proc that changes sprite and var.
/obj/structure/bed/x_stand/proc/toggle_mode()
	state_thing = stand_states[state_thing]
	switch(state_thing)
		if("open")
			stand_state = "open"
			update_icon_state()
			update_icon()
			playsound(loc, 'sound/weapons/magin.ogg', 20, TRUE)
			cut_overlay(xstand_overlay)

		if("close")
			stand_state = "close"
			update_icon_state()
			update_icon()
			playsound(loc, 'sound/weapons/magin.ogg', 20, TRUE)
			add_overlay(xstand_overlay)

//xstand allows buckle someone to it.
/obj/structure/bed/x_stand/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(stand_state == "close")
		if(has_buckled_mobs())
			if(buckled_mob != user)
				buckled_mob.visible_message("<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
					"<span class='hear'>You hear a metal clank...</span>")
				stand_state = "open"
				update_icon_state()
				update_icon()
			else
				buckled_mob.visible_message("<span class='warning'>[buckled_mob.name] struggles to break free from the gelatinous resin!</span>",\
					"<span class='notice'>You struggle to break free from the gelatinous resin... (Stay still for two minutes.)</span>",\
					"<span class='hear'>You hear a metal clank...</span>")
				if(!do_after(buckled_mob, 1200, target = src))
					if(buckled_mob?.buckled)
						to_chat(buckled_mob, "<span class='warning'>You fail to unbuckle yourself!</span>")
					return
				if(!buckled_mob.buckled)
					return

				buckled_mob.visible_message("<span class='warning'>[buckled_mob.name] breaks free from the gelatinous resin!</span>",\
					"<span class='notice'>You break free from the gelatinous resin!</span>",\
					"<span class='hear'>You hear a metal clank...</span>")
				stand_state = "open"
				update_icon_state()
				update_icon()

				unbuckle_mob(buckled_mob)
				add_fingerprint(user)

/obj/structure/bed/x_stand/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(stand_state == "close")
		return

	if(buckle_mob(M))
		M.visible_message("<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
			"<span class='danger'>[user.name] drenches you in a foul-smelling resin, trapping you in [src]!</span>",\
			"<span class='hear'>You hear a metal clank...</span>")

/obj/structure/bed/x_stand/post_buckle_mob(mob/living/M)
	M.pixel_y = M.base_pixel_y
	M.pixel_x = M.base_pixel_x + 2
	M.layer = BELOW_MOB_LAYER

/obj/structure/bed/x_stand/post_unbuckle_mob(mob/living/M)
	M.pixel_x = M.base_pixel_x + M.body_position_pixel_x_offset
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	M.layer = initial(M.layer)

///////////////////////////
//xstand construction kit//
///////////////////////////

/obj/item/x_stand_kit
	name = "xstand construction kit"
	desc = "A wrench is required to construct."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'
	throwforce = 0
	icon_state = "xstand_kit"
	var/unwrapped = 0
	w_class = WEIGHT_CLASS_HUGE

/obj/item/x_stand_kit/attackby(obj/item/P, mob/user, params) //constructing a bed here.
	add_fingerprint(user)
	if(istype(P, /obj/item/wrench))
		if (!(item_flags & IN_INVENTORY))
			to_chat(user, "<span class='notice'>You start to fasten the frame to the floor.</span>")
			if(P.use_tool(src, user, 8 SECONDS, volume=50))
				to_chat(user, "<span class='notice'>You construct the x-stand!</span>")
				var/obj/structure/bed/x_stand/C = new
				C.loc = loc
				del(src)
			return

/obj/structure/bed/x_stand/attackby(obj/item/P, mob/user, params) //deconstructing a bed. Aww(
	add_fingerprint(user)
	if(istype(P, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You start to unfastening the frame of x-stand...</span>")
		if(P.use_tool(src, user, 8 SECONDS, volume=50))
			to_chat(user, "<span class='notice'>You take down the x-stand!</span>")
			var/obj/item/x_stand_kit/C = new
			C.loc = loc
			del(src)
		return
