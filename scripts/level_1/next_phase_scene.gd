extends Control

signal play_again

func _ready():
	self.visible = false

func show_destination(planet_name: String):
	self.visible = true
	%NomePlaneta.text = planet_name

func _on_ok_pressed():
	self.visible = false
	play_again.emit()
