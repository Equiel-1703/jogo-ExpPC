extends Node

var nome_aluno: String
var num_acertos: int
var num_erros: int
var tempo_total_jogo_sec: float
var tempo_por_fase_sec: Dictionary

const log_dir: String = "user://log_atividade"
var _log_file_access: FileAccess

func _ready():
	if not DirAccess.dir_exists_absolute(log_dir):
		DirAccess.make_dir_absolute(log_dir)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Log> Quitting application. Closing log file.")
		
		# Close log file
		if self._log_file_access and self._log_file_access.is_open():
			self._log_file_access.close()
	
		# Quit the game
		get_tree().quit()

func _get_json_dictionary() -> Dictionary:
	return {
		"nome_do_aluno": nome_aluno,
		"num_acertos": num_acertos,
		"num_erros": num_erros,
		"tempo_total_jogo_sec": tempo_total_jogo_sec,
		"tempo_por_fase_sec": tempo_por_fase_sec
	}

func _setup_empty_log() -> void:
	nome_aluno = ""
	num_acertos = 0
	num_erros = 0
	tempo_total_jogo_sec = 0.0
	tempo_por_fase_sec = {}

func add_tempo_por_fase(nivel: int, fase: int, tempo: float) -> void:
	var key = str(nivel) + "-" + str(fase)

	tempo_por_fase_sec[key] = tempo

	tempo_total_jogo_sec += tempo

## Create log file with default values
func create_empty_log_file(new_nome_aluno: String) -> void:
	# Initialize log data with default values
	_setup_empty_log()

	# Update student name
	self.nome_aluno = new_nome_aluno

	# Create log data dictionary
	var json_data: Dictionary = _get_json_dictionary()

	# Create log file path
	var log_path = log_dir + "/" + self.nome_aluno.replace(" ", "_") + "_log.json"

	# Create log file and store the FileAccess object
	self._log_file_access = JsonSaver.create_json_file(log_path, json_data)

## Update log file with current values
func update_log() -> void:
	var json_data: Dictionary = _get_json_dictionary()

	JsonSaver.update_json_file(self._log_file_access, json_data)
