extends Spatial



signal pressed

var _enabled = true

export(String) var text = "Text" setget _set_text
export(Color) var color = Color.green setget _set_color
export(float) var alpha = 0.4

onready var slider = $Slider


func _ready():
	_assign_text()
	_assign_color()

func _on_Area_mouse_entered():
	if _enabled:
		slider.slide()
func _on_Area_mouse_exited():
	if _enabled:
		slider.unslide()
func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if(event is InputEventMouseButton):
		if(!event.pressed):
			emit_signal("pressed")
#			print(event.as_text())


func enable() -> void:
	_enabled = true
func disable() -> void:
	_enabled = false
	slider.unslide()

func _assign_text() -> void:
	get_node("GUI3D/Viewport/Control/Label").text = text
	pass

func _assign_color() -> void:
#	print("kek")
#	print(get_node("Slider").mesh, get_node("Slider").mesh.surface_get_material(0))
	get_node("Slider").mesh.surface_get_material(0).albedo_color = color

func _set_text(value: String) -> void:
	text = value
	_assign_text()

func _set_color(value: Color) -> void:
	color = Color(value.r, value.g, value.b, alpha)
