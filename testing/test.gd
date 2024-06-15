extends Node2D

@onready var _button = $DirectionButton

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_yellow_pressed():
	_button.set_color(Color.YELLOW)


func _on_blue_pressed():
	_button.set_color(Color.BLUE)


func _on_red_pressed():
	_button.set_color(Color.RED)


func _on_green_pressed():
	_button.set_color(Color.GREEN)
