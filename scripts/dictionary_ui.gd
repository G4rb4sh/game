extends Control
class_name DictionaryUI

## UI del diccionario interactivo

signal closed()
signal word_selected(category: String, key: String)

@onready var category_list: ItemList = $Panel/MarginContainer/HBoxContainer/CategoryList
@onready var word_list: ItemList = $Panel/MarginContainer/HBoxContainer/VBoxContainer/WordList
@onready var word_detail: RichTextLabel = $Panel/MarginContainer/HBoxContainer/VBoxContainer/WordDetail
@onready var close_button: Button = $Panel/MarginContainer/HBoxContainer/VBoxContainer/CloseButton

var language_data: Dictionary = {}
var current_category: String = ""

func _ready() -> void:
	visible = false
	category_list.item_selected.connect(_on_category_selected)
	word_list.item_selected.connect(_on_word_selected)
	close_button.pressed.connect(_on_close_pressed)

func open_dictionary(language_manager: LanguageManager) -> void:
	language_data = language_manager.language_data
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_populate_categories()

func open_to_word(language_manager: LanguageManager, category: String, key: String) -> void:
	open_dictionary(language_manager)
	# Buscar y seleccionar la categoría
	for i in range(category_list.item_count):
		if category_list.get_item_text(i) == category:
			category_list.select(i)
			_on_category_selected(i)
			# Buscar y seleccionar la palabra
			for j in range(word_list.item_count):
				var metadata = word_list.get_item_metadata(j)
				if metadata == key:
					word_list.select(j)
					_on_word_selected(j)
					break
			break

func close_dictionary() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	closed.emit()

func _populate_categories() -> void:
	category_list.clear()
	if not language_data.has("categories"):
		return

	for category_name in language_data.categories.keys():
		category_list.add_item(category_name.capitalize())

func _on_category_selected(index: int) -> void:
	current_category = category_list.get_item_text(index).to_lower()
	_populate_words()

func _populate_words() -> void:
	word_list.clear()
	word_detail.clear()

	if not language_data.has("categories") or not language_data.categories.has(current_category):
		return

	var category_data = language_data.categories[current_category]
	for key in category_data.keys():
		var word_data = category_data[key]
		var display_text = "%s - %s" % [word_data.get("word", "?"), word_data.get("translation", "?")]
		word_list.add_item(display_text)
		word_list.set_item_metadata(word_list.item_count - 1, key)

func _on_word_selected(index: int) -> void:
	var key = word_list.get_item_metadata(index)
	var word_data = language_data.categories[current_category][key]

	word_detail.clear()
	word_detail.push_font_size(24)
	word_detail.append_text(word_data.get("word", "?"))
	word_detail.pop()
	word_detail.append_text("\n\n")

	word_detail.push_font_size(18)
	word_detail.append_text("Romaji: ")
	word_detail.push_italic()
	word_detail.append_text(word_data.get("romaji", "?"))
	word_detail.pop()
	word_detail.append_text("\n\n")

	word_detail.append_text("Español: ")
	word_detail.push_bold()
	word_detail.append_text(word_data.get("translation", "?"))
	word_detail.pop()
	word_detail.pop()

	word_selected.emit(current_category, key)

func _on_close_pressed() -> void:
	close_dictionary()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close_dictionary()
		get_viewport().set_input_as_handled()
