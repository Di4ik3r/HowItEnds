extends Spatial

export(NodePath) var BlocksMMPath
export(NodePath) var TreesMM1Path
export(NodePath) var TreesMM2Path


var resource: MapExport = null setget _set_resource
var mapBuilder: MapBuilder

onready var BlocksMM = get_node(BlocksMMPath)
onready var TreesMM1 = get_node(TreesMM1Path)
onready var TreesMM2 = get_node(TreesMM2Path)

func _ready():
	pass

func _set_resource(value: MapExport) -> void:
	resource = value
	mapBuilder = MapBuilder.new(resource, BlocksMM, TreesMM1, TreesMM2)
	mapBuilder.generate_map()

