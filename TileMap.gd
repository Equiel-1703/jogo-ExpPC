extends TileMap

const tile_size = 70

const map_w = 27
const map_h = 14

const layer_grid = 0
const layer_selection = 1
const id_grid_tile = 1
const id_selection_tile = 2

func _ready():
	for y in map_h:
		for x in map_w:
			set_cell(layer_grid, Vector2(x,y), id_grid_tile, Vector2.ZERO)

var line_from:Vector2 = Vector2.ZERO
var last_mouse_coord:Vector2 = Vector2.ZERO
var mouse_coord:Vector2 = Vector2.ZERO

func _process(_delta):
	erase_selection_map()
	
	mouse_coord = local_to_map(get_local_mouse_position())
	
	set_cell(layer_selection, mouse_coord, id_selection_tile, Vector2.ZERO)
	
	if Input.is_action_just_pressed("LeftClick"):
		line_from = map_to_local(mouse_coord)
		last_mouse_coord = line_from
		%PathLine.add_point(line_from)
	
	if Input.is_action_pressed("LeftClick"):
		mouse_coord = map_to_local(mouse_coord)

		if mouse_coord != last_mouse_coord:
			var x_diff = mouse_coord.x - last_mouse_coord.x
			var y_diff = mouse_coord.y - last_mouse_coord.y

			# Detecting diagonal movement
			if abs(x_diff) == tile_size and abs(y_diff) == tile_size:
				# Now we need to add a point in the middle of the two points
				var middle_point:Vector2 = mouse_coord
				if x_diff > 0:
					middle_point.x -= tile_size
				else:
					middle_point.x += tile_size

				%PathLine.add_point(middle_point)

			%PathLine.add_point(mouse_coord)
			last_mouse_coord = mouse_coord

func erase_selection_map():
	for y in map_h:
		for x in map_w:
			erase_cell(layer_selection, Vector2(x, y))
