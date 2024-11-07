extends Control

signal level_num_finished

@export var level_num: int = 1
@export var time_visible: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

func show_level_num():
	%LevelText.text = "Nível " + str(level_num)
	$Timer.wait_time = time_visible

	self.visible = true
	$AnimationPlayer.play("entrance")
	await $AnimationPlayer.animation_finished
	$Timer.start()
	await $Timer.timeout
	$AnimationPlayer.play("exit")
	level_num_finished.emit()
