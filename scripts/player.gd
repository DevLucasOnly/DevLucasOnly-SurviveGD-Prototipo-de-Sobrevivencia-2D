extends CharacterBody2D

@export var speed: float = 300.0
@export var humanidade: float = 100.0
@export var taxa_decaimento: float = 5.0

func _physics_process(delta: float) -> void:
	# 1. Verifica estado vital
	if humanidade > 0.0:
		# 2. Aplica o decaimento contínuo baseado no tempo (delta)
		humanidade -= taxa_decaimento * delta
		
		# 3. Trava o movimento imediatamente se zerar
		if humanidade <= 0.0:
			humanidade = 0.0
			print("Humanidade esgotada. Movimento bloqueado.")
			return 

		# 4. Cálculo vetorial normalizado (executado apenas se humanidade > 0)
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
		move_and_slide()
