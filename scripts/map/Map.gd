extends Spatial

export(NodePath) var BlocksMMPath
export(NodePath) var TreesMMPath

var resource: MapExport = null setget _set_resource
var mapBuilder: MapBuilder

onready var BlocksMM = get_node(BlocksMMPath)
onready var TreesMM = get_node(TreesMMPath)

func _ready():
	pass
	

func _set_resource(value: MapExport) -> void:
	resource = value
	mapBuilder = MapBuilder.new(resource, BlocksMM, TreesMM)
	mapBuilder.generate_map()
