extends Control
class_name HUD

## HUD persistente que muestra información del juego

@onready var money_label: Label = $MarginContainer/VBoxContainer/TopBar/MoneyContainer/MoneyLabel
@onready var day_label: Label = $MarginContainer/VBoxContainer/TopBar/TimeContainer/DayLabel
@onready var rent_label: Label = $MarginContainer/VBoxContainer/TopBar/RentContainer/RentLabel
@onready var interaction_label: Label = $MarginContainer/VBoxContainer/BottomBar/InteractionLabel
@onready var crosshair: Control = $Crosshair

var time_manager: TimeManager
var money_manager: MoneyManager

func _ready() -> void:
	interaction_label.visible = false
	crosshair.visible = true  # Mira siempre visible

	# Esperar un frame para que GameManager esté listo
	await get_tree().process_frame

	if GameManager:
		time_manager = GameManager.time_manager
		money_manager = GameManager.money_manager

		if money_manager:
			money_manager.money_changed.connect(_on_money_changed)
			_update_money_display(money_manager.get_money())

		if time_manager:
			time_manager.day_changed.connect(_on_day_changed)
			_update_time_display()

func _update_money_display(amount: int) -> void:
	if money_label:
		money_label.text = "%d ¥" % amount

func _update_time_display() -> void:
	if not time_manager:
		return

	if day_label:
		day_label.text = "Día %d" % time_manager.get_current_day()

	if rent_label:
		var days_left = time_manager.get_days_until_rent()
		var rent_amount = time_manager.rent_amount

		# Color de advertencia si quedan pocos días
		if days_left <= 2:
			rent_label.add_theme_color_override("font_color", Color.RED)
		elif days_left <= 4:
			rent_label.add_theme_color_override("font_color", Color.ORANGE)
		else:
			rent_label.add_theme_color_override("font_color", Color.WHITE)

		rent_label.text = "Renta en %d días (%d ¥)" % [days_left, rent_amount]

func show_interaction_prompt(text: String) -> void:
	if interaction_label:
		interaction_label.text = text
		interaction_label.visible = true

	# Hacer crosshair más visible cuando hay interacción
	if crosshair:
		crosshair.modulate = Color(0, 1, 0)  # Verde

func hide_interaction_prompt() -> void:
	if interaction_label:
		interaction_label.visible = false

	# Volver crosshair a color normal
	if crosshair:
		crosshair.modulate = Color(1, 1, 1)  # Blanco

func _on_money_changed(new_amount: int, _change: int) -> void:
	_update_money_display(new_amount)

	# Pequeña animación de escala
	if money_label:
		var tween = create_tween()
		tween.tween_property(money_label, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(money_label, "scale", Vector2(1.0, 1.0), 0.1)

func _on_day_changed(_new_day: int) -> void:
	_update_time_display()

	# Pequeña animación de flash
	if day_label:
		var tween = create_tween()
		tween.tween_property(day_label, "modulate:a", 0.3, 0.2)
		tween.tween_property(day_label, "modulate:a", 1.0, 0.2)
