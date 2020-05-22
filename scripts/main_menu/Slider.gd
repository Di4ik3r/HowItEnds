extends MeshInstance


const SCALE_START = Vector3(0, 1, 1)
const SCALE_END = Vector3(5, 1, 1)
const TRANSLATION_START = Vector3(0, 0, -0.1)
const TRANSLATION_END = Vector3(2.5, 0, -0.1)

const TWEEN_SPEED = 0.2
const TWEEN_DELAY = 0.1

onready var tween_size = $TweenSize
onready var tween_position = $TweenPosition


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func slide():
	tween_size.interpolate_property(self, "scale", scale, SCALE_END, TWEEN_SPEED, 0, 2)
	tween_position.interpolate_property(self, "translation", translation, TRANSLATION_END, TWEEN_SPEED, 0, 2)
	tween_size.start()
	tween_position.start()
	pass

func unslide():
	tween_size.interpolate_property(self, "scale", scale, SCALE_START, TWEEN_SPEED, 0, 2)
	tween_position.interpolate_property(self, "translation", translation, TRANSLATION_START, TWEEN_SPEED, 0, 2)
	tween_size.start()
	tween_position.start()
	pass
