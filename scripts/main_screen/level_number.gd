extends Control

var _button_num: int = 0
var _visible_rec: Rect2

# Preset colors
const DARK_DARK_BLUE: Color = Color(0.004, 0.016, 0.082)
const DARK_BLUE: Color = Color(0, 0.086, 0.173)
const LIGHT_BLUE: Color = Color(0, 0.42, 0.84)
const LIGHT_LIGHT_BLUE: Color = Color(0.58, 0.97, 0.96)

func _ready():
	# Save visible rectangle
	_visible_rec = $rec.get_rect()
	# Set to default initial color
	set_rec_color(DARK_DARK_BLUE)
	
func _process(_delta):
	if _visible_rec.has_point(get_local_mouse_position()):
		# Set the rec to dark blue if mouse is over
		set_rec_color(DARK_BLUE)
	else:
		if GlobalGameData.start_level_index == _button_num - 1:
			# Set the rec to light blue if mouse is not over and this is the level selected to the game to start
			set_rec_color(LIGHT_BLUE)
		else:
			# Set the rec to dark dark blue if mouse is not over
			set_rec_color(DARK_DARK_BLUE)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		set_process(false)
		if event.is_pressed():
			if _visible_rec.has_point(get_local_mouse_position()):
				# Set the rec to light light blue is clicked
				set_rec_color(LIGHT_LIGHT_BLUE)
				
				# Update global variables
				GlobalGameData.set_start_level_by_index(_button_num - 1) # Button nums are 1-based and indexes are 0-based
		else:
			# Mouse button released
			set_process(true)

func set_rec_color(color: Color):
	$rec.material.set_shader_parameter("color_rgb", color)

func set_button_num(num: int):
	_button_num = num
	$num.text = str(num)

func print_info():
	print("Button num: ", _button_num)
	print("Visible rec: ", $rec.get_rect())
	print("Position: ", position)
