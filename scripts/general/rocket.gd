extends Node2D
class_name Rocket

signal move_completed(final_position: Vector2)
signal explosion_animation_finished()

const MOVE_SPEED = 1.0

var _tile_size = GlobalGameData.MAP_TILE_SIZE.x
var _commands_to_process: Array
var _execute_flag: bool
var _exploded: bool

@onready var _propulsion = $Propulsion
@onready var _rocket_sprite = $RocketSpr
@onready var _explosion = $Explosion

func _ready():
	_execute_flag = false
	_propulsion.emitting = false

func set_start_position(start_pos: Vector2) -> void:
	self.position = start_pos
	self.rotation_degrees = 0

	_rocket_sprite.visible = true
	_propulsion.emitting = false
	
	_exploded = false

var _destination_pos: Vector2
var _t: float = 0.0

func execute_move_commands(commands: Array) -> void:
	# Store the commands to process
	_commands_to_process = commands
	# Turn on the propulsion effect
	_propulsion.emitting = true
	# Execute the first command
	_execute_next_command()

func explode():
	_exploded = true
	_propulsion.emitting = false
	_rocket_sprite.visible = false
	_explosion.emitting = true

func _on_explosion_finished():
	explosion_animation_finished.emit()

func _execute_next_command() -> void:
	if _commands_to_process.size() > 0:
		var command = _commands_to_process.pop_front()
		_destination_pos = self.position
		
		match command:
				PathProcessor.MOVES.UP:
					_destination_pos += Vector2(0, -_tile_size)
					self.rotation_degrees = 0
				PathProcessor.MOVES.DOWN:
					_destination_pos += Vector2(0, _tile_size)
					self.rotation_degrees = 180
				PathProcessor.MOVES.LEFT:
					_destination_pos += Vector2( - _tile_size, 0)
					self.rotation_degrees = 270
				PathProcessor.MOVES.RIGHT:
					_destination_pos += Vector2(_tile_size, 0)
					self.rotation_degrees = 90
		
		_t = 0.0
		_execute_flag = true
			
	else:
		# Turn off the propulsion effect
		_propulsion.emitting = false
		
		# Emit the signal if the rocket didn't explode
		if not _exploded:
			# The last destination position is the final position of the rocket
			move_completed.emit(_destination_pos)

func _physics_process(delta):
	if _execute_flag:
		if _t < 0.5:
			_t += MOVE_SPEED * delta
		
			self.position = self.position.lerp(_destination_pos, _t)
			# Used for debug purposes only
			# print(_t)
			# print(self.position)
		else:
			_execute_flag = false
			_execute_next_command()
