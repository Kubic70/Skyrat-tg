/datum/crew_manifest

/datum/crew_manifest/ui_state(mob/user)
	return GLOB.always_state

/datum/crew_manifest/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || isAI(user) || ispAI(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/crew_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewManifest")
		ui.open()

/datum/crew_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return

/datum/crew_manifest/ui_data(mob/user)
	var/list/positions = list(
		"Central Command" = list("exceptions" = list(), "open" = 0),
		"Command" = list("exceptions" = list(), "open" = 0),
		"Security" = list("exceptions" = list(), "open" = 0),
		"Engineering" = list("exceptions" = list(), "open" = 0),
		"Medical" = list("exceptions" = list(), "open" = 0),
		"Misc" = list("exceptions" = list(), "open" = 0),
		"Science" = list("exceptions" = list(), "open" = 0),
		"Supply" = list("exceptions" = list(), "open" = 0),
		"Service" = list("exceptions" = list(), "open" = 0),
		"Silicon" = list("exceptions" = list(), "open" = 0)
	)
	var/list/departments = list(
		list("flag" = DEPARTMENT_CENTRAL_COMMAND, "name" = "Central Command"), //SKYRAT EDIT CHANGE
		list("flag" = DEPARTMENT_COMMAND, "name" = "Command"),
		list("flag" = DEPARTMENT_SECURITY, "name" = "Security"),
		list("flag" = DEPARTMENT_ENGINEERING, "name" = "Engineering"),
		list("flag" = DEPARTMENT_MEDICAL, "name" = "Medical"),
		list("flag" = DEPARTMENT_SCIENCE, "name" = "Science"),
		list("flag" = DEPARTMENT_CARGO, "name" = "Supply"),
		list("flag" = DEPARTMENT_SERVICE, "name" = "Service"),
		list("flag" = DEPARTMENT_SILICON, "name" = "Silicon")
	)

	for(var/job in SSjob.occupations)
		for(var/department in departments)
			// Check if the job is part of a department using its flag
			// Will return true for Research Director if the department is Science or Command, for example
			if(job["departments"] & department["flag"])
				// Add open positions to current department
				positions[department["name"]] += (job["total_positions"] - job["current_positions"])

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
