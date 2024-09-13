extends TileMapLayer
class_name SelectionMap

signal selection_started

var _mouse_coord: Vector2 = Vector2.ZERO
var _last_coord: Vector2 = Vector2.ZERO

var _map: Map

var _erase_last_cell: bool = true

func _ready():
	set_selection_map_enabled(false)
	
	_map = get_parent()

func _process(_delta):
	_mouse_coord = local_to_map(get_local_mouse_position())
	
	if _mouse_coord != _last_coord and _erase_last_cell:
		erase_cell(_last_coord)
	
	_last_coord = _mouse_coord

	if _map.grid_map.get_cell_tile_data(_mouse_coord):
		set_cell(_mouse_coord, Map.id_selection_tile, Vector2i(0,0), 0)
	else:
		return

	if Input.is_action_just_pressed("LeftClick"):
		selection_started.emit()

func set_selection_map_enabled(e: bool) -> void:
	visible = e
	set_process(e)

func set_erase_last_cell(e: bool) -> void:
	_erase_last_cell = e