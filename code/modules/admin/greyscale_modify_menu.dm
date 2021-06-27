/datum/greyscale_modify_menu
	var/atom/target
	var/client/user

	var/list/split_colors

	var/list/sprite_data

/datum/greyscale_modify_menu/New(atom/target, client/user)
	src.target = target
	src.user = user

	ReadColorsFromString(target.greyscale_colors)

	refresh_preview()

	RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/ui_close)

/datum/greyscale_modify_menu/Destroy()
	target = null
	user = null
	return ..()

/datum/greyscale_modify_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/greyscale_modify_menu/ui_close()
	qdel(src)

/datum/greyscale_modify_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GreyscaleModifyMenu")
		ui.open()

/datum/greyscale_modify_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/color_data = list()
	data["colors"] = color_data
	for(var/i in 1 to length(split_colors))
		color_data += list(list(
			"index" = i,
			"value" = split_colors[i]
		))

	data["sprites"] = sprite_data
	return data

/datum/greyscale_modify_menu/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("recolor")
			var/index = text2num(params["color_index"])
			split_colors[index] = lowertext(params["new_color"])
			refresh_preview()
		if("recolor_from_string")
			ReadColorsFromString(lowertext(params["color_string"]))
			refresh_preview()
		if("pick_color")
			var/group = params["color_index"]
			var/new_color = input(
				usr,
				"Choose color for greyscale color group [group]:",
				"Greyscale Modification Menu",
				split_colors[group]
			) as color|null
			if(new_color)
				split_colors[group] = new_color
				queue_refresh()

		if("random_color")
			var/group = text2num(params["color_index"])
			randomize_color(group)
			queue_refresh()

		if("random_all_colors")
			for(var/i in 1 to length(split_colors))
				randomize_color(i)
			queue_refresh()

		if("select_icon_state")
			var/new_icon_state = params["new_icon_state"]
			if(!config.icon_states[new_icon_state])
				return
			icon_state = new_icon_state
			queue_refresh()

		if("apply")
			target.greyscale_colors = split_colors.Join()
			target.update_appearance()
		if("refresh_file")
			SSgreyscale.RefreshConfigsFromFile()
			refresh_preview()

/datum/greyscale_modify_menu/proc/ReadColorsFromString(colorString)
	var/list/raw_colors = splittext(colorString, "#")
	split_colors = list()
	for(var/i in 2 to length(raw_colors))
		split_colors += "#[raw_colors[i]]"

/datum/greyscale_modify_menu/proc/randomize_color(color_index)
	var/new_color = "#"
	for(var/i in 1 to 3)
		new_color += num2hex(rand(0, 255), 2)
	split_colors[color_index] = new_color

/datum/greyscale_modify_menu/proc/queue_refresh()
	refreshing = TRUE
	addtimer(CALLBACK(src, .proc/refresh_preview), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/greyscale_modify_menu/proc/refresh_preview()
	var/list/data = SSgreyscale.configurations["[target.greyscale_config]"].GenerateDebug(split_colors)

	sprite_data = list()

	var/list/generated_icon_states = list()
	for(var/state in config.icon_states)
		generated_icon_states += state // We don't want the values from this keyed list
	sprite_data["icon_states"] = generated_icon_states

	if(!(icon_state in generated_icon_states))
		icon_state = target.icon_state
		if(!(icon_state in generated_icon_states))
			icon_state = pick(generated_icon_states)

	var/image/finished
	var/time_spent = TICK_USAGE
	if(!generate_full_preview)
		finished = image(config.GenerateBundle(used_colors), icon_state=icon_state)
		time_spent = TICK_USAGE - time_spent
	else
		var/list/data = config.GenerateDebug(used_colors.Join())
		time_spent = TICK_USAGE - time_spent
		finished = image(data["icon"], icon_state=icon_state)
		var/list/steps = list()
		sprite_data["steps"] = steps
		for(var/step in data["steps"])
			CHECK_TICK
			var/list/step_data = data["steps"][step]
			var/image/layer = image(step)
			var/image/result = step_data["result"]
			steps += list(
				list(
					"layer"=icon2html(layer, user, dir=sprite_dir, sourceonly=TRUE),
					"result"=icon2html(result, user, dir=sprite_dir, sourceonly=TRUE),
					"config_name"=step_data["config_name"]
				)
			)

	sprite_data["time_spent"] = TICK_DELTA_TO_MS(time_spent)
	sprite_data["finished"] = icon2html(finished, user, dir=sprite_dir, sourceonly=TRUE)
	refreshing = FALSE

/datum/greyscale_modify_menu/proc/Unlock()
	allowed_configs = SSgreyscale.configurations
	unlocked = TRUE

/datum/greyscale_modify_menu/proc/DefaultApply()
	target.set_greyscale(split_colors, config.type)
