extends Node2D

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
	# Connect NextPhaseScene signal
	%NextPhaseScene.play_again.connect(_on_play_again)

	var planet_earth = GlobalGameData.PLANETS_COORDS["terra"]
	%Rocket.set_start_position(%Map.map_to_local(planet_earth.planet_coord))

	# Show first phase
	%Map.disable_map()
	%Level1PhasesManager.show_next_phase()

# Emmited by Map when the player has finished creating the path for the rocket
func _on_path_set(path_answer: Array, start_coord: Vector2):
	# Check if Rocket start position is different from the start position of the path
	if %Rocket.position != start_coord:
		print("Rocket position is different from the start position of the path")

		# We must clear the PathLine in this case
		%PathLine.clear_points()
		
		return

	%Level1PhasesManager.correct_answer = path_answer
	_start_coord = start_coord

	%Map.disable_map()
	%CriarPath.show_path_menu(path_answer.size())

# Emmited by the CriarPath screen, when the player has finished creating the path
func _on_player_path_done(player_path_answer: Array):
	# Set the player's answer in the Level1PhasesManager object
	%Level1PhasesManager.player_answer = player_path_answer

	# For debugging purposes only
	%Level1PhasesManager.print_answers()

	# "Launch" the rocket :)
	%Rocket.set_start_position(_start_coord)
	%Rocket.execute_move_commands(player_path_answer.duplicate())

# Emmited by the Rocket node, when the rocket has finished moving
func _on_move_completed(final_position: Vector2):
	# Check if the player's answer is correct
	if %Level1PhasesManager.player_won(%Map.local_to_map(final_position)):
		# Show the WinScene
		%WinScene.visible = true
	else:
		# Show the LoseScene
		%LoseScene.visible = true

# Emmited by the CriarPath screen, when the player has cancelled the path creation
func _on_player_path_cancelled():
	%Map.enable_map()
	%PathLine.clear_points()

# Emmited by the NextPhaseScene and LoseScene node
func _on_play_again(): 
	# Now the yellow selection can be erased and you can move the cursor again
	%Map.enable_map()
	%PathLine.clear_points()
