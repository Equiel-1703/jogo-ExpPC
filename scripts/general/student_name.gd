extends Control

func _on_tam_rota_line_field_text_submitted(new_text: String) -> void:
	print("Student name: ", new_text)

	Log.nome_aluno = new_text

	# Going to first level
	get_tree().change_scene_to_file(GlobalGameData.start_level_scene_path)
