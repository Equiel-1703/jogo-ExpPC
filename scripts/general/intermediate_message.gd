extends Control

signal message_faded_out

@export var time_visible: float = 1.0

const _messages = [
	"Muito bem!",
	"Parabéns!",
	"Excelente!",
	"Ótimo!",
	"Perfeito!",
	"Maravilhoso!",
	"Fantástico!",
	"Espetacular!",
	"Extraordinário!",
	"Incrível!",
	"Brilhante!",
	"Supimpa!"
]

func show_message():
	$AnimationPlayer.stop()
	$Message.text = _messages.pick_random()
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
