extends Control
class_name NextPhaseBase

signal play
signal play_reverse

# Nodes references
@onready var _label_planeta = $Content/DestContainer/NomePlaneta
@onready var _label_destino = $Content/DestContainer/Destino
@onready var _container_instrucoes = $Content/CenterContainer
@onready var _label_instrucoes = $Content/CenterContainer/Instrucoes

# Messages
var _message: String 
var _message_mp: String
var _destino_text: String
var _destino_text_mp: String

func _ready():
	_message = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem.[/center]"
	_message_mp = "[center]Clique no final da última rota e arraste até o seu planeta de destino para traçar a rota de viagem.[/center]"
	
	_destino_text = "Seu destino é "
	_destino_text_mp = "Seu próximo destino é "

	self.visible = false

func show_destination(instructions_visible: bool = true):
	# Set texts
	_label_instrucoes.text = _message if GlobalGameData.current_path == 1 else _message_mp
	_label_destino.text = _destino_text if GlobalGameData.current_path == 1 else _destino_text_mp

	# Show instruction label if we are in the tutorial phase
	_container_instrucoes.visible = instructions_visible

	_label_planeta.text = GlobalGameData.destination_planet_name

	self.visible = true

func _on_ok_pressed():
	self.visible = false

	play.emit()
