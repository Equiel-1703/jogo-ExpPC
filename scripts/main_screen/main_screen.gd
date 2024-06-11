extends Control

@export var levels_table_path: String

var levels_selection_screen: PackedScene

func _ready():
	levels_selection_screen = preload("res://scenes/main_screen/niveis_screen.tscn")

	# Loading levels table
	GlobalGameData.levels_table = JsonLoader.load_json_file(levels_table_path)

	if not (GlobalGameData.levels_table is Array):
		printerr("MainScreen> Error loading levels.json: it is not an Array.")
		get_tree().quit()
	
	for item in GlobalGameData.levels_table:
		print("Level no: ", item["level_no"])
		print("Scene path: ", item["scene_path"])

func _on_jogar_pressed():
	get_tree().change_scene_to_file(GlobalGameData.levels_table[GlobalGameData.start_level_index]["scene_path"])

func _on_sair_pressed():
	get_tree().quit()

func _on_niveis_pressed():
	get_tree().change_scene_to_packed(levels_selection_screen)
