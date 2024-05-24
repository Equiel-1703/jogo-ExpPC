extends Control

var level_1: PackedScene

func _ready():
	level_1 = preload("res://scenes/level_1/level_1.tscn")

func _on_jogar_pressed():
	get_tree().change_scene_to_packed(level_1)

func _on_sair_pressed():
	get_tree().quit()
