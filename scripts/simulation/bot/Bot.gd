extends Spatial
class_name Bot

const FOOD_COST = 45
const BOT_COST = 14
const MOVE_COST = 0
const ROTATE_COST = 0
const REPRODUCE_COST = 35
const REPRODUCE_BOUND = 225

const START_ENERGY = 140

var Manager: SimManager = SimManager.new()
var function_dict = {
	Manager.Genes.MOVE: funcref(self, "_move"),
	Manager.Genes.STAY: funcref(self, "_stay"),
	Manager.Genes.EAT: funcref(self, "_eat"),
	Manager.Genes.EAT_BOT: funcref(self, "_eat_bot"),
	Manager.Genes.REPRODUCE: funcref(self, "_reproduce"),
	Manager.Genes.SENSE: funcref(self, "_sense"),
	Manager.Genes.ROTATE_E: funcref(self, "_rotate_e"),
	Manager.Genes.ROTATE_ES: funcref(self, "_rotate_es"),
	Manager.Genes.ROTATE_S: funcref(self, "_rotate_s"),
	Manager.Genes.ROTATE_WS: funcref(self, "_rotate_ws"),
	Manager.Genes.ROTATE_W: funcref(self, "_rotate_w"),
	Manager.Genes.ROTATE_WN: funcref(self, "_rotate_wn"),
	Manager.Genes.ROTATE_N: funcref(self, "_rotate_n"),
	Manager.Genes.ROTATE_EN: funcref(self, "_rotate_en"),
	Manager.Genes.SKIP1: funcref(self, "_skip1"),
	Manager.Genes.SKIP2: funcref(self, "_skip2"),
	Manager.Genes.SKIP3: funcref(self, "_skip3"),
	Manager.Genes.SKIP4: funcref(self, "_skip4"),
	Manager.Genes.SKIP5: funcref(self, "_skip5"),
	Manager.Genes.SKIP6: funcref(self, "_skip6"),
	Manager.Genes.SKIP7: funcref(self, "_skip7"),
	Manager.Genes.SKIP8: funcref(self, "_skip8"),
	Manager.Genes.SKIP9: funcref(self, "_skip9"),
	Manager.Genes.SKIP10: funcref(self, "_skip10"),
}

var current_rotation: Vector2 = Vector2(Manager.UNIT, 0) setget _set_current_rotation

var genotype: = Array()
var current_gen: = 0 setget _set_current_gen
var current_gen_increaser = 1

var energy = START_ENERGY setget _set_energy


onready var EnergyLabel = $EnergyLabel
onready var BotSprite = $BotSprite

func _ready() -> void:
	randomize()
#	print(GenTransition)
	_update_label()
	if genotype.size() == 0:
		generate_genotype()

func last_duplicate() -> Bot:
	var bot: Bot = load("res://scenes/Bot.tscn").instance()
#	bot.parenting(self, reproduce_block)
#	var bot: Bot = self.duplicate()
	bot.genotype = mutate_restart(genotype)
	bot.energy = START_ENERGY
	return bot

func mutate_restart(_genotype: Array) -> Array:
	var result: Array = _genotype.duplicate()
	var chance: int = randi() % 11 + 1
	if chance <= 2:
		result = mutate(result)
	return result

func parenting(parent: Bot, pos: Vector2) -> void:
#	print("reproduced")
	randomize()
	$BotSprite.texture = load("res://square.png")
	parent._set_energy(parent.energy - REPRODUCE_COST)
	genotype = generate_genotype_by_parent(parent)
	energy = 80 + randi() % 10 - 11
	Manager.reproduce_bot(self, pos)

func generate_genotype_by_parent(parent: Bot) -> Array:
	var result: Array = parent.genotype.duplicate()
	var chance: int = randi() % 11 + 1
	if chance <= 2:
		$BotSprite.texture = load("res://child.png")
		result = mutate(result)
	return result

func mutate(_genotype: Array) -> Array:
#	_genotype[rand_gene] = Manager.Genes[rand_gene]
#	_genotype[rand_gene] = Manager.Genes[randi() % Manager.Genes.size()]

	var rand_gene = randi() % _genotype.size()
#	_genotype[rand_gene] = Manager.Genes.values()[randi() % Manager.Genes.size()]
	
	var category = get_random_category()
	var category_bounds = get_category_bounds(category)
	var gen = random(category_bounds)
	_genotype[rand_gene] = Manager.Genes.values()[gen]
	return _genotype
func random(bounds: Array) -> int:
	return randi() % (bounds[1] - bounds[0] + 1) + bounds[0]
func get_category_bounds(category: int) -> Array:
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
func get_random_category() -> int:
	return randi() % 6


func generate_my_genotype() -> void:
	genotype = Array()
	current_gen = 0
	
	var genes = Manager.Genes.values()
	
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
func generate_genotype() -> void:
	genotype = Array()
	current_gen = 0
	
	var genes = Manager.Genes.values()
	var genes_size = Manager.Genes.size()
	
	var skip = 5
	
	for i in range(0, 64):
#		var chance = randi() % 11 + 1
#		if chance <= 5:
#			genotype.append(genes[randi() % skip])
#		else:
#			genotype.append(genes[randi() % 13 + skip + 1])
		
		genotype.append(genes[randi() % genes_size])
		
