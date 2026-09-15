extends Area2D

@export var cura_valor: float = 30.0

# Esta função será chamada automaticamente pelo sinal 'body_entered'
func _on_body_entered(body: Node2D) -> void:
	# Verifica se a entidade colidida é o jogador
	if body.name == "Player":
		# Envia o valor da cura para o script global gerenciar
		GameManager.restaurar_humanidade(cura_valor)
		
		# Opcional: print para depuração no console
		print("Antídoto coletado. Cura enviada: ", cura_valor)
		
		# Remove o item da árvore de cenas e libera a memória
		queue_free()
