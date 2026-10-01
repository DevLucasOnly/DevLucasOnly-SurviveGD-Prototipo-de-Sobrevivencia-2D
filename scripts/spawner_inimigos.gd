extends Node2D

@export var inimigo_cena: PackedScene
@export var wait_time_base: float = 3.0
@export var wait_time_minimo: float = 0.5

@onready var timer_spawn: Timer = $TimerSpawn
@onready var pontos_spawn: Node2D = $PontosSpawn

func _ready() -> void:
	timer_spawn.timeout.connect(_gerar_inimigo)

func _process(_delta: float) -> void:
	if not GameManager.jogo_ativo:
		if not timer_spawn.is_stopped():
			timer_spawn.stop()
		return
	elif timer_spawn.is_stopped():
		timer_spawn.start()

	# Lógica da Issue 20: Redução do intervalo proporcional ao tempo e dificuldade
	var reducao = GameManager.tempo_sobrevivencia * 0.02 * GameManager.multiplicador_dificuldade
	var novo_wait_time = wait_time_base - reducao
	
	# Aplica o tempo com limite de segurança
	timer_spawn.wait_time = clamp(novo_wait_time, wait_time_minimo, wait_time_base)

func _gerar_inimigo() -> void:
	if inimigo_cena == null:
		print("[ERRO] Cena do inimigo não atribuída no Spawner.")
		return
		
	var marcadores = pontos_spawn.get_children()
	if marcadores.is_empty():
		return
		
	var marcador_escolhido = marcadores.pick_random()
	var novo_inimigo = inimigo_cena.instantiate()
	
	novo_inimigo.global_position = marcador_escolhido.global_position
	# Adiciona o inimigo à cena principal (world), não ao spawner
	get_tree().current_scene.add_child(novo_inimigo)