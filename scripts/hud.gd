extends CanvasLayer

@onready var barra_humanidade: ProgressBar = $BarraHumanidade
@onready var tempo_label: Label = $TempoLabel

func _ready() -> void:
	# Inicializa Barra
	barra_humanidade.max_value = GameManager.humanidade_maxima
	barra_humanidade.value = GameManager.humanidade_atual
	
	# Conexões restritas ao funcionamento do HUD
	GameManager.humanidade_alterada.connect(_atualizar_barra)
	GameManager.tempo_atualizado.connect(_atualizar_tempo)

func _atualizar_barra(valor: float) -> void:
	barra_humanidade.value = valor

func _atualizar_tempo(tempo_segundos: int) -> void:
	# Formata e atualiza o relógio
	var minutos = int(tempo_segundos / 60.0) 
	var segundos = tempo_segundos % 60
	tempo_label.text = "%02d:%02d" % [minutos, segundos]
