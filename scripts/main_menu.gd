extends Control

## Menú principal del juego

func _ready() -> void:
	print("📋 Menú principal cargado")

func _on_start_button_pressed() -> void:
	print("🎮 Iniciando nuevo juego...")
	get_tree().change_scene_to_file("res://scenes/home/apartment.tscn")

func _on_quit_button_pressed() -> void:
	print("👋 Saliendo del juego...")
	get_tree().quit()
