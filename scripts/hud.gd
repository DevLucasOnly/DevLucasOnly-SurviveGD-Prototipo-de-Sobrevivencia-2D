extends CanvasLayer

@onready var barra_humanidade: ProgressBar = $BarraHumanidade
@onready var tempo_label: Label = $TempoLabel
@onready var painel_game_over: ColorRect = $PainelGameOver
@onready var botao_restart: Button = $PainelGameOver/BotaoRestart

func _ready() -> void:
	# Oculta o painel de Game Over ao iniciar
	painel_game_over.hide()
	barra_humanidade.max_value = GameManager.humanidade_maxima
	barra_humanidade.value = GameManager.humanidade_atual
	
	GameManager.humanidade_alterada.connect(_atualizar_barra)
	GameManager.tempo_atualizado.connect(_atualizar_tempo)
	
	# Conecta o sinal de derrota
	GameManager.game_over.connect(_exibir_game_over)
	
	# Conecta o clique do botão via código
	botao_restart.pressed.connect(_reiniciar_jogo)

func _atualizar_barra(valor: float) -> void:
	barra_humanidade.value = valor

func _atualizar_tempo(tempo_segundos: int) -> void:
	var minutos = tempo_segundos / 60
	var segundos = tempo_segundos % 60
	tempo_label.text = "%02d:%02d" % [minutos, segundos]

func _exibir_game_over() -> void:
	painel_game_over.show()
	get_tree().paused = true # Pausa todos os nós do jogo

func _reiniciar_jogo() -> void:
	get_tree().paused = false # Remove a pausa
	GameManager.resetar_estado() # Reseta os dados do Singleton
	get_tree().reload_current_scene() # Recarrega o mapa
