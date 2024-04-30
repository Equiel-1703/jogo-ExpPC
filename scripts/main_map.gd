extends TileMap

@export var tile_size:int = 70

const map_w = 27
const map_h = 14

const layer_grid = 0
const layer_selection = 1
const layer_active_selection = 2

const id_grid_tile = 1
const id_selection_tile = 2
const id_active_selection_tile = 3

var draw_state: bool = false
var movement_enabled: bool = true
var path_commands_answer: Array = []
var player_won: bool = false

func _ready():
	self.tile_set.tile_size = Vector2(tile_size, tile_size)
	
	for y in map_h:
		for x in map_w:
			set_cell(layer_grid, Vector2(x, y), id_grid_tile, Vector2.ZERO)
	
	# Connect Rocket signal
	%Rocket.move_completed.connect(_on_move_completed)
	# Connect CriarPath signal
	%CriarPath.player_path_done.connect(_on_player_path_done)
	# Connect WinScene and LoseScene signals
	%WinScene.play_again.connect(_on_play_again)
	%LoseScene.play_again.connect(_on_play_again)

var mouse_coord: Vector2 = Vector2.ZERO
var last_mouse_coord: Vector2 = Vector2.ZERO
var line_from: Vector2 = Vector2.ZERO

func _process(_delta):
	if not draw_state:
		erase_selection_map()
	
	if not movement_enabled:
		return
	
	mouse_coord = local_to_map(get_local_mouse_position())
	
	set_cell(layer_selection, mouse_coord, id_selection_tile, Vector2.ZERO)
	
	if Input.is_action_just_pressed("LeftClick"):
		draw_state = true
		# Mark on map origin point
		set_cell(layer_active_selection, mouse_coord, id_active_selection_tile, Vector2.ZERO)
		%PathLine.clear_points()
		path_commands_answer.clear()

		line_from = map_to_local(mouse_coord)
		last_mouse_coord = line_from
		%PathLine.add_point(line_from)
	
	if Input.is_action_pressed("LeftClick"):
		mouse_coord = map_to_local(mouse_coord)

		if mouse_coord != last_mouse_coord:
			var x_diff = mouse_coord.x - last_mouse_coord.x
			var y_diff = mouse_coord.y - last_mouse_coord.y

			print("x_diff: ", x_diff, " y_diff: ", y_diff)

			# Detecting vertical movement missing (drag mouse too fast)
			if abs(y_diff) > tile_size:
				print("Vertical movement detected")
				var steps:int = abs(y_diff) / tile_size
				var middle_point: Vector2

				for i in range(steps):
					var new_y = last_mouse_coord.y + (tile_size if y_diff > 0 else -tile_size)
					var new_x = last_mouse_coord.x
					middle_point = Vector2(new_x, new_y)
					# Add the new point to the path commands
					path_commands_answer.append(PathProcessor.determine_direction(last_mouse_coord, middle_point))
					# Add the new point to the path line
					%PathLine.add_point(middle_point)
					# Update the last mouse coord
					last_mouse_coord = middle_point

			# Detecting horizontal movement missing (drag mouse too fast)
			if abs(x_diff) > tile_size:
				print("Horizontal movement detected")
				var steps:int = abs(x_diff) / tile_size
				var middle_point: Vector2

				for i in range(steps):
					var new_x = last_mouse_coord.x + (tile_size if x_diff > 0 else -tile_size)
					var new_y = last_mouse_coord.y
					middle_point = Vector2(new_x, new_y)
					# Add the new point to the path commands
					path_commands_answer.append(PathProcessor.determine_direction(last_mouse_coord, middle_point))
					# Add the new point to the path line
					%PathLine.add_point(middle_point)
					# Update the last mouse coord
					last_mouse_coord = middle_point
			
			# Detecting diagonal movement
			if abs(x_diff) == tile_size and abs(y_diff) == tile_size:
				print("Diagonal movement detected")
				# Now we need to add a point in the middle of the two points
				var middle_point: Vector2 = mouse_coord
				if x_diff > 0:
					middle_point.x -= tile_size
				else:
					middle_point.x += tile_size

				# Add the middle point to the path commands
				path_commands_answer.append(PathProcessor.determine_direction(last_mouse_coord, middle_point))
				# Add the middle point to the path line
				%PathLine.add_point(middle_point)
				# Add the last point (mouse coord) to the path commands
				path_commands_answer.append(PathProcessor.determine_direction(middle_point, mouse_coord))
				# Add the last point (mouse coord) to the path line
				%PathLine.add_point(mouse_coord)
				# Update the last mouse coord
				last_mouse_coord = mouse_coord

			# Single point movement
			elif abs(x_diff) == tile_size or abs(y_diff) == tile_size:
				print("Single point movement detected")
				# Add the new point to the path commands
				path_commands_answer.append(PathProcessor.determine_direction(last_mouse_coord, mouse_coord))
				# Add the new point to the path line
				%PathLine.add_point(mouse_coord)
				# Update the last mouse coord
				last_mouse_coord = mouse_coord
	
func _input(event):
	if event.is_action_released("LeftClick"):
		print("LeftClick released")
		draw_state = false
		movement_enabled = false

		print("+ Answer: ")
		PathProcessor.print_moves(path_commands_answer)
		
		%CriarPath.show_path_menu(path_commands_answer)
		set_process_input(false)

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(answer):
	# For debugging purposes only
	print("Player answer: " + str(answer))
	print("Correct answer: " + str(path_commands_answer))

	if answer == path_commands_answer:
		print("CORRETO")
		player_won = true
	else:
		print("ERRADO")
		player_won = false

	%Rocket.set_start_position(line_from)
	%Rocket.execute_move_commands(answer.duplicate())

# Emmited by the Rocket node
func _on_move_completed():
	if player_won:
		%WinScene.visible = true
	else:
		%LoseScene.visible = true

# Emmited by the WinScene and LoseScene nodes
func _on_play_again():
	movement_enabled = true

	%PathLine.clear_points()
	%Rocket.visible = false

	# Enable input processing again
	set_process_input(true)

func erase_selection_map():
	for y in map_h:
		for x in map_w:
			erase_cell(layer_selection, Vector2(x, y))
			erase_cell(layer_active_selection, Vector2(x, y))
