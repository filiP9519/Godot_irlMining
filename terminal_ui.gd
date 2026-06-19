extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#zrusenie terminalu
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
