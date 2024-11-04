extends Control
class_name Battery

@onready var _cells_container: CellsContainer = %CellsContainer

func _ready():
	_cells_container.set_battery_level(5)

func _on_button_pressed() -> void:
	_cells_container.consume_battery()

func _on_button_2_pressed() -> void:
	_cells_container.fill_battery()
