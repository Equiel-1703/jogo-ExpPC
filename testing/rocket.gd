extends Sprite2D

const speed: float = 1

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += speed
