extends Control
class_name CriarPath

signal player_path_done(player_path_answer: Array)
signal player_path_cancelled()

var _direction_button: PackedScene
var _path_lenght: int

func _ready():
	# Load _direction_button scene
	_direction_button = preload ("res://scenes/level_1/direction_button.tscn")
	
	# Hide the menu
	self.visible = false

func show_path_menu(path_lenght: int):
	_path_lenght = path_lenght

	# Hide gradient background and set the normal background visible
	%GradientBG.visible = false
	%BG.visible = true

	_load_buttons()
	self.visible = true

func _load_buttons():
	DirectionButton.reset_labels_count()
	for i in range(_path_lenght):
		%PathButtons.add_child(_direction_button.instantiate())

func _clear_buttons():
	for child in %PathButtons.get_children():
		child.queue_free()

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
