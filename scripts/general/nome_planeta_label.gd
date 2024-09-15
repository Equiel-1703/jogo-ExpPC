extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = GlobalGameData.destination_planet_name
