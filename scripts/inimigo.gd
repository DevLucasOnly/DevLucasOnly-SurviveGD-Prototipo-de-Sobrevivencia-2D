extends CharacterBody2D

@export var velocidade: float = 120.0
var alvo: Node2D

func _ready() -> void:
	# Localiza o jogador dinamicamente através do grupo
	alvo = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta: float) -> void:
	# Persegue apenas se o alvo existir e o jogo não estiver em Game Over
	if alvo and GameManager.humanidade_atual > 0.0:
		var direcao = global_position.direction_to(alvo.global_position)
		velocity = direcao * velocidade
		move_and_slide()
	else:
		velocity = Vector2.ZERO
