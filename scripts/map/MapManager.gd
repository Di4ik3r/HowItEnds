extends Node
class_name MapManager





var map_export: MapExport = null
var map_pos: Array
var map_type: Array
var map_bots: Dictionary
var food_blocks: Dictionary = {}
var FoodManager = null



func _ready():
	pass


func place_food(pos: Vector3) -> void:
	food_blocks[Vector3(pos.x, 0, pos.z)] = map_type[pos.x][pos.z]
	map_type[pos.x][pos.z] = Variables.BlockType.FOOD


func remove_food(pos: Vector3) -> void:
	map_type[pos.x][pos.z] = food_blocks[Vector3(pos.x, 0, pos.z)]
	food_blocks.erase(Vector3(pos.x, 0, pos.z))


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


func block_is_bot(x: int, z: int) -> bool:
#	var value = null if map_bots[Vector3(x, 0, z)] is int else map_bots[Vector3(x, 0, z)]
	var value = map_bots[Vector3(x, 0, z)]
	if value:
		return true
	return false


func block_is_food(x: int, z: int) -> bool:
	if FoodManager.foods.has(Vector3(x, 0, z)):
		return true
	return false


func validate_block(x, z) -> bool:
	if !is_out_of_bounds(x, z):
#		if !map_bots[Vector3(x, 0, z)]:
		if (map_type[x][z] == Variables.BlockType.SAND
		or map_type[x][z] == Variables.BlockType.GRASS):
				if !block_is_bot(x, z):
					return true
	return false


#func validate_block_vector(pos: Vector3) -> bool:
#	if (map_type[pos.x][pos.z] == Variables.BlockType.SAND
#	or map_type[pos.x][pos.z] == Variables.BlockType.GRASS):
#		if !map_bots[Vector3(pos.x, 0, pos.z)]:
#			return true
#	return false


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



func export_map_to_csv() -> void:
	var file = File.new()
	file.open("user://map_export.csv", File.WRITE)
	
	var array = []
	var buff = []
	for row in map_type:
		for cell in row:
			buff.append(str(cell) + ",")
		file.store_csv_line(PoolStringArray(buff))
		buff.clear()
	
	file.close()
