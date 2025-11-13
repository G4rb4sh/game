extends Node
class_name LanguageManager

## Gestor del sistema de idiomas y vocabulario

signal word_learned(category: String, key: String)
signal language_loaded(language_name: String)

var current_language: String = "japanese"
var language_data: Dictionary = {}
var learned_words: Dictionary = {}  # {category: {key: bool}}
var favorite_words: Array[Dictionary] = []  # [{category: "", key: ""}]

func _ready() -> void:
	load_language(current_language)

func load_language(language_name: String) -> bool:
	var file_path = "res://data/languages/%s.json" % language_name

	if not FileAccess.file_exists(file_path):
		push_error("Archivo de idioma no encontrado: " + file_path)
		return false

	var file = FileAccess.open(file_path, FileAccess.READ)
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())

	if parse_result != OK:
		push_error("Error parseando idioma: " + str(parse_result))
		file.close()
		return false

	language_data = json.data
	current_language = language_name
	file.close()

	print("🌍 Idioma cargado: ", language_data.get("display_name", "Desconocido"))
	language_loaded.emit(language_name)
	return true

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

func mark_word_learned(category: String, key: String) -> void:
	if not learned_words.has(category):
		learned_words[category] = {}

	if not learned_words[category].has(key):
		learned_words[category][key] = true
		word_learned.emit(category, key)
		print("✅ Palabra aprendida: %s/%s" % [category, key])

func is_word_learned(category: String, key: String) -> bool:
	return learned_words.has(category) and learned_words[category].has(key)

func toggle_favorite(category: String, key: String) -> void:
	var entry = {"category": category, "key": key}
	var index = favorite_words.find(entry)

	if index >= 0:
		favorite_words.remove_at(index)
		print("⭐ Removido de favoritos: %s/%s" % [category, key])
	else:
		favorite_words.append(entry)
		print("⭐ Agregado a favoritos: %s/%s" % [category, key])

func is_favorite(category: String, key: String) -> bool:
	return favorite_words.has({"category": category, "key": key})

func get_favorites() -> Array[Dictionary]:
	return favorite_words
