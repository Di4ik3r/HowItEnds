extends Spatial

"""
const CAMERA_HEIGHT = 45

export(NodePath) var InterpolatedCameraPath
export(NodePath) var PositionFollowPath
export(NodePath) var PositionCenterPath

#export(Vector2) var center_pos: Vector2

var current_angle = 0
var circle_radius: float = 1
var circle_center: Vector3 = Vector3.ZERO

onready var Cam: = get_node(InterpolatedCameraPath) as InterpolatedCamera
onready var PositionFollow: = get_node(PositionFollowPath) as Position3D
onready var PositionCenter: = get_node(PositionCenterPath) as Position3D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	current_angle += delta / 10
	PositionFollow.translation = _circle_equation(current_angle)
	PositionFollow.look_at(PositionCenter.translation, Vector3.UP)
	PositionCenter.look_at(Cam.translation, Vector3.UP)

func _circle_equation(angle: float) -> Vector3:
	var x = circle_center.x + circle_radius * cos(angle)
	var z = circle_center.z + circle_radius * sin(angle)
	return Vector3(x, CAMERA_HEIGHT, z)

func update(resource: MapExport) -> void:
	var a = resource.a_side
	var b = resource.b_side
	
	var max_side: = max(a, b) as int
	var min_side: = min(a, b) as int
	circle_radius = max_side / 2 + min_side / 2
	circle_radius -= circle_radius / 3
	
	circle_center = Vector3(a / 2, -20, b / 2)
	PositionCenter.translation = circle_center
"""
