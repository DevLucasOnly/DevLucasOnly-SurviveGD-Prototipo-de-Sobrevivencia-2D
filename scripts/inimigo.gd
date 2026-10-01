extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer # Nova referência

@export var velocidade_base: float = 120.0
@export var vida_maxima: int = 3

var alvo: Node2D
var vida_atual: int

func _ready() -> void:
	vida_atual = vida_maxima
	alvo = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta: float) -> void:
	if alvo and GameManager.humanidade_atual > 0.0:
		# Lógica de escalonamento: Aumenta a velocidade progressivamente
		var escalonamento_temporal = 1.0 + (GameManager.tempo_sobrevivencia * 0.005) # +0.5% por segundo
		var velocidade_atual = velocidade_base * escalonamento_temporal * GameManager.multiplicador_dificuldade
		
		var direcao = global_position.direction_to(alvo.global_position)
		velocity = direcao * velocidade_atual
		move_and_slide()
		
		if velocity != Vector2.ZERO:
			acionar_som_sfx()
			atualizar_direcao_visual()
	else:
		velocity = Vector2.ZERO
		sfx_player.stop()

func atualizar_direcao_visual() -> void:
	# Define a animação com base no eixo dominante da velocidade
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			anim.play("right")
		else:
			anim.play("left")
	elif velocity.y > 0:
		anim.play("down")
	else:
		anim.play("up")

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

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		if body.has_method("receber_dano"):
			body.receber_dano(1)