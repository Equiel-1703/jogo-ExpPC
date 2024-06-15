extends Control
class_name CriarPath

signal player_path_done(player_path_answer: Array)
signal player_path_cancelled()

@export var phases_manager: PhasesManager

var _direction_button: PackedScene
var _new_path_len: int
var _path_colors: Array

func _ready():
	# Load _direction_button scene
	_direction_button = preload ("res://scenes/level_1/direction_button.tscn")
	
	# Hide the menu
	self.visible = false

func _load_buttons():
	DirectionButton.reset_labels_count()

	# Let's create the buttons for the already set answers
	var last_answers = phases_manager.get_player_answers()

	# Iterate over last answers
	for i in range(last_answers.size()):
		var answer = last_answers[i]

		# Check if there are no more answers
		if not answer:
			break

		var current_color = _path_colors[i]

		# Iterate over the directions
		for j in range(answer.size()):
			var direction = answer[j]
			var button = _direction_button.instantiate()
			button.button_direction = direction
			button.set_color(current_color)
			%PathButtons.add_child(button)

	# Create the buttons for the new path
	var new_path_color = _path_colors.back()

	for i in range(_new_path_len):
		var button = _direction_button.instantiate()
		button.set_color(new_path_color)
		%PathButtons.add_child(button)

func _clear_buttons():
	for child in %PathButtons.get_children():
		child.queue_free()

func _on_ok_pressed():
	self.visible = false

	var last_answers = phases_manager.get_player_answers()
	var player_path = []

	# Update last answers
	for i in range(last_answers.size()):
		var answer = last_answers[i]

		# Check if there are no more answers
		if not answer:
			break
		
		player_path.clear()
		
		# Now we will cycle trough the buttons and get the directions
		for dir in answer.size():
			var button = %PathButtons.get_child(0)
			var direction = button.button_direction
			player_path.append(direction)
			button.free()
		
		# Set the player path to the phases manager correct index
		phases_manager.set_player_answer_at(player_path, i)

		# Print the player path for debug
		print("CriarPath> Updated player path ", i, ":")
		PathProcessor.print_moves(player_path)

	# Now we will get the new path
	player_path.clear()

	for i in range(_new_path_len):
		var button = %PathButtons.get_child(0)
		var direction = button.button_direction
		player_path.append(direction)
		button.free()

	# Clear the buttons
	# _clear_buttons()

	# Print the player path for debug
	print("CriarPath> New player path:")
	PathProcessor.print_moves(player_path)
	
	# Emit the path done signal with the player path
	player_path_done.emit(player_path)

var label_2: String = "Ver menu"
var temp: String

func _on_ver_mapa_pressed():
	# Swap VerMapa button label
	temp = %VerMapa.text
	%VerMapa.text = label_2
	label_2 = temp

	# VerMapa not in focus
	%VerMapa.focus_mode = Control.FOCUS_NONE

	# Set the gradient background visible and the normal background invisible
	%BG.visible = ! %BG.visible
	%GradientBG.visible = ! %GradientBG.visible
	
	if GlobalGameData.tutorial_phase:
		# Hide instruction label
		%InstructionLabel.visible = ! %InstructionLabel.visible

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

func show_path_menu(new_path_lenght: int, path_color: Color):
	_new_path_len = new_path_lenght
	_path_colors.append(path_color)

	# Hide gradient background and set the normal background visible
	%GradientBG.visible = false
	%BG.visible = true

	# Show instruction label if we are in the tutorial phase
	%InstructionLabel.visible = GlobalGameData.tutorial_phase

	_load_buttons()
	self.visible = true
