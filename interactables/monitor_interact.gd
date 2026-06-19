extends StaticBody3D
@onready var openPC = $openPC
@export var terminal_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func interact()-> void:
	if terminal_scene:
		openPC.play()
		var ui_instance = terminal_scene.instantiate()
		get_tree().root.add_child(ui_instance)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		print("ERROR: Terminal Missing, not working!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
