extends Node2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var line = $LineManager.get_active_line()
		print(line.default_color)
		_add_random_points(line)


		$LineManager.go_to_next_line()

func _add_random_points(line: Line2D):
	for i in range(randi_range(3, 10)):
		var x = randi_range(0, int(GlobalGameData.WINDOW_SIZE.x))
		var y = randi_range(0, int(GlobalGameData.WINDOW_SIZE.y))
		line.add_point(Vector2(x, y))
