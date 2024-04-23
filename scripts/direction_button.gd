extends TextureButton

@export var path_direction: PathProcessor.MOVES = PathProcessor.MOVES.RIGHT

func _ready():
	self.pivot_offset = Vector2(self.size.x / 2, self.size.y / 2)

func _on_pressed():
	self.rotation_degrees += 90
	self.path_direction = (self.path_direction + 1) % PathProcessor.MOVES.size() as PathProcessor.MOVES
	PathProcessor.print_move(self.path_direction)
