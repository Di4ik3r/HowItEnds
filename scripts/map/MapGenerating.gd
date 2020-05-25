extends Spatial


signal map_back_button_pressed
signal refresh_ui

const CAMERA_HEIGHT = 45

var mapGenerator: MapGenerator = MapGenerator.new()
var mapVars: Resource = mapGenerator.MapVars

var circle_center: Vector3 = Vector3.ZERO
var current_angle: float = 0
var circle_radius: float = 1

onready var CameraFollowPos: = $"CameraFollowPos" as Position3D
onready var CenterPos: = $"CenterPos" as Position3D
onready var Terrain = $Terrain
onready var Trees1 = $Trees1
onready var Trees2 = $Trees2

onready var UI = $MapGeneratingUI

func _ready() -> void:
	mapGenerator.set_mminstance(Terrain, Trees1, Trees2)
	_update()
	mapGenerator.update_Terrain()
	_include_signals()

func _include_signals() -> void:
	(mapGenerator as MapGenerator).connect("refresh_ui", UI, "_on_refresh_ui")

func _update() -> void:
	var cube_size = mapVars.CUBE_SIZE
	var a = mapVars.a_side
	var b = mapVars.b_side
	
	var max_side: = max(a, b) as int
	var min_side: = min(a, b) as int
	circle_radius = max_side / 2 + min_side / 2
	
	circle_center = Vector3(a / 2, -20, b / 2)
	CenterPos.translation = circle_center

func _physics_process(delta: float) -> void:
	current_angle += delta / 10
	CameraFollowPos.translation = _circle_equation(current_angle)
	CameraFollowPos.look_at(CenterPos.translation, Vector3.UP)
	CenterPos.look_at(CameraFollowPos.translation, Vector3.UP)

func _circle_equation(angle: float) -> Vector3:
	var x = circle_center.x + circle_radius * cos(angle)
	var z = circle_center.z + circle_radius * sin(angle)
	return Vector3(x, CAMERA_HEIGHT, z)




func _on_MapGeneratingUI_length_changed(value: int, update: bool) -> void:
	mapVars.a_side = value
	if update:
		mapGenerator.update_Terrain(true)
		_update()
func _on_MapGeneratingUI_width_changed(value: int, update: bool) -> void:
	mapVars.b_side = value
	if update:
		mapGenerator.update_Terrain(true)
		_update()
func _on_MapGeneratingUI_seed_changed(value: float, update: bool = true) -> void:
	mapVars.noise_seed = value
	if update:
		mapGenerator.update_Terrain(true)
func _on_MapGeneratingUI_forest_comparison_changed(value, update: bool = true) -> void:
	mapVars.forest_comparison = value
	if update:
		mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_percent_changed(value: float, update: bool = true) -> void:
	mapVars.forest_percent = value
	if update:
		mapGenerator.update_Terrain()
func _on_MapGeneratingUI_forest_perioad_changed(value: float, update: bool = true) -> void:
	mapVars.forest_period = value
	if update:
		mapGenerator.update_Terrain()


func _on_MapGeneratingUI_back_button_pressed():
	emit_signal("map_back_button_pressed")
func _on_MapGeneratingUI_randomize_button_pressed():
	mapGenerator.randomize()
func _on_MapGeneratingUI_start_button_pressed():
	var data = mapGenerator.export_map()
	var map_export_resource = MapExport.new(data)
	SceneSwitcher.goto_scene(SceneSwitcher.SCENES.Simulation, map_export_resource)
	pass # Replace with function body.
func _on_MapGeneratingUI_generate_button_pressed():
	mapGenerator.update_Terrain(true)
	_update()

func _on_refresh_ui(value) -> void:
	emit_signal("refresh_ui", value)

