extends Node2D
class_name MiniBateria

@onready var _path_follow: PathFollow2D = %PathFollow2D
@onready var _light: PointLight2D = %PointLight2D
@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_area: Area2D = $PowerUpCollision

var ganho_text: PackedScene = preload("res://scenes/battery/mini_bateria/ganho_text.tscn")

var _bounce_speed: float = 0.0

static var _power_ups_to_delete: Array = []

func _ready() -> void:
	self.visible = true
	_animated_sprite.speed_scale = randf_range(0.8, 2.0)
	_bounce_speed = randf_range(0.1, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_light.energy = 2.0 + sin(Time.get_ticks_msec() / 1000.0) * 0.5
	_path_follow.progress_ratio += _bounce_speed * delta

func _on_power_up_collision_area_entered(area: Area2D) -> void:
	var _parent = area.get_parent()

	if _parent is Rocket:
		var energy_to_add = randi_range(4, 8)
		
		var node_text: Label = ganho_text.instantiate()
		node_text.text = "+" + str(energy_to_add)
		get_parent().add_child(node_text)
		
		node_text.position = self.position
		
		get_tree().call_group("battery", "fill_battery", energy_to_add)
		
		self.visible = false
		self.collision_area.set_deferred("monitoring", false)

		_power_ups_to_delete.append(self)

static func delete_power_ups() -> void:
	for power_up in _power_ups_to_delete:
		power_up.queue_free()
	_power_ups_to_delete.clear()

static func reset_power_ups() -> void:
	for power_up in _power_ups_to_delete:
		power_up.visible = true
		power_up.collision_area.monitoring = true
	_power_ups_to_delete.clear()
