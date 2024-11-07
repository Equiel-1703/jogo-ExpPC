extends Node2D
class_name Map

signal path_set(path_answer: Array, start_coord: Vector2, end_coord: Vector2)

var tile_size: int

var _map_w_tiles: int
var _map_h_tiles: int

@onready var grid_map: TileMapLayer = $Grid
@onready var selection_map: SelectionMap = $Selection
@onready var active_selection_map: ActiveSelectionMap = $ActiveSelection

const id_grid_tile = 1
const id_selection_tile = 2
const id_active_selection_tile = 3

@export var line_manager: LineManager
@export var prohibited_areas: Node2D

var _is_map_enabled: bool = true

func _ready():
	# Check if the user did not provide a line or a line manager
	if not line_manager:
		printerr("Map> You need to provide a Line2D or a LineManager node to the map!")
		get_tree().quit()
		return
	
	if prohibited_areas:
		_process_prohibited_areas()
	
	# Getting the tile size
	tile_size = int(GlobalGameData.MAP_TILE_SIZE.x)

	# Setting the tiles size on the maps
	grid_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE
	selection_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE
	active_selection_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE

	# Setting number of map tiles
	_map_w_tiles = int(GlobalGameData.WINDOW_SIZE.x / tile_size)
	_map_h_tiles = int(GlobalGameData.WINDOW_SIZE.y / tile_size)

	print("Map> Map size: ", _map_w_tiles, "x", _map_h_tiles)

func _process_prohibited_areas():
	var disabled_areas = prohibited_areas.get_children()
	selection_map.process_prohibided_areas(disabled_areas)

func get_line() -> Line2D:
	if not line_manager.is_node_ready(): await line_manager.ready
	return line_manager.get_active_line()

func get_last_line() -> Line2D:
	if not line_manager.is_node_ready(): await line_manager.ready
	return line_manager.get_last_line()

func disable_map():
	active_selection_map.set_active_selection_map_enabled(false)
	selection_map.set_selection_map_enabled(false)
	_is_map_enabled = false

func enable_map():
	selection_map.set_selection_map_enabled(true)
	_is_map_enabled = true

func is_enabled() -> bool:
	return _is_map_enabled

func clear_active_line():
	line_manager.get_active_line().clear_points()

func clear_last_line():
	(await get_last_line()).clear_points()

func clear_all_lines():
	line_manager.clear_all_lines()

func go_to_next_line():
	line_manager.go_to_next_line()

func go_to_previous_line():
	line_manager.go_to_previous_line()

func cancel_path():
	clear_active_line()

func map_to_local(coord: Vector2) -> Vector2:
	return grid_map.map_to_local(coord)

func local_to_map(coord: Vector2) -> Vector2:
	return grid_map.local_to_map(coord)

func convert_local_array_to_map(array: Array):
	var new_array: Array = []
	
	new_array.resize(array.size())

	for i in range(array.size()):
		new_array[i] = grid_map.local_to_map(array[i])

	return new_array
