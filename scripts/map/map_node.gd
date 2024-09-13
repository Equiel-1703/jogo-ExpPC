extends Node2D
class_name Map

signal path_set(path_answer: Array, start_coord: Vector2, end_coord: Vector2)

var _tile_size: int

var _map_w_tiles: int
var _map_h_tiles: int

@onready var grid_map: TileMapLayer = $Grid
@onready var selection_map: TileMapLayer = $Selection
@onready var active_selection_map: TileMapLayer = $ActiveSelection

const id_grid_tile = 1
const id_selection_tile = 2
const id_active_selection_tile = 3

var _draw_state: bool = false
var _movement_enabled: bool = true
var _can_erase: bool = true

var _path_commands_answer: Array = []

var _mouse_coord: Vector2 = Vector2.ZERO
var _last_mouse_coord: Vector2 = Vector2.ZERO
var _line_from: Vector2 = Vector2.ZERO

@export var line : Line2D
@export var line_manager: LineManager

func _ready():
	# # Check if the user did not provide a line or a line manager
	# if not line and not line_manager:
	# 	printerr("Map> You need to provide a Line2D or a LineManager node to the map!")
	# 	get_tree().quit()
	# 	return
	
	# # Check if the user provided a line or a line manager, and await the ready signal
	# if line:
	# 	if not line.is_node_ready(): await line.ready
	# else:
	# 	# If the line was not provided, we get it from the line manager
	# 	if not line_manager.is_node_ready(): await line_manager.ready
	# 	line = line_manager.get_active_line()

	# Getting the tile size
	_tile_size = int(GlobalGameData.MAP_TILE_SIZE.x)

	# Setting the tiles size on the maps
	grid_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE
	selection_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE
	active_selection_map.tile_set.tile_size = GlobalGameData.MAP_TILE_SIZE

	# Setting number of map tiles
	_map_w_tiles = int(GlobalGameData.WINDOW_SIZE.x / _tile_size)
	_map_h_tiles = int(GlobalGameData.WINDOW_SIZE.y / _tile_size)

	print("Map> Map size: ", _map_w_tiles, "x", _map_h_tiles)
