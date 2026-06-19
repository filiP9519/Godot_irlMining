extends StaticBody3D
@onready var click_sound = $switchSound
#creates a field in inspector where we can then assign OmniLight3D from indoor Light
@export var target_light: Light3D

# Called when the node enters the scene tree for the first time.
func interact() -> void:
	click_sound.play()
	if target_light:
		target_light.visible = !target_light.visible
