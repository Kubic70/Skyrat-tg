#define MAX_SANE_LAYERS 50

/// A datum tying together a greyscale configuration and dmi file. Required for using GAGS and handles the code interactions.
/datum/greyscale_config
	/// Reference to the json config file
	var/json_config

	/// Reference to the dmi file for this config
	var/icon_file

	///////////////////////////////////////////////////////////////////////////////////////////
	// Do not set any further vars, the json file specified above is what generates the object

	/// String path to the json file, used for reloading
	var/string_json_config

	/// String path to the icon file, used for reloading
	var/string_icon_file

	/// Layer objects that the sprite is made up of
	var/list/layers

	/// How many colors are expected to be given when building the sprite
	var/expected_colors = 0

	/// Generated icons keyed by their color arguments
	var/list/icon_cache

// There's more sanity checking here than normal because this is designed for spriters to work with
// Sensible error messages that tell you exactly what's wrong is the best way to make this easy to use
/datum/greyscale_config/New()
	if(!json_config)
		CRASH("Greyscale config object [DebugName()] is missing a json configuration, make sure `json_config` has been assigned a value.")
	string_json_config = "[json_config]"
	if(!icon_file)
		CRASH("Greyscale config object [DebugName()] is missing an icon file, make sure `icon_file` has been assigned a value.")
	string_icon_file = "[icon_file]"

	Refresh()

/datum/greyscale_config/proc/Refresh(loadFromDisk=FALSE)
	if(loadFromDisk)
		json_config = file(string_json_config)
		icon_file = file(string_icon_file)

	var/list/raw = json_decode(file2text(json_config))
	ReadIconStateConfiguration(raw)

	if(!length(icon_states))
		CRASH("The json configuration [DebugName()] doesn't have any icon states.")

	icon_cache = list()

	ReadMetadata()

/// Gets the name used for debug purposes
/datum/greyscale_config/proc/DebugName()
	var/display_name = name || "MISSING_NAME"
	return "[display_name] ([icon_file]|[json_config])"

/// Takes the json icon state configuration and puts it into a more processed format
/datum/greyscale_config/proc/ReadIconStateConfiguration(list/data)
	icon_states = list()
	for(var/state in data)
		var/list/raw_layers = data[state]
		if(!length(raw_layers))
			stack_trace("The json configuration [DebugName()] for icon state '[state]' is missing any layers.")
			continue
		if(icon_states[state])
			stack_trace("The json configuration [DebugName()] has a duplicate icon state '[state]' and is being overriden.")
		icon_states[state] = ReadLayersFromJson(raw_layers)

/// Takes the json layers configuration and puts it into a more processed format
/datum/greyscale_config/proc/ReadLayersFromJson(list/data)
	var/list/output = ReadLayerGroup(data)
	return output[1]

/datum/greyscale_config/proc/ReadLayerGroup(list/data)
	if(!islist(data[1]))
		var/layer_type = SSgreyscale.layer_types[data["type"]]
		if(!layer_type)
			CRASH("An unknown layer type was specified in the json of greyscale configuration [DebugName()]: [data["layer_type"]]")
		return new layer_type(icon_file, data.Copy()) // We don't want anything in there touching our version of the data
	var/list/output = list()
	for(var/list/group as anything in data)
		output += ReadLayerGroup(group)
	if(length(output)) // Adding lists to lists unwraps the top level so here we are
		output = list(output)
	return output

/// Reads layer configurations to take out some useful overall information
/datum/greyscale_config/proc/ReadMetadata()
	var/icon/source = icon(icon_file)
	height = source.Height()
	width = source.Width()

	var/list/datum/greyscale_layer/all_layers = list()
	var/list/to_process = list(layers)
	while(length(to_process))
		var/current = to_process[length(to_process)]
		to_process.len--
		if(islist(current))
			to_process += current
		else
			all_layers += current

	if(length(all_layers) > MAX_SANE_LAYERS)
		stack_trace("[DebugName()] has [length(all_layers)] layers which is larger than the max of [MAX_SANE_LAYERS].")

	var/list/color_groups = list()
	var/largest_id = 0
	for(var/datum/greyscale_layer/layer as anything in all_layers)
		for(var/id in layer.color_ids)
			if(!isnum(id))
				continue
			largest_id = max(id, largest_id)
			color_groups["[id]"] = TRUE

	for(var/i in 1 to largest_id)
		if(color_groups["[i]"])
			continue
		stack_trace("Color Ids are required to be sequential and start from 1. [DebugName()] has a max id of [largest_id] but is missing [i].")

	expected_colors = length(color_groups)

/// Actually create the icon and color it in, handles caching
/datum/greyscale_config/proc/Generate(list/colors)
	if(length(colors) != expected_colors)
		CRASH("[DebugName()] expected [expected_colors] color arguments but only received [length(colors)]")
	var/key = colors.Join("&")
	var/icon/new_icon = icon_cache[key]
	if(new_icon)
		return new_icon
	new_icon = icon_cache[key] = GenerateLayerGroup(colors, layers)
	return new_icon

/// Internal recursive proc to handle nested layer groups
/datum/greyscale_config/proc/GenerateLayerGroup(list/colors, list/group, list/render_steps)
	var/icon/new_icon
	for(var/datum/greyscale_layer/layer as anything in group)
		var/icon/layer_icon
		if(islist(layer))
			layer_icon = GenerateLayerGroup(colors, layer, render_steps)
			layer = layer[1] // When there are multiple layers in a group like this we use the first one's blend mode
		else
			layer_icon = layer.Generate(colors, render_steps)

		if(!new_icon)
			new_icon = layer_icon
		else
			new_icon.Blend(layer_icon, layer.blend_mode)

		// These are so we can see the result of every step of the process in the preview ui
		if(render_steps)
			var/list/icon_data = list()
			render_steps[icon(layer_icon)] = icon_data
			icon_data["config_name"] = name
			icon_data["result"] = icon(new_icon)
	return new_icon

/datum/greyscale_config/proc/GenerateDebug(list/colors)
	if(length(colors) != expected_colors)
		CRASH("[DebugName()] expected [expected_colors] color arguments but only received [length(colors)]")

	var/list/output = list()
	var/list/debug_steps = list()
	output["steps"] = debug_steps

	output["icon"] = GenerateLayerGroup(colors, layers, debug_steps)
	return output

#undef MAX_SANE_LAYERS
