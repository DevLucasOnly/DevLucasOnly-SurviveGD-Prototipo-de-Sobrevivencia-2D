extends Area2D

@export var speed: float = 600.0
@export var damage: int = 1
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# --- NOVO: Deteta dano através da Hitbox (Area2D) ---
func _on_area_entered(area: Area2D) -> void:
	var entidade = area.get_parent() # Acede ao nó raiz (CharacterBody2D) que contém o script
	
	if entidade and entidade.name != "Player" and entidade.has_method("receber_dano"):
		entidade.receber_dano(damage)
		queue_free()

# --- ATUALIZADO: Serve apenas para destruir o tiro no cenário físico ---
func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		queue_free() 

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()