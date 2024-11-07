# This is the generic version of this screen
extends CriarPath

var _reading_path_size: bool

const _invalid_int_alert: String = "Por favor, insira um tamanho de rota válido!"
const _invalid_negative_alert: String = "Por favor, insira um tamanho de rota positivo!"
const _route_too_big: String = "O tamanho máximo de uma rota é 30!"

func show_path_menu(_new_path_lenght: int):
	_path_menu_basic_setup(GlobalGameData.tutorial_phase_normal)

	# We will read the path size first
	_reading_path_size = true

	# Hide path buttons
	%PathButtons.visible = false

	# Show the path size text field
	%TamRotaLineField.text = ""
	%TamRotaLineField.visible = true

	# Hide alert label
	%AlertLabel.visible = false

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
		# The parent class implements exactly what we need to do here
		super._on_ok_pressed()
		return
	
	# If the path size is empty, return
	if %TamRotaLineField.text == "":
		return

	# Check if the path size is a valid integer
	if not %TamRotaLineField.text.is_valid_int():
		_show_alert(_invalid_int_alert)
		return

	# Get the path size from the text field
	_new_path_len = %TamRotaLineField.text.to_int()

	# Check if the path size is valid
	if _new_path_len <= 0:
		_show_alert(_invalid_negative_alert)
		return
	if _new_path_len > GlobalGameData.MAX_PATH_LENGTH:
		_show_alert(_route_too_big)
		return

	# Clear buttons (if any)
	_clear_buttons()
	
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
