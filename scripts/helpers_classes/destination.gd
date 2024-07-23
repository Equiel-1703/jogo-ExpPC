extends Node
class_name Destination

enum DEST_MODE {NORMAL, MIN_PATH, REVERSE}

var planet_name: String
var mode: DEST_MODE

func _init(p_name: String, p_mode: DEST_MODE=DEST_MODE.NORMAL):
	planet_name = p_name
	mode = p_mode

func _to_string():
	return planet_name + " - " + str(mode)