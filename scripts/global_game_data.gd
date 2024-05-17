extends Node

const WINDOW_SIZE: Vector2 = Vector2(1890, 980)
const MAP_TILE_SIZE: Vector2 = Vector2(70, 70)

# Planets coordinates
var PLANETS_COORDS = {
	"mercurio": Planet.new("Mercúrio", Vector2i(5, 9)),
	"venus": Planet.new("Vênus", Vector2i(7, 5)),
	"terra": Planet.new("Terra", Vector2i(9, 6)),
	"marte": Planet.new("Marte", Vector2i(12, 7)),
	"jupiter": Planet.new("Júpiter", Vector2i(15, 8)),
	"saturno": Planet.new("Saturno", Vector2i(18, 5)),
	"urano": Planet.new("Urano", Vector2i(20, 8)),
	"netuno": Planet.new("Netuno", Vector2i(24, 6)),
}

var player_won: bool = false
var tutorial_phase: bool = true