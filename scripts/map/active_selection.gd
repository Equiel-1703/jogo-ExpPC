extends TileMapLayer
class_name ActiveSelectionMap

var _path_commands_answer: Array = []

var _map: Map
var _line: Line2D
var tile_size: int

var _mouse_coord: Vector2 = Vector2.ZERO
var _last_mouse_coord: Vector2 = Vector2.ZERO

var _start_coord: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_active_selection_map_enabled(false)

	_map = get_parent()

	await _map.ready

	tile_size = _map.tile_size

func _process(_delta: float) -> void:
	_mouse_coord = local_to_map(get_local_mouse_position()) # Map mouse coord
	_mouse_coord = map_to_local(_mouse_coord) # Local mouse coord (centered in the cell)

	if Input.is_action_pressed("LeftClick"):
		# If there is no movement, we do not need to do anything
		if _mouse_coord == _last_mouse_coord:
			return
		
		# Calculate difference between the last mouse coord and the current mouse coord
		var x_diff = _mouse_coord.x - _last_mouse_coord.x
		var y_diff = _mouse_coord.y - _last_mouse_coord.y

		# Detecting vertical movement missing (mouse was dragged too fast)
		if abs(y_diff) > tile_size:
			var steps: int = abs(y_diff) / tile_size
			var middle_point: Vector2

			for i in range(steps):
				var new_y = _last_mouse_coord.y + (tile_size if y_diff > 0 else - tile_size)
				var new_x = _last_mouse_coord.x
				middle_point = Vector2(new_x, new_y)
				# Add the new point to the path commands
				_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
				# Add missing tile to the selection map
				_map.selection_map.set_cell(local_to_map(middle_point), Map.id_selection_tile, Vector2i(0,0), 0)
				# Add the new point to the path line
				_line.add_point(middle_point)
				# Update the last mouse coord
				_last_mouse_coord = middle_point

		# Detecting horizontal movement missing (drag mouse too fast)
		if abs(x_diff) > tile_size:
			# print("Horizontal movement detected")
			var steps: int = abs(x_diff) / tile_size
			var middle_point: Vector2

			for i in range(steps):
				var new_x = _last_mouse_coord.x + (tile_size if x_diff > 0 else - tile_size)
				var new_y = _last_mouse_coord.y
				middle_point = Vector2(new_x, new_y)
				# Add the new point to the path commands
				_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
				# Add missing tile to the selection map
				_map.selection_map.set_cell(local_to_map(middle_point), Map.id_selection_tile, Vector2i(0,0), 0)
				# Add the new point to the path line
				_line.add_point(middle_point)
				# Update the last mouse coord
				_last_mouse_coord = middle_point
		
		# Detecting diagonal movement
		if abs(x_diff) == tile_size and abs(y_diff) == tile_size:
			# Now we need to add a point in the middle of the two points
			var middle_point: Vector2 = _mouse_coord
			if x_diff > 0:
				middle_point.x -= tile_size
			else:
				middle_point.x += tile_size

			# Add the middle point to the path commands
			_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
			# Add the middle point to the path line
			_line.add_point(middle_point)
			# Add missing tile to the selection map
			_map.selection_map.set_cell(local_to_map(middle_point), Map.id_selection_tile, Vector2i(0,0), 0)

			# Add the last point (mouse coord) to the path commands
			_path_commands_answer.append(PathProcessor.determine_direction(middle_point, _mouse_coord))
			# Add the last point (mouse coord) to the path line
			_line.add_point(_mouse_coord)

			# Update the last mouse coord
			_last_mouse_coord = _mouse_coord

		# Single point movement
		elif abs(x_diff) == tile_size or abs(y_diff) == tile_size:
			# Add the new point to the path commands
			_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, _mouse_coord))
			# Add the new point to the path line
			_line.add_point(_mouse_coord)
			# Update the last mouse coord
			_last_mouse_coord = _mouse_coord
	
	if Input.is_action_just_released("LeftClick"):
		# Single click with no movement
		if _path_commands_answer.size() <= 0 or not GlobalGameData.is_valid_planet_coord(_map.local_to_map(_last_mouse_coord)):
			_map.clear_active_line()
			leave_active_selection_map()
			return

		# For debugging purposes
		print("Map> Answer: ")
		PathProcessor.print_moves(_path_commands_answer)
		
		leave_active_selection_map()

		# Emit the signal with the path answer
		_map.path_set.emit(_path_commands_answer, _start_coord, _last_mouse_coord)

# Here the selection will start and the active selection map will be enabled
func _on_selection_started() -> void:
	# Clear all the cells
	clear()

	# Get line from the map
	_line = await _map.get_line()
	_line.clear_points()
	_path_commands_answer.clear()

	# Get the mouse coord and mark the start of the path
	_mouse_coord = local_to_map(get_local_mouse_position()) # Map mouse coord
	set_cell(_mouse_coord, Map.id_active_selection_tile, Vector2i(0,0), 0)

	# Add the first point to the path line
	_start_coord = map_to_local(_mouse_coord) # Local mouse coord (centered in the cell)
	_last_mouse_coord = _start_coord
	_line.add_point(_start_coord)

	# Disable erase last cell in selection layer (yellow trail)
	_map.selection_map.set_erase_last_cell(false)

	# Enable itself
	set_active_selection_map_enabled(true)

func set_active_selection_map_enabled(e: bool):
	visible = e
	set_process(e)

func is_active_selection_map_enabled():
	return visible

func leave_active_selection_map():
	# Let's clear the yellow selection
	_map.selection_map.clear()
	# Enable erase last cell in selection layer (disable yellow trail)
	_map.selection_map.set_erase_last_cell(true)
	# Disable itself
	set_active_selection_map_enabled(false)

func abort_selection():
	_line.clear_points()
	leave_active_selection_map()
