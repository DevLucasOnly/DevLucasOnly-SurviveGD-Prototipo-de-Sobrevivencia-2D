extends CanvasModulate

@export var cor_dia: Color = Color.WHITE
@export var cor_noite: Color = Color("1a1a2e") # Azul noturno/cinza chumbo
@export var tempo_espera_segundos: float = 60.0
@export var tempo_transicao_segundos: float = 10.0

func _ready() -> void:
	# Garante que o jogo começa com iluminação total
	self.color = cor_dia
	_iniciar_anoitecer()

func _iniciar_anoitecer() -> void:
	# Aguarda 1 minuto de jogo
	await get_tree().create_timer(tempo_espera_segundos, false).timeout
	
	# Cria a interpolação suave da cor atual para a cor noturna
	var tween = create_tween()
	tween.tween_property(self, "color", cor_noite, tempo_transicao_segundos)