extends Control

func _ready():
	# Load button scene
	var button = preload("res://scenes/direction_button.tscn")

	# Add button to the VBoxContainer
	%HBoxContainer.add_child(button.instantiate())

func load_buttons(path_commands_answer: Array):
	var button = preload("res://scenes/direction_button.tscn")
	
	for i in range(path_commands_answer.size()):
		var button_instance = button.instance()
		button_instance.set_text(path_commands_answer[i])
		%HBoxContainer.add_child(button_instance)
