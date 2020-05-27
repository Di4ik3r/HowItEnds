extends Node
class_name BotManager


var map_export: MapExport = null
var map_pos: Array
var map_type: Array
var bots: Array


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _init() -> void:
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC
func spawn_bot() -> void:
	var parent = get_parent()
	
	var bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	bot.translation = _get_available_pos()
	
	parent.add_child(bot)

func move_bot(bot: Bot) -> void:
	if _validate_move(bot):
		bot.translation += bot.look_at_pos
		bot.translation.y = map_pos[bot.translation.x][bot.translation.z]


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _get_available_pos() -> Vector3:
	var condition = true
#	while(condition):
#		var x = Tools.random_int_range(0, map_export.a_side)
#		var z = Tools.random_int_range(0, map_export.b_side)
	return Vector3.ZERO

func _validate_move(bot: Bot) -> bool:
	var predictable_pos = bot.translation + bot.look_at_pos
	var x = predictable_pos.x
	var z = predictable_pos.z
	
	var x_limit = map_export.a_side
	var z_limit = map_export.b_side
	
	if x >= 0 and x < x_limit and z >= 0 and z < z_limit:
		if (map_type[x][z] == Variables.BlockType.SAND
		or map_type[x][z] == Variables.BlockType.GRASS):
			return true
	return false
