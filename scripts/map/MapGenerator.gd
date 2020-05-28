class_name MapGenerator
extends Node

#signal noise_changed(value)
#signal forest_comparison_changed(value)
#signal forest_percent_changed(value)
#signal forest_period_changed(value)
signal refresh_ui(values)

export(NodePath) var TerrainPath
export(NodePath) var Trees1Path
export(Resource) var MapVars = preload("res://resources/map/MapVars.tres")

var Terrain: MultiMeshInstance
var Trees1: MultiMeshInstance
var Trees2: MultiMeshInstance
var map_blocks: Array
var map_trees: Array

func _init() -> void:
	MapVars.connect("refresh_ui", self, "_on_refresh_ui")
#	MapVars.connect("noise_seed_changed", self, "_on_noise_seed_changed")
#	MapVars.connect("forest_comparison_changed", self, "_on_forest_comparison_changed")
#	MapVars.connect("forest_percent_changed", self, "_on_forest_percent_changed")
#	MapVars.connect("forest_period_changed", self, "_on_forest_period_changed")

func set_mminstance(_Terrain: MultiMeshInstance, _Trees1: MultiMeshInstance, _Trees2: MultiMeshInstance) -> void:
	Terrain = _Terrain
	Trees1 = _Trees1
	Trees2 = _Trees2

func change_parameter(parameter: String, value) -> void:
	MapVars[parameter] = value

var min_height
var max_height
var block_color: Color
func _generate(isTragic: bool) -> void:
	var forest_blocks = Array()
	var blocks = Array()
	var trees = Array()
	
	if isTragic or not min_height or not max_height:
		min_height = 999
		max_height = -999
		for a in range(0, MapVars.a_side):
			for b in range(0, MapVars.b_side):
				var noise: float = MapVars.noise.get_noise_2d(a, b) * MapVars.NOISE_MULTIPLIER
				var height: float = MapVars.BLOCK_HEIGHT_MULTIPLIER * MapVars.noise.get_noise_2d(a, b)
	
				if height > max_height:
					max_height = height
	
				if height < min_height:
					min_height = height
#
	var instance: int = 0
	for a in range(0, MapVars.a_side):
		for b in range(0, MapVars.b_side):
			var type
			var noise = MapVars.noise.get_noise_2d(a, b) * MapVars.NOISE_MULTIPLIER
			var height_compare = noise + MapVars.HEIGHT_ADDITION
			var height = MapVars.BLOCK_HEIGHT_MULTIPLIER * MapVars.noise.get_noise_2d(a, b)

			if height_compare < MapVars.WATER_COMPARISON:
				height = _generate_water(noise, instance)
				type = Variables.BlockType.WATER
			elif height_compare < MapVars.SAND_COMPARISON:
				_generate_sand(noise, instance)
				type = Variables.BlockType.SAND
			elif height_compare > 7 - MapVars.MOUNTAIN_COMPARISON && MapVars.generate_mountain:
				height = _generate_mountain(min_height, height, noise, instance)
				type = Variables.BlockType.MOUNTAIN
			elif height_compare > 8 - MapVars.forest_comparison:
				forest_blocks.append(
					{
						"transform": _generate_tree(a, b, min_height, height, noise, instance),
						"i": instance,
					})
				type = Variables.BlockType.FOREST
			else:
				_generate_grass(noise, instance)
				type = Variables.BlockType.GRASS
			
			var transform: = _place_block(a, b, min_height, height, noise, instance) as Transform
			var top_pos = transform.origin + Vector3(0, ((abs(min_height) + height) * 2 + 1) / 2, 0)
			
			blocks.append({
#				"i": instance,
				"transform": transform,
				"type": type,
				"color": block_color,
				"top_pos": top_pos,
			})
			instance += 1

	var count: int = forest_blocks.size()
	var forest_percent_count = ((count as float * MapVars.forest_percent)) as int
	var array = Array()
	var trees1_count = 0
	var trees2_count = 0
	var t_min = 999
	var t_max = -999
	for i in range(count):
		var vector = forest_blocks[i].transform
		var noise = MapVars.noise_tree.get_noise_2d(vector.x, vector.z) + MapVars.forest_percent * 2 - 0.9
		if noise > 0:
			if noise >= 0.2:
				trees2_count += 1
				array.append({
					"vector": vector,
					"type": 2,
				})
			else:
				trees1_count += 1
				array.append({
					"vector": vector,
					"type": 1,
				})
		else:
			var ind = forest_blocks[i].i
			var block: Dictionary = _find_forest_block(blocks, ind)
			block.type = Variables.BlockType.GRASS
#			print(block, "; ", ind, "; ", blocks.size())

#		t_min = min(t_min, noise)
#		t_max = max(t_max, noise)
#	print("Trees mim nax: ", t_min, "; ", t_max)
#	print("Trees counts: ", trees1_count, "; ", trees2_count)

	count = array.size()
	Trees1.multimesh.instance_count = trees1_count
	Trees2.multimesh.instance_count = trees2_count
	var trees1_indexer = 0
	var trees2_indexer = 0
	for i in range(count):
		var vector = array[i].vector
		var type = array[i].type
		
		var tree_basis = Basis()
		tree_basis = tree_basis.rotated(Vector3(0, 1, 0), PI * (randi() + 1))
		var scale = randi() % 8 + 7
		tree_basis = tree_basis.scaled(Vector3(scale, scale, scale))
