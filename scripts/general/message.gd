extends Control

@export var time_visible: float = 1.0

func show_message(text: String):
	$AnimationPlayer.stop()
	$Message.text = text
	self.visible = true
	$Timer.start()

func _on_timer_timeout():
	$AnimationPlayer.play()

func _ready():
	$Timer.wait_time = time_visible
	$AnimationPlayer.current_animation = "fade_out"
	self.visible = false
