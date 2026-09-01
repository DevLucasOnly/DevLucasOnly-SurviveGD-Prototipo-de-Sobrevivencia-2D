extends Area2D

@export var cura_valor: float = 30.0

# Esta função será chamada automaticamente pelo sinal 'body_entered'
func _on_body_entered(body: Node2D) -> void:
	# Verifica se a entidade colidida possui a propriedade 'humanidade'
	if "humanidade" in body:
		# Soma o valor da cura, garantindo que não ultrapasse o limite de 100
		body.humanidade = min(body.humanidade + cura_valor, 100.0)
		
		# Opcional: print para depuração no console
		print("Antidoto coletado. Humanidade atual: ", body.humanidade)
		
		# Remove o item da árvore de cenas e libera a memória
		queue_free()
