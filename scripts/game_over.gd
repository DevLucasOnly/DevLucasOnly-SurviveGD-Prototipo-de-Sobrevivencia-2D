extends CanvasLayer

@onready var painel: TextureRect = $PainelGameOver
@onready var label_score: Label = $PainelGameOver/VBoxContainer/ContainerScores/LabelScoreAtual
@onready var label_high_score: Label = $PainelGameOver/VBoxContainer/ContainerScores/LabelHighScore
@onready var btn_restart: TextureButton = $PainelGameOver/VBoxContainer/BtnTenteNovamente
@onready var btn_sair: TextureButton = $PainelGameOver/VBoxContainer/BtnSair

func _ready() -> void:
	painel.hide()
	GameManager.game_over.connect(_acionar_game_over)
	
	# Ligações de clique
	btn_restart.pressed.connect(_reiniciar)
	btn_sair.pressed.connect(_ir_para_menu)
	
	# Ligações de feedback visual (hover)
	btn_restart.mouse_entered.connect(_on_btn_restart_hover_in)
	btn_restart.mouse_exited.connect(_on_btn_restart_hover_out)
	btn_sair.mouse_entered.connect(_on_btn_sair_hover_in)
	btn_sair.mouse_exited.connect(_on_btn_sair_hover_out)

func _acionar_game_over() -> void:
	painel.show()
	label_score.text = "SCORE ATUAL: " + str(int(GameManager.tempo_sobrevivencia))
	label_high_score.text = "HIGH SCORE: " + str(GameManager.high_score)
	get_tree().paused = true

# --- Ações de Clique ---
func _reiniciar() -> void:
	get_tree().paused = false
	GameManager.resetar_estado()
	get_tree().reload_current_scene()

func _ir_para_menu() -> void:
	get_tree().paused = false
	GameManager.resetar_estado()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# --- Feedback Visual (Hover) ---
func _on_btn_restart_hover_in() -> void:
	btn_restart.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_restart_hover_out() -> void:
	btn_restart.modulate = Color(1, 1, 1)

func _on_btn_sair_hover_in() -> void:
	btn_sair.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_sair_hover_out() -> void:
	btn_sair.modulate = Color(1, 1, 1)
