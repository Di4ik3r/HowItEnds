extends Spatial
class_name Bot

enum Direction {
	N, NE, E, ES, S, SW, W, WN
}

var cardinal = Direction.W setget _set_cardinal
var look_at_pos: Vector3 = Vector3(1, 0, 0)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready() -> void:
	_set_cardinal(Direction.W)
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC
func move() -> void:
	translation += look_at_pos

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
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
