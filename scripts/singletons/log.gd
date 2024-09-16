extends Node

var nome_aluno: String
var num_acertos: int
var num_erros: int
var tempo_total_jogo_sec: float
var tempo_por_fase_sec: Dictionary

const log_dir: String = "user://log_atividade"

func _ready():
	if not DirAccess.dir_exists_absolute(log_dir):
		DirAccess.make_dir_absolute(log_dir)

func add_tempo_por_fase(nivel: int, fase: int, tempo: float) -> void:
	var key = str(nivel) + "-" + str(fase)

	tempo_por_fase_sec[key] = tempo

	tempo_total_jogo_sec += tempo

func save_log() -> void:
	var json_file: Dictionary = {
		"nome_do_aluno": nome_aluno,
		"num_acertos": num_acertos,
		"num_erros": num_erros,
		"tempo_total_jogo_sec": tempo_total_jogo_sec,
		"tempo_por_fase_sec": tempo_por_fase_sec
	}

	var log_path = log_dir + "/" + nome_aluno.replace(" ", "_") + "_log.json"

	JsonSaver.write_json_file(log_path, json_file)
