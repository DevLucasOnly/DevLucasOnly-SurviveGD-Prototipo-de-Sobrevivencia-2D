extends CanvasLayer

@onready var barra_humanidade: TextureProgressBar = $BarraHumanidade
@onready var barra_vida: TextureProgressBar = $BarraVida
@onready var tempo_label: Label = $TempoLabel

func _ready() -> void:
	# Inicializa Humanidade
	barra_humanidade.max_value = GameManager.humanidade_maxima
	barra_humanidade.value = GameManager.humanidade_atual
	GameManager.humanidade_alterada.connect(_atualizar_humanidade)
	
	# Inicializa Vida
	barra_vida.max_value = GameManager.vida_maxima
	barra_vida.value = GameManager.vida_atual
	GameManager.vida_alterada.connect(_atualizar_vida)
	
	# Inicializa Tempo
	GameManager.tempo_atualizado.connect(_atualizar_tempo)

func _atualizar_humanidade(valor: float) -> void:
	barra_humanidade.value = valor

# CORREÇÃO: O parâmetro 'valor' agora é int, correspondendo ao sinal do GameManager
func _atualizar_vida(valor: int) -> void:
	barra_vida.value = valor

func _atualizar_tempo(tempo_segundos: int) -> void:
	var minutos = int(tempo_segundos / 60.0) 
	var segundos = tempo_segundos % 60
	tempo_label.text = "%02d:%02d" % [minutos, segundos]