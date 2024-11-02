extends Node
class_name PhasesManager

## Important definitions for the PhasesManager class:
##
## * Level: a level is a list of phases. After all phases completed, the level is over.
##
## * Phase: a phase is a list of Destinations. After all planets destinations visited, the phase is over.
## A phase can have one or more planets destinations.
##
## * Path: a path is a set of moves to reach a planet. Therefore, we can call a path simply as a destination.

signal phase_is_over(final_coords: Array)

@export var level_json_path: String
@export var next_level: PackedScene
@export var rocket: Rocket
@export var next_phase_manager: NextPhaseManager

# Phases for the level. It is an Array containing Arrays of Destination.
var _phases: Array = []
# Destinations of the phase. It is an Array of Destination.
var _destinations: Array = []
# Last destinations visited by the player.
var _last_destinations: Array

# Player and correct answers for the current phase. These are Arrays of Arrays.
var _player_answers: Array
var _correct_answers: Array

# Index of the current destination we're working.
var _dest_index: int = 0
# Current phase number.
var _current_phase_num: int = 0

func _ready():
	if not rocket:
		printerr("PhasesManager> Rocket is not set.")
		get_tree().quit()
		return

	if not level_json_path:
		printerr("PhasesManager> Level JSON path is not set.")
		get_tree().quit()
		return
	
	if not next_phase_manager:
		printerr("PhasesManager> NextPhaseManager is not set.")
		get_tree().quit()
		return
	
	# Load the level JSON file.
	_phases = JsonLoader.load_level(level_json_path)

	_last_destinations = ["terra"]

	# Go to the first phase.
	go_to_next_phase()

# ------------------------- Private Methods -------------------------

## Get the current destination of the current path.
func _get_current_destination():
	if _dest_index < _destinations.size():
		return _destinations[_dest_index]
	return null

## Check if the player reached the destination with the minimum path.
func _check_minimum_path(player_answer_index: int) -> bool:
	var dest_planet = _destinations[player_answer_index].planet_name
	var orig_planet = _last_destinations[player_answer_index]
	var player_answer_size = _player_answers[player_answer_index].size()

	var minimum_dist: int = GlobalGameData.get_minimum_distance(orig_planet, dest_planet)

	return player_answer_size <= minimum_dist

## Reset _last_destinations array and configure the reverse destinations.
func _parse_destinations():
	# Maintain only the last element from last destinations array.
	_last_destinations = [_last_destinations.pop_back()]
	
	if _destinations[0].mode == Destination.DEST_MODE.REVERSE:
		# The first destination can't be a reverse destination. Turn it to normal.
		_destinations[0] = Destination.DEST_MODE.NORMAL
	
	while _destinations.size() > 0 and _destinations[0].planet_name == _last_destinations[0]:
		# If the first destination is the same as the last destination, remove it.
		_destinations.pop_front()

	if _destinations.size() == 0:
		# In this case, skip the phase
		go_to_next_phase()

# ------------------------- Public Methods -------------------------

## For debug.
func print_answers():
	print("PhasesManager> Player answer: ", _player_answers[_dest_index])
	print("PhasesManager> Correct answer: ", _correct_answers[_dest_index])

## Get the current phase number.
func get_current_phase_num() -> int:
	return _current_phase_num

func get_current_destination_index() -> int:
	return _dest_index

## Set the player answer for the current destination.
func set_player_answer(answer: Array):
	_player_answers[_dest_index] = answer.duplicate()

func set_player_answer_at(answer: Array, index: int):
	_player_answers[index] = answer.duplicate()

## Set the correct answer for the current destination.
func set_correct_answer(answer: Array):
	_correct_answers[_dest_index] = answer.duplicate()

func set_correct_answer_reverse():
	_correct_answers[_dest_index] = PathProcessor.invert_moves(_correct_answers[_dest_index - 1])

func has_next_destination() -> bool:
	return _dest_index < _destinations.size() - 1

## Get player answers
func get_player_answers() -> Array:
	return _player_answers.duplicate(true)

func get_player_answer_at(index: int) -> Array:
	return _player_answers[index].duplicate(true)

func player_lose():
	# Clearing all answers
	for i in range(GlobalGameData.no_of_paths):
		_player_answers[i] = []
		_correct_answers[i] = []
	
	# Reset destination index
	_dest_index = 0

	# Update GlobalGameData variables
	GlobalGameData.current_path = _dest_index + 1
	GlobalGameData.destination_planet_name = GlobalGameData.PLANETS_COORDS[_destinations[0].planet_name].planet_name

