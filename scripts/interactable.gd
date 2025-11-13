extends StaticBody3D
class_name Interactable

## Clase base para objetos con los que el jugador puede interactuar

@export var interaction_text := "Interactuar"
@export var interaction_enabled := true

signal interacted(player: Player)

func get_interaction_text() -> String:
	return interaction_text

func interact(player: Player) -> void:
	if interaction_enabled:
		interacted.emit(player)
		_on_interact(player)

# Override este método en clases hijas
func _on_interact(player: Player) -> void:
	pass
