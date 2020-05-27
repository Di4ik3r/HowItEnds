extends Spatial


export(NodePath) var MapPath
export(NodePath) var CircleCameraPath

var resource: MapExport = null setget _set_resource
var bot_manager = BotManager.new()

onready var Map = get_node(MapPath)
onready var CircleCamera = get_node(CircleCameraPath)

func _ready():
	pass

func _set_resource(value: MapExport) -> void:
	resource = value
	Map.resource = resource
	CircleCamera.update(resource)
	
	bot_manager.map_pos = Map.map_pos
	bot_manager.map_type = Map.map_type
	bot_manager.map_export = resource
