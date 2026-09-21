extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Ignora o próprio jogador; requer que o inimigo tenha o método 'receber_dano'
	if body.name != "Player" and body.has_method("receber_dano"):
		body.receber_dano(damage)
		queue_free()
	# Destrói a bala se bater em paredes (StaticBody2D ou TileMapLayer)
	elif not body.name == "Player":
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()