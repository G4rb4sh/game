extends CharacterBody3D
class_name Player

# Movimiento
@export var speed := 5.0
@export var sprint_speed := 8.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.003

# Referencias
@onready var camera: Camera3D = $Camera3D
@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_interactable: Node = null
var current_dialogue_bubble: DialogueBubble3D = null
var is_looking_at_bubble := false
var hud: HUD = null  # Referencia al HUD (se asigna desde la escena)

func _ready() -> void:
	# Capturar el mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Rotación de cámara con mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

	# Liberar/capturar mouse con ESC
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Interacción
	if event.is_action_pressed("interact"):
		_try_interact()

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Movimiento
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		var current_speed = sprint_speed if Input.is_action_pressed("ui_shift") else speed
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	# Detectar objeto interactuable
	_check_interactable()

	# Detectar burbuja de diálogo
	_check_dialogue_bubble()

func _check_interactable() -> void:
	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		if collider and collider.has_method("get_interaction_text"):
			if current_interactable != collider:
				current_interactable = collider
				_show_interaction_prompt(collider.get_interaction_text())
		else:
			_clear_interaction()
	else:
		_clear_interaction()

func _try_interact() -> void:
	if current_interactable and current_interactable.has_method("interact"):
		current_interactable.interact(self)

func _show_interaction_prompt(text: String) -> void:
	if hud:
		hud.show_interaction_prompt(text)

func _clear_interaction() -> void:
	if current_interactable:
		current_interactable = null
		if hud:
			hud.hide_interaction_prompt()

func _check_dialogue_bubble() -> void:
	"""Detecta si el jugador está mirando una burbuja de diálogo"""
	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()

		# Buscar DialogueBubble3D en el árbol del collider
		var bubble = _find_dialogue_bubble(collider)

		if bubble and bubble.visible:
			if not is_looking_at_bubble:
				is_looking_at_bubble = true
				current_dialogue_bubble = bubble
				bubble.set_looking_at(true)
				# Liberar mouse para permitir clicks en las palabras
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			return

	# No está mirando ninguna burbuja
	if is_looking_at_bubble:
		is_looking_at_bubble = false
		if current_dialogue_bubble:
			current_dialogue_bubble.set_looking_at(false)
			current_dialogue_bubble = null
		# Volver a capturar mouse
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _find_dialogue_bubble(node: Node) -> DialogueBubble3D:
	"""Busca un DialogueBubble3D en el árbol del nodo"""
	var current = node
	while current:
		if current is DialogueBubble3D:
			return current
		# Buscar en hermanos y padre
		if current.get_parent():
			for sibling in current.get_parent().get_children():
				if sibling is DialogueBubble3D:
					return sibling
		current = current.get_parent()
	return null
