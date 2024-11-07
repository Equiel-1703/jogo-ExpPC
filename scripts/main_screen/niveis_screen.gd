extends Control

@onready var _btns_container = $CenterContainer/HFlowContainer

@export var button_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Adding buttons to the container
	for i in GlobalGameData.levels_table.size():
		var button = button_scene.instantiate()
		button.set_button_num(i + 1)
		_btns_container.add_child(button)
		button.print_info()


func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://scenes/main_screen/main_screen.tscn")
