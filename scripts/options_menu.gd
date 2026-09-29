extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterSlider
@onready var bgm_slider: HSlider = $MarginContainer/VBoxContainer/BGMSlider
@onready var fullscreen_btn: TextureButton = $MarginContainer/VBoxContainer/FullscreenBtn
@onready var dificuldade_btn: TextureButton = $MarginContainer/VBoxContainer/DificuldadeBtn

var master_bus_index: int
var bgm_bus_index: int

# Variáveis para controlo cíclico de dificuldade
enum NivelDificuldade {FACIL, NORMAL, DIFICIL}
var dificuldade_atual: NivelDificuldade = NivelDificuldade.NORMAL

# Caminhos para as texturas de dificuldade (ajuste os caminhos conforme o seu projeto)
const TEX_FACIL = preload("res://assets/ui/dif_facil.png")
const TEX_NORMAL = preload("res://assets/ui/dif_normal.png")
const TEX_DIFICIL = preload("res://assets/ui/dif_dificil.png")

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	
	# Sincroniza o estado inicial do botão de fullscreen com o sistema operativo
	fullscreen_btn.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	_atualizar_textura_dificuldade()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_index, linear_to_db(value))

func _on_fullscreen_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_dificuldade_btn_pressed() -> void:
	# Cicla os valores: 0 -> 1 -> 2 -> 0
	dificuldade_atual = (dificuldade_atual + 1) % 3 as NivelDificuldade
	_atualizar_textura_dificuldade()

func _atualizar_textura_dificuldade() -> void:
	match dificuldade_atual:
		NivelDificuldade.FACIL:
			dificuldade_btn.texture_normal = TEX_FACIL
		NivelDificuldade.NORMAL:
			dificuldade_btn.texture_normal = TEX_NORMAL
		NivelDificuldade.DIFICIL:
			dificuldade_btn.texture_normal = TEX_DIFICIL

func _on_voltar_btn_pressed() -> void:
	queue_free()