extends Control
class_name DirectionButton

@export var button_direction: PathProcessor.MOVES = PathProcessor.MOVES.RIGHT
static var button_index_label: int = 1

func _ready():
	%DirectionButton.pivot_offset = Vector2( %DirectionButton.size.x / 2, %DirectionButton.size.y / 2)
	%IndexLabel.text = str(self.button_index_label)
	self.button_index_label += 1

func _on_pressed():
	%DirectionButton.rotation_degrees += 90
	self.button_direction = (self.button_direction + 1) % PathProcessor.MOVES.size() as PathProcessor.MOVES

static func reset_labels_count():
	button_index_label = 1
