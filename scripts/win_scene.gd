extends Control

signal play_again

func _ready():
	self.visible = false

func _on_play_again_pressed():
	self.visible = false
	play_again.emit()
