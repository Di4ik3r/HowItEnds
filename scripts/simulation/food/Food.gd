extends Spatial



onready var A = $MeshHolder/a
onready var B = $MeshHolder/b
onready var C = $MeshHolder/c


func _ready():
	randomize()
	match randi() % 3:
		0:
			A.show()
		1:
			B.show()
		2:
			C.show()
