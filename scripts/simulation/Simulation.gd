extends Spatial

export(NodePath) var MapPath

var resource: MapExport = null setget _set_resource

onready var Map = get_node(MapPath)

func _ready():
	pass


func _set_resource(value: MapExport) -> void:
	resource = value
	Map.resource = resource
