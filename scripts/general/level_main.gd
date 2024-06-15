extends Node2D
class_name LevelMain

# Used to manage the phases progression of the levels
@export var phases_manager: PhasesManager

# Used to spawn the rocket in the start of the level
var _rocket_default_start_coord: Vector2
# Used to respawn the rocket if the player loses
var _rocket_respawn_coord: Vector2

# Última coordenada de fim do caminho (usada para verificar se o jogador começou o caminho no lugar correto, onde o primeiro é a terra)
var _last_end_coord: Vector2
# Coordenada de fim do caminho temporária (é usada caso o jogador cancele a criação do path)
var _temp_last_end: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if not phases_manager:
		printerr("LevelMain> phases_manager must be set in the inspector!")
		get_tree().quit()
		return
	
	# Connect Map signal
	$Map.path_set.connect(_on_path_set)
	# Connect Rocket signal
	$Rocket.moves_matrix_completed.connect(_on_moves_matrix_completed)

	# Connect CriarPath signals
	%CriarPath.player_path_done.connect(_on_player_path_done)
	%CriarPath.player_path_cancelled.connect(_on_player_path_cancelled)
	# Connect WinScene and LoseScene signals
	%WinScene.go_to_next_phase.connect(_on_go_to_next_phase)
	%LoseScene.play_again.connect(_on_play_again)
	# Connect NextPhaseScene signal
	%NextPhaseScene.play.connect(_on_play)
	# Connect LevelNum signal
	%LevelNum.level_num_finished.connect(_on_level_num_finished)
	# Connect IntermMessage signal
	# %IntermMessage.message_faded_out.connect(_on_interm_message_faded_out)

	# Connect PhasesManager signals
	phases_manager.all_paths_set.connect(_on_all_paths_set)
	phases_manager.went_to_next_destination.connect(_on_went_to_next_destination)

	# Connecting barriers explosion signal
	for barrier in $Barriers.get_children():
		barrier.area_entered.connect(_on_explosion_area_entered)

	# Get planet Earth's object from the GlobalGameData singleton
	var planet_earth = GlobalGameData.PLANETS_COORDS["terra"]
	# Set the Rocket's start position to the Earth's position
	_rocket_default_start_coord = $Map.map_to_local(planet_earth.planet_coord)
	$Rocket.set_start_position(_rocket_default_start_coord)

	# Setting the respawn coord to the default start coord
	_rocket_respawn_coord = _rocket_default_start_coord
	# Na primeira vez, a última coordenada de fim do caminho para o foguete é sua posição inicial
	_last_end_coord = _rocket_default_start_coord
	_temp_last_end = _last_end_coord

	# Disable the map at the beginning
	$Map.disable_map()

	# Show level num
	%LevelNum.level_num = GlobalGameData.current_level
	%LevelNum.show_level_num()
	
	print("Level ", GlobalGameData.current_level)

# Emmited by LevelNum when the level number has finished showing
func _on_level_num_finished():
	# Show first phase
	phases_manager.show_current_destination()

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2, end_coord: Vector2):
	# Get the current phase number
	var path_index = phases_manager.get_current_destination_index()

	# Check if path length is not greater than the maximum allowed
	if path_answer.size() > GlobalGameData.MAX_PATH_LENGTH:
		print("Path length (", path_answer.size(), ") is greater than ", GlobalGameData.MAX_PATH_LENGTH)

		# We must clear the PathLine in this case
		$Map.clear_active_line()

		# Print a message to the player
		%MessageScene.show_message("O caminho é muito longo! As rotas não podem ser maiores que " + str(GlobalGameData.MAX_PATH_LENGTH) + ".")
		
		return

	var start_coord_player: Vector2 = $Map.local_to_map(start_coord)
	var start_coord_correct: Vector2 = $Map.local_to_map(_last_end_coord)

	# Debug prints
	print("Start coord correct: ", start_coord_correct)
	print("Start coord player: ", start_coord_player)

	# Check if the start coord of the player is the same as the start coord of the path (valid for the rocket and the 2nd path)
	if start_coord_player != start_coord_correct:
		# We must clear the PathLine in this case
		$Map.clear_active_line()
		
		# Print a message to the player
		if path_index == 0:
			print("The rocket position is different from the start position of the path")
			%MessageScene.show_message("Você deve começar o caminho no foguete!")
		else:
			print("The start position of the 2nd path is different from the end position of the 1st path")
			%MessageScene.show_message("Você deve começar o segundo caminho no final do primeiro!")

		return

	phases_manager.set_correct_answer(path_answer)

	# Saving end coord of path as the temp last end
	_temp_last_end = end_coord

	$Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size(), $Map.line.default_color)

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# Set the new last end coord (player didn't cancel the path creation)
	_last_end_coord = _temp_last_end

	# Set the player's answer in the phases manager object
	phases_manager.set_player_answer(player_path_answer)
	# For debugging purposes only
	phases_manager.print_answers()

	# Go to next line in the map
	$Map.go_to_next_line()

	# Mostrar mensagem intermediária antes de ir para o próximo destino
	%IntermMessage.show_message()
	await %IntermMessage.message_faded_out

	# Go to next destination in the phase
	phases_manager.go_to_next_destination()

# Emmit by PhasesManager when we went to the next destination in the phase without finishing all destinations
func _on_went_to_next_destination():
	# Show new destination to the player
	phases_manager.show_current_destination()

# Emmited by PhasesManager when all paths are set (i.e. the go_to_next_destination failed).
# There is no next destination in the phase. At this point, we can launch the rocket.
func _on_all_paths_set(rocket_moves: Array):
	$Rocket.execute_move_commands(rocket_moves)

# Emmited by the Rocket node, when the rocket has finished moving
func _on_moves_matrix_completed(final_coords: Array):
	$Map.clear_all_lines()

	if phases_manager.player_won($Map.convert_local_array_to_map(final_coords)):
		# Player won
		%WinScene.visible = true

		# Get the last coord to use as the respawn coord
		_rocket_respawn_coord = _last_end_coord
	else:
		# Player lost (The message is set in phases_manager.player_won() function
		%LoseScene.visible = true

		# As the player lost, the last coord is now its respawn coord
		_last_end_coord = _rocket_respawn_coord

# Emmited by the NextPhaseScene when the player clicks on the "OK" button
func _on_play():
	$Map.enable_map()
	$Map.clear_active_line()

# Emmited by the CriarPath screen, when the player has cancelled the path creation
func _on_player_path_cancelled():
	_on_play()

# Emmited by the LoseScene
func _on_play_again():
	if not GlobalGameData.player_won:
		# Put the rocket back to the start position if player lost
		$Rocket.set_start_position(_rocket_respawn_coord)
	
	_on_play()

# Emmited by the WinScene, we go to the next phase
func _on_go_to_next_phase():
	# Go to the next phase
	phases_manager.go_to_next_phase()
	# Show the next phase
	phases_manager.show_current_destination()

# Emmited by the Rocket node, when the rocket enters a prohibited area
func _on_explosion_area_entered(_area):
	$Rocket.explode()
	await $Rocket.explosion_animation_finished
	lose_immediately("Seu foguete explodiu! Tente novamente.")

# Can be used by other nodes to lose immediately
func lose_immediately(lose_screen_text: String):
	$Map.disable_map()
	%LoseScene.set_lose_screen_text(lose_screen_text)
	%LoseScene.visible = true
