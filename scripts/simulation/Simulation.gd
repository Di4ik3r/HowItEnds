extends Spatial


export(NodePath) var MapPath
export(NodePath) var CircleCameraPath

var resource: MapExport = null setget _set_resource
var bot_manager = BotManager.new()

onready var Map = get_node(MapPath)
onready var CircleCamera = get_node(CircleCameraPath)

func _ready():
	pass


func start() -> void:
	for i in range(0, 3):
		bot_manager.spawn_bot()

func _set_resource(value: MapExport) -> void:
	resource = value
	Map.resource = resource
	CircleCamera.update(resource)
	
	bot_manager.map_pos = Map.map_pos
	bot_manager.map_type = Map.map_type
	bot_manager.map_export = resource
	bot_manager.bot_holder = get_node("BotHolder")
	
	start()


func _on_BotTimer_timeout():
	bot_manager.cycle()
