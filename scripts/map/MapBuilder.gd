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
	var blocks = map_export.blocks
#	for i in range(blocks.size()):
#		_place_block()

func _place_block(a: int, b: int, min_height: float, height: float, instance: int) -> void:
	var pos = Vector3(a, (height + abs(min_height) + mapVars.CUBE_SIZE / 2), b)
	var basis = Basis()
	var calc: float = (abs(min_height) + height) * 2 + 1
	basis = basis.scaled(Vector3(1, calc, 1))
	var transform: Transform = Transform(basis, pos)
	BlocksMM.multimesh.set_instance_transform(instance, transform)
