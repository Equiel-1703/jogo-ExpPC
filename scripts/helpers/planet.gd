extends Node
class_name Planet

var planet_name : String
var coord : Vector2

func _init(p_name : String, p_coord : Vector2):
	planet_name = p_name
	coord = p_coord