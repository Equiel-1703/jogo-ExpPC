extends Control

signal player_path_done(player_path: Array)

var direction_button: PackedScene
var path_commands_answer: Array

func _ready():
	# Load direction_button scene
	direction_button = preload("res://scenes/direction_button.tscn")

	# Hide the menu
	self.visible = false

	# # make test answer array (for debug purposes only)
	# path_commands_answer = [PathProcessor.MOVES.UP, PathProcessor.MOVES.RIGHT, PathProcessor.MOVES.DOWN, PathProcessor.MOVES.LEFT]
	# show_path_menu(path_commands_answer)

func _load_buttons():
	for i in range(path_commands_answer.size()):
		%PathButtons.add_child(direction_button.instantiate())

func show_path_menu(answer: Array):
	path_commands_answer = answer

	_load_buttons()
	self.visible = true

func _on_ok_pressed():
	self.visible = false

	var player_path = []
	for child in %PathButtons.get_children():
		var direction = child.button_direction
		player_path.append(direction)

	# Clear the buttons
	for child in %PathButtons.get_children():
		child.queue_free()
	
	self.visible = false
	
	print("+ Player path:")
	PathProcessor.print_moves(player_path)
	player_path_done.emit(player_path)

