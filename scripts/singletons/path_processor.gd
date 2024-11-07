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

func invert_moves(moves:Array) -> Array:
	var inverted_moves:Array = []
	for move in moves:
		match move:
			MOVES.UP:
				inverted_moves.append(MOVES.DOWN)
			MOVES.DOWN:
				inverted_moves.append(MOVES.UP)
			MOVES.LEFT:
				inverted_moves.append(MOVES.RIGHT)
			MOVES.RIGHT:
				inverted_moves.append(MOVES.LEFT)
	inverted_moves.reverse()
	return inverted_moves

func move_to_vector2(move:MOVES) -> Vector2:
	match move:
		MOVES.UP:
			return Vector2(0, -1)
		MOVES.DOWN:
			return Vector2(0, 1)
		MOVES.LEFT:
			return Vector2(-1, 0)
		MOVES.RIGHT:
			return Vector2(1, 0)
	
	return Vector2.ZERO

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
