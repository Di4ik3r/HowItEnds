extends Spatial
class_name Bot

var function_dict = {
	Variables.Genes.MOVE: funcref(self, "_move"),
	Variables.Genes.STAY: funcref(self, "_stay"),
	Variables.Genes.EAT: funcref(self, "_eat"),
	Variables.Genes.EAT_BOT: funcref(self, "_eat_bot"),
	Variables.Genes.REPRODUCE: funcref(self, "_reproduce"),
	Variables.Genes.SENSE: funcref(self, "_sense"),
	Variables.Genes.ROTATE_E: funcref(self, "_rotate_e"),
	Variables.Genes.ROTATE_ES: funcref(self, "_rotate_es"),
	Variables.Genes.ROTATE_S: funcref(self, "_rotate_s"),
	Variables.Genes.ROTATE_WS: funcref(self, "_rotate_ws"),
	Variables.Genes.ROTATE_W: funcref(self, "_rotate_w"),
	Variables.Genes.ROTATE_WN: funcref(self, "_rotate_wn"),
	Variables.Genes.ROTATE_N: funcref(self, "_rotate_n"),
	Variables.Genes.ROTATE_EN: funcref(self, "_rotate_en"),
	Variables.Genes.SKIP1: funcref(self, "_skip1"),
	Variables.Genes.SKIP2: funcref(self, "_skip2"),
	Variables.Genes.SKIP3: funcref(self, "_skip3"),
	Variables.Genes.SKIP4: funcref(self, "_skip4"),
	Variables.Genes.SKIP5: funcref(self, "_skip5"),
	Variables.Genes.SKIP6: funcref(self, "_skip6"),
	Variables.Genes.SKIP7: funcref(self, "_skip7"),
	Variables.Genes.SKIP8: funcref(self, "_skip8"),
	Variables.Genes.SKIP9: funcref(self, "_skip9"),
	Variables.Genes.SKIP10: funcref(self, "_skip10"),
}

enum Direction {
	N, NE, E, ES, S, SW, W, WN
}

var manager
var cardinal = Direction.W setget _set_cardinal
var look_at_pos: Vector3 = Vector3(1, 0, 0)

var genotype: Array = Array()
var current_gen: int = 0 setget _set_current_gen
var current_gen_increaser: int = 1

var energy: int = Variables.START_ENERGY setget _set_energy
var type = Variables.BotType.A setget _set_type

onready var ModelA = $BotModelA
onready var ModelB = $BotModelB


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready() -> void:
	_set_cardinal(Direction.W)
	_init_genotype()
	_set_type(type)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC

func generate_genotype() -> void:
	current_gen = 0
	
	var genes = Variables.Genes.values()
	var genes_size = Variables.Genes.size()
	
	var types = Variables.BotType.values()
	_set_type(types[Tools.random_int_range(0, types.size() - 1)])
	
	for i in range(0, 64):
		var category = _get_random_category()
		var category_bounds = _get_category_bounds(category)
		var gen = Tools.random_array_range(category_bounds)
		genotype.append(Variables.Genes.values()[gen])

func generate_my_genotype() -> void:
	current_gen = 0
	
	var genes = Variables.Genes.values()
	
	genotype.append(genes[9])
	genotype.append(genes[17])
	genotype.append(genes[15])
	genotype.append(genes[0])
	genotype.append(genes[3])
	genotype.append(genes[3])
	genotype.append(genes[15])
	genotype.append(genes[15])
	genotype.append(genes[12])
	genotype.append(genes[0])
	genotype.append(genes[14])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[2])
	genotype.append(genes[5])
	genotype.append(genes[0])
	genotype.append(genes[6])
	genotype.append(genes[16])
	genotype.append(genes[2])
	genotype.append(genes[13])
	genotype.append(genes[7])
	genotype.append(genes[14])
	genotype.append(genes[11])
	genotype.append(genes[18])
	genotype.append(genes[6])
	genotype.append(genes[6])
	genotype.append(genes[0])
	genotype.append(genes[9])
	genotype.append(genes[0])
	genotype.append(genes[14])
	genotype.append(genes[0])
	genotype.append(genes[10])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[9])
	genotype.append(genes[13])
	genotype.append(genes[2])
	genotype.append(genes[0])
	genotype.append(genes[10])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[2])
	genotype.append(genes[0])
	genotype.append(genes[11])
	genotype.append(genes[0])
	genotype.append(genes[11])
	genotype.append(genes[15])
	genotype.append(genes[11])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[12])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[14])
	genotype.append(genes[12])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[11])
	genotype.append(genes[0])
	genotype.append(genes[0])
	genotype.append(genes[0])

func increase_current_gen(amount: int = 1) -> void:
	_set_current_gen(current_gen + current_gen_increaser)

func make_choice() -> void:
	(function_dict[genotype[current_gen]] as FuncRef).call_func()
	increase_current_gen()
	_set_energy(energy - 1)
	current_gen_increaser = 1

func kill() -> void:
	queue_free()
func _kill() -> void:
	manager.kill_bot(self)
	self.queue_free()

func parenting(parent: Bot, pos: Vector3) -> void:
	randomize()
	parent._set_energy(parent.energy - Variables.REPRODUCE_COST)
	genotype = generate_genotype_by_parent(parent)
#	energy = 80 + randi() % 10 - 11
	energy = round(parent.energy / 2)
func generate_genotype_by_parent(parent: Bot) -> Array:
	var result: Array = parent.genotype.duplicate()
	var chance: int = randi() % 11 + 1
	if chance <= 2:
		var types = Variables.BotType.values()
		type = types[Tools.random_int_range(0, types.size() - 1)]
		
		result = mutate(result)
	return result
