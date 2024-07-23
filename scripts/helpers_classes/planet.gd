class_name Planet

var planet_name : String
var planet_coord : Vector2i
var planet_index : int 

func _init(p_name : String, p_coord : Vector2i, p_index : int):
	planet_name = p_name
	planet_coord = p_coord
	planet_index = p_index