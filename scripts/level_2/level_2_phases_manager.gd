extends PhasesManager

# var _player_answers: Array
# var _correct_answers: Array

# # Setting the destinations of the level here.
# func _ready():
# 	_destinations = [_destination.new("venus", true)]

# 	# Set the player answers and correct answers arrays.
# 	_player_answers.resize(paths_per_phase)
# 	_correct_answers.resize(paths_per_phase)

# # ------------------------- Private Methods -------------------------

# ## Check if each answer of the player match the correct answer for the paths per phase.
# func _validate_player_answers() -> bool:
# 	for i in range(paths_per_phase):
# 		if _player_answers[i] != _correct_answers[i]:
# 			return false
# 	return true

# # ------------------------- Public Methods -------------------------

# # For debug.
# func print_answers():
# 	print("Player answer: ", _player_answers)
# 	print("Correct answer: ", _correct_answers)

# ## Set the player answer for the current phase.
# func set_player_answer(answer: Array):
# 	_player_answers[_get_current_destination_index()] = answer

# ## Set the correct answer for the current phase.
# func set_correct_answer(answer: Array):
# 	_correct_answers[_get_current_destination_index()] = answer

# ## Get the player answer for the current phase.
# func get_player_answer() -> Array:
# 	return _player_answers[_get_current_destination_index()]

# ## Get the correct answer for the current phase.
# func get_correct_answer() -> Array:
# 	return _correct_answers[_get_current_destination_index()]

# ## Return an array of the rocket moves for all the paths of this phase.
# func get_rocket_moves():
# 	var moves: Array = []

# 	for path in _player_answers:
# 		moves.append_array(path)
	
# 	return moves

# ## Check if the player won the game.
# ##
# ## The criteria is: the player path must be equal to the correct answer (traced in red) on the map.
# ## But also, the destination coordinates must be the same as the destination planet.
# func player_won_multi(rocket_destinations: Array) -> bool:
# 	if not _validate_player_answers():
# 		get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não seguiu a rota traçada!")
# 		return false
	
# 	var won: bool = true

# 	for i in range(paths_per_phase):
# 		# Get the destination of the current path.
# 		var dest = _get_current_destination()
# 		var planet_destination = GlobalGameData.PLANETS_COORDS[dest.planet_name]

# 		# Debug.
# 		print("Rocket destination: ", rocket_destinations[_get_current_destination_index()])
# 		print("Planet destination: ", planet_destination.planet_coord)

# 		# Check if the rocket reached the destination.
# 		var rocket_reached_destination = (rocket_destinations[_get_current_destination_index()] == planet_destination.planet_coord)

# 		if rocket_reached_destination:
# 			if !dest.min_path:
# 				# Nothing to do here.
# 				go_to_next_destination()
# 				continue
# 			else:
# 				if _check_minimum_path(get_player_answer().size()):
# 					go_to_next_destination()
# 					continue
# 				else:
# 					get_tree().call_group("lose_screen", "set_lose_screen_text", "Esse não era o caminho mínimo.\nTente de novo!")
# 					won = false
# 					break
# 		else:
# 			get_tree().call_group("lose_screen", "set_lose_screen_text", "Você não chegou ao destino correto!")
# 			won = false
# 			break
	
# 	return won
