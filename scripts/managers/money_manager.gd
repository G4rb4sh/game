extends Node
class_name MoneyManager

## Gestor de dinero del jugador

signal money_changed(new_amount: int, change: int)
signal not_enough_money(required: int, current: int)

@export var starting_money := 10000
var current_money: int = 0

func _ready() -> void:
	current_money = starting_money
	print("💵 MoneyManager iniciado - Dinero inicial: %d" % current_money)

func add_money(amount: int) -> void:
	if amount > 0:
		current_money += amount
		print("💰 +%d → Total: %d" % [amount, current_money])
		money_changed.emit(current_money, amount)

func remove_money(amount: int) -> bool:
	if amount > current_money:
		print("❌ No hay suficiente dinero (necesitas %d, tienes %d)" % [amount, current_money])
		not_enough_money.emit(amount, current_money)
		return false

	current_money -= amount
	print("💸 -%d → Total: %d" % [amount, current_money])
	money_changed.emit(current_money, -amount)
	return true

func has_enough(amount: int) -> bool:
	return current_money >= amount

func get_money() -> int:
	return current_money

func set_money(amount: int) -> void:
	var change = amount - current_money
	current_money = amount
	money_changed.emit(current_money, change)
