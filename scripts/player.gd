extends CharacterBody2D

@export var speed: float = 300.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Conecta o sinal do Autoload a uma função local para validação
	GameManager.humanidade_alterada.connect(_on_humanidade_alterada)

func _physics_process(_delta: float) -> void:
	# Verifica o estado no script global
	if GameManager.humanidade_atual > 0.0:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
		
		# Controle de Animação
		if velocity != Vector2.ZERO:
			anim.play("walk")
			if velocity.x != 0:
				sprite.flip_h = velocity.x < 0
		else:
			anim.play("idle")
			pass
	else:
		# Bloqueia a movimentação e força animação base caso a energia zere
		velocity = Vector2.ZERO
		anim.play("idle")
		
	move_and_slide()

func _on_humanidade_alterada(valor: float) -> void:
	print("Humanidade: ", valor)
