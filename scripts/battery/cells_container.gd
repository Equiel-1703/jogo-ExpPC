extends HBoxContainer
class_name CellsContainer

@export var fill_animation_delay: float = 0.3

var _cells_container: HBoxContainer = self
var _cell_texture_on: Texture2D = preload("res://res/celula_bateria_cheia.png")
var _cell_texture_off: Texture2D = preload("res://res/celula_bateria_vazia.png")

const _battery_capacity: int = 10
var _battery_level: int = 0
var _fill_animation_timer: Timer

func _ready():
	_fill_animation_timer = Timer.new()
	_fill_animation_timer.set_wait_time(fill_animation_delay)
	_fill_animation_timer.set_one_shot(true)
	
	_cells_container.add_child(_fill_animation_timer)

	set_battery_level(_battery_level)

func set_battery_level(level: int) -> void:
	# Let's make sure the level is within the bounds
	if level < 0:
		level = 0
	elif level > _battery_capacity:
		level = _battery_capacity
	
	# Set internal level variable
	_battery_level = level

	for i in range(_battery_capacity):
		if i < level:
			_cells_container.get_child(i).texture = _cell_texture_on
		else:
			_cells_container.get_child(i).texture = _cell_texture_off

func get_battery_level() -> int:
	return _battery_level

func consume_battery() -> void:
	if _battery_level > 0:
		_battery_level -= 1
		_cells_container.get_child(_battery_level).texture = _cell_texture_off

var is_filling: bool = false

func fill_battery(amount: int = _battery_capacity) -> void:
	if is_filling or _battery_level == _battery_capacity:
		return
	else:
		is_filling = true
	
	while _battery_level < _battery_capacity and amount > 0:
		_fill_animation_timer.start()

		await _fill_animation_timer.timeout
		
		_cells_container.get_child(_battery_level).texture = _cell_texture_on
		_battery_level += 1
		amount -= 1
	
	is_filling = false
