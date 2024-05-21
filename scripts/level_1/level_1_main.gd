extends Node2D

var _rocket_start_coord: Vector2

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
	# Connect NextPhaseScene signal
	%NextPhaseScene.play_again.connect(_on_play_again)

	# Get planet Earth's object from the GlobalGameData singleton
	var planet_earth = GlobalGameData.PLANETS_COORDS["terra"]
	# Set the Rocket's start position to the Earth's position
	_rocket_start_coord = %Map.map_to_local(planet_earth.planet_coord)
	%Rocket.set_start_position(_rocket_start_coord)

	# Show first phase
	%Map.disable_map()
	%Level1PhasesManager.show_current_phase()

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2):
	# Check if path length is not greater than the maximum allowed
	if path_answer.size() > GlobalGameData.MAX_PATH_LENGTH:
		print("Path length (", path_answer.size(), ") is greater than ", GlobalGameData.MAX_PATH_LENGTH)

		# We must clear the PathLine in this case
		%PathLine.clear_points()

		# Print a message to the player (this is just a placeholder)
		var message_label = Label.new()
		message_label.text = "O tamanho do caminho é grande demais!"
		message_label.custom_minimum_size = Vector2(200, 50)
		message_label.position = Vector2(100, 100)
		add_child(message_label)
		
		return

	var rocket_pos_map = %Map.local_to_map(%Rocket.position)
	var start_coord_map = %Map.local_to_map(start_coord)

	print("Rocket pos = ", rocket_pos_map)
	print("Start coord = ", start_coord_map)

	# Check if Rocket start position is different from the start position of the path
	if rocket_pos_map != start_coord_map:
		print("Rocket position is different from the start position of the path")

		# We must clear the PathLine in this case
		%PathLine.clear_points()
		
		# Print a message to the player (this is just a placeholder)
		var message_label = Label.new()
		message_label.text = "A rota deve começar no foguete!"
		message_label.custom_minimum_size = Vector2(200, 50)
		message_label.position = Vector2(100, 100)
		add_child(message_label)

		return

	%Level1PhasesManager.correct_answer = path_answer
	_rocket_start_coord = start_coord

	%Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size())

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# Set the player's answer in the Level1PhasesManager object
	%Level1PhasesManager.player_answer = player_path_answer

	# For debugging purposes only
	%Level1PhasesManager.print_answers()

	# "Launch" the rocket :)
	%Rocket.set_start_position(_rocket_start_coord)
	%Rocket.execute_move_commands(player_path_answer.duplicate())

# Emmited by the Rocket node, when the rocket has finished moving
func _on_move_completed(final_position: Vector2):
	# Check if player won and store in GlobalGameData
	GlobalGameData.player_won = %Level1PhasesManager.player_won(%Map.local_to_map(final_position))

	# Decide which scene to show
	if GlobalGameData.player_won:
		# Show the WinScene
		%WinScene.visible = true
		# Tell the PhasesManager to go to the next phase
		%Level1PhasesManager.go_to_next_phase()
	else:
		# Show the LoseScene
		%LoseScene.visible = true
		
# Emmited by the CriarPath screen, when the player has cancelled the path creation
func _on_player_path_cancelled():
	%Map.enable_map()
	%PathLine.clear_points()

# Emmited by the NextPhaseScene and LoseScene node
func _on_play_again():
	if not GlobalGameData.player_won:
		# Put the rocket back to the start position if player lost
		%Rocket.set_start_position(_rocket_start_coord)
	
	# Now the yellow selection can be erased and you can move the cursor again
	%Map.enable_map()
	%PathLine.clear_points()
