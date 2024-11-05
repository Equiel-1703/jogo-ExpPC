extends Control
class_name BatteryMainContainer

signal battery_clicked(centered: bool)

@onready var center: CenterContainer = $Center
@onready var corner: Control = $Corner
@onready var battery: Battery = %Battery
@onready var blurred_bg: ColorRect = $BlurredBG

var _battery_on_center: bool = false

func _ready() -> void:
	battery.reparent(corner)
	blurred_bg.visible = _battery_on_center

func _on_battery_clicked() -> void:
	if _battery_on_center:
		battery.reparent(corner)
		_battery_on_center = false
	else:
		battery.reparent(center)
		_battery_on_center = true

	blurred_bg.visible = _battery_on_center
	battery_clicked.emit(_battery_on_center)
