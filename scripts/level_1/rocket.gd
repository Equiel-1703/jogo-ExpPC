extends Sprite2D

signal move_completed

const MOVE_SPEED = 1.0

var _tile_size = GlobalGameData.MAP_TILE_SIZE.x
var _commands_to_process: Array
var _execute_flag: bool

func _ready():
	self.visible = false
	_execute_flag = false

func set_start_position(start_pos: Vector2) -> void:
	self.position = start_pos
	self.visible = true

var destination_pos: Vector2
var t: float = 0.0

func execute_move_commands(commands: Array) -> void:
	_commands_to_process = commands
	execute_next_command()

func execute_next_command() -> void:
	if _commands_to_process.size() > 0:
		var command = _commands_to_process.pop_front()
		destination_pos = self.position

		match command:
				PathProcessor.MOVES.UP:
					destination_pos += Vector2(0, -_tile_size)
					self.rotation_degrees = 0
				PathProcessor.MOVES.DOWN:
					destination_pos += Vector2(0, _tile_size)
					self.rotation_degrees = 180
				PathProcessor.MOVES.LEFT:
					destination_pos += Vector2( - _tile_size, 0)
					self.rotation_degrees = 270
				PathProcessor.MOVES.RIGHT:
					destination_pos += Vector2(_tile_size, 0)
					self.rotation_degrees = 90
		
		t = 0.0
		_execute_flag = true
			
	else:
		move_completed.emit()

func _physics_process(delta):
	if _execute_flag:
		if t < 0.5:
			t += MOVE_SPEED * delta
		
			self.position = self.position.lerp(destination_pos, t)
			# Used for debug purposes only
			# print(t)
			# print(self.position)
		else:
			_execute_flag = false
			execute_next_command()
