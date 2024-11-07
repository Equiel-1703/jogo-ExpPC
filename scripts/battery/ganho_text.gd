extends Label

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	self.queue_free()
