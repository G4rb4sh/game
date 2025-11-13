extends Interactable
class_name Bed

## Cama para descansar y avanzar al siguiente día

signal sleep_requested()

func _ready() -> void:
	interaction_text = "[E] Dormir"

func _on_interact(player: Player) -> void:
	print("💤 Durmiendo... avanzando al siguiente día")
	sleep_requested.emit()
	# TODO: Conectar con TimeManager para avanzar día
	# TODO: Fade out/in de pantalla
	# TODO: Restaurar energía del jugador