#		var chance = randi() % 11 + 1
#		if chance <= 5:
#			genotype.append(genes[randi() % skip])
#		elif chance > 5 and chance <= 7:
#			genotype.append(genes[randi() % 8 + skip])
#		else:
#			genotype.append(genes[randi() % 10 + skip + 8])
	
#	for i in range(0, genotype.size()):
#		print("%d: %s" % [i, Manager.Genes.keys()[genotype[i]]])

func increase_current_gen(amount: int = 1) -> void:
	_set_current_gen(current_gen + current_gen_increaser)

func make_choice() -> void:
	(function_dict[genotype[current_gen]] as FuncRef).call_func()
	increase_current_gen()
	_set_energy(energy - 1)
	current_gen_increaser = 1

func print_current_gen() -> void:
	print("next gene: ", Manager.Genes.keys()[genotype[current_gen]])

func _move() -> void:
	var block_type = Manager.get_type(self.get_pos_vec2(), current_rotation)
	match block_type:
		Manager.BlockType.EMPTY:
			Manager.move_bot(get_pos_vec2(), current_rotation)
#			var translating = Vector3(current_rotation.x, get_pos_vec2().y, current_rotation.y)
			translate(get_look_at_pos())
			current_gen_increaser = Manager.GenTransition.EMPTY
		Manager.BlockType.IMPASSABLE:
			current_gen_increaser = Manager.GenTransition.IMPASSABLE
		Manager.BlockType.FOOD:
			current_gen_increaser = Manager.GenTransition.FOOD
		Manager.BlockType.BOT:
			current_gen_increaser = Manager.GenTransition.BOT

func _stay() -> void:
	_set_energy(energy + 1)

func _eat() -> void:
	if !Manager.is_block_ahead(Manager.BlockType.FOOD, get_pos_vec2(), current_rotation):
		return
	
	Manager.remove_food(get_pos_vec2(), current_rotation)
	$BotSprite.texture = load("res://lox.png")
	
	var _energy = energy + FOOD_COST
	_set_energy(_energy)

func _eat_bot() -> void:
	if Manager.is_block_ahead(Manager.BlockType.BOT, get_pos_vec2(), current_rotation) == false:
		return
	var energy_from_bot = round(Manager.eat_bot(get_pos_vec2() + current_rotation) / 4)
	$BotSprite.texture = load("res://predator.png")
	_set_energy(energy + energy_from_bot)

func _reproduce() -> void:
	var reproduce_block = Manager.get_block_for_reproduce(get_pos_vec2())
	if reproduce_block == Vector2.INF:
		return
	if energy <= REPRODUCE_BOUND:
		return
	
	var bot: Bot = load("res://scenes/Bot.tscn").instance()
	bot.parenting(self, reproduce_block)

func _sense() -> void:
	var block_ahead = Manager.get_type(get_pos_vec2(), current_rotation)
	current_gen_increaser = Manager.GenTransition.values()[block_ahead]

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
	_set_current_rotation(Vector2(Manager.UNIT, 0))
#	BotSprite.rotation_degrees = 0
#	print("rotate_e")
	pass
func _rotate_es() -> void:
	_set_current_rotation(Vector2(Manager.UNIT, Manager.UNIT))
#	BotSprite.rotation_degrees = 45
#	print("rotate_es")
	pass
func _rotate_s() -> void:
	_set_current_rotation(Vector2(0, Manager.UNIT))
#	BotSprite.rotation_degrees = 90
#	print("rotate_s")
	pass
func _rotate_ws() -> void:
	_set_current_rotation(Vector2(-Manager.UNIT, Manager.UNIT))
#	BotSprite.rotation_degrees = 135
#	print("rotate_ws")
	pass
func _rotate_w() -> void:
	_set_current_rotation(Vector2(-Manager.UNIT, 0))
#	BotSprite.rotation_degrees = 180
#	print("rotate_w")
	pass
func _rotate_wn() -> void:
	_set_current_rotation(Vector2(-Manager.UNIT, -Manager.UNIT))
#	BotSprite.rotation_degrees = 225
#	print("rotate_wn")
	pass
func _rotate_n() -> void:
	_set_current_rotation(Vector2(0,  -Manager.UNIT))
#	BotSprite.rotation_degrees = 270
#	print("rotate_n")
	pass
func _rotate_en() -> void:
	_set_current_rotation(Vector2(Manager.UNIT, -Manager.UNIT))
#	BotSprite.rotation_degrees = 315
#	print("rotate_en")
	pass

func kill() -> void:
	queue_free()

func _kill() -> void:
	Manager.kill_bot(self)
	self.queue_free()

func _update_label() -> void:
	if EnergyLabel:
		EnergyLabel.text = str(energy)

func _set_energy(value: int) -> void:
	energy = value
	if energy <= 0:
		_kill()
	_update_label()

func _set_current_rotation(value: Vector2) -> void:
	current_rotation = value
	
	look_at(get_look_at_pos(), Vector3.UP)

func _set_current_gen(value: int) -> void:
	var genotype_size = genotype.size()
	if value < genotype_size:
		current_gen = value
	else:
		current_gen = value - genotype_size

func get_pos_vec2() -> Vector2:
	return Vector2(translation.x, translation.z)
func get_look_at_pos() -> Vector3:
	return translation + Vector3(current_rotation.x, 0, current_rotation.y)
