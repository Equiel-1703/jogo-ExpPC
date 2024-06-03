extends Node2D

func _ready():
	var file_path: String = "res://levels_json/level_1.json"

	var level = LevelLoader.load_level(file_path)

	print(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
