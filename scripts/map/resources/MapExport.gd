extends Resource
class_name MapExport


var blocks: Array
var trees: Array
var a_side: int
var b_side: int
var min_height: float
var max_height: float

func _init(data: Dictionary) -> void:
	blocks = data.blocks
	trees = data.trees
	a_side = data.a_side
	b_side = data.b_side
	min_height = data.min_height
	max_height = data.max_height
#	tress = data.blocks
