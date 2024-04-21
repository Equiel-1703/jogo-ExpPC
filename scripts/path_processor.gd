extends Node

enum MOVES {UP, DOWN, LEFT, RIGHT}

func determine_direction(from:Vector2, to:Vector2) -> MOVES:
	var direction:MOVES
	if from.x < to.x:
		direction = MOVES.RIGHT
	elif from.x > to.x:
		direction = MOVES.LEFT
	elif from.y < to.y:
		direction = MOVES.DOWN
	else:
		direction = MOVES.UP
	return direction

func print_moves(moves:Array):
	for move in moves:
		match move:
			MOVES.UP:
				print("UP ")
			MOVES.DOWN:
				print("DOWN ")
			MOVES.LEFT:
				print("LEFT ")
			MOVES.RIGHT:
				print("RIGHT ")
