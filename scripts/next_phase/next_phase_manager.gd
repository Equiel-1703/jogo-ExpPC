extends Control
class_name NextPhaseManager

func show_destination():
	$Simple.show_destination(GlobalGameData.tutorial_phase_normal)

func show_destination_min_path():
	$MinPath.show_destination()

func show_destination_reverse():
	$Reverse.show_destination(GlobalGameData.tutorial_phase_reverse)
