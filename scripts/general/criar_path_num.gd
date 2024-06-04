# This is the generic version of this screen
extends CriarPath

var _reading_path_size: bool

const _invalid_int_alert: String = "Por favor, insira um tamanho de rota válido!"
const _invalid_negative_alert: String = "Por favor, insira um tamanho de rota positivo!"
const _route_too_big: String = "O tamanho máximo de uma rota é 30!"

func show_path_menu(_p_len: int=0):
	# We will read the path size first
	_reading_path_size = true

	# Hide gradient background and set the normal background visible
	%GradientBG.visible = false
	%BG.visible = true

	# Hide path buttons
	%PathButtons.visible = false

	# Show the path size text field
	%TamRotaLineField.text = ""
	%TamRotaLineField.visible = true

	# Hide alert label
	%AlertLabel.visible = false

	# Show instruction label if we are in the tutorial phase
	%InstructionLabel.visible = GlobalGameData.tutorial_phase

	self.visible = true

func _show_alert(text: String):
	%AlertLabel.text = text
	%AlertLabel.visible = true
	%TamRotaLineField.text = ""

func _on_tam_rota_line_field_text_submitted(_new_text):
	_on_ok_pressed()

func _on_ok_pressed():
	# Hide alert label
	%AlertLabel.visible = false

	# If we are not reading the path size, we are getting the player path and emitting the signal
	if not _reading_path_size:
		self.visible = false

		# Get the player path from the buttons
		var player_path = []
		for child in %PathButtons.get_children():
			player_path.append(child.button_direction)

		# Clear the buttons
		_clear_buttons()

		# Print the player path for debug
		print("CriarPath> Player path:")
		PathProcessor.print_moves(player_path)
		
		# Emit the path done signal with the player path
		player_path_done.emit(player_path)
		return
	
	# If the path size is empty, return
	if %TamRotaLineField.text == "":
		return

	# Check if the path size is a valid integer
	if not %TamRotaLineField.text.is_valid_int():
		_show_alert(_invalid_int_alert)
		return

	# Get the path size from the text field and check if it is valid
	_path_lenght = %TamRotaLineField.text.to_int()

	if _path_lenght <= 0:
		_show_alert(_invalid_negative_alert)
		return
	
	if _path_lenght > GlobalGameData.MAX_PATH_LENGTH:
		_show_alert(_route_too_big)
		return

	# Load the buttons and make them visible
	_load_buttons()
	%PathButtons.visible = true

	# Hide the path size text field
	%TamRotaLineField.visible = false

	# Now we are not reading the path size anymore
	_reading_path_size = false

func _on_ver_mapa_pressed():
	super._on_ver_mapa_pressed()

	if _reading_path_size:
		%TamRotaLineField.visible = ! %TamRotaLineField.visible
		%AlertLabel.visible = false
