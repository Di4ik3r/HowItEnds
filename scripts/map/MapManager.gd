extends Node
class_name MapManager





var map_export: MapExport = null
var map_pos: Array
var map_type: Array
var map_bots: Dictionary




func _ready():
	pass


func get_y(x: int, z: int) -> float:
	return map_pos[x][z].y


func get_block_for_reproduce(bot: Bot) -> Vector3:
	var pos = bot.translation
	var range_x = range(pos.x - Variables.UNIT, pos.x + (Variables.UNIT * 2), Variables.UNIT)
	var range_z = range(pos.z - Variables.UNIT, pos.z + (Variables.UNIT * 2), Variables.UNIT)
	
	var iteration = 0
	for x in range_x:
		for z in range_z:
			if is_out_of_bounds(x, z):
				continue
			var block = map_pos[x][z]
			if is_block_reproduce_valid(block):
				return block
			iteration += 1
	return Vector3.INF


func is_block_reproduce_valid(pos: Vector3) -> bool:
	if validate_block(pos.x, pos.z):
		if !map_bots[Vector3(pos.x, 0, pos.z)]:
#		if value == BlockType.EMPTY || value == BlockType.FOOD:
			return true
	return false


func validate_block(x, z) -> bool:
	if !is_out_of_bounds(x, z):
		if (map_type[x][z] == Variables.BlockType.SAND
			or map_type[x][z] == Variables.BlockType.GRASS):
				return true
	return false


func validate_block_vector(pos: Vector3) -> bool:
	if (map_type[pos.x][pos.z] == Variables.BlockType.SAND
		or map_type[pos.x][pos.z] == Variables.BlockType.GRASS):
			return true
	return false


func get_available_pos() -> Vector3:
	var block
	var iteration = 0
	while(true):
		var x = Tools.random_int_range(0, map_export.a_side - 1)
		var z = Tools.random_int_range(0, map_export.b_side - 1)
		
		iteration += 1
		if iteration >= 100:
			break
		
		if validate_block(x, z):
			var y = map_pos[x][z].y
			block = Vector3(x, y, z)
			return block
	return Vector3.INF


func is_out_of_bounds(x, z) -> bool:
	var x_limit = map_export.a_side
	var z_limit = map_export.b_side
	
	if x >= 0 and x < x_limit and z >= 0 and z < z_limit:
		return false
	return true
