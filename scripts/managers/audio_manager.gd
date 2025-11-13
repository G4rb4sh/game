extends Node
class_name AudioManager

## Gestor de audio del juego - Singleton (Autoload)

# Audio players
var ui_click_player: AudioStreamPlayer
var dictionary_open_player: AudioStreamPlayer
var dictionary_close_player: AudioStreamPlayer
var dialogue_advance_player: AudioStreamPlayer
var word_click_player: AudioStreamPlayer
var typewriter_player: AudioStreamPlayer

# Volúmenes (0.0 a 1.0)
@export var master_volume := 1.0
@export var sfx_volume := 0.8
@export var ui_volume := 0.7

func _ready() -> void:
	# Crear audio players
	ui_click_player = _create_audio_player("UIClick")
	dictionary_open_player = _create_audio_player("DictionaryOpen")
	dictionary_close_player = _create_audio_player("DictionaryClose")
	dialogue_advance_player = _create_audio_player("DialogueAdvance")
	word_click_player = _create_audio_player("WordClick")
	typewriter_player = _create_audio_player("Typewriter")

	print("🔊 AudioManager inicializado")

func _create_audio_player(name: String) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.name = name
	player.bus = "Master"
	add_child(player)
	return player

# Funciones para reproducir sonidos
func play_ui_click() -> void:
	if ui_click_player and ui_click_player.stream:
		ui_click_player.volume_db = _volume_to_db(ui_volume * master_volume)
		ui_click_player.play()

func play_dictionary_open() -> void:
	if dictionary_open_player and dictionary_open_player.stream:
		dictionary_open_player.volume_db = _volume_to_db(sfx_volume * master_volume)
		dictionary_open_player.play()

func play_dictionary_close() -> void:
	if dictionary_close_player and dictionary_close_player.stream:
		dictionary_close_player.volume_db = _volume_to_db(sfx_volume * master_volume)
		dictionary_close_player.play()

func play_dialogue_advance() -> void:
	if dialogue_advance_player and dialogue_advance_player.stream:
		dialogue_advance_player.volume_db = _volume_to_db(ui_volume * master_volume)
		dialogue_advance_player.play()

func play_word_click() -> void:
	if word_click_player and word_click_player.stream:
		word_click_player.volume_db = _volume_to_db(ui_volume * master_volume)
		word_click_player.play()

func play_typewriter_char() -> void:
	if typewriter_player and typewriter_player.stream:
		typewriter_player.volume_db = _volume_to_db(ui_volume * master_volume * 0.3)  # Más bajo
		typewriter_player.play()

# Cargar sonidos desde archivos (cuando estén disponibles)
func load_sounds() -> void:
	# TODO: Cargar archivos de audio cuando existan
	# ui_click_player.stream = load("res://assets/sounds/ui_click.ogg")
	# dictionary_open_player.stream = load("res://assets/sounds/dictionary_open.ogg")
	# etc.
	pass

func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)

func set_ui_volume(volume: float) -> void:
	ui_volume = clamp(volume, 0.0, 1.0)

func _volume_to_db(linear: float) -> float:
	"""Convierte volumen lineal (0-1) a decibeles"""
	if linear <= 0.0:
		return -80.0
	return 20.0 * log(linear) / log(10.0)
