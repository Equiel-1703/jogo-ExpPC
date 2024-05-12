extends StateMachine
class_name PhasesStateMachine
## This script is a state machine that manages the phases of the game. It is based on the StateMachine class and uses the State class to manage the states.

## This signal is emmited by the Rocket when the move is completed.
func on_move_completed(final_position: Vector2):
	if current_state.has_method("on_move_completed"):
		current_state.on_move_completed(final_position)
