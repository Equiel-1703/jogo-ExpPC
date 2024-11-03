extends Control
class_name CriarPathReverse

signal player_reverse_path_done(player_path_answer: Array, reverse_last_coord: Vector2)

@export var line_manager: LineManager

var _direction_button: PackedScene
var _last_path: Array
var _last_path_color: Color
var _new_path_color: Color

func _ready():
	if not line_manager:
		printerr("CriarPathReverse> Line manager is not set.")
		get_tree().quit()
		return

	# Load _direction_button scene
	_direction_button = preload ("res://scenes/general/direction_button.tscn")
	
	# Hide the menu
	self.visible = false

func _load_buttons():
	DirectionButton.reset_labels_count()

	# Let's create the buttons for the last path
	for dir in _last_path:
		var button = _direction_button.instantiate()
		button.enabled = false
		button.button_direction = dir
		button.set_color(_last_path_color)
		%OriginalPath.add_child(button)
	
	DirectionButton.reset_labels_count()	

	# Create the buttons for the new path
	for dir in _last_path:
		var button = _direction_button.instantiate()
		button.button_direction = dir
		button.set_color(_new_path_color)
		%PathButtons.add_child(button)

func _clear_buttons():
	for child in %PathButtons.get_children():
		child.queue_free()

	for child in %OriginalPath.get_children():
		child.queue_free()

func _on_ok_pressed():
	self.visible = false

	var player_path = []

	for i in range(_last_path.size()):
		var button = %PathButtons.get_child(0)
		var direction = button.button_direction
		player_path.append(direction)
		button.free()

	# Print the player path for debug
	print("CriarPathReversed> New player path:")
	PathProcessor.print_moves(player_path)
	
	# Add the moves to the line manager
	var reverse_last_coord = line_manager.add_moves_to_line(player_path)
	
	# Clear the buttons
	_clear_buttons()

	# Emit the path done signal with the player path
	player_reverse_path_done.emit(player_path, reverse_last_coord)

func _on_reset_pressed():
	print("x Player resetted reverse path creation x")

	# Reset the path buttons directions
	for i in _last_path.size():
		var button: DirectionButton = %PathButtons.get_child(i)
		button.button_direction = _last_path[i]

func show_reverse_path_menu(last_path: Array):
	_last_path = last_path
	_new_path_color = line_manager.get_active_line_color()
	_last_path_color = line_manager.get_last_line_color(1)

	# Hide gradient background and set the normal background visible
	%GradientBG.visible = false
	%BG.visible = true

	# Show instruction label if we are in the tutorial phase
	%InstructionLabel.visible = GlobalGameData.tutorial_phase_reverse

	# Clear buttons (if any)
	_clear_buttons()

	# Load the buttons
	_load_buttons()

	self.visible = true