## Check if the player won the game.
##
## Will return true if every destination was visited attending it's mode.
func player_won(_rocket_final_coords: Array) -> bool:
	# First, let's check if the player followed the traced path.
	for i in range(_rocket_final_coords.size()):
		if _player_answers[i] != _correct_answers[i]:
			var planet_name = GlobalGameData.PLANETS_COORDS[_destinations[i].planet_name].planet_name
			
			get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não seguiu a rota traçada para o planeta " + planet_name + "!")
			
			return false

	# Now, let's check if the player reached the destination and followed the minimum path (if it's the case).
	for i in range(_rocket_final_coords.size()):
		# Get the destination relative to the i index.
		var destination = _destinations[i]
		# Get the planet using the destination name.
		var planet_dest = GlobalGameData.PLANETS_COORDS[destination.planet_name]

		if destination.mode == Destination.DEST_MODE.MIN_PATH:
			# Check if the player reached the destination with the minimum path.
			if !_check_minimum_path(i):
				get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não seguiu o caminho mínimo para o planeta " + planet_dest.planet_name + "!")
				return false
		
		# Check if the player reached the destination.
		if _rocket_final_coords[i] != planet_dest.planet_coord:
			get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não chegou ao planeta " + planet_dest.planet_name + "!")
			return false

	# If nothing failed, the player won the phase.
	return true

## Go to next destination.
func go_to_next_destination():
	_last_destinations.append(_destinations[_dest_index].planet_name)

	# Increment the path index.
	_dest_index += 1
	GlobalGameData.current_path = _dest_index + 1

	# If the path index is greater than the destinations size, we setted all paths.
	if _dest_index > _destinations.size() - 1:
		# Reset the current path.
		_dest_index = 0
		GlobalGameData.current_path = _dest_index + 1

		# Launch the rocket
		rocket.execute_move_commands(_player_answers.duplicate(true))
		# Waits for the rocket to finish moving and emit the signal.
		var final_coords = await rocket.moves_matrix_completed
		
		phase_is_over.emit(final_coords)
	else:
		# If not, just show the next destination.
		show_current_destination()

var level_is_over: bool = false

## Update the internal variables to go to the next phase.
func go_to_next_phase():
	# If there are no more phases, the level is over.
	if _phases.size() == 0:
		# The level is over.
		level_is_over = true

		# Debug message.
		print("Level " + str(GlobalGameData.current_level) + " is over!")

		# Increase level in GlobalGameData.
		GlobalGameData.current_level += 1

		# Change the scene to the next level, if there is one.
		if next_level:
			get_tree().change_scene_to_packed(next_level)
		else:
			# The game is over.
			get_tree().change_scene_to_packed(GlobalGameData.main_screen)
		return

	# Increment the current phase number.
	_current_phase_num += 1
	# Reset the destination index.
	_dest_index = 0

	# Get the next destinations from the next phase.
	_destinations = _phases.pop_front()
	_parse_destinations()
	
	# Update global variables.
	GlobalGameData.current_phase = _current_phase_num
	GlobalGameData.current_path = _dest_index + 1
	GlobalGameData.no_of_paths = _destinations.size()

	# Clear the player and correct answers arrays.
	_player_answers.clear()
	_correct_answers.clear()

	# Resize the player and correct answers arrays.
	_player_answers.resize(GlobalGameData.no_of_paths)
	_correct_answers.resize(GlobalGameData.no_of_paths)

## Show the current destination on the screen.
func show_current_destination():
	if level_is_over:
		return
	
	if _current_phase_num > 1:
		# The first phase is the tutorial, now the player is in the second phase upwards.
		GlobalGameData.tutorial_phase = false

	# Get the current destination.
	var destination = _get_current_destination()
	# Get the planet name from the destination.
	var planet_name = GlobalGameData.PLANETS_COORDS[destination.planet_name].planet_name
	# Save planet name in GlobalGameData
	GlobalGameData.destination_planet_name = planet_name
	# Debug message.
	print("PhasesManager> Going to planet " + planet_name + "!")

	# Check the destination mode and show the screen accordingly.
	match destination.mode:
		Destination.DEST_MODE.NORMAL:
			# Show the next phase screen.
			next_phase_manager.show_destination()
		Destination.DEST_MODE.MIN_PATH:
			# Show the min path screen.
			next_phase_manager.show_destination_min_path()
		Destination.DEST_MODE.REVERSE:
			# Show the reverse path creation screen.
			next_phase_manager.show_destination_reverse()
