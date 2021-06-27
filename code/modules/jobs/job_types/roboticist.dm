/datum/job/roboticist
	title = "Roboticist"
	department_head = list("Research Director")
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#ffeeff"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW
	bounty_types = CIV_JOB_ROBO

	outfit = /datum/outfit/job/roboticist
	plasmaman_outfit = /datum/outfit/plasmaman/robotics
	departments = DEPARTMENT_SCIENCE

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_ROBOTICIST

	family_heirlooms = list(/obj/item/toy/plush/pkplush)

/datum/job/roboticist/New()
	. = ..()
	family_heirlooms += subtypesof(/obj/item/toy/mecha)

/datum/outfit/job/roboticist
	name = "Roboticist"
	jobtype = /datum/job/roboticist

	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/pda/roboticist
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/rnd/roboticist
	suit = /obj/item/clothing/suit/toggle/labcoat/roboticist

	backpack = /obj/item/storage/backpack/science/robo //SKYRAT CHANGE - Roboticist Bags (CHANGE)
	satchel = /obj/item/storage/backpack/satchel/tox/robo //SKYRAT CHANGE - Roboticist Bags (CHANGE)
	duffelbag = /obj/item/storage/backpack/duffel/robo //SKYRAT CHANGE - Roboticist Bags (ADDITION)

	pda_slot = ITEM_SLOT_LPOCKET

	skillchips = list(/obj/item/skillchip/job/roboticist)

	id_trim = /datum/id_trim/job/roboticist
