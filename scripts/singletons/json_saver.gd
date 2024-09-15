extends Node

func write_json_file(file_path: String, data: Dictionary) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))

	print("JSON Saver> File saved: " + file_path)
