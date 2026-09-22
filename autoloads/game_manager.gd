extends Node

signal humanidade_alterada(novo_valor: float)
signal tempo_atualizado(novo_tempo: int)
signal game_over

var humanidade_maxima: float = 100.0
var humanidade_atual: float = 100.0
var tempo_sobrevivencia: float = 0.0
var taxa_decaimento: float = 5.0 # Perda por segundo

var high_score: int = 0
const SAVE_PATH: String = "user://highscore.save"

func _ready() -> void:
	humanidade_atual = humanidade_maxima
	carregar_high_score()

func _process(delta: float) -> void:
	if humanidade_atual > 0.0:
		# Lógica de decaimento contínuo
		humanidade_atual -= taxa_decaimento * delta
		humanidade_alterada.emit(humanidade_atual)
		
		# Incremento do score de tempo
		tempo_sobrevivencia += delta
		tempo_atualizado.emit(int(tempo_sobrevivencia))
	elif humanidade_atual <= 0.0:
		humanidade_atual = 0.0
		
		# Validação do High Score
		var tempo_inteiro = int(tempo_sobrevivencia)
		if tempo_inteiro > high_score:
			high_score = tempo_inteiro
			salvar_high_score()
			
		print("[DEBUG] GameManager emitiu game_over")
		game_over.emit()
		set_process(false) # Interrompe o loop ao zerar a humanidade

# Função pública para ser chamada pelos Antídotos
func restaurar_humanidade(quantidade: float) -> void:
	if humanidade_atual > 0.0:
		humanidade_atual = clamp(humanidade_atual + quantidade, 0.0, humanidade_maxima)
		humanidade_alterada.emit(humanidade_atual)

func resetar_estado() -> void:
	humanidade_atual = humanidade_maxima
	tempo_sobrevivencia = 0.0
	set_process(true)

func salvar_high_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(high_score)
		file.close()
		print("[DEBUG] High Score salvo: ", high_score)

func carregar_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			high_score = file.get_32()
			file.close()
			print("[DEBUG] High Score carregado: ", high_score)