extends CanvasLayer

@onready var btn_continuar = $VBoxContainer/BtnContinuar
@onready var btn_sair = $VBoxContainer/BtnSair

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		alternar_pausa()

func alternar_pausa() -> void:
	var novo_estado = not get_tree().paused
	get_tree().paused = novo_estado
	visible = novo_estado

# --- Funcionalidade dos Botões ---
func _on_btn_continuar_pressed() -> void:
	alternar_pausa()

func _on_btn_sair_pressed() -> void:
	get_tree().paused = false # Obrigatório antes de mudar de cena
	GameManager.resetar_estado()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# --- Feedback Visual (Hover) ---
func _on_btn_continuar_mouse_entered() -> void:
	btn_continuar.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_continuar_mouse_exited() -> void:
	btn_continuar.modulate = Color(1, 1, 1)

func _on_btn_sair_mouse_entered() -> void:
	btn_sair.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_sair_mouse_exited() -> void:
	btn_sair.modulate = Color(1, 1, 1)
