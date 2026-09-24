extends CanvasLayer

@onready var barra_humanidade: ProgressBar = $BarraHumanidade
@onready var tempo_label: Label = $TempoLabel
@onready var painel_game_over: TextureRect = $PainelGameOver

@onready var label_score_atual: Label = $LabelScoreAtual
@onready var label_high_score: Label = $LabelHighScore
@onready var btn_tente_novamente: TextureButton = $PainelGameOver/VBoxContainer/BtnTenteNovamente
@onready var btn_sair: TextureButton = $PainelGameOver/VBoxContainer/BtnSair

func _ready() -> void:
	painel_game_over.hide()
	barra_humanidade.max_value = GameManager.humanidade_maxima
	barra_humanidade.value = GameManager.humanidade_atual
	
	# Estes sinais pertencem ao GameManager e devem permanecer aqui
	GameManager.humanidade_alterada.connect(_atualizar_barra)
	GameManager.tempo_atualizado.connect(_atualizar_tempo)
	GameManager.game_over.connect(_exibir_game_over)
	
	# As linhas .connect() dos botões foram removidas para evitar o conflito de duplicação

func _atualizar_barra(valor: float) -> void:
	barra_humanidade.value = valor

func _atualizar_tempo(tempo_segundos: int) -> void:
	var minutos = int(tempo_segundos / 60.0) 
	var segundos = tempo_segundos % 60
	tempo_label.text = "%02d:%02d" % [minutos, segundos]

func _exibir_game_over() -> void:
	painel_game_over.show()
	label_score_atual.text = "SCORE ATUAL: " + str(int(GameManager.tempo_sobrevivencia))
	label_high_score.text = "HIGH SCORE: " + str(GameManager.high_score)
	get_tree().paused = true 

# --- Ações de Clique ---
func _on_btn_tente_novamente_pressed() -> void:
	get_tree().paused = false
	GameManager.resetar_estado()
	get_tree().reload_current_scene()

func _on_btn_sair_pressed() -> void:
	get_tree().paused = false
	GameManager.resetar_estado()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# --- Feedback Visual (Hover) ---
func _on_btn_tente_novamente_mouse_entered() -> void:
	btn_tente_novamente.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_tente_novamente_mouse_exited() -> void:
	btn_tente_novamente.modulate = Color(1, 1, 1)

func _on_btn_sair_mouse_entered() -> void:
	btn_sair.modulate = Color(0.7, 0.7, 0.7)

func _on_btn_sair_mouse_exited() -> void:
	btn_sair.modulate = Color(1, 1, 1)
