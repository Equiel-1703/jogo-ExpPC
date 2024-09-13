extends TileMapLayer

signal selection_started

var _mouse_coord: Vector2 = Vector2.ZERO
var _map: Map

func _ready():
	set_selection_map_enabled(true)
	_map = get_parent()

func _process(_delta):
	erase_selection_map()

	_mouse_coord = local_to_map(get_local_mouse_position())

	if _map.grid_map.get_cell_tile_data(_mouse_coord):
		set_cell(_mouse_coord, Map.id_selection_tile, Vector2i(0,0), 0)

	if Input.is_action_just_pressed("LeftClick"):
		selection_started.emit()
		set_selection_map_enabled(false)

func erase_selection_map() -> void:
	for cell in get_used_cells():
		erase_cell(cell)

func set_selection_map_enabled(e: bool) -> void:
	visible = e
	set_process(e)
