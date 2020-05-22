extends Resource
class_name MapExport


var blocks: Array
var tress: Array
var a_side: int
var b_side: int
var min_height: int
var max_height: int

func _init(data: Dictionary) -> void:
	blocks = data.blocks
	a_side = data.a_side
	b_side = data.b_side
	min_height = data.min_height
	max_height = data.max_height
#	tress = data.blocks
