extends Control

signal play_again

func _ready():
	#self.visible = false
	pass

func _on_next_phase_pressed():
	self.visible = false
	%Level1PhasesManager.show_next_phase()

func _on_play_again_pressed():
	self.visible = false
	play_again.emit()
