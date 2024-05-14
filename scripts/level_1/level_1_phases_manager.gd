extends Node
class_name Level1PhasesManager

signal play_again

var _destinations: Array = ["mercurio", "marte"]

var player_answer: Array
var correct_answer: Array

# For debug.
func print_answers():
	print("Player answer: ", player_answer)
	print("Correct answer: ", correct_answer)

## Get the destination of the current phase.
func _get_next_destination() -> String:
	if _destinations.size() == 0:
		return ""
	else:
		return _destinations[0]

## Check if the player won the game.
##
## The criteria is: the player path must be equal to the correct answer (traced in red) on the map.
## But also, the destination coordinates must be the same as the destination planet.
func player_won(rocket_destination: Vector2) -> bool:
	if player_answer != correct_answer:
		return false
	
	var planet_destination = GlobalGameData.PLANETS_COORDS[_get_next_destination()]

	print("Rocket destination: ", rocket_destination)
	print("Planet destination: ", planet_destination.planet_coord)

	if rocket_destination == planet_destination.planet_coord:
		# Go to the next phase (remove the first planet).
		_destinations.pop_front()
		return true
	else:
		return false

## Show the next phase screen.
func show_next_phase():
	# Get the next destination.
	var destination = _get_next_destination()
	if destination == "":
		# The level is over.
		# For now, this is only a placeholder.
		print("Level 1 is over!")
		get_tree().quit()
	else:
		var planet_destination = GlobalGameData.PLANETS_COORDS[destination]
		# Show the next phase screen.
		%NextPhaseScene.show_destination(planet_destination.planet_name)
		# For debug only.
		print("Next phase: ", planet_destination.planet_name)
