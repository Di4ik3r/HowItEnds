extends Spatial

export(NodePath) var BlocksMMPath
export(NodePath) var TreesMM1Path
export(NodePath) var TreesMM2Path


var resource: MapExport = null setget _set_resource
var mapBuilder: MapBuilder
var map: Array

onready var BlocksMM = get_node(BlocksMMPath)
onready var TreesMM1 = get_node(TreesMM1Path)
onready var TreesMM2 = get_node(TreesMM2Path)
onready var Debug = $DebugInstance

func _ready():
	pass

func _set_resource(value: MapExport) -> void:
	resource = value
	mapBuilder = MapBuilder.new(resource, BlocksMM, TreesMM1, TreesMM2)
	mapBuilder.generate_map()
	map = mapBuilder.gen_2dim_map()
	
	
	export_map_to_csv()

func export_map_to_csv() -> void:
	var blocks = resource.blocks
	var divider = resource.b_side
	var file = File.new()
	file.open("user://map_export.csv", File.WRITE)
	
	var array = []
	var buff = []
	for i in range(blocks.size()):
		buff.append(str(blocks[i].type) + ",")
		if (i + 1) % divider == 0:
			print(buff)
			file.store_csv_line(PoolStringArray(buff))
			buff.clear()
	
	file.close()
