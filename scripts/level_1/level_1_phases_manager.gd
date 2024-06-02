extends PhasesManagerBase

var player_answer: Array
var correct_answer: Array

# Setting the destinations of the level here.
func _ready():
	_destinations = [_destination.new("venus", true),_destination.new("mercurio", false)]

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
			if _check_minimum_path(player_answer.size()):
				return true
			else:
				get_tree().call_group("lose_screen", "set_lose_screen_text", "Esse não era o caminho mínimo.\nTente de novo!")
				return false
	else:
		get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não chegou ao destino correto!")
		return false