#		var tree_transform = Transform(Basis(), vector)
		var tree_transform = Transform(tree_basis, vector)
		var tree_color = Color(0.2, 0.1, 0)
		
		trees.append({
			"transform": tree_transform,
			"color": tree_color,
			"type": type,
		})
		
		match(type):
			1:
				Trees1.multimesh.set_instance_color(trees1_indexer, tree_color)
				Trees1.multimesh.set_instance_transform(trees1_indexer, tree_transform)
				trees1_indexer += 1
			2:
				Trees2.multimesh.set_instance_color(trees2_indexer, tree_color)
				Trees2.multimesh.set_instance_transform(trees2_indexer, tree_transform)
				trees2_indexer += 1
	
	map_blocks = blocks
	map_trees = trees
#	pass

# ######################################################################################## BLOCK GEN
func _generate_water(noise: float, instance: int) -> float:
	block_color = Color(MapVars.COLOR_WATER.to_html()).linear_interpolate(MapVars.COLOR_WATER_INTERPOLATION,
		Tools.noise_float_lerp(noise) * noise + 1)
	Terrain.multimesh.set_instance_color(instance, block_color)
	return MapVars.WATER_HEIGHT - MapVars.BLOCK_HEIGHT_MULTIPLIER / 1.89

func _generate_sand(noise: float, instance: int) -> void:
	block_color = Color(MapVars.COLOR_SAND.to_html()).linear_interpolate(MapVars.COLOR_SAND_INTERPOLATE,
		Tools.noise_float_lerp(noise) + 0.2)
	Terrain.multimesh.set_instance_color(instance, block_color)

func _generate_mountain(min_height: float, height: float, noise:float, instance: int) -> float:
	block_color = Color(MapVars.COLOR_MOUNTAIN.to_html()).linear_interpolate(MapVars.COLOR_MOUNTAIN_INTERPOLATION,
		Tools.noise_float_lerp(noise) * 5 - 10)
	height *= noise * MapVars.MOUNTAIN_COMPARISON / 1.5
	height -= MapVars.BLOCK_HEIGHT_MULTIPLIER / 2
	
	Terrain.multimesh.set_instance_color(instance, block_color)

	return height

func _generate_tree(a: int, b: int, min_height: float, height: float, noise: float, instance: int) -> Vector3:
	block_color = Color(MapVars.COLOR_GRASS.to_html()).linear_interpolate(MapVars.COLOR_GRASS_INTERPOLATION,
		Tools.noise_float_lerp(noise))
	
	Terrain.multimesh.set_instance_color(instance, block_color)

#	var calc: float = (abs(min_height) + height) * MapVars.BLOCK_HEIGHT_MULTIPLIER / (MapVars.BLOCK_HEIGHT_MULTIPLIER / 2) + 1
	var calc: float = (abs(min_height) + height) * 2 + 1
	
	calc -= 1.5
#	calc = 10
	
	var offset = 0.15
	var x_offset = rand_range(-offset, offset)
	var z_offset = rand_range(-offset, offset)
#	var pos = Vector3(a, calc + 0.5, b)
#	var pos = Vector3(a + x_offset, calc + 0.5, b + z_offset)
	var pos = Vector3(a + x_offset, calc + 0.5, b + z_offset)

	return pos

func _generate_grass(noise, instance) -> void:
	block_color = Color(MapVars.COLOR_GRASS.to_html()).linear_interpolate(MapVars.COLOR_GRASS_INTERPOLATION,
		Tools.noise_float_lerp(noise) )
	Terrain.multimesh.set_instance_color(instance, block_color)

func _place_block(a: int, b: int, min_height: float, height: float,  noise: float, instance: int) -> Transform:
	var pos = Vector3(a, (height + abs(min_height) + MapVars.CUBE_SIZE / 2), b)
	var basis = Basis()
	var calc: float = (abs(min_height) + height) * 2 + 1
	basis = basis.scaled(Vector3(1, calc, 1))
	var transform: Transform = Transform(basis, pos)
	
	Terrain.multimesh.set_instance_transform(instance, transform)
	
	return transform
#func _on_noise_seed_changed(value: int) -> void:
#	emit_signal("noise_changed", value)
#func _on_forest_comparison_changed(value: float) -> void:
#	emit_signal("forest_comparison_changed", value)
#func _on_forest_percent_changed(value: float) -> void:
#	emit_signal("forest_percent_changed", value)
#func _on_forest_period_changed(value: int) -> void:
#	emit_signal("forest_period_changed", value)

# ######################################################################################## BLOCK GEN END



func _on_refresh_ui(values) -> void:
	emit_signal("refresh_ui", values)

func update_Terrain(isTragic: bool = false) -> void:
	seed(MapVars.noise_seed)
	Terrain.multimesh.instance_count = MapVars.a_side * MapVars.b_side
	_generate(isTragic)

func randomize() -> void:
	MapVars.randomize()

func export_map() -> Dictionary:
	return {
		"blocks": map_blocks,
		"trees": map_trees,
		"a_side": MapVars.a_side,
		"b_side": MapVars.b_side,
		"min_height": min_height,
		"max_height": max_height,
	}

func _find_forest_block(blocks: Array, index) -> Dictionary:
#	if blocks[index].empty():
#		print("block - ", blocks[index])
	return blocks[index]
