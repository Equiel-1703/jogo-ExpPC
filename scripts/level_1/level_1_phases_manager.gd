extends Node
class_name Level1PhasesManager

signal play_again

class _destination:
	var planet_name: String
	var min_path: bool

	func _init(p_name: String, m_path: bool):
		planet_name = p_name
		min_path = m_path

# Destinations of the level.
var _destinations: Array = [_destination.new("mercurio", false), _destination.new("venus", true)]

var _current_phase_num: int = 1
var _last_destination: String = "terra"

var player_answer: Array
var correct_answer: Array

## Get the destination of the current phase.
func _get_current_destination() -> _destination:
	if _destinations.size() == 0:
		return null
	else:
		return _destinations[0]

func _check_minimum_path() -> bool:
	var dest_planet = _get_current_destination().planet_name
	var orig_planet = _last_destination

	var minimum_dist : int = GlobalGameData.get_minimum_distance(orig_planet, dest_planet)

	return player_answer.size() <= minimum_dist

# For debug.
func print_answers():
	print("Player answer: ", player_answer)
	print("Correct answer: ", correct_answer)


## Check if the player won the game.
##
## The criteria is: the player path must be equal to the correct answer (traced in red) on the map.
## But also, the destination coordinates must be the same as the destination planet.
func player_won(rocket_destination: Vector2) -> bool:
	if player_answer != correct_answer:
		get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não seguiu a rota traçada!")
		return false
	
	var dest = _get_current_destination()
	var planet_destination = GlobalGameData.PLANETS_COORDS[dest.planet_name]

	print("Rocket destination: ", rocket_destination)
	print("Planet destination: ", planet_destination.planet_coord)

	var rocket_reached_destination = rocket_destination == planet_destination.planet_coord

	if rocket_reached_destination:
		if !dest.min_path:
			return true
		else:
			if _check_minimum_path():
				return true
			else:
				get_tree().call_group("lose_screen", "set_lose_screen_text", "Esse não era o caminho mínimo.\nTente de novo!")
				return false
	else:
		get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não chegou ao destino correto!")
		return false

## Update the internal variables to go to the next phase.
func go_to_next_phase():
	# Increment the current phase number.
	_current_phase_num += 1
	# Remove the current destination from the list.
	_last_destination = _destinations.pop_front().planet_name

## Show the current phase screen.
func show_current_phase():
	if _current_phase_num > 1:
		# The first phase is the tutorial, now the player is in the second phase.
		GlobalGameData.tutorial_phase = false

	# Get the current destination.
	var destination = _get_current_destination()
	if !destination:
		# The level is over.
		# For now, this is only a placeholder.
		print("Level 1 is over!")
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
