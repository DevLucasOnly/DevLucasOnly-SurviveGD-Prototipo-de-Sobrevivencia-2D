extends Control
const ARQUIVO_CONFIG = "user://settings.cfg"

@onready var master_slider: HSlider = $TextureRect/MarginContainer/VBoxContainer/MasterSlider
@onready var bgm_slider: HSlider = $TextureRect/MarginContainer/VBoxContainer/BGMSlider
@onready var fullscreen_btn: CheckButton = $TextureRect/MarginContainer/VBoxContainer/FullscreenBtn
@onready var dificuldade_btn: OptionButton = $TextureRect/MarginContainer/VBoxContainer/DificuldadeBtn
@onready var voltar_btn: TextureButton = $TextureRect/MarginContainer/VBoxContainer/VoltarBtn

var config = ConfigFile.new()
var master_bus_index: int
var bgm_bus_index: int
var dificuldade_atual: int = 1 

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	
	dificuldade_btn.clear()
	dificuldade_btn.add_item("Fácil", 0)
	dificuldade_btn.add_item("Normal", 1)
	dificuldade_btn.add_item("Difícil", 2)
	
	carregar_opcoes()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_index, linear_to_db(value))

func _on_fullscreen_btn_toggled(toggled_on: bool) -> void:
	print("[DEBUG] Sinal recebido. Modo Tela Cheia: ", toggled_on)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_dificuldade_btn_item_selected(index: int) -> void:
	dificuldade_atual = index
	print("Dificuldade selecionada: ", index)

func _on_voltar_btn_pressed() -> void:
	guardar_opcoes() 
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") 

func guardar_opcoes() -> void:
	config.set_value("Audio", "master", master_slider.value)
	config.set_value("Audio", "bgm", bgm_slider.value)
	config.set_value("Video", "fullscreen", fullscreen_btn.button_pressed)
	config.set_value("Jogo", "dificuldade", dificuldade_btn.selected)
	
	config.save(ARQUIVO_CONFIG)

func carregar_opcoes() -> void:
	var erro = config.load(ARQUIVO_CONFIG)
	if erro != OK:
		return 
	
	master_slider.value = config.get_value("Audio", "master", 0.8)
	bgm_slider.value = config.get_value("Audio", "bgm", 0.8)
	
	var modo_fullscreen = config.get_value("Video", "fullscreen", false)
	fullscreen_btn.button_pressed = modo_fullscreen
	if modo_fullscreen:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
		
	var diff = config.get_value("Jogo", "dificuldade", 1)
	dificuldade_btn.selected = diff
	dificuldade_atual = diff

# --- Feedback Visual (Hover) ---
func _on_voltar_btn_mouse_entered() -> void:
	voltar_btn.modulate = Color(0.7, 0.7, 0.7)

func _on_voltar_btn_mouse_exited() -> void:
	voltar_btn.modulate = Color(1, 1, 1)
