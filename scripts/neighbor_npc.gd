extends Interactable
class_name NeighborNPC

## NPC vecino que puede pedir favores y dar recompensas
## Usa burbujas de diálogo 3D con palabras clickeables

signal dialogue_started(npc: NeighborNPC)
signal quest_completed(npc: NeighborNPC, reward: int)
signal word_lookup_requested(category: String, key: String)

@export var npc_name := "Vecino"
@export var has_quest := false
@export var quest_reward := 500

@onready var dialogue_bubble: DialogueBubble3D = $DialogueBubble3D

# Estructura: [{text: "...", words: [{word: "りんご", category: "food", key: "apple"}]}]
var dialogue_lines: Array[Dictionary] = []
var current_dialogue_index := 0

func _ready() -> void:
	super._ready()
	interaction_text = "[E] Hablar con %s" % npc_name

	# Configurar diálogos por defecto con palabras del diccionario
	if dialogue_lines.is_empty():
		dialogue_lines = [
			{
				"text": "Hola! ¿Necesitas ayuda con algo?",
				"words": []
			},
			{
				"text": "Si quieres puedo enseñarte algunas palabras básicas.",
				"words": []
			},
			{
				"text": "¡Buena suerte aprendiendo el idioma!",
				"words": []
			}
		]

	# Conectar señales de la burbuja
	if dialogue_bubble:
		dialogue_bubble.word_clicked.connect(_on_word_clicked)
		dialogue_bubble.bubble_closed.connect(_on_bubble_closed)

func _on_interact(player: Player) -> void:
	if dialogue_bubble and not dialogue_bubble.visible:
		print("💬 Hablando con %s" % npc_name)
		dialogue_started.emit(self)
		current_dialogue_index = 0
		_show_next_dialogue()
	else:
		# Si ya está hablando, avanzar al siguiente diálogo
		_show_next_dialogue()

func _show_next_dialogue() -> void:
	if current_dialogue_index < dialogue_lines.size():
		var line_data = dialogue_lines[current_dialogue_index]
		var text = line_data.get("text", "")
		var words = line_data.get("words", [])

		print("  %s: %s" % [npc_name, text])
		dialogue_bubble.show_dialogue(text, words)
		current_dialogue_index += 1
	else:
		_end_dialogue()

func _end_dialogue() -> void:
	current_dialogue_index = 0
	dialogue_bubble.hide_bubble()
	print("💬 Fin de la conversación")

	if has_quest:
		_complete_quest()

func _on_bubble_closed() -> void:
	_end_dialogue()

func _on_word_clicked(word_data: Dictionary) -> void:
	"""Cuando se hace click en una palabra de la burbuja"""
	var category = word_data.get("category", "")
	var key = word_data.get("key", "")
	if not category.is_empty() and not key.is_empty():
		word_lookup_requested.emit(category, key)

func _complete_quest() -> void:
	print("✅ ¡Favor completado! Recompensa: %d" % quest_reward)
	quest_completed.emit(self, quest_reward)
	has_quest = false

func set_dialogue(lines: Array[Dictionary]) -> void:
	"""
	Establece los diálogos del NPC
	Formato: [{text: "Hola りんご", words: [{word: "りんご", category: "food", key: "apple"}]}, ...]
	"""
	dialogue_lines = lines

func set_quest(reward: int, quest_dialogue: Array[Dictionary]) -> void:
	has_quest = true
	quest_reward = reward
	if not quest_dialogue.is_empty():
		dialogue_lines = quest_dialogue

func add_word_to_current_dialogue(word: String, category: String, key: String) -> void:
	"""Helper para agregar palabras clickeables al último diálogo"""
	if dialogue_lines.is_empty():
		return
	var last_dialogue = dialogue_lines[-1]
	if not last_dialogue.has("words"):
		last_dialogue["words"] = []
	last_dialogue["words"].append({
		"word": word,
		"category": category,
		"key": key
	})
