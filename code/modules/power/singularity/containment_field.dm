

/obj/machinery/field/containment
	name = "containment field"
	desc = "An energy field."
	icon = 'icons/obj/singularity.dmi' //ICON OVERRIDEN IN SKYRAT AESTHETICS - SEE MODULE
	icon_state = "Contain_F"
	density = FALSE
	move_resist = INFINITY
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	use_power = NO_POWER_USE
	interaction_flags_atom = NONE
	interaction_flags_machine = NONE
	CanAtmosPass = ATMOS_PASS_NO
	light_range = 4
	layer = ABOVE_OBJ_LAYER
	var/obj/machinery/field/generator/FG1 = null
	var/obj/machinery/field/generator/FG2 = null

/obj/machinery/field/containment/Initialize()
	. = ..()
	air_update_turf(TRUE, TRUE)
	RegisterSignal(src, COMSIG_ATOM_SINGULARITY_TRY_MOVE, .proc/block_singularity)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/field/containment/Destroy()
	FG1.fields -= src
	FG2.fields -= src
	CanAtmosPass = ATMOS_PASS_YES
	air_update_turf(TRUE, FALSE)
	return ..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/machinery/field/containment/attack_hand(mob/user, list/modifiers)
	if(get_dist(src, user) > 1)
		return FALSE
	else
		shock(user)
		return TRUE

/obj/machinery/field/containment/attackby(obj/item/W, mob/user, params)
	shock(user)
	return TRUE

/obj/machinery/field/containment/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BURN)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)
		if(BRUTE)
			playsound(loc, 'sound/effects/empulse.ogg', 75, TRUE)

/obj/machinery/field/containment/blob_act(obj/structure/blob/B)
	return FALSE

/obj/machinery/field/containment/ex_act(severity, target)
	return FALSE

/obj/machinery/field/containment/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if(!FG1 || !FG2)
		qdel(src)
		return
	if(ismegafauna(user))
		user.visible_message(span_warning("[user] glows fiercely as the containment field flickers out!"))
		FG1.calc_power(INFINITY) //rip that 'containment' field
		user.adjustHealth(-user.obj_damage)
	else
		return ..()

/obj/machinery/field/containment/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		shock(AM)

	if(ismachinery(AM) || isstructure(AM) || ismecha(AM))
		bump_field(AM)

/obj/machinery/field/containment/proc/set_master(master1,master2)
	if(!master1 || !master2)
		return FALSE
	FG1 = master1
	FG2 = master2
	return TRUE

/obj/machinery/field/containment/proc/block_singularity()
	SIGNAL_HANDLER

	return SINGULARITY_TRY_MOVE_BLOCK

/obj/machinery/field/containment/shock(mob/living/user)
	if(!FG1 || !FG2)
		qdel(src)
		return FALSE
	..()

/obj/machinery/field/containment/Move()
	qdel(src)
	return FALSE


// Abstract Field Class
// Used for overriding certain procs

/obj/machinery/field
	var/hasShocked = FALSE //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.

/obj/machinery/field/Bumped(atom/movable/mover)
	if(hasShocked)
		return
	if(isliving(mover))
		shock(mover)
		return
	if(ismachinery(mover) || isstructure(mover) || ismecha(mover))
		bump_field(mover)
		return


/obj/machinery/field/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(hasShocked || isliving(mover) || ismachinery(mover) || isstructure(mover) || ismecha(mover))
		return FALSE

/obj/machinery/field/proc/shock(mob/living/user)
	var/shock_damage = min(rand(30,40),rand(30,40))

	if(iscarbon(user))
		user.Paralyze(300)
		user.electrocute_act(shock_damage, src, 1)

	else if(issilicon(user))
		if(prob(20))
			user.Stun(40)
		user.take_overall_damage(0, shock_damage)
		user.visible_message(span_danger("[user.name] is shocked by the [src.name]!"), \
		span_userdanger("Energy pulse detected, system damaged!"), \
		span_hear("You hear an electrical crack."))

	user.updatehealth()
	bump_field(user)

/obj/machinery/field/proc/clear_shock()
	hasShocked = FALSE

/obj/machinery/field/proc/bump_field(atom/movable/AM as mob|obj)
	if(hasShocked)
		return FALSE
	hasShocked = TRUE
	do_sparks(5, TRUE, AM.loc)
	var/atom/target = get_edge_target_turf(AM, get_dir(src, get_step_away(AM, src)))
	AM.throw_at(target, 200, 4)
	addtimer(CALLBACK(src, .proc/clear_shock), 5)
