extends CharacterBody2D

enum Estado {IDLE, MOVE, DEAD}
var estado_atual: Estado = Estado.IDLE

@export var speed: float = 300.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Conecta os sinais do Autoload às funções locais
	GameManager.humanidade_alterada.connect(_on_humanidade_alterada)
	GameManager.game_over.connect(_on_game_over)

func _physics_process(_delta: float) -> void:
	match estado_atual:
		Estado.IDLE:
			_estado_idle()
		Estado.MOVE:
			_estado_move()
		Estado.DEAD:
			_estado_dead()
	
	move_and_slide()

func _estado_idle() -> void:
	velocity = Vector2.ZERO
	anim.play("idle")
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction != Vector2.ZERO:
		estado_atual = Estado.MOVE

func _estado_move() -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
	if velocity == Vector2.ZERO:
		estado_atual = Estado.IDLE
	else:
		anim.play("walk")
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0

func _estado_dead() -> void:
	velocity = Vector2.ZERO
	anim.play("idle")

func _on_humanidade_alterada(valor: float) -> void:
	# Mantido para debugar a humanidade, caso necessário
	pass 

func _on_game_over() -> void:
	estado_atual = Estado.DEAD