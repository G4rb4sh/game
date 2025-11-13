extends Node3D
class_name DialogueBubble3D

## Burbuja de diálogo 3D que aparece sobre los NPCs
## Las palabras son clickeables para buscar en el diccionario

signal word_clicked(word_data: Dictionary)
signal bubble_closed()

@onready var sprite: Sprite3D = $Sprite3D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var dialogue_panel: Panel = $SubViewport/DialoguePanel
@onready var dialogue_text: RichTextLabel = $SubViewport/DialoguePanel/MarginContainer/DialogueText

var is_looking_at := false
var current_words: Array[Dictionary] = []  # [{text: "", category: "", key: ""}]
var hovering_word_index := -1

func _ready() -> void:
	# Configurar el SubViewport
	sub_viewport.size = Vector2(512, 256)
	sub_viewport.transparent_bg = true
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	# Configurar el Sprite3D para usar la textura del viewport
	sprite.texture = sub_viewport.get_texture()
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.shaded = false
	sprite.pixel_size = 0.002

	# Configurar el texto
	dialogue_text.bbcode_enabled = true
	dialogue_text.meta_clicked.connect(_on_meta_clicked)
	dialogue_text.meta_hover_started.connect(_on_meta_hover_started)
	dialogue_text.meta_hover_ended.connect(_on_meta_hover_ended)

	visible = false

func show_dialogue(text: String, word_mappings: Array[Dictionary] = []) -> void:
	"""
	Muestra el diálogo con palabras clickeables
	word_mappings: [{word: "りんご", category: "food", key: "apple"}, ...]
	"""
	current_words = word_mappings
	visible = true

	# Generar el texto con BBCode para palabras clickeables
	var formatted_text = _format_text_with_links(text, word_mappings)
	dialogue_text.clear()
	dialogue_text.append_text(formatted_text)

func hide_bubble() -> void:
	visible = false
	bubble_closed.emit()

func _format_text_with_links(text: String, word_mappings: Array[Dictionary]) -> String:
	"""Convierte palabras en links clickeables"""
	var result = text

	for i in range(word_mappings.size()):
		var word_info = word_mappings[i]
		var word = word_info.get("word", "")
		if word.is_empty():
			continue

		# Crear un link BBCode: [url=index]palabra[/url]
		var link = "[url=%d][u]%s[/u][/url]" % [i, word]
		result = result.replace(word, link)

	return result

func _on_meta_clicked(meta) -> void:
	"""Cuando se hace click en una palabra"""
	var word_index = int(str(meta))
	if word_index >= 0 and word_index < current_words.size():
		var word_data = current_words[word_index]
		print("🔍 Click en palabra: %s (categoría: %s, key: %s)" % [
			word_data.get("word", ""),
			word_data.get("category", ""),
			word_data.get("key", "")
		])
		word_clicked.emit(word_data)

func _on_meta_hover_started(meta) -> void:
	"""Cuando el mouse pasa sobre una palabra"""
	hovering_word_index = int(str(meta))
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_meta_hover_ended(meta) -> void:
	"""Cuando el mouse sale de una palabra"""
	hovering_word_index = -1
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func set_looking_at(looking: bool) -> void:
	"""Cambia el estilo cuando el jugador mira la burbuja"""
	is_looking_at = looking
	if looking:
		# Hacer la burbuja más visible cuando la miran
		sprite.modulate = Color(1, 1, 1, 1)
		sprite.render_priority = 10  # Renderizar al frente
	else:
		sprite.modulate = Color(1, 1, 1, 0.8)
		sprite.render_priority = 0
