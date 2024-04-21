extends Sprite2D

signal move_completed

@onready var tile_size = %MainMap.tile_size

const MOVE_SPEED = 0.4
const PAUSE_BETWEEN_MOVES = 3.0

var in_between_timer:Timer
var commands_to_process:Array
var execute_flag:bool

func _ready():
	self.visible = false
	execute_flag = false

	in_between_timer = Timer.new()
	in_between_timer.one_shot = true
	in_between_timer.wait_time = PAUSE_BETWEEN_MOVES
	add_child(in_between_timer)

func set_start_position(start_pos:Vector2) -> void:
	self.position = start_pos
	self.visible = true

func execute_move_commands(commands:Array) -> void:
	commands_to_process = commands
	execute_flag = true

func _physics_process(delta):
	if execute_flag:
		if commands_to_process.size() > 0:
			var command = commands_to_process.pop_front()
			var destination_pos = self.position
			var t:float = 0.0

			match command:
				PathProcessor.MOVES.UP:
					destination_pos += Vector2(0, -tile_size)
				PathProcessor.MOVES.DOWN:
					destination_pos += Vector2(0, tile_size)
				PathProcessor.MOVES.LEFT:
					destination_pos += Vector2(-tile_size, 0)
				PathProcessor.MOVES.RIGHT:
					destination_pos += Vector2(tile_size, 0)
				
			while t < 0.9:
				t += MOVE_SPEED * delta
			
				print(t)
				print(self.position)
				self.position = self.position.lerp(destination_pos, t)

			# in_between_timer.start()
			await get_tree().create_timer(PAUSE_BETWEEN_MOVES).timeout

		else:
			execute_flag = false
			move_completed.emit()
