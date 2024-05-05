extends Control

signal player_path_done(player_path_answer: Array)
signal player_path_cancelled()

var _direction_button: PackedScene
var _path_commands_answer: Array

func _ready():
	# Load _direction_button scene
	_direction_button = preload ("res://scenes/direction_button.tscn")

	# Hide gradient background and set the normal background visible
	%GradientBG.visible = false
	%BG.visible = true
	
	# Hide the menu
	self.visible = false

	# # make test answer array (for debug purposes only)
	# _path_commands_answer = [PathProcessor.MOVES.UP, PathProcessor.MOVES.RIGHT, PathProcessor.MOVES.DOWN, PathProcessor.MOVES.LEFT]
	# show_path_menu(_path_commands_answer)

func _load_buttons():
	for i in range(_path_commands_answer.size()):
		%PathButtons.add_child(_direction_button.instantiate())

func _clear_buttons():
	for child in %PathButtons.get_children():
		child.queue_free()

func show_path_menu(answer: Array):
	_path_commands_answer = answer

	_load_buttons()
	self.visible = true

func _on_ok_pressed():
	self.visible = false

	# Get the player path from the buttons
	var player_path = []
	for child in %PathButtons.get_children():
		player_path.append(child.button_direction)

	# Clear the buttons
	_clear_buttons()

	# Print the player path for debug
	print("+ Player path:")
	PathProcessor.print_moves(player_path)
	
	# Emit the path done signal with the player path
	player_path_done.emit(player_path)

func _on_ver_mapa_pressed():
	# Set the gradient background visible and the normal background invisible
	%BG.visible = ! %BG.visible
	%GradientBG.visible = ! %GradientBG.visible
	
	# Hide path buttons
	%PathButtons.visible = ! %PathButtons.visible

	# Hide unused buttons
	%Ok.visible = ! %Ok.visible
	%Cancelar.visible = ! %Cancelar.visible

func _on_cancelar_pressed():
	self.visible = false

	# Clear the buttons
	_clear_buttons()
	
	print("x Player cancelled path selection x")

	player_path_cancelled.emit()