func mutate(_genotype: Array) -> Array:
	var rand_gene = randi() % _genotype.size()
	var category = _get_random_category()
	var category_bounds = _get_category_bounds(category)
	var gen = Tools.random_array_range(category_bounds)
	_genotype[rand_gene] = Variables.Genes.values()[gen]
	return _genotype

func last_duplicate() -> Bot:
	var bot: Bot = load("res://scenes/simulation/bot/Bot.tscn").instance()
	bot.type = type
	bot.genotype = mutate_restart(genotype)
	bot.energy = Variables.START_ENERGY
	return bot
func mutate_restart(_genotype: Array) -> Array:
	var result: Array = _genotype.duplicate()
	var chance: int = randi() % 11 + 1
	if chance <= 2:
		var types = Variables.BotType.values()
		type = types[Tools.random_int_range(0, types.size() - 1)]
		
		result = mutate(result)
	return result


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _move() -> void:
	current_gen_increaser = manager.bot_move(self)
func _stay() -> void:
	_set_energy(energy + 1)
func _eat() -> void:
	manager.bot_eat(self)
#	if !manager.is_block_ahead(Env.BlockType.FOOD, position, current_rotation):
#		return
#	manager.remove_food(position, current_rotation)
#	var _energy = energy + Variables.FOOD_COST
#	_set_energy(_energy)
func _eat_bot() -> void:
	current_gen_increaser = manager.bot_eat_bot(self)
	
#	if Env.is_block_ahead(Env.BlockType.BOT, position, current_rotation) == false:
#		return
#	var energy_from_bot = round(manager.eat_bot(self) / 4)
#	_set_energy(energy + energy_from_bot)
func _reproduce() -> void:
	manager.bot_reproduce(self)
#	var reproduce_block = manager.get_block_for_reproduce(self)
#	if reproduce_block == Vector3.INF:
#		return
#	if energy <= Variables.REPRODUCE_BOUND:
#		return
	
#	var bot: Bot = load("res://scenes/Bot.tscn").instance()
#	bot.parenting(self, reproduce_block)

func _sense() -> void:
	current_gen_increaser = manager.bot_sense(self)
#	var block_ahead = Env.get_type(position, current_rotation)
#	current_gen_increaser = Env.GenTransition.values()[block_ahead]

const zero_skip: int = 40
func _skip1() -> void:
	increase_current_gen(zero_skip + 1)
func _skip2() -> void:
	increase_current_gen(zero_skip + 2)
func _skip3() -> void:
	increase_current_gen(zero_skip + 3)
func _skip4() -> void:
	increase_current_gen(zero_skip + 4)
func _skip5() -> void:
	increase_current_gen(zero_skip + 5)
func _skip6() -> void:
	increase_current_gen(zero_skip + 6)
func _skip7() -> void:
	increase_current_gen(zero_skip + 7)
func _skip8() -> void:
	increase_current_gen(zero_skip + 8)
func _skip9() -> void:
	increase_current_gen(zero_skip + 9)
func _skip10() -> void:
	increase_current_gen(zero_skip + 10)

func _rotate_e() -> void:
	_set_cardinal(Direction.E)
func _rotate_es() -> void:
	_set_cardinal(Direction.ES)
func _rotate_s() -> void:
	_set_cardinal(Direction.S)
func _rotate_ws() -> void:
	_set_cardinal(Direction.SW)
func _rotate_w() -> void:
	_set_cardinal(Direction.W)
func _rotate_wn() -> void:
	_set_cardinal(Direction.WN)
func _rotate_n() -> void:
	_set_cardinal(Direction.N)
func _rotate_en() -> void:
	_set_cardinal(Direction.NE)


func _init_genotype() -> void:
	if genotype.size() == 0:
		randomize()
#		generate_my_genotype()
		generate_genotype()

func _get_category_bounds(category: int) -> Array:
	var bound: Array
	match category:
		0:
			bound = [0, 1]
		1:
			bound = [2, 3]
		2:
			bound = [4, 4]
		3:
			bound = [5, 5]
		4:
			bound = [6, 13]
		5:
			bound = [14, 23]
		_:
			bound = [63, 64]
	
	return bound
func _get_random_category() -> int:
	return randi() % 6

func _set_cardinal(value) -> void:
	cardinal = value
	match cardinal:
		Direction.N:
			look_at_pos = Vector3(1, 0, 0)
		Direction.NE:
			look_at_pos = Vector3(1, 0, 1)
		Direction.E:
			look_at_pos = Vector3(0, 0, 1)
		Direction.ES:
			look_at_pos = Vector3(-1, 0, 1)
		Direction.S:
			look_at_pos = Vector3(-1, 0, 0)
		Direction.SW:
			look_at_pos = Vector3(-1, 0, -1)
		Direction.W:
			look_at_pos = Vector3(0, 0, -1)
		Direction.WN:
			look_at_pos = Vector3(1, 0, -1)
	look_at(translation + look_at_pos, Vector3.UP)

func _set_current_gen(value: int) -> void:
	var genotype_size = genotype.size()
	if value < genotype_size:
		current_gen = value
	else:
		current_gen = value - genotype_size

func _set_energy(value: int) -> void:
	energy = value
	if energy <= 0:
		_kill()


func _set_type(value: int) -> void:
	type = value
	
	if ModelA:
		ModelA.hide()
		ModelB.hide()
		match type:
			Variables.BotType.A:
				ModelA.show()
			Variables.BotType.B:
				ModelB.show()
