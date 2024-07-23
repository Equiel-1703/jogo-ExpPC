extends Control
class_name NextPhaseManager

func show_destination(planet_name: String):
	$Simple.show_destination(planet_name)

func show_destination_min_path(planet_name: String):
	$MinPath.show_destination(planet_name)

func show_destination_reverse(planet_name: String):
	$Reverse.show_destination(planet_name)
