extends Control

@onready var master_slider: HSlider = $TextureRect/MarginContainer/VBoxContainer/MasterSlider
@onready var bgm_slider: HSlider = $TextureRect/MarginContainer/VBoxContainer/BGMSlider
@onready var fullscreen_btn: CheckButton = $TextureRect/MarginContainer/VBoxContainer/FullscreenBtn
@onready var dificuldade_btn: OptionButton = $TextureRect/MarginContainer/VBoxContainer/DificuldadeBtn

var master_bus_index: int
var bgm_bus_index: int
var dificuldade_atual: int = 1 # 0 = Fácil, 1 = Normal, 2 = Difícil

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	
	# 1. Inicializa o estado visual do botão de ecrã inteiro
	var modo_atual = DisplayServer.window_get_mode()
	fullscreen_btn.button_pressed = (modo_atual == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# 2. Preenche os níveis de dificuldade no OptionButton
	dificuldade_btn.clear()
	dificuldade_btn.add_item("Fácil", 0)
	dificuldade_btn.add_item("Normal", 1)
	dificuldade_btn.add_item("Difícil", 2)
	dificuldade_btn.selected = dificuldade_atual

# --- SINAIS DE ÁUDIO ---
func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_index, linear_to_db(value))

# --- SINAL DO ECRÃ INTEIRO ---
func _on_fullscreen_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# --- SINAL DA DIFICULDADE ---
func _on_dificuldade_btn_item_selected(index: int) -> void:
	dificuldade_atual = index
	# Futuramente, isto será gravado no ficheiro e lido pelo GameManager
	print("Dificuldade selecionada: ", index)

func _on_voltar_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") 
