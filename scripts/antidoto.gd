extends Area2D

@export var cura_valor: float = 30.0
@onready var sfx_coletar: AudioStreamPlayer2D = $SfxColetar

func _ready() -> void:
	sfx_coletar.finished.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Oculta o sprite e desativa a colisão imediatamente
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		
		GameManager.restaurar_humanidade(cura_valor)
		print("Antídoto coletado. Cura enviada: ", cura_valor)
		
		sfx_coletar.play()
