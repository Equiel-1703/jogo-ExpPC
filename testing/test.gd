extends Node2D


func _ready():
	$LevelNum.show_level_num()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$LevelNum.show_level_num()
