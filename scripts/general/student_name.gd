extends Control

func _on_tam_rota_line_field_text_submitted(new_text: String) -> void:
	print("Student name: ", new_text)

	# Create log file with default values
	Log.create_empty_log_file(new_text)

	# Going to first level
	get_tree().change_scene_to_file(GlobalGameData.start_level_scene_path)

func _on_ok_pressed() -> void:
	_on_tam_rota_line_field_text_submitted(%TamRotaLineField.text)

func _on_cancelar_pressed() -> void:
	get_tree().change_scene_to_packed(GlobalGameData.main_screen)
