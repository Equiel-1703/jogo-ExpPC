extends Control

signal undo_last_route

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = not get_tree().paused
	%PauseMenu.visible = not %PauseMenu.visible

func _on_resumir_pressed() -> void:
	_toggle_pause()

func _on_reiniciar_nivel_pressed() -> void:
	_toggle_pause()
	get_tree().reload_current_scene()

func _on_desfazer_ult_rota_pressed() -> void:
	_toggle_pause()
	undo_last_route.emit()

func _on_sair_pressed() -> void:
	_toggle_pause()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
