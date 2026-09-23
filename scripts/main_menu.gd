extends Control

func _ready() -> void:
	$BtnJogar.pressed.connect(_on_jogar_pressed)

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
