extends NextPhaseBase

func _ready():
	_message = "[center]Retorne para {0} invertendo a última rota que você criou.[/center]"
	_destino_text = "Volte para "

	self.visible = false

func show_destination(instructions_visible: bool = true):
	# Set texts
	_label_instrucoes.text = _message.format([GlobalGameData.destination_planet_name])
	_label_destino.text = _destino_text

	# Show instruction label if we are in the tutorial phase
	_container_instrucoes.visible = instructions_visible
	_label_planeta.text = GlobalGameData.destination_planet_name

	self.visible = true

func _on_ok_pressed():
	self.visible = false

	play_reverse.emit()
