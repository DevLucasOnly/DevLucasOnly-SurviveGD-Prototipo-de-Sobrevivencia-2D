extends Control

@onready var btn_jogar = $BotoesContainer/BtnJogar
@onready var btn_opcoes = $BotoesContainer/BtnOpcoes
@onready var btn_sair = $BotoesContainer/BtnSair

func _on_btn_jogar_pressed() -> void:
	GameManager.resetar_estado()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_btn_opcoes_pressed() -> void:
	print("[DEBUG] Abrir ecrã de opções")

func _on_btn_sair_pressed() -> void:
	get_tree().quit()

func _on_btn_jogar_mouse_entered() -> void:
	btn_jogar.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_jogar_mouse_exited() -> void:
	btn_jogar.modulate = Color(1, 1, 1)

func _on_btn_opcoes_mouse_entered() -> void:
	btn_opcoes.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_opcoes_mouse_exited() -> void:
	btn_opcoes.modulate = Color(1, 1, 1)

func _on_btn_sair_mouse_entered() -> void:
	btn_sair.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_sair_mouse_exited() -> void:
	btn_sair.modulate = Color(1, 1, 1)
