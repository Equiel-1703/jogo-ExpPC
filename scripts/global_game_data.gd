extends Node

const WINDOW_SIZE: Vector2 = Vector2(1890, 980)
const MAP_TILE_SIZE: Vector2 = Vector2(70, 70)

# Planets coordinates
var PLANETS_COORDS = {
	"mercurio": Planet.new("Mercúrio", Vector2(5, 9)),
	"venus": Planet.new("Vênus", Vector2(7, 5)),
	"terra": Planet.new("Terra", Vector2(9, 6)),
	"marte": Planet.new("Marte", Vector2(12, 7)),
	"jupiter": Planet.new("Júpiter", Vector2(15, 8)),
	"saturno": Planet.new("Saturno", Vector2(18, 5)),
	"urano": Planet.new("Urano", Vector2(20, 8)),
	"netuno": Planet.new("Netuno", Vector2(24, 6)),
}