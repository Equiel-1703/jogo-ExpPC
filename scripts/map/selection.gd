extends TileMapLayer
class_name SelectionMap

signal selection_started

var _mouse_coord: Vector2 = Vector2.ZERO
var _last_coord: Vector2 = Vector2.ZERO
var _prohibided_areas: Array = []

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

	if _map.grid_map.get_cell_tile_data(_mouse_coord) and not _is_prohibited_area():
		set_cell(_mouse_coord, Map.id_selection_tile, Vector2i(0,0), 0)
	else:
		if _map.active_selection_map.is_active_selection_map_enabled():
			_map.active_selection_map.abort_selection()
		return

	if Input.is_action_just_pressed("LeftClick"):
		selection_started.emit()

func process_prohibided_areas(areas: Array) -> void:
	for a in areas:
		var shape: Shape2D = (a as Area2D).get_child(0).shape
		var rect: Rect2 = shape.get_rect()
		rect.position = (a.get_child(0).global_position - (rect.size / 2))
		_prohibided_areas.append(rect)

func _is_prohibited_area() -> bool:
	var coord = get_global_mouse_position()

	for a in _prohibided_areas:
		if a.has_point(coord):
			return true
	return false

func set_selection_map_enabled(e: bool) -> void:
	visible = e
	set_process(e)

func set_erase_last_cell(e: bool) -> void:
	_erase_last_cell = e
