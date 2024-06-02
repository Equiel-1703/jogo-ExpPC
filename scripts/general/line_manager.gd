extends Node
class_name LineManager

signal all_lines_looped

@export var base_line: Line2D
@export_range(1, 20) var num_of_lines: int = 1

var _array_of_lines: Array = []
var _active_index: int = 0

func _ready():
	if !base_line:
		printerr("Line Manager> base_line is not set.")
		get_tree().quit()
		return

	set_num_of_lines(num_of_lines)

# ------------------------- Private Methods -------------------------

## Creates a line with the properties of the base_line node and sets a random color.
func _create_line() -> Line2D:
	var line = base_line.duplicate()
	line.default_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	return line

# ------------------------- Public Methods -------------------------

## Remove all lines and clean array
func clear_lines():
	for line in _array_of_lines:
		line.queue_free()
	_array_of_lines.clear()

## Sets the number of lines to be displayed. If there was already lines set, they will be removed and replaced by the new lines.
func set_num_of_lines(value: int):
	num_of_lines = value

	clear_lines()

	# Create new lines and add them to the array
	for i in range(num_of_lines):
		var line = _create_line()
		# Add as child of LineManager node (this node)
		add_child(line)
		# Add to array
		_array_of_lines.append(line)

## Returns the active selected line of the internal array.
func get_active_line() -> Line2D:
	return _array_of_lines[_active_index]

## Will set the index to the next line in the array. If we were in the last line, the signal all_lines_looped will be emitted and the active index will reset to 0.
func go_to_next_line():
	if _active_index == _array_of_lines.size() - 1:
		# We have looped all lines (visited all lines)
		all_lines_looped.emit()

	_active_index = (_active_index + 1) % _array_of_lines.size()
