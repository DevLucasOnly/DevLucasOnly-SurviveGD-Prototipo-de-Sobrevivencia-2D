extends CharacterBody2D

enum Estado {IDLE, MOVE, DEAD}
var estado_atual: Estado = Estado.IDLE

@export var speed: float = 300.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D

var shake_intensity: float = 0.0
const SHAKE_DECAY: float = 10.0

func _ready() -> void:
	# Conecta os sinais do Autoload às funções locais
	GameManager.humanidade_alterada.connect(_on_humanidade_alterada)
	GameManager.game_over.connect(_on_game_over)

func _process(delta: float) -> void:
	# Controle do decaimento do Camera Shake
	if shake_intensity > 0:
		shake_intensity = lerpf(shake_intensity, 0.0, SHAKE_DECAY * delta)
		camera.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake_intensity
	else:
		camera.offset = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	match estado_atual:
		Estado.IDLE:
			_estado_idle()
		Estado.MOVE:
			_estado_move()
		Estado.DEAD:
			_estado_dead()
	
	move_and_slide()
	
	# Gatilho temporário para validação da Issue #11
	if Input.is_action_just_pressed("ui_accept"):
		acionar_feedback_dano()

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

func acionar_feedback_dano() -> void:
	# Aplica Camera Shake
	shake_intensity = 15.0
	
	# Aplica Freeze Frame
	Engine.time_scale = 0.0
	await get_tree().create_timer(0.05, true, false, true).timeout
	Engine.time_scale = 1.0

func _on_humanidade_alterada(_valor: float) -> void:
	pass 

func _on_game_over() -> void:
	estado_atual = Estado.DEAD