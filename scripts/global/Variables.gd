extends Node



enum SimulationState {
	STOP, NORMAL, FAST
}

enum BlockType {
	MOUNTAIN,
	SAND,
	GRASS,
	WATER,
	FOREST,
	BOT,
	FOOD,
}

enum MapBots {
	EMPTY, BOT
}

enum Genes {
	MOVE,
	STAY,
	EAT,
	EAT_BOT,
	REPRODUCE,
	SENSE,
	ROTATE_E,
	ROTATE_ES,
	ROTATE_S,
	ROTATE_WS,
	ROTATE_W,
	ROTATE_WN,
	ROTATE_N,
	ROTATE_EN,
	SKIP1,
	SKIP2,
	SKIP3,
	SKIP4,
	SKIP5,
	SKIP6,
	SKIP7,
	SKIP8,
	SKIP9,
	SKIP10,
}

enum BlockType_depr {
	EMPTY = 0,
	FOOD = 1,
	BOT = 2,
	IMPASSABLE = -1,
}

enum GenTransition {
	EMPTY = 2,
	FOOD = 3,
	BOT = 4,
	IMPASSABLE = 5,
}

enum BotType {
	A, B
}

var IP = "http://192.168.43.10:5000"
#const FOOD_COST = 45
const FOOD_COST = 75
const BOT_COST = 14
const MOVE_COST = 0
const ROTATE_COST = 0
const REPRODUCE_COST = 35
#const REPRODUCE_BOUND = 625
const REPRODUCE_BOUND = 2
#const START_ENERGY = 440   # new last was ~100
const START_ENERGY = 120

const UNIT = 1

#const BOTS_BUFF_SIZE = 15
const BOTS_BUFF_SIZE = 15
const BOTS_BUFF_MULTIPLIER = 0

const SIM_STOP_SPEED = 0
const SIM_NORMAL_SPEED = 1
const SIM_FAST_SPEED = 0.001


var timestamp = OS.get_time()
var save_name: String = ""
var sim_state = SimulationState.STOP

var _bots_counter = 0


func _ready():
	pass


func bots_counter() -> int:
	_bots_counter += 1
	return _bots_counter
