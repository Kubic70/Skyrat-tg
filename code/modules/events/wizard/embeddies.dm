/datum/round_event_control/wizard/embedpocalypse
	name = "Make Everything Embeddable"
	weight = 2
	typepath = /datum/round_event/wizard/embedpocalypse
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/wizard/embedpocalypse/start()
	for(var/obj/item/I in world)
		CHECK_TICK

		if(!(I.flags_1 & INITIALIZED_1))
			continue

		if(!I.embedding || I.embedding == EMBED_HARMLESS)
			I.embedding = EMBED_POINTY
			I.updateEmbedding()
			I.name = "pointy [I.name]"

	GLOB.embedpocalypse = TRUE
	GLOB.stickpocalypse = FALSE // embedpocalypse takes precedence over stickpocalypse

/datum/round_event_control/wizard/embedpocalypse/sticky
	name = "Make Everything Sticky"
	weight = 6
	typepath = /datum/round_event/wizard/embedpocalypse/sticky
	max_occurrences = 1
	earliest_start = 0 MINUTES

<<<<<<< HEAD
/datum/round_event_control/wizard/embedpocalypse/sticky/canSpawnEvent(players_amt, gamemode)
	if(GLOB.embedpocalypse)
		return FALSE
=======
/datum/round_event/wizard/embedpocalypse/sticky/start()
	GLOB.global_funny_embedding = new /datum/global_funny_embedding/sticky

///set this to a new instance of a SUBTYPE of global_funny_embedding. The main type is a prototype and will runtime really hard
GLOBAL_DATUM(global_funny_embedding, /datum/global_funny_embedding)

/**
 * ## global_funny_embedding!
 *
 * Stored in a global datum, and created when it is turned on via event or VV'ing the GLOB.embedpocalypse_controller to be a new /datum/global_funny_embedding.
 * Gives every item in the world a prefix to their name, and...
 * Makes every item in the world embed when thrown, but also hooks into global signals for new items created to also bless them with embed-ability(??).
 */
/datum/global_funny_embedding
	var/embed_type = EMBED_POINTY
	var/prefix = "error"

/datum/global_funny_embedding/New()
	. = ..()
	//second operation takes MUCH longer, so lets set up signals first.
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_ITEM, .proc/on_new_item_in_existence)
	handle_current_items()

/datum/global_funny_embedding/Destroy(force)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_NEW_ITEM)

///signal sent by a new item being created.
/datum/global_funny_embedding/proc/on_new_item_in_existence(datum/source, obj/item/created_item)
	SIGNAL_HANDLER

	// this proc says it's for initializing components, but we're initializing elements too because it's you and me against the world >:)
	if(LAZYLEN(created_item.embedding))
		return //already embeds to some degree, so whatever 🐀
	created_item.embedding = embed_type
	created_item.name = "[prefix] [created_item.name]"
	created_item.updateEmbedding()
>>>>>>> origin/master

/datum/round_event/wizard/embedpocalypse/sticky/start()
	for(var/obj/item/I in world)
		CHECK_TICK

		if(!(I.flags_1 & INITIALIZED_1))
			continue

		if(!I.embedding)
			I.embedding = EMBED_HARMLESS
			I.updateEmbedding()
			I.name = "sticky [I.name]"

	GLOB.stickpocalypse = TRUE
