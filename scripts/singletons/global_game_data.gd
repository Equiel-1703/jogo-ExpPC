extends Node

const WINDOW_SIZE: Vector2 = Vector2(1890, 980)
const MAP_TILE_SIZE: Vector2 = Vector2(70, 70)
const MAX_PATH_LENGTH: int = 30

var player_won: bool = false
var tutorial_phase: bool = true
var start_level_index: int = 0
var levels_table: Array

# Current game status
var current_level: int = 1
var current_phase: int
var current_path: int

# Planets coordinates
var PLANETS_COORDS = {
	"mercurio": Planet.new("Mercúrio", Vector2i(5, 9), 0),
	"venus": Planet.new("Vênus", Vector2i(7, 5), 1),
	"terra": Planet.new("Terra", Vector2i(9, 6), 2),
	"marte": Planet.new("Marte", Vector2i(12, 7), 3),
	"jupiter": Planet.new("Júpiter", Vector2i(15, 8), 4),
	"saturno": Planet.new("Saturno", Vector2i(18, 5), 5),
	"urano": Planet.new("Urano", Vector2i(20, 8), 6),
	"netuno": Planet.new("Netuno", Vector2i(24, 6), 7),
}

# Minimum distances matrix
var _MIN_DISTANCES:  = [
	[0, 6, 7, 9, 11, 17, 16, 21],
	[6, 0, 3, 7, 11, 13, 16, 19],
	[7, 3, 0, 4, 8, 12, 13, 16],
	[9, 7, 4, 0, 4, 8, 9, 12],
	[11, 11, 8, 4, 0, 6, 5, 10],
	[17, 13, 12, 8, 6, 0, 5, 8],
	[16, 16, 13, 9, 5, 5, 0, 5],
	[21, 19, 16, 12, 10, 8, 5, 0],
]

func get_minimum_distance(planet1: String, planet2: String) -> int:
	var planet1_index = PLANETS_COORDS[planet1].planet_index
	var planet2_index = PLANETS_COORDS[planet2].planet_index

	return _MIN_DISTANCES[planet1_index][planet2_index]