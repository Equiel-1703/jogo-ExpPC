extends TileMap

signal path_set(path_answer: Array, start_coord: Vector2)

var _tile_size: int

var _map_w_tiles: int
var _map_h_tiles: int

const _layer_grid = 0
const _layer_selection = 1
const _layer_active_selection = 2

const _id_grid_tile = 1
const _id_selection_tile = 2
const _id_active_selection_tile = 3

var _draw_state: bool = false
var _movement_enabled: bool = true
var _can_erase: bool = true

var _path_commands_answer: Array = []

var _mouse_coord: Vector2 = Vector2.ZERO
var _last_mouse_coord: Vector2 = Vector2.ZERO
var _line_from: Vector2 = Vector2.ZERO

func _ready():
	# Getting the tile size
	_tile_size = int(GlobalGameData.MAP_TILE_SIZE.x)

	# Setting the tile size
	tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE

	# Setting number of map tiles
	_map_w_tiles = int(GlobalGameData.WINDOW_SIZE.x / _tile_size)
	_map_h_tiles = int(GlobalGameData.WINDOW_SIZE.y / _tile_size)

	print("Map size: ", _map_w_tiles, "x", _map_h_tiles)

func _process(_delta):
	if not _draw_state and _can_erase:
		_erase_selection_map()
	
	if not _movement_enabled:
		return
	
	_mouse_coord = local_to_map(get_local_mouse_position())
	
	if get_cell_source_id(_layer_grid, _mouse_coord) == _id_grid_tile:
		set_cell(_layer_selection, _mouse_coord, _id_selection_tile, Vector2.ZERO)
	else:
		return
	
	if Input.is_action_just_pressed("LeftClick"):
		_draw_state = true
		# Mark on map origin point
		set_cell(_layer_active_selection, _mouse_coord, _id_active_selection_tile, Vector2.ZERO)

		# Clear line and path commands answer
		%PathLine.clear_points()
		_path_commands_answer.clear()

		# Add the first point to the path line
		_line_from = map_to_local(_mouse_coord)
		_last_mouse_coord = _line_from
		%PathLine.add_point(_line_from)
	
	if Input.is_action_pressed("LeftClick") and _draw_state:
		_mouse_coord = map_to_local(_mouse_coord)

		if _mouse_coord != _last_mouse_coord:
			var x_diff = _mouse_coord.x - _last_mouse_coord.x
			var y_diff = _mouse_coord.y - _last_mouse_coord.y

			print("x_diff: ", x_diff, " y_diff: ", y_diff)

			# Detecting vertical movement missing (drag mouse too fast)
			if abs(y_diff) > _tile_size:
				print("Vertical movement detected")
				var steps: int = abs(y_diff) / _tile_size
				var middle_point: Vector2

				for i in range(steps):
					var new_y = _last_mouse_coord.y + (_tile_size if y_diff > 0 else - _tile_size)
					var new_x = _last_mouse_coord.x
					middle_point = Vector2(new_x, new_y)
					# Add the new point to the path commands
					_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
					# Add the new point to the path line
					%PathLine.add_point(middle_point)
					# Update the last mouse coord
					_last_mouse_coord = middle_point

			# Detecting horizontal movement missing (drag mouse too fast)
			if abs(x_diff) > _tile_size:
				print("Horizontal movement detected")
				var steps: int = abs(x_diff) / _tile_size
				var middle_point: Vector2

				for i in range(steps):
					var new_x = _last_mouse_coord.x + (_tile_size if x_diff > 0 else - _tile_size)
					var new_y = _last_mouse_coord.y
					middle_point = Vector2(new_x, new_y)
					# Add the new point to the path commands
					_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
					# Add the new point to the path line
					%PathLine.add_point(middle_point)
					# Update the last mouse coord
					_last_mouse_coord = middle_point
			
			# Detecting diagonal movement
			if abs(x_diff) == _tile_size and abs(y_diff) == _tile_size:
				print("Diagonal movement detected")
				# Now we need to add a point in the middle of the two points
				var middle_point: Vector2 = _mouse_coord
				if x_diff > 0:
					middle_point.x -= _tile_size
				else:
					middle_point.x += _tile_size

				# Add the middle point to the path commands
				_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, middle_point))
				# Add the middle point to the path line
				%PathLine.add_point(middle_point)
				# Add the last point (mouse coord) to the path commands
				_path_commands_answer.append(PathProcessor.determine_direction(middle_point, _mouse_coord))
				# Add the last point (mouse coord) to the path line
				%PathLine.add_point(_mouse_coord)
				# Update the last mouse coord
				_last_mouse_coord = _mouse_coord

			# Single point movement
			elif abs(x_diff) == _tile_size or abs(y_diff) == _tile_size:
				print("Single point movement detected")
				# Add the new point to the path commands
				_path_commands_answer.append(PathProcessor.determine_direction(_last_mouse_coord, _mouse_coord))
				# Add the new point to the path line
				%PathLine.add_point(_mouse_coord)
				# Update the last mouse coord
				_last_mouse_coord = _mouse_coord
	
	if Input.is_action_just_released("LeftClick") and _draw_state:
		# For debugging purposes
		print("LeftClick released")
		
		# Finished drawing
		_draw_state = false

		# Single click with no movement
		if _path_commands_answer.size() <= 0:
			return

		# For debugging purposes
		print("+ Answer: ")
		PathProcessor.print_moves(_path_commands_answer)
		
		# Emit the signal with the path answer
		path_set.emit(_path_commands_answer, _line_from)

func _erase_selection_map():
	for y in _map_h_tiles:
		for x in _map_w_tiles:
			erase_cell(_layer_selection, Vector2(x, y))
			erase_cell(_layer_active_selection, Vector2(x, y))

func disable_map():
	_draw_state = false
	_can_erase = false
	_movement_enabled = false

func enable_map():
	_draw_state = false
	_can_erase = true
	_movement_enabled = true
