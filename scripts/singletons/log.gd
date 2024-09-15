extends Node

var nome_aluno: String
var num_acertos: int
var num_erros: int
var tempo_total_jogo: float
var tempo_por_fase: Array

const log_dir: String = "user://log_atividade"

func _ready():
	if not DirAccess.dir_exists_absolute(log_dir):
		DirAccess.make_dir_absolute(log_dir)

func save_log() -> void:
	var json_file: Dictionary = {
		"nome_do_aluno": nome_aluno,
		"num_acertos": num_acertos,
		"num_erros": num_erros,
		"tempo_total_jogo": tempo_total_jogo,
		"tempo_por_fase": tempo_por_fase
	}

	var log_path = log_dir + "/" + nome_aluno.replace(" ", "_") + "_log.json"

	JsonSaver.write_json_file(log_path, json_file)
