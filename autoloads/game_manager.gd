extends Node

signal humanidade_alterada(novo_valor: float)
signal vida_alterada(novo_valor: int) # Novo sinal para a UI dos corações
signal tempo_atualizado(novo_tempo: int)
signal game_over

var humanidade_maxima: float = 100.0
var humanidade_atual: float = 100.0
var tempo_sobrevivencia: float = 0.0
var taxa_decaimento: float = 5.0 # Perda por segundo

# Variáveis de Vida
var vida_maxima: int = 3
var vida_atual: int = 3

var high_score: int = 0
const SAVE_PATH: String = "user://highscore.save"

var jogo_ativo: bool = true # Controla se o jogo está a correr

func _ready() -> void:
	humanidade_atual = humanidade_maxima
	vida_atual = vida_maxima
	carregar_high_score()

func _process(delta: float) -> void:
	if not jogo_ativo:
		return

	if humanidade_atual > 0.0:
		# Lógica de decaimento contínuo
		humanidade_atual -= taxa_decaimento * delta
		humanidade_alterada.emit(humanidade_atual)
		
		# Incremento do score de tempo
		tempo_sobrevivencia += delta
		tempo_atualizado.emit(int(tempo_sobrevivencia))
		
		# Verifica se a humanidade zerou
		if humanidade_atual <= 0.0:
			humanidade_atual = 0.0
			encerrar_jogo()

# Nova função para deduzir vida independentemente da humanidade
func aplicar_dano_jogador(quantidade: int) -> void:
	if not jogo_ativo:
		return
		
	vida_atual -= quantidade
	vida_alterada.emit(vida_atual)
	
	if vida_atual <= 0:
		vida_atual = 0
		encerrar_jogo()

# Centraliza a lógica de Game Over para ser acionada por vida ou humanidade
func encerrar_jogo() -> void:
	jogo_ativo = false
	set_process(false)
	
	var tempo_inteiro = int(tempo_sobrevivencia)
	if tempo_inteiro > high_score:
		high_score = tempo_inteiro
		salvar_high_score()
		
	print("[DEBUG] GameManager emitiu game_over")
	game_over.emit()

func restaurar_humanidade(quantidade: float) -> void:
	if jogo_ativo and humanidade_atual > 0.0:
		humanidade_atual = clamp(humanidade_atual + quantidade, 0.0, humanidade_maxima)
		humanidade_alterada.emit(humanidade_atual)

func resetar_estado() -> void:
	humanidade_atual = humanidade_maxima
	vida_atual = vida_maxima
	tempo_sobrevivencia = 0.0
	jogo_ativo = true
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