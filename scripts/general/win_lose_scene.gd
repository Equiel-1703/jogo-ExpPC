extends Control

signal play_again
signal go_to_next_phase

func _ready():
	self.visible = false

# Only in win screen
func _on_next_phase_pressed():
	self.visible = false
	go_to_next_phase.emit()

# Only in lose screen
func _on_play_again_pressed():
	self.visible = false
	play_again.emit()

# Only for lose screen
func set_lose_screen_text(text: String):
	%LoseText.text = text
