extends Spatial

export(NodePath) var BlocksMMPath
export(NodePath) var TreesMMPath

var resource: Resource = null
var mapBuilder: MapBuilder

onready var BlocksMM = get_node(BlocksMMPath)
onready var TreesMM = get_node(TreesMMPath)

func _ready():
	mapBuilder = MapBuilder.new(resource, BlocksMM, TreesMM)
	mapBuilder.generate_map()
