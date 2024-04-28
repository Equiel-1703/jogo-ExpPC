extends TextureButton

@export var button_direction: PathProcessor.MOVES = PathProcessor.MOVES.RIGHT

func _ready():
	self.pivot_offset = Vector2(self.size.x / 2, self.size.y / 2)

func _on_pressed():
	self.rotation_degrees += 90
	self.button_direction = (self.button_direction + 1) % PathProcessor.MOVES.size() as PathProcessor.MOVES
	# Used for debugging
	# PathProcessor.print_move(self.button_direction)
