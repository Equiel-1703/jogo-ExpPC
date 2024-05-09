extends Control

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1/level_1.tscn")

func _on_sair_pressed():
	get_tree().quit()
