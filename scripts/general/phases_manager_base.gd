extends Node
class_name PhasesManagerBase

signal play_again
signal all_paths_set

@export_range(1, 20) var paths_per_phase: int = 1
@export var next_level_scene: PackedScene

## Important definitions for the PhasesManagerBase class:
##
## * Level: a level is a set of phases. After all phases completed, the level is over.
##
## * Phase: a phase is a set of planets destinations. After all planets destinations visited, the phase is over.
## A phase can have one or more planets destinations.
##
## * Path: a path is a set of moves to reach a planet. Therefore, we can call path simply as destination.

## Idea for the _destination of each phase.
class _destination:
	var planet_name: String
	var min_path: bool

	func _init(p_name: String, m_path: bool):
		planet_name = p_name
		min_path = m_path

# Destinations of the level. It is an Array of _destination.
var _destinations: Array

var _current_path: int = 1
var _current_phase_num: int = 1
var _last_destination: String = "terra"

## Setting the destinations of the level here.
##
## NEED TO OVERRIDE THIS FUNCTION.
func _ready():
	pass

## Get current destination index in the _destinations array.
func _get_current_destination_index() -> int:
	return _current_path - 1

## Get the current destination of the current path.
func _get_current_destination() -> _destination:
	var index = _get_current_destination_index()

	if index > _destinations.size() - 1:
		return null
	else:
		return _destinations[index]

## Check if the player reached the destination with the minimum path.
func _check_minimum_path(player_answer_size: int) -> bool:
	var dest_planet = _get_current_destination().planet_name
	var orig_planet = _last_destination

	var minimum_dist: int = GlobalGameData.get_minimum_distance(orig_planet, dest_planet)

	return player_answer_size <= minimum_dist

## Get the current phase number.
func get_current_phase_num() -> int:
	return _current_phase_num

## Check if the player won the game.
##
## NEED TO OVERRIDE THIS FUNCTION.
func player_won(_rocket_destination: Vector2) -> bool:
	return false

## Go to next path
func go_to_next_path():
	# Update the last destination.
	_last_destination = _get_current_destination().planet_name

	_current_path += 1

	if _current_path > paths_per_phase:
		# Reset the current path.
		_current_path = 1

		all_paths_set.emit()

## Update the internal variables to go to the next phase.
func go_to_next_phase():
	# Increment the current phase number.
	_current_phase_num += 1
	# Reset the current path.
	_current_path = 1

	# Pop the visited planets from the list.
	for i in range(paths_per_phase):
		_destinations.pop_front()

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
			get_tree().quit()
	else:
		var planet_destination = GlobalGameData.PLANETS_COORDS[destination.planet_name]

		if destination.min_path:
			# Show the min path screen.
			%NextPhaseScene.show_destination_min_path(planet_destination.planet_name)
		else:
			# Show the next phase screen.
			%NextPhaseScene.show_destination(planet_destination.planet_name)
		
		# For debug only.
		print("Next phase: ", planet_destination.planet_name)
