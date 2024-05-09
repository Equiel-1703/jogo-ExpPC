extends Node2D

var _player_won: bool = false

var _correct_answer: Array = []
var _start_coord: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect Map signal
	%Map.path_set.connect(_on_path_set)
	# Connect Rocket signal
	%Rocket.move_completed.connect(_on_move_completed)
	# Connect CriarPath signals
	%CriarPath.player_path_done.connect(_on_player_path_done)
	%CriarPath.player_path_cancelled.connect(_on_player_path_cancelled)
	# Connect WinScene and LoseScene signals
	%WinScene.play_again.connect(_on_play_again)
	%LoseScene.play_again.connect(_on_play_again)

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2):
	_correct_answer = path_answer
	_start_coord = start_coord

	%Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size())

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# For debugging purposes only
	print("Player player_path_answer: " + str(player_path_answer))
	print("Correct player_path_answer: " + str(_correct_answer))

	if player_path_answer == _correct_answer:
		print("CORRETO")
		_player_won = true
	else:
		print("ERRADO")
		_player_won = false

	%Rocket.set_start_position(_start_coord)
	%Rocket.execute_move_commands(player_path_answer.duplicate())

# Emmited by the CriarPath screen, when the player has cancelled the path creation
func _on_player_path_cancelled():
	%Map.enable_map()
	%PathLine.clear_points()

# Emmited by the Rocket node when it has finished moving
func _on_move_completed(final_position: Vector2):
	print("RCKT> Rocket has arrived at: " + str(final_position))
	print("RCKT> In TileMap coords: " + str(%Map.local_to_map((final_position))))

	if _player_won:
		%WinScene.visible = true
	else:
		%LoseScene.visible = true

# Emmited by the WinScene and LoseScene nodes
func _on_play_again():
	# Now the yellow selection can be erased and you can move the cursor again
	%Map.enable_map()
	%PathLine.clear_points()

	# Hide the Rocket
	%Rocket.visible = false
