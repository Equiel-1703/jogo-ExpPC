extends Node2D
class_name LevelMain

# Used to manage the lines that show the path
@export var line_manager: LineManager
# Used to manage the phases progression of the levels
@export var phases_manager: PhasesManagerBase

# Used to spawn the rocket in the start of the level
var _rocket_default_start_coord: Vector2
# Used to respawn the rocket if the player loses
var _rocket_last_start_coord: Vector2

# Última coordenada de fim do caminho (usada para verificar se o jogador começou o caminho no lugar correto, onde o primeiro é a terra)
var _last_end_coord: Vector2
# Usada para armazenar temporariamente o último _last_end_coord
var _temp_last_end: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if not line_manager or not phases_manager:
		printerr("LevelMain: line_manager and phases_manager must be set in the inspector!")
		get_tree().quit()
		return
	
	# Connect Map signal
	$Map.path_set.connect(_on_path_set)
	# Connect Rocket signal
	$Rocket.move_completed.connect(_on_move_completed)
	# Connect CriarPath signals
	%CriarPath.player_path_done.connect(_on_player_path_done)
	%CriarPath.player_path_cancelled.connect(_on_player_path_cancelled)
	# Connect WinScene and LoseScene signals
	%WinScene.play_again.connect(_on_play_again)
	%LoseScene.play_again.connect(_on_play_again)
	# Connect NextPhaseScene signal
	%NextPhaseScene.play_again.connect(_on_play_again)
	# Connect LevelNum signal
	%LevelNum.level_num_finished.connect(_on_level_num_finished)
	# Connect PhasesManager signal
	phases_manager.all_paths_set.connect(_on_all_paths_set)

	# Connecting barriers explosion signal
	for barrier in $Barriers.get_children():
		barrier.area_entered.connect(_on_explosion_area_entered)

	# Get planet Earth's object from the GlobalGameData singleton
	var planet_earth = GlobalGameData.PLANETS_COORDS["terra"]
	# Set the Rocket's start position to the Earth's position
	_rocket_default_start_coord = $Map.map_to_local(planet_earth.planet_coord)
	$Rocket.set_start_position(_rocket_default_start_coord)

	# Saving last start coord for the rocket
	_rocket_last_start_coord = _rocket_default_start_coord
	# Na primeira vez, a última coordenada de fim do caminho para o foguete é sua posição inicial
	_last_end_coord = _rocket_default_start_coord

	# Disable the map at the beginning
	$Map.disable_map()

	# Show level num
	%LevelNum.level_num = GlobalGameData.current_level
	%LevelNum.show_level_num()
	print("Level ", GlobalGameData.current_level)

# Can be used by other nodes to lose immediately
func lose_immediately(lose_screen_text: String):
	$Map.disable_map()
	%LoseScene.set_lose_screen_text(lose_screen_text)
	%LoseScene.visible = true

# # Emmited by Map when the player has finished creating the path for the rocket
# func _on_path_set(path_answer: Array, start_coord: Vector2, _end_coord: Vector2):
# 	# Check if path length is not greater than the maximum allowed
# 	if path_answer.size() > GlobalGameData.MAX_PATH_LENGTH:
# 		print("Path length (", path_answer.size(), ") is greater than ", GlobalGameData.MAX_PATH_LENGTH)

# 		# We must clear the PathLine in this case
# 		%PathLine.clear_points()

# 		# Print a message to the player
# 		%MessageScene.show_message("O caminho é muito longo! As rotas não podem ser maiores que " + str(GlobalGameData.MAX_PATH_LENGTH) + ".")
		
# 		return

# 	var rocket_pos_map = $Map.local_to_map($Rocket.position)
# 	var start_coord_map = $Map.local_to_map(start_coord)

# 	print("Rocket pos = ", rocket_pos_map)
# 	print("Start coord = ", start_coord_map)

# 	# Check if Rocket start position is different from the start position of the path
# 	if rocket_pos_map != start_coord_map:
# 		print("Rocket position is different from the start position of the path")

