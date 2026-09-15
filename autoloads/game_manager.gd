extends Node

signal humanidade_alterada(novo_valor: float)
signal tempo_atualizado(novo_tempo: int)
signal game_over

var humanidade_maxima: float = 100.0
var humanidade_atual: float = 100.0
var tempo_sobrevivencia: float = 0.0
var taxa_decaimento: float = 5.0 # Perda por segundo

func _ready() -> void:
	humanidade_atual = humanidade_maxima

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
