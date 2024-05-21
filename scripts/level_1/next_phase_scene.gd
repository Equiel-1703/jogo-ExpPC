extends Control

signal play_again

@onready var _label_planeta = $Content/DestContainer/NomePlaneta
@onready var _label_instrucoes = $Content/CenterContainer/Instrucoes

var _message_default = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem.[/center]"
var _message_min_path = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem. [color=red]Faça o menor caminho possível.[/color][/center]"

func _ready():
	self.visible = false

func show_destination(planet_name: String):
	# Set text to default message
	_label_instrucoes.text = _message_default
	# Show instruction label if we are in the tutorial phase
	_label_instrucoes.visible = GlobalGameData.tutorial_phase
	_label_planeta.text = planet_name

	self.visible = true

func show_destination_min_path(planet_name: String):
	# Set text to min path message
	_label_instrucoes.text = _message_min_path
	# On min path, we always show the instruction label
	_label_instrucoes.visible = true
	_label_planeta.text = planet_name

	self.visible = true

func _on_ok_pressed():
	self.visible = false
	play_again.emit()
