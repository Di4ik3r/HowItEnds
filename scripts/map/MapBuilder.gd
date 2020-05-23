class_name MapBuilder

var map_export: MapExport
var BlocksMM: MultiMeshInstance
var TreesMM: MultiMeshInstance
var mapVars = preload("res://resources/map/MapVars.tres")

func _init(_map_export: MapExport, _BlocksMM: MultiMeshInstance, _TreesMM: MultiMeshInstance) -> void:
	map_export = _map_export
	BlocksMM = _BlocksMM
	TreesMM = _TreesMM

func generate_map() -> void:
	var a_side = map_export.a_side
	var b_side = map_export.b_side
	var blocks = map_export.blocks
	var trees = map_export.trees
	
	BlocksMM.multimesh.instance_count = blocks.size()
	TreesMM.multimesh.instance_count = trees.size()
	
	for i in range(blocks.size()):
		if i == 500:
			print(blocks[i].color)
		_place_block(blocks[i].transform, blocks[i].color, i)
	
	for i in range(trees.size()):
		_place_tree(trees[i], i)
#	var instance = 0
#	for a in range(a_side):
#		for b in range(b_side):
#			_place_block()
#			instance += 1

func _place_block(transform: Transform, color: Color, instance: int) -> void:
#	var pos = Vector3(a, (height + abs(map_export.min_height) + mapVars.CUBE_SIZE / 2), b)
#	var basis = Basis()
#	var calc: float = (abs(map_export.min_height) + height) * 2 + 1
#	basis = basis.scaled(Vector3(1, calc, 1))
#	var transform: Transform = Transform(basis, pos)
	BlocksMM.multimesh.set_instance_color(instance, color)
	BlocksMM.multimesh.set_instance_transform(instance, transform)

func _place_tree(data: Dictionary, instance: int) -> void:
	TreesMM.multimesh.set_instance_color(instance, data.color)
	TreesMM.multimesh.set_instance_transform(instance, data.transform)
