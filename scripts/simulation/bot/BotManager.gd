extends Node
class_name BotManager


var map_bots: Dictionary

var bot_holder: Spatial
var bots: Array

var map_manager: MapManager
var FoodManager = null

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _init() -> void:
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC


func cycle() -> void:
	for bot in bots:
		(bot as Bot).make_choice()





func spawn_bot(bot: Bot = null, pos: Vector3 = Vector3.INF) -> void:
	if !bot:
		bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	
	if pos == Vector3.INF:
		pos = map_manager.get_available_pos()
		
	bot.translation = pos
	bot.manager = self
	
	bots.append(bot)
	map_bots[Vector3(pos.x, 0, pos.z)] = bot
	bot_holder.add_child(bot)


func bot_move(bot: Bot) -> int:
#	var increaser = Variables.GenTransition.EMPTY
	if _validate_move(bot):
		var increaser = bot_sense(bot)
		
		map_bots[Vector3(bot.translation.x, 0, bot.translation.z)] = null
		bot.translation += bot.look_at_pos
		bot.translation.y = map_manager.get_y(bot.translation.x, bot.translation.z)
		map_bots[Vector3(bot.translation.x, 0, bot.translation.z)] = bot
		
		return increaser
	return bot_sense(bot)
#		increaser = _get_transition_gen(map_type[bot.translation.x][bot.translation.z])
#	return increaser


func bot_eat(bot: Bot) -> int:
	var pos = Vector3(bot.translation.x + bot.look_at_pos.x, \
		map_manager.get_y(bot.translation.x, bot.translation.z), \
		bot.translation.z + bot.look_at_pos.z)
	
	if map_manager.is_out_of_bounds(pos.x, pos.z):
		return Variables.GenTransition.IMPASSABLE
	
	if map_manager.block_is_food(pos.x, pos.z):
		FoodManager.remove_food(pos)
		bot.energy += Variables.FOOD_COST
	return sense(pos)


func bot_eat_bot(bot: Bot) -> int:
	var pos = Vector3(bot.translation.x + bot.look_at_pos.x, \
		map_manager.get_y(bot.translation.x, bot.translation.z), \
		bot.translation.z + bot.look_at_pos.z)
	
	if map_manager.is_out_of_bounds(pos.x, pos.z):
		return Variables.GenTransition.IMPASSABLE
	
	var bot_for_eat = map_bots[Vector3(pos.x, 0, pos.z)]
	if bot_for_eat:
#		print(bot_for_eat)
		kill_bot(bot_for_eat)
		bot.energy += round(bot_for_eat.energy / 4)
#		return Variables.GenTransition.BOT
#	return Variables.GenTransition.EMPTY
	return sense(pos)


func kill_bot(bot: Bot) -> void:
#	last_bots.push_back(bot.last_duplicate())
#	if last_bots.size() > TEST_BOT_BOUND:
#		var bot_to_remove = last_bots.pop_front()
#		bot_to_remove.queue_free()
	var pos = bot.translation
	map_bots[Vector3(pos.x, 0, pos.z)] = null
	var result = bots.erase(bot)
	bot_holder.remove_child(bot)
	bot.kill()
#	if bots.size() == 0:
#		restart()

func reproduce_bot(bot: Bot) -> void:
	pass
func bot_reproduce(bot: Bot) -> void:
	var reproduce_block = map_manager.get_block_for_reproduce(bot)
	if reproduce_block == Vector3.INF ||\
	bot.energy <= Variables.REPRODUCE_BOUND:
		return
	
	var child: Bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	child.parenting(bot, reproduce_block)
	
	spawn_bot(child, reproduce_block)

func bot_sense(bot: Bot) -> int:
	var pos = Vector3(\
		bot.translation.x + bot.look_at_pos.x,\
		0,\
		bot.translation.z + bot.look_at_pos.z)
	return sense(pos)

func sense(pos: Vector3) -> int:
	if map_manager.is_out_of_bounds(pos.x, pos.z):
		return Variables.GenTransition.IMPASSABLE
	if map_bots[Vector3(pos.x, 0, pos.z)]:
		return Variables.GenTransition.BOT
	return _get_transition_gen(map_manager.map_type[pos.x][pos.z])

func init_map_bots() -> void:
	map_bots = Dictionary()
	for blocks in map_manager.map_pos:
		for block in blocks:
			var pos = Vector3(block.x, 0, block.z)
#			map_bots[pos] = Variables.MapBots.EMPTY
			map_bots[pos] = null

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _get_bot_by_pos(_pos: Vector3) -> Bot:
	for bot in bots:
		var bot_pos = Vector3(bot.translation.x, 0, bot.translation.z)
		var pos = Vector3(_pos.x, 0, _pos.z)
		if bot_pos == pos:
			return bot
	return null


func _validate_move(bot: Bot) -> bool:
	var predictable_pos = bot.translation + bot.look_at_pos
	var x = predictable_pos.x
	var z = predictable_pos.z
	
	var x_limit = map_manager.map_export.a_side
	var z_limit = map_manager.map_export.b_side
	
	if !map_manager.is_out_of_bounds(x, z):
		if map_manager.validate_block(x, z):
#			if !map_manager.block_is_bot(x, z):
#		if (map_type[x][z] == Variables.BlockType.SAND
#		or map_type[x][z] == Variables.BlockType.GRASS):
			return true
	return false

func _get_transition_gen(block_type: int) -> int:
	match block_type:               
		Variables.BlockType.BOT:
			return Variables.GenTransition.BOT
		Variables.BlockType.FOREST,\
		Variables.BlockType.MOUNTAIN,\
		Variables.BlockType.WATER:
			return Variables.GenTransition.IMPASSABLE
		Variables.BlockType.GRASS,\
		Variables.BlockType.SAND:
			return Variables.GenTransition.EMPTY
		Variables.BlockType.FOOD:
			return Variables.GenTransition.FOOD
	
	return Variables.GenTransition.EMPTY
