#class_name Tools
tool
extends Node

const NOISE_A = -1
const NOISE_B = 1

func _ready():
	pass

func noise_float_lerp(a: float) -> float:
	var result = range_lerp(a * 1, NOISE_A, NOISE_B, 0, 1)
	return result

func random_array_range(bounds: Array) -> int:
	return randi() % (bounds[1] - bounds[0] + 1) + bounds[0]
func random_int_range(a: int, b: int) -> int:
	return randi() % (b - a + 1) + a
