extends CharacterBody3D

# --- 1. EXPORTY (Nastavenia dostupné v Inšpektore) ---
@export_category("Movement Parameters")
@export var speed: float = 10.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@onready var interact_ray = $Collider/head/Camera3D/RayCast3D

@export_category("Node References")
# Namiesto "natvrdo" napísaného $Node3D to necháme voľné. 
# V Inšpektore do tohto políčka presunieš uzol hlavy.
@export var head: Node3D 


# --- 2. VSTAVANÉ FUNKCIE (Engine Callbacks) ---
func _ready() -> void:
	_capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	_handle_camera_rotation(event)
	_handle_mouse_toggle()
	#interaction with the environment (E press interaction)
	# Interakcia s prostredím
	if Input.is_action_just_pressed("interact"):
		if interact_ray.is_colliding():
			# Zistíme, do čoho laser narazil
			var object_hit = interact_ray.get_collider()
			print("Laser trafil objekt: ", object_hit.name)
			
			# Ak objekt do ktorého sme narazili má funkciu "interact" (ako náš vypínač), spustíme ju
			if object_hit.has_method("interact"):
				print("Objekt má funkciu interact, zapínam!")
				object_hit.interact()
			else:
				print("Pozor: Tento objekt nemá funkciu interact.")
		else:
			print("Laser vyletel, ale netrafil vôbec nič.")

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
#	_handle_jump()
	_handle_movement()
	
	move_and_slide()


# --- 3. VLASTNÉ FUNKCIE (Abstrahovaná logika) ---
func _capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _handle_mouse_toggle() -> void:
	# Tento kód teraz umožňuje myš nielen zobraziť (ESC), ale aj znova swkryť (po kliknutí dnu)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("ui_accept") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_capture_mouse()

func _handle_camera_rotation(event: InputEvent) -> void:
	# Zabezpečíme, aby sa kamera hýbala, len keď je myš skrytá v hre
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Bezpečnostná kontrola: Kód nespadne, ak zabudneš v Inšpektore priradiť hlavu
		if head:
			head.rotate_x(-event.relative.y * mouse_sensitivity)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

#func _handle_jump() -> void:
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = jump_velocity

func _handle_movement() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
