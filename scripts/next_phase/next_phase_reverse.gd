extends NextPhaseBase

func _ready():
	_message = "[center]Retorne para {0} invertendo a última rota que você criou.[/center]"
	_destino_text = "Volte para "

	self.visible = false

func show_destination(planet_name: String):
	# Set texts
	_label_instrucoes.text = _message.format([planet_name])
	_label_destino.text = _destino_text

	# Show instruction label if we are in the tutorial phase
	_container_instrucoes.visible = GlobalGameData.tutorial_phase
	_label_planeta.text = planet_name

	self.visible = true

func _on_ok_pressed():
	self.visible = false

	play_reverse.emit()
