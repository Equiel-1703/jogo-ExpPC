extends Control

signal play_again

@onready var label_planeta = $DestinationContainer/NomePlaneta

func _ready():
	self.visible = false

func show_destination(planet_name: String):
	# Show instruction label if we are in the tutorial phase
	$CenterContainer/Instrucoes.visible = GlobalGameData.tutorial_phase
	
	# If we are not in the tutorial phase, reparent the destination container to be inside the instructions container
	if not GlobalGameData.tutorial_phase:
		$DestinationContainer.reparent($CenterContainer)
	
	label_planeta.text = planet_name
	self.visible = true

func _on_ok_pressed():
	self.visible = false
	play_again.emit()
