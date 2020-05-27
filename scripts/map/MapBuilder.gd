class_name MapBuilder

var map_export: MapExport
var MapVars = preload("res://resources/map/MapVars.tres")

var BlocksMM: MultiMeshInstance
var TreesMM1: MultiMeshInstance
var TreesMM2: MultiMeshInstance

var tree1_counter = 0
var tree2_counter = 0

func _init(_map_export: MapExport, _BlocksMM: MultiMeshInstance, _TreesMM1: MultiMeshInstance, _TreesMM2: MultiMeshInstance) -> void:
	map_export = _map_export
	BlocksMM = _BlocksMM
	TreesMM1 = _TreesMM1
	TreesMM2 = _TreesMM2

func gen_2dim_map() -> Array:
	var blocks = map_export.blocks
	var divider = map_export.b_side
	var result: Array = Array()
	
	var col: Array = Array()
	for i in range(blocks.size()):
		col.append(blocks[i].top_pos)
		if (i + 1) % divider == 0:
			result.append(col.duplicate())
			col.clear()
	
	return result

func generate_map() -> void:
	var a_side = map_export.a_side
	var b_side = map_export.b_side
	var blocks = map_export.blocks
	var trees = map_export.trees
	
	var tree1_count = 0
	var tree2_count = 0
	for tree in trees:
		match(tree.type):
			1:
				tree1_count += 1
			2:
				tree2_count += 1
	
	BlocksMM.multimesh.instance_count = blocks.size()
	TreesMM1.multimesh.instance_count = tree1_count
	TreesMM2.multimesh.instance_count = tree2_count
	
	for i in range(blocks.size()):
		_place_block(blocks[i].transform, blocks[i].color, i)
	
	for tree in trees:
		_place_tree(tree)
#	var instance = 0
#	for a in range(a_side):
#		for b in range(b_side):
#			_place_block()
#			instance += 1

func _place_block(transform: Transform, color: Color, instance: int) -> void:
#	var pos = Vector3(a, (height + abs(map_export.min_height) + MapVars.CUBE_SIZE / 2), b)
#	var basis = Basis()
#	var calc: float = (abs(map_export.min_height) + height) * 2 + 1
#	basis = basis.scaled(Vector3(1, calc, 1))
#	var transform: Transform = Transform(basis, pos)
	BlocksMM.multimesh.set_instance_color(instance, color)
	BlocksMM.multimesh.set_instance_transform(instance, transform)

func _place_tree(tree: Dictionary) -> void:
	var transform: = tree.transform as Transform
	match(tree.type):
		1:
			TreesMM1.multimesh.set_instance_transform(tree1_counter, transform)
			tree1_counter += 1
		2:
			TreesMM2.multimesh.set_instance_transform(tree2_counter, transform)
			tree2_counter += 1
#	TreesMM.multimesh.set_instance_color(instance, data.color)
#	TreesMM.multimesh.set_instance_transform(instance, transform)

