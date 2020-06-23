extends Node
class_name BotManager


signal bots_died
signal bots_refreshed

var map_bots: Dictionary

var bot_holder: Spatial
var bots: Array
var bots_buff: Array = Array()

var map_manager: MapManager
var FoodManager = null
var sim_stats = null



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _init() -> void:
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC

func start_spawn() -> void:
	if Tools.sim_stats:
		if Tools.sim_stats.info.size() == 0:
			print("empty")
			var multiplier = Variables.BOTS_BUFF_MULTIPLIER
			if multiplier == 0:
				multiplier = 1
			for i in range(0, Variables.BOTS_BUFF_SIZE * multiplier):
				spawn_bot()
		else:
			print("loading")
			var amount = Tools.sim_stats.info.size()
			for i in range(0, amount):
				spawn_bot_with_genotype(Tools.sim_stats.info[i])
	
#	var a = map_manager.map_export.a_side
#	var b = map_manager.map_export.b_side
#	var amount = a * b
#	amount *= 0.002
#	for i in range(0, amount):
#		spawn_bot()


func restart() -> void:
#	restart_count += 1
	var restart_count = Tools.sim_stats.restart_count - 1
	print("restart #%d : %s" % [restart_count, str(OS.get_time())])
	
	for i in range(0, bots_buff.size()):
		var _bot = bots_buff.pop_back()
		if !(_bot is Bot):
			continue
		var bot: Bot = _bot
#		var amount_of_copy = randi() % (Variables.BOTS_BUFF_MULTIPLIER + 1)
#		var amount_of_copy = Variables.BOTS_BUFF_MULTIPLIER
		var amount_of_copy = Tools.random_int_range(0, Variables.BOTS_BUFF_MULTIPLIER)
		for j in range(0, amount_of_copy):
#			print("copied")
			var bot_copy = bot.last_duplicate()
			spawn_bot(bot_copy)
		spawn_bot(bot)
	
	print(bots.size())


func cycle() -> void:
	for bot in bots:
		if bot and is_instance_valid(bot) and bot is Bot:
			(bot as Bot).make_choice()


func spawn_bot(bot: Bot = null, pos: Vector3 = Vector3.INF) -> void:
	if !bot:
		bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	
	if pos == Vector3.INF:
		pos = map_manager.get_available_pos()
		
	bot.translation = pos
	bot.manager = self
	
	bots.append(bot)
	emit_signal("bots_refreshed")
	map_bots[Vector3(pos.x, 0, pos.z)] = bot
	bot_holder.add_child(bot)


func spawn_bot_with_genotype(info: Dictionary) -> void:
	var bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	var pos = map_manager.get_available_pos()
	
	bot.genotype = info.genotype.duplicate()
	bot.type = info.type
	bot.manager = self
	bot.translation = pos
	
	bots.append(bot)
	emit_signal("bots_refreshed")
	map_bots[Vector3(pos.x, 0, pos.z)] = bot
	
	bot_holder.add_child(bot)


func bot_move(bot: Bot) -> int:
#	var increaser = Variables.GenTransition.EMPTY
	if _validate_move(bot):
		var increaser = bot_sense(bot)
		
		map_bots[Vector3(bot.translation.x, 0, bot.translation.z)] = null
		
		var pos = bot.translation + bot.look_at_pos
		pos.y = map_manager.get_y(pos.x, pos.z)
		
		bot.translation += bot.look_at_pos
		bot.translation.y = pos.y
#		bot.interpolate_move(pos)
#		bot.translation += bot.look_at_pos
#		bot.translation.y = map_manager.get_y(bot.translation.x, bot.translation.z)
		
		map_bots[Vector3(pos.x, 0, pos.z)] = bot
		
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
		bot.food_eated += 1
	
	return sense(pos)


func bot_eat_bot(bot: Bot) -> int:
	
	var pos = Vector3(bot.translation.x + bot.look_at_pos.x, \
		map_manager.get_y(bot.translation.x, bot.translation.z), \
		bot.translation.z + bot.look_at_pos.z)
	pos.x = floor(pos.x)
	pos.z = floor(pos.z)
	
	if map_manager.is_out_of_bounds(pos.x, pos.z):
		return Variables.GenTransition.IMPASSABLE
	
	var bot_for_eat = map_bots[Vector3(pos.x, 0, pos.z)]
	
	if is_instance_valid(bot_for_eat):
		if bot_for_eat and bot_for_eat is Bot:
	#		print(bot_for_eat)
			print("try eating ", bot.id)
	#		bot.energy += round(bot_for_eat.energy / 4)
			bot.energy += round(bot_for_eat.energy / 2)
			kill_bot(bot_for_eat)
			bot.bots_eated += 1
	#		return Variables.GenTransition.BOT
#	return Variables.GenTransition.EMPTY
	return sense(pos)


func kill_bot(bot: Bot) -> void:
	if !bot:
		return
	
	if is_instance_valid(bot):
		bots_buff.push_back(bot.last_duplicate())
		if bots_buff.size() > Variables.BOTS_BUFF_SIZE:
			if is_instance_valid(bot):
				var bot_to_remove = bots_buff.pop_front()
				if is_instance_valid(bot_to_remove):
					if bot_to_remove is Bot:
						bot_to_remove.queue_free()

	var pos = bot.translation
	map_bots[Vector3(pos.x, 0, pos.z)] = null
	var result = bots.erase(bot)
	emit_signal("bots_refreshed")
	bot_holder.remove_child(bot)
	bot.kill()
	
	if bots.size() == 0:
		emit_signal("bots_died")
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
	if map_manager.is_out_of_bounds(floor(pos.x), floor(pos.z)):
		return Variables.GenTransition.IMPASSABLE
	if map_bots[Vector3(floor(pos.x), 0, floor(pos.z))]:
		return Variables.GenTransition.BOT
	return _get_transition_gen(map_manager.map_type[floor(pos.x)][floor(pos.z)])


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
