extends Interactable
class_name NeighborNPC

## NPC vecino que puede pedir favores y dar recompensas

signal dialogue_started(npc: NeighborNPC)
signal quest_completed(npc: NeighborNPC, reward: int)

@export var npc_name := "Vecino"
@export var dialogue_lines: Array[String] = []
@export var has_quest := false
@export var quest_reward := 500

var current_dialogue_index := 0

func _ready() -> void:
	interaction_text = "[E] Hablar con %s" % npc_name

	if dialogue_lines.is_empty():
		dialogue_lines = [
			"Hola, soy tu vecino.",
			"¿Necesitas ayuda con algo?",
			"¡Buena suerte aprendiendo el idioma!"
		]

func _on_interact(player: Player) -> void:
	print("💬 Hablando con %s" % npc_name)
	dialogue_started.emit(self)
	_show_next_dialogue()

func _show_next_dialogue() -> void:
	if current_dialogue_index < dialogue_lines.size():
		var line = dialogue_lines[current_dialogue_index]
		print("  %s: %s" % [npc_name, line])
		current_dialogue_index += 1
	else:
		_end_dialogue()

func _end_dialogue() -> void:
	current_dialogue_index = 0
	print("💬 Fin de la conversación")

	if has_quest:
		_complete_quest()

func _complete_quest() -> void:
	print("✅ ¡Favor completado! Recompensa: %d" % quest_reward)
	quest_completed.emit(self, quest_reward)
	has_quest = false

func set_quest(reward: int, quest_dialogue: Array[String]) -> void:
	has_quest = true
	quest_reward = reward
	if not quest_dialogue.is_empty():
		dialogue_lines = quest_dialogue
