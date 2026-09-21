extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@export var velocidade: float = 120.0
var alvo: Node2D

func _ready() -> void:
	alvo = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta: float) -> void:
	if alvo and GameManager.humanidade_atual > 0.0:
		var direcao = global_position.direction_to(alvo.global_position)
		velocity = direcao * velocidade
		move_and_slide()
		
		# Gatilho: Toca o som de movimento enquanto possui velocidade
		if velocity != Vector2.ZERO:
			acionar_som_sfx()
	else:
		velocity = Vector2.ZERO
		# Para o som imediatamente se o inimigo parar de se mover
		sfx_player.stop()

func acionar_som_sfx() -> void:
	if not sfx_player.playing:
		sfx_player.play()