# 		# We must clear the PathLine in this case
# 		%PathLine.clear_points()
		
# 		# Print a message to the player
# 		%MessageScene.show_message("Você deve começar o caminho no foguete!")

# 		return

# 	# Save the last start coord of the rocket
# 	_rocket_last_start_coord = start_coord

# 	phases_manager.correct_answer = path_answer

# 	$Map.disable_map()
# 	%CriarPath.show_path_menu(path_answer.size())

# Emmited by LevelNum when the level number has finished showing
func _on_level_num_finished():
	# Show first phase
	phases_manager.show_current_destination()

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2, end_coord: Vector2):
	# Get the current phase number
	var phase_num = phases_manager.get_current_phase_num()
	# Get current line used by Map
	var path_line = $Map.line

	# Check if path length is not greater than the maximum allowed
	if path_answer.size() > GlobalGameData.MAX_PATH_LENGTH:
		print("Path length (", path_answer.size(), ") is greater than ", GlobalGameData.MAX_PATH_LENGTH)

		# We must clear the PathLine in this case
		path_line.clear_points()

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
		path_line.clear_points()
		
		# Print a message to the player
		if phase_num == 1:
			print("The rocket position is different from the start position of the path")
			%MessageScene.show_message("Você deve começar o caminho no foguete!")
		else:
			print("The start position of the 2nd path is different from the end position of the 1st path")
			%MessageScene.show_message("Você deve começar o segundo caminho no final do primeiro!")

		return

	phases_manager.set_correct_answer(path_answer)

	# Used for respawn the rocket if loses
	_rocket_last_start_coord = start_coord
	# Saving new end
	_temp_last_end = end_coord

	$Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size())

# # Emmited by the CriarPath screen, when the player has finished creating the path
# func _on_player_path_done(player_path_answer: Array):
# 	# Set the player's answer in the LevelPhasesManager object
# 	phases_manager.player_answer = player_path_answer

# 	# For debugging purposes only
# 	phases_manager.print_answers()

# 	# "Launch" the rocket :)
# 	$Rocket.execute_move_commands(player_path_answer.duplicate())

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# For debugging purposes only
	phases_manager.print_answers()

	# Set the player's answer in the LevelPhasesManager object
	phases_manager.set_player_answer(player_path_answer)

# Emmited by PhasesManager when all paths are set. At this point, we can launch the rocket.
func _on_all_paths_set():
	$Rocket.execute_move_commands(phases_manager.get_rocket_moves())

# # Emmited by the Rocket node, when the rocket has finished moving
# func _on_move_completed(final_position: Vector2):
# 	# Check if player won and store in GlobalGameData
# 	GlobalGameData.player_won = phases_manager.player_won($Map.local_to_map(final_position))

# 	# Decide which scene to show
# 	if GlobalGameData.player_won:
# 		# Show the WinScene
# 		%WinScene.visible = true
# 		# Tell the PhasesManager to go to the next phase
# 		phases_manager.go_to_next_phase()
# 	else:
# 		# Show the LoseScene
# 		%LoseScene.visible = true

# Emmited by the Rocket node, when the rocket has finished moving
func _on_move_completed(final_position: Vector2):
	print(final_position)
		
# Emmited by the CriarPath screen, when the player has cancelled the path creation
func _on_player_path_cancelled():
	$Map.enable_map()
	%PathLine.clear_points()

# Emmited by the NextPhaseScene, LoseScene and NextPhaseScene when the player clicks on "OK"
func _on_play_again():
	if not GlobalGameData.player_won:
		# Put the rocket back to the start position if player lost
		$Rocket.set_start_position(_rocket_last_start_coord)
	
	# Now the yellow selection can be erased and you can move the cursor again
	$Map.enable_map()
	# Clear the path line
	$Map.line.clear_points()

# Emmited by the Rocket node, when the rocket enters a prohibited area
func _on_explosion_area_entered(_area):
	$Rocket.explode()
	await $Rocket.explosion_animation_finished
	lose_immediately("Seu foguete explodiu! Tente novamente.")
