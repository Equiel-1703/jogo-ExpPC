extends Node

# Enum for the destination mode.
enum DEST_MODE {NORMAL, MIN_PATH, REVERSE}

class _destination:
	var planet_name: String
	var mode: DEST_MODE

	func _init(p_name: String, p_mode: DEST_MODE=DEST_MODE.NORMAL):
		planet_name = p_name
		mode = p_mode

func _parse_level_dictionary(level_dic: Dictionary):
	var phases_json: Array = level_dic["phases"]

	var dests: Array = []
	var phases: Array = []

	# Get the phases from the JSON file.
	for p in phases_json:
		# Get the destinations in the phase p.
		for dest in p:
			var dest_obj = _destination.new(dest["planet_name"],dest["mode"])
			
			print("Destination: " + dest_obj.planet_name + " Mode: " + str(dest_obj.mode) + "\n")
			
			dests.push_back(dest_obj)
		
		phases.push_back(dests)
	
	return phases

func load_level(level_path: String) -> Array:
	if not FileAccess.file_exists(level_path):
		printerr("JSON Loader> File not found: " + level_path)
		get_tree().quit()

	var file = FileAccess.open(level_path, FileAccess.READ)
	var json_file = JSON.parse_string(file.get_as_text())

	if json_file is Dictionary:
		return _parse_level_dictionary(json_file)
	else:
		printerr("JSON Loader> Invalid JSON file: " + level_path)
		get_tree().quit()
	
	return []