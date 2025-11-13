extends Node

## Gestor principal del juego - Singleton (Autoload)

var time_manager: TimeManager
var money_manager: MoneyManager
var language_manager: LanguageManager

var current_scene: Node = null
var player: Player = null

func _ready() -> void:
	# Inicializar managers
	time_manager = TimeManager.new()
	money_manager = MoneyManager.new()
	language_manager = LanguageManager.new()

	add_child(time_manager)
	add_child(money_manager)
	add_child(language_manager)

	# Conectar señales importantes
	time_manager.rent_due.connect(_on_rent_due)
	money_manager.not_enough_money.connect(_on_not_enough_money)

	print("🎮 GameManager inicializado")

func _on_rent_due() -> void:
	var rent_amount = time_manager.rent_amount
	if money_manager.remove_money(rent_amount):
		print("✅ Renta pagada exitosamente!")
	else:
		print("❌ No tienes suficiente dinero para la renta. ¡GAME OVER!")
		_trigger_game_over()

func _on_not_enough_money(required: int, current: int) -> void:
	print("⚠️ Necesitas %d más para completar la acción" % (required - current))

func _trigger_game_over() -> void:
	print("💀 GAME OVER - No pudiste pagar la renta")
	# TODO: Mostrar pantalla de Game Over
	# TODO: Opción de reiniciar o volver al menú

func load_scene(scene_path: String) -> void:
	call_deferred("_deferred_load_scene", scene_path)

func _deferred_load_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()

	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene

	# Buscar al jugador en la nueva escena
	_find_player(new_scene)

func _find_player(node: Node) -> void:
	if node is Player:
		player = node
		return

	for child in node.get_children():
		_find_player(child)

func get_player() -> Player:
	return player
