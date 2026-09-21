extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var sprite: Sprite2D = $Sprite2D # Certifique-se de que o nó da imagem se chama exatamente "Sprite2D"

@export var velocidade: float = 120.0
@export var vida_maxima: int = 3

var alvo: Node2D
var vida_atual: int

func _ready() -> void:
	vida_atual = vida_maxima
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

func receber_dano(quantidade: int) -> void:
	vida_atual -= quantidade
	
	if vida_atual <= 0:
		morrer()
	else:
		piscar_dano()

func piscar_dano() -> void:
	if sprite:
		# Altera a cor do sprite temporariamente para branco intenso
		sprite.modulate = Color(10, 10, 10) 
		await get_tree().create_timer(0.1, false).timeout
		
		# Verifica se o inimigo ainda existe antes de reverter a cor
		if is_instance_valid(sprite):
			sprite.modulate = Color(1, 1, 1)

func morrer() -> void:
	queue_free()