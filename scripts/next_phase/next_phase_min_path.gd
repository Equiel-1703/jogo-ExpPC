extends NextPhaseBase

func _ready():
	_message = "[center]Clique no foguete e arraste até o seu planeta de destino para traçar a rota de viagem. [color=red]Faça o menor caminho possível.[/color][/center]"
	_message_mp = "[center]Clique no final da última rota e arraste até o seu planeta de destino para traçar a rota de viagem. [color=red]Faça o menor caminho possível.[/color][/center]"

	_destino_text = "Seu destino é "
	_destino_text_mp = "Seu próximo destino é "

	self.visible = false
