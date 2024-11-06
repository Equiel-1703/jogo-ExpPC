extends Node2D
class_name Rocket

## Emmited when the rocket has finished moving ALL the arrays of commands
signal moves_matrix_completed(final_coords: Array)
## Emmitted when the rocket's battery runs out
signal battery_died()

## Emmited when the rocket has finished moving a single array of commands
signal _single_move_array_completed(final_position: Vector2)

const MOVE_SPEED = 1.0

var _tile_size = GlobalGameData.MAP_TILE_SIZE.x
var _commands_to_process: Array
var _execute_flag: bool
var _is_last_array: bool = false
var _is_last_command: bool = false
var _exploded: bool
var _use_battery: bool = false
var _battery: Battery
var falling: bool = false

@onready var _propulsion = $Propulsion
@onready var _rocket_sprite = $RocketSpr
@onready var _explosion = $Explosion

const FALL_ANIMATION_DURATION: float = 2.0
const FALL_LOSE_MESSAGE: String = "A bateria acabou no meio do caminho!"
const EXPLOSION_LOSE_MESSAGE: String = "Seu foguete explodiu! Tente novamente."

func _ready():
	_execute_flag = false
	_propulsion.emitting = false

func set_use_battery(use_battery: bool) -> void:
	_use_battery = use_battery

	if _use_battery:
		_battery = get_tree().get_first_node_in_group("battery")
		if not _battery:
			printerr("Rocket> The Rocket was set to use battery, but a battery node is not present in the scene.")
			get_tree().quit()
			return

func set_start_position(start_pos: Vector2) -> void:
	_execute_flag = false
	falling = false
	_exploded = false

	self.position = start_pos
	self.rotation_degrees = 0

	_rocket_sprite.visible = true
	_propulsion.emitting = false
	_explosion.emitting = false

	set_physics_process(true)

var _destination_pos: Vector2
var _t: float = 0.0

## This function expects an array of arrays containing the commands to move the rocket
func execute_move_commands(commands_matrix: Array) -> void:
	var final_coords_array = []

	# Reset the last array and last command flags
	_is_last_array = false
	_is_last_command = false

	for command_array in commands_matrix:
		if not command_array:
			break
		
		# Check if this is the last array of commands
		if command_array == commands_matrix[-1]:
			_is_last_array = true
		
		# Store the commands to process
		_commands_to_process = command_array
		# Turn on the propulsion effect
		_propulsion.emitting = true
		# Start executing the commands
		_execute_next_command()

		# Wait for the move to be completed
		var final_coord = await _single_move_array_completed

		# Store the final position of the rocket
		final_coords_array.push_back(final_coord)

	# Just before the function ends, set the rocket sprite to point up
	# self.rotation_degrees = 0

	# Emit the signal with the final coordinates
	moves_matrix_completed.emit(final_coords_array)	

func fall():
	_propulsion.emitting = false
	_commands_to_process.clear()
	falling = true

	await get_tree().create_timer(FALL_ANIMATION_DURATION).timeout

	if not _exploded:
		get_tree().call_group("main_level", "lose_immediately", FALL_LOSE_MESSAGE)

func explode():
	set_physics_process(false)

	_exploded = true
	_commands_to_process.clear()

	_propulsion.emitting = false
	_rocket_sprite.visible = false
	_explosion.emitting = true

func _on_explosion_finished():
	if falling:
		get_tree().call_group("main_level", "lose_immediately", FALL_LOSE_MESSAGE)
	else:
		get_tree().call_group("main_level", "lose_immediately", EXPLOSION_LOSE_MESSAGE)

func _execute_next_command() -> void:
	if _commands_to_process.size() > 0:
		var command = _commands_to_process.pop_front()
		_is_last_command = _commands_to_process.size() == 0

		if _use_battery and _battery.is_battery_empty():
			battery_died.emit()
			return

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
			_single_move_array_completed.emit(_destination_pos)

func _physics_process(delta):
	if _execute_flag:
		if _t < 0.5:
			_t += MOVE_SPEED * delta
		
			self.position = self.position.lerp(_destination_pos, _t)
			
			if _is_last_array and _is_last_command:
				# Adjust rotation to zero degrees slowly
				self.rotation_degrees = lerp(self.rotation_degrees, 0.0, _t)

			# Used for debug purposes only
			# print(_t)
			# print(self.position)
		else:
			# Only process the next command if the battery is not being filled
			if _use_battery and _battery.is_filling():
				return
			
			_execute_flag = false

			if _use_battery:
				get_tree().call_group("battery", "consume_battery")

			_execute_next_command()
	
	if falling:
		self.position += Vector2.DOWN
		self.rotation_degrees += 1
