extends Control

@export var levels_table_path: String

var levels_selection_screen: PackedScene
var student_name_screen: PackedScene

func _ready():
	levels_selection_screen = preload("res://scenes/main_screen/niveis_screen.tscn")
	student_name_screen = preload("res://scenes/general/student_name.tscn")

	# Loading levels table
	GlobalGameData.levels_table = JsonLoader.load_json_file(levels_table_path)

	if not (GlobalGameData.levels_table is Array):
		printerr("MainScreen> Error loading levels.json: it is not an Array.")
		get_tree().quit()
	
	# Loading first level scene
	GlobalGameData.start_level_scene = load(GlobalGameData.levels_table[0]["scene_path"])
	
	# Printing levels table
	for item in GlobalGameData.levels_table:
		print("Level no: ", item["level_no"])
		print("Scene path: ", item["scene_path"])

func _on_jogar_pressed():
	get_tree().change_scene_to_packed(student_name_screen)

func _on_sair_pressed():
	get_tree().quit()

func _on_niveis_pressed():
	get_tree().change_scene_to_packed(levels_selection_screen)
