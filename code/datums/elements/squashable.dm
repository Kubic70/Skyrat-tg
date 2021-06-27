///This element allows something to be when crossed, for example for cockroaches.
/datum/element/squashable
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2
	///Chance on crossed to be squashed
	var/squash_chance = 50
	///How much brute is applied when mob is squashed
	var/squash_damage = 1
	///Squash flags, for extra checks etcetera.
	var/squash_flags = NONE
	///Special callback to call on squash instead, for things like hauberoach
	var/datum/callback/on_squash_callback


/datum/element/squashable/Attach(mob/living/target, squash_chance, squash_damage, squash_flags, squash_callback)
	. = ..()
	if(!istype(target))
		return ELEMENT_INCOMPATIBLE
	if(squash_chance)
		src.squash_chance = squash_chance
	if(squash_damage)
		src.squash_damage = squash_damage
	if(squash_flags)
		src.squash_flags = squash_flags
	if(!src.on_squash_callback && squash_callback)
		on_squash_callback = CALLBACK(target, squash_callback)

	AddElement(/datum/element/connect_loc_behalf, parent, loc_connections)

///Handles the squashing of the mob
/datum/element/squashable/proc/OnCrossed(mob/living/target, atom/movable/crossing_movable)
	SIGNAL_HANDLER


	if(squash_flags & SQUASHED_SHOULD_BE_DOWN && target.body_position != LYING_DOWN)
		return

	var/should_squash = prob(squash_chance)

	if(should_squash && on_squash_callback)
		if(on_squash_callback.Invoke(target, crossing_movable))
			return //Everything worked, we're done!
	if(isliving(crossing_movable))
		var/mob/living/crossing_mob = crossing_movable
		if(crossing_mob.mob_size > MOB_SIZE_SMALL && !(crossing_mob.movement_type & FLYING))
			if(HAS_TRAIT(crossing_mob, TRAIT_PACIFISM))
				crossing_mob.visible_message(span_notice("[crossing_mob] carefully steps over [parent_as_living]."), span_notice("You carefully step over [parent_as_living] to avoid hurting it."))
				return
			if(should_squash)
				crossing_mob.visible_message(span_notice("[crossing_mob] squashed [parent_as_living]."), span_notice("You squashed [parent_as_living]."))
				Squish(parent_as_living)
			else
				parent_as_living.visible_message(span_notice("[parent_as_living] avoids getting crushed."))
	else if(isstructure(crossing_movable))
		if(should_squash)
			crossing_movable.visible_message(span_notice("[parent_as_living] is crushed under [crossing_movable]."))
			Squish(parent_as_living)
		else
			parent_as_living.visible_message(span_notice("[parent_as_living] avoids getting crushed."))

/datum/element/squashable/proc/Squish(mob/living/target)
	if(squash_flags & SQUASHED_SHOULD_BE_GIBBED)
		target.gib()
	else
		target.adjustBruteLoss(squash_damage)

/datum/component/squashable/UnregisterFromParent()
	. = ..()
	RemoveElement(/datum/element/connect_loc_behalf, parent, loc_connections)
