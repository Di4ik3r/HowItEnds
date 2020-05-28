extends Node

enum BlockType {
	MOUNTAIN,
	SAND,
	GRASS,
	WATER,
	FOREST,
	BOT,
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

const FOOD_COST = 45
const BOT_COST = 14
const MOVE_COST = 0
const ROTATE_COST = 0
const REPRODUCE_COST = 35
const REPRODUCE_BOUND = 225
const START_ENERGY = 140

const UNIT = 1



func _ready():
	pass
