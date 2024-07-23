extends Control
class_name DirectionButton

# Create a property to store the direction of the button with a setter being set_btn_direction
var button_direction: PathProcessor.MOVES = PathProcessor.MOVES.RIGHT:
	set(value):
		button_direction = value
		%Seta.rotation_degrees = 90 * (value - 1)

var enabled: bool = true

static var button_index_label: int = 1

static func reset_labels_count():
	button_index_label = 1

func _ready():
	%Seta.pivot_offset = Vector2( %Seta.size.x / 2, %Seta.size.y / 2)
	%IndexLabel.text = str(button_index_label)
	button_index_label += 1

func _on_seta_pressed():
	if enabled:
		%Seta.rotation_degrees += 90
		self.button_direction = (self.button_direction + 1) % PathProcessor.MOVES.size() as PathProcessor.MOVES

func set_color(color: Color):
	%ButtonBG.material.set_shader_parameter("color_rgb", color)
