extends Node
class_name PhasesManager

## Important definitions for the PhasesManager class:
##
## * Level: a level is a set of phases. After all phases completed, the level is over.
##
## * Phase: a phase is a set of planets destinations. After all planets destinations visited, the phase is over.
## A phase can have one or more planets destinations.
##
## * Path: a path is a set of moves to reach a planet. Therefore, we can call path simply as destination.

signal all_paths_set(rocket_moves: Array)

@export var next_level_scene: PackedScene
@export var level_json_path: String

# Phases for the level. It is an Array containing Arrays of _destination.
var _phases: Array = []
# Destinations of the level. It is an Array of _destination.
var _destinations: Array = []
# Last destinations visited by the player.
var _last_destinations: Array

# Player and correct answers for the current destination.
var _player_answers: Array
var _correct_answers: Array

# Index of the current destination we're working.
var _dest_index: int = 0
# Current phase number.
var _current_phase_num: int = 0

func _ready():
	if not level_json_path:
		printerr("PhasesManager> Level JSON path is not set.")
		get_tree().quit()
		return
	
	# Load the level JSON file.
	_phases = LevelLoader.load_level(level_json_path)

	# Go to the first phase.
	go_to_next_phase()

# ------------------------- Private Methods -------------------------

## Get the current destination of the current path.
func _get_current_destination():
	return _destinations[_dest_index]

## Reset the last destinations array.
func _reset_last_destinations():
	_last_destinations = ["terra"]

## Check if the player reached the destination with the minimum path.
func _check_minimum_path(player_answer_index: int) -> bool:
	var dest_planet = _destinations[player_answer_index].planet_name
	var orig_planet = _last_destinations[player_answer_index]
	var player_answer_size = _player_answers[player_answer_index].size()

	var minimum_dist: int = GlobalGameData.get_minimum_distance(orig_planet, dest_planet)

	return player_answer_size <= minimum_dist

# ------------------------- Public Methods -------------------------

## For debug.
func print_answers():
	print("Player answer: ", _player_answers[_dest_index])
	print("Correct answer: ", _correct_answers[_dest_index])

## Get the current phase number.
func get_current_phase_num() -> int:
	return _current_phase_num

func get_current_destination_index() -> int:
	return _dest_index

## Set the player answer for the current destination.
func set_player_answer(answer: Array):
	_player_answers[_dest_index] = answer

## Set the correct answer for the current destination.
func set_correct_answer(answer: Array):
	_correct_answers[_dest_index] = answer

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

	# Now, let's check if the player reached the destination and followed the minimum path.
	for i in range(_rocket_final_coords.size()):
		# Get the destination relative to the i index.
		var destination = _destinations[i]
		# Get the planet using the destination name.
		var planet_dest = GlobalGameData.PLANETS_COORDS[destination.planet_name]

		if destination.mode == LevelLoader.DEST_MODE.MIN_PATH:
			# Check if the player reached the destination with the minimum path.
			if !_check_minimum_path(i):
				get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não seguiu o caminho mínimo para o planeta " + planet_dest.planet_name + "!")
				return false
		else:
			# Check if the player reached the destination.
			if _rocket_final_coords[i] != planet_dest.planet_coord:
				get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não chegou ao planeta " + planet_dest.planet_name + "!")
				return false
	
	# If nothing failed, the player won the phase.
	return true

## Go to next destination.
func go_to_next_destination():
	# Append new last destination.
	_last_destinations.push_back(_get_current_destination().planet_name)

	# Increment the path index.
	_dest_index += 1

	# If the path index is greater than the destinations size, we setted all paths.
	if _dest_index > _destinations.size() - 1:
		# Reset the current path.
		_dest_index = 0

		all_paths_set.emit(_player_answers)

## Update the internal variables to go to the next phase.
func go_to_next_phase():
	# Increment the current phase number.
	_current_phase_num += 1
	# Reset the path index.
	_dest_index = 0

	# Pop the visited planets from the list.
	for i in range(_destinations.size()):
		_destinations.pop_front()
	
	# Reset last destinations.
	_reset_last_destinations()
	
	# Get the next destinations from the next phase.
	_destinations = _phases[_current_phase_num - 1]

## Show the current phase screen.
func show_current_destination():
	if _current_phase_num > 1:
		# The first phase is the tutorial, now the player is in the second phase.
		GlobalGameData.tutorial_phase = false

	# Get the current destination.
	var destination = _get_current_destination()
	if !destination:
		# The level is over.
		print("Level " + str(GlobalGameData.current_level) + " is over!")

		# Increase level in GlobalGameData.
		GlobalGameData.current_level += 1

		# Change the scene to the next level, if there is one.
		if next_level_scene:
			get_tree().change_scene_to_packed(next_level_scene)
		else:
			# The game is over.
			get_tree().quit()
		return
	
	# Get the planet destination.
	var planet_destination = GlobalGameData.PLANETS_COORDS[destination.planet_name]

	# Check the destination mode and show the screen accordingly.
	match destination.mode:
		LevelLoader.DEST_MODE.MIN_PATH:
			# Show the min path screen.
			%NextPhaseScene.show_destination_min_path(planet_destination.planet_name)
		LevelLoader.DEST_MODE.NORMAL:
			# Show the next phase screen.
			%NextPhaseScene.show_destination(planet_destination.planet_name)
	
	# For debug only.
	print("Next phase: ", planet_destination.planet_name)
