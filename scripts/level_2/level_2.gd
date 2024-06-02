extends LevelMain

@onready var _phases_manager: PhasesManagerBase = $LevelPhasesManager

# Última coordenada de fim do caminho (usada para verificar se o jogador começou o caminho no lugar correto, onde o primeiro é o foguete)
@onready var _last_end_coord: Vector2 = %Rocket.position
# Usada para armazenar temporariamente o último _last_end_coord
var _temp_last_end: Vector2

func _ready():
	super._ready()
	
	# Connect PhasesManager signal
	_phases_manager.all_paths_set.connect(_on_all_paths_set)

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2, end_coord: Vector2):
	# Get the current phase number
	var phase_num = _phases_manager.get_current_phase_num()
	# Get current line used by Map
	var path_line = %Map.line

	# Check if path length is not greater than the maximum allowed
	if path_answer.size() > GlobalGameData.MAX_PATH_LENGTH:
		print("Path length (", path_answer.size(), ") is greater than ", GlobalGameData.MAX_PATH_LENGTH)

		# We must clear the PathLine in this case
		path_line.clear_points()

		# Print a message to the player
		%MessageScene.show_message("O caminho é muito longo! As rotas não podem ser maiores que " + str(GlobalGameData.MAX_PATH_LENGTH) + ".")
		
		return

	var start_coord_player: Vector2 = %Map.local_to_map(start_coord)
	var start_coord_correct: Vector2 = %Map.local_to_map(_last_end_coord)

	# Debug prints
	print("Start coord correct: ", start_coord_correct)
	print("Start coord player: ", start_coord_player)

	# Check if the start coord of the player is the same as the start coord of the path (valid for the rocket and the 2nd path)
	if start_coord_player != start_coord_correct:
		# We must clear the PathLine in this case
		path_line.clear_points()
		
		# Print a message to the player
		if phase_num == 1:
			print("The rocket position is different from the start position of the path")
			%MessageScene.show_message("Você deve começar o caminho no foguete!")
		else:
			print("The start position of the 2nd path is different from the end position of the 1st path")
			%MessageScene.show_message("Você deve começar o segundo caminho no final do primeiro!")

		return

	%LevelPhasesManager.set_correct_answer(path_answer)

	# Used for respawn the rocket if loses
	_rocket_last_start_coord = start_coord
	# Saving new end
	_temp_last_end = end_coord

	%Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size())

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# For debugging purposes only
	_phases_manager.print_answers()

	# Set the player's answer in the LevelPhasesManager object
	_phases_manager.set_player_answer(player_path_answer)

# Emmited by PhasesManager when all paths are set. At this point, we can launch the rocket.
func _on_all_paths_set():
	%Rocket.execute_move_commands(_phases_manager.get_rocket_moves())

# Emmited by the Rocket node, when the rocket has finished moving
func _on_move_completed(final_position: Vector2):
	print(final_position)
