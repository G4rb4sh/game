extends Node3D

## Gestor de la escena del apartamento
## Conecta todos los sistemas: NPCs, diccionario, objetos interactivos

@onready var dictionary_ui: DictionaryUI = $UI/DictionaryUI
@onready var neighbor: NeighborNPC = $NPCs/Neighbor
@onready var dictionary_object: Dictionary3D = $Furniture/Dictionary
@onready var bed: Bed = $Furniture/Bed
@onready var player: Player = $Player

func _ready() -> void:
	# Conectar señales del vecino
	if neighbor:
		neighbor.word_lookup_requested.connect(_on_word_lookup_requested)
		neighbor.quest_completed.connect(_on_quest_completed)

		# Configurar un diálogo con palabras del japonés
		neighbor.set_dialogue([
			{
				"text": "こんにちは! Hola, soy Tanaka-san, tu vecino.",
				"words": [
					{"word": "こんにちは", "category": "greetings", "key": "hello"}
				]
			},
			{
				"text": "¿Quieres aprender japonés? Te puedo enseñar りんご",
				"words": [
					{"word": "りんご", "category": "food", "key": "apple"}
				]
			},
			{
				"text": "También puedo enseñarte números: いち に さん",
				"words": [
					{"word": "いち", "category": "numbers", "key": "1"},
					{"word": "に", "category": "numbers", "key": "2"},
					{"word": "さん", "category": "numbers", "key": "3"}
				]
			},
			{
				"text": "¡ありがとうございます por escuchar! Buena suerte.",
				"words": [
					{"word": "ありがとうございます", "category": "greetings", "key": "thank_you"}
				]
			}
		])

	# Conectar señales del diccionario objeto
	if dictionary_object:
		dictionary_object.dictionary_opened.connect(_on_dictionary_opened)

	# Conectar señales de la cama
	if bed:
		bed.sleep_requested.connect(_on_sleep_requested)

func _on_word_lookup_requested(category: String, key: String) -> void:
	"""Cuando se hace click en una palabra del diálogo"""
	print("📖 Buscando palabra en diccionario: %s/%s" % [category, key])
	if dictionary_ui and GameManager.language_manager:
		dictionary_ui.open_to_word(GameManager.language_manager, category, key)

func _on_dictionary_opened() -> void:
	"""Cuando se abre el diccionario desde el objeto 3D"""
	print("📚 Abriendo diccionario desde objeto")
	if dictionary_ui and GameManager.language_manager:
		dictionary_ui.open_dictionary(GameManager.language_manager)

func _on_quest_completed(npc: NeighborNPC, reward: int) -> void:
	"""Cuando se completa una misión de un vecino"""
	print("💰 Misión completada! +%d" % reward)
	if GameManager.money_manager:
		GameManager.money_manager.add_money(reward)

func _on_sleep_requested() -> void:
	"""Cuando el jugador duerme"""
	print("😴 Durmiendo...")
	if GameManager.time_manager:
		GameManager.time_manager.advance_day()
	# TODO: Fade out/in
	# TODO: Restaurar energía
