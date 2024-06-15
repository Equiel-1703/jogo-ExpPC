extends Control

signal play

@onready var _label_planeta = $Content/DestContainer/NomePlaneta
@onready var _label_destino = $Content/DestContainer/Destino
@onready var _container_instrucoes = $Content/CenterContainer
@onready var _label_instrucoes = $Content/CenterContainer/Instrucoes

var _message_default = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem.[/center]"
var _message_min_path = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem. [color=red]Faça o menor caminho possível.[/color][/center]"

var _message_default_mp = "[center]Clique no final da última rota e arraste até o seu planeta de destino para traçar a rota de viagem.[/center]"
var _message_min_path_mp = "[center]Clique no final da última rota e arraste até o seu planeta de destino para traçar a rota de viagem. [color=red]Faça o menor caminho possível.[/color][/center]"

var _destino_text = "Seu destino é "
var _destino_text_mp = "Seu próximo destino é "

func _ready():
	self.visible = false

func show_destination(planet_name: String):
	# Set texts
	_label_instrucoes.text = _message_default if GlobalGameData.current_path == 0 else _message_default_mp
	_label_destino.text = _destino_text if GlobalGameData.current_path == 0 else _destino_text_mp

	# Show instruction label if we are in the tutorial phase
	_container_instrucoes.visible = GlobalGameData.tutorial_phase
	_label_planeta.text = planet_name

	self.visible = true

func show_destination_min_path(planet_name: String):
	# Set texts
	_label_instrucoes.text = _message_min_path if GlobalGameData.current_path == 0 else _message_min_path_mp
	_label_destino.text = _destino_text if GlobalGameData.current_path == 0 else _destino_text_mp

	# On min path, we always show the instruction label
	_container_instrucoes.visible = true
	_label_planeta.text = planet_name

	self.visible = true

func _on_ok_pressed():
	self.visible = false
	play.emit()
