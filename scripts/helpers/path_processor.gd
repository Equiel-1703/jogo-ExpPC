extends Node

enum MOVES {UP, RIGHT, DOWN, LEFT}

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
		print_move(move)

func print_move(move:MOVES):
	match move:
		MOVES.UP:
			print("UP")
		MOVES.DOWN:
			print("DOWN")
		MOVES.LEFT:
			print("LEFT")
		MOVES.RIGHT:
			print("RIGHT")
