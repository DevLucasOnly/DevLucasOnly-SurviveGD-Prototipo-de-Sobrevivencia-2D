extends CharacterBody2D

@export var speed: float = 300.0
@export var humanidade: float = 100.0
@export var taxa_decaimento: float = 5.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if humanidade > 0.0:
		humanidade -= taxa_decaimento * delta
		
		if humanidade <= 0.0:
			humanidade = 0.0
			anim.play("idle")
			return 

		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
		
		# Controle de Animação
		if velocity != Vector2.ZERO:
			anim.play("walk")
			# Inverte o sprite horizontalmente se estiver indo para a esquerda
			if velocity.x != 0:
				sprite.flip_h = velocity.x < 0
		else:
			anim.play("idle")
			
		move_and_slide()
