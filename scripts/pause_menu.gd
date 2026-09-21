extends CanvasLayer

@onready var fundo: ColorRect = $ColorRect
@onready var btn_continuar: Button = $ColorRect/BtnContinuar
@onready var btn_sair: Button = $ColorRect/BtnSair

func _ready() -> void:
	fundo.hide()
	btn_continuar.pressed.connect(_on_continuar_pressed)
	btn_sair.pressed.connect(_on_sair_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): # Tecla ESC por padrão
		alternar_pausa()

func alternar_pausa() -> void:
	var novo_estado = not get_tree().paused
	get_tree().paused = novo_estado
	fundo.visible = novo_estado

func _on_continuar_pressed() -> void:
	alternar_pausa()

func _on_sair_pressed() -> void:
	get_tree().paused = false
	GameManager.resetar_estado() # Garante que as variáveis de humanidade sejam reiniciadas
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")