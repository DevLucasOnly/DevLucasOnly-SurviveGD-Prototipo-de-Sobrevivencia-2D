extends Node2D

@export var antidoto_cena: PackedScene

@onready var spawn_points: Node2D = $SpawnPoints
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	# Conecta o sinal de timeout do Timer à função de geração
	spawn_timer.timeout.connect(_gerar_antidoto)

func _gerar_antidoto() -> void:
	# Coleta todos os nós Marker2D filhos
	var marcadores = spawn_points.get_children()
	
	if marcadores.is_empty():
		return
		
	# Sorteia um marcador aleatório da lista
	var marcador_escolhido = marcadores.pick_random()
	
	# Instancia a cena do antídoto e define a posição
	var novo_antidoto = antidoto_cena.instantiate()
	novo_antidoto.global_position = marcador_escolhido.global_position
	
	# Adiciona o item na árvore da cena principal
	add_child(novo_antidoto)
