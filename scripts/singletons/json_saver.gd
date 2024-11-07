extends Node

func create_json_file(file_path: String, data: Dictionary) -> FileAccess:
	var counter: int = 0
	var file_name = file_path.get_file().replace(".json", "")

	# If file already exists, do not overwrite it
	while FileAccess.file_exists(file_path):
		counter += 1
		
		var new_file_path = file_path.get_base_dir() + "/" + file_name + "_" + str(counter) + ".json"
		
		print("JSON Saver> File already exists: " + file_path.get_file() + ". Renaming to: " + new_file_path.get_file())
		
		file_path = new_file_path
	
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))

	print("JSON Saver> File succesfully created: " + file_path)

	return file

func update_json_file(file: FileAccess, data: Dictionary) -> void:
	if not file:
		print("JSON Saver> File is null. Cannot update.")
		return
	
	file.seek(0)
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()

	print("JSON Saver> File succesfully updated: " + file.get_path())
