extends Node
class_name TimeManager

## Gestor de tiempo del juego: días, horas, sistema de renta

signal day_changed(new_day: int)
signal rent_due()
signal time_advanced(hours: int)

@export var starting_day := 1
@export var rent_period := 7  # Cada cuántos días se paga renta
@export var rent_amount := 50000  # Precio de la renta en moneda del juego

var current_day: int = 1
var current_hour: int = 8  # Empieza a las 8 AM
var days_until_rent: int = 7

func _ready() -> void:
	current_day = starting_day
	days_until_rent = rent_period
	print("🕐 TimeManager iniciado - Día %d, Renta en %d días" % [current_day, days_until_rent])

func advance_day() -> void:
	current_day += 1
	current_hour = 8  # Reset a la mañana
	days_until_rent -= 1

	print("📅 Día %d - Faltan %d días para la renta" % [current_day, days_until_rent])
	day_changed.emit(current_day)

	if days_until_rent <= 0:
		_trigger_rent()

func advance_hours(hours: int) -> void:
	current_hour += hours
	if current_hour >= 24:
		advance_day()
	else:
		time_advanced.emit(hours)

func _trigger_rent() -> void:
	print("💰 ¡Es día de pagar la renta! (%d monedas)" % rent_amount)
	rent_due.emit()
	days_until_rent = rent_period

func get_current_day() -> int:
	return current_day

func get_days_until_rent() -> int:
	return days_until_rent

func get_current_hour() -> int:
	return current_hour

func get_time_string() -> String:
	return "Día %d - %02d:00" % [current_day, current_hour]
