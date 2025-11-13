extends Interactable
class_name Dictionary3D

## Diccionario 3D interactivo para estudiar vocabulario

signal dictionary_opened()

@export var language_file := "res://data/languages/japanese.json"
var language_data: Dictionary = {}

func _ready() -> void:
	interaction_text = "[E] Abrir diccionario"
	_load_language_data()

func _load_language_data() -> void:
	if FileAccess.file_exists(language_file):
		var file = FileAccess.open(language_file, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())

		if parse_result == OK:
			language_data = json.data
			print("📚 Diccionario cargado: ", language_data.get("display_name", "Desconocido"))
		else:
			push_error("Error parseando diccionario: " + str(parse_result))

		file.close()
	else:
		push_error("Archivo de idioma no encontrado: " + language_file)

func _on_interact(player: Player) -> void:
	print("📖 Abriendo diccionario...")
	dictionary_opened.emit()
	# TODO: Abrir UI del diccionario
	# TODO: Mostrar categorías y palabras
	# TODO: Permitir marcar favoritos

func get_word(category: String, key: String) -> Dictionary:
	if language_data.has("categories") and language_data.categories.has(category):
		return language_data.categories[category].get(key, {})
	return {}

func get_category(category_name: String) -> Dictionary:
	if language_data.has("categories"):
		return language_data.categories.get(category_name, {})
	return {}

func get_all_categories() -> Array:
	if language_data.has("categories"):
		return language_data.categories.keys()
	return []
