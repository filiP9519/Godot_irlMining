extends StaticBody3D

#creates a field in inspector where we can then assign OmniLight3D from indoor Light
@export var target_light: Light3D

# Called when the node enters the scene tree for the first time.
func interact() -> void:
	if target_light:
		target_light.visible = !target_light.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
