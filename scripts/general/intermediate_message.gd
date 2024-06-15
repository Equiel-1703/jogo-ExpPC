extends Control

signal message_faded_out

@export var time_visible: float = 1.0

const _messages_multiline = [
	"Vamos ver o próximo destino?",
	"Vejamos o proximo destino!",
	"Qual será o próximo destino?",
	"Vamos ver o que temos a seguir!",
	"Agora vamos ver o próximo destino!",
	"E o próximo destino é..."
]

const _messages_final = [
	"Lá vamos nós!",
	"Lançando foguete!",
	"Vamos decolar!",
	"O céu é o limite!",
	"Vamos voar!",
	"Ao infinito e além!"
]

func show_message():
	$AnimationPlayer.stop()
	$Message.text = _messages_multiline.pick_random() if GlobalGameData.current_path < GlobalGameData.no_of_paths else _messages_final.pick_random()
	self.visible = true
	$Timer.start()

func _on_timer_timeout():
	$AnimationPlayer.play()
	await $AnimationPlayer.animation_finished
	self.visible = false
	message_faded_out.emit()

func _ready():
	$Timer.wait_time = time_visible
	$AnimationPlayer.current_animation = "fade_out"
	self.visible = false
