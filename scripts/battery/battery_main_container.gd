extends Control

signal battery_clicked

func _on_battery_clicked() -> void:
	self.visible = false
	battery_clicked.emit()
