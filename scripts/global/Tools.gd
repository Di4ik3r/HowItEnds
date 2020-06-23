#class_name Tools
#tool
extends Node

const NOISE_A = -1
const NOISE_B = 1

var sim_stats = preload("res://resources/simulation/SimStats.tres")
var saves_info = preload("res://resources/saves/SavesInfo.tres")


func _ready():
	pass


func save_last_save() -> void:
	saves_info.last_save_name = Variables.save_name
	saves_info.auto_save()


func get_last_save() -> String:
#	print("in get last save")
	saves_info.auto_read()
	return saves_info.last_save_name


func sort_restarts(a: int, b: int):
		if a < b:
			return true
		return false

func get_save_restarts() -> Array:
	var files = []
	var dir = Directory.new()
	dir.open("user://saves/%s/" % [Variables.save_name])
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(int(file))

	files.sort()
	dir.list_dir_end()
	return files

func get_all_saves() -> Array:
	var files = []
	var dir: Directory = Directory.new()
#	if !dir.dir_exists("user://saves/"):
#		dir.make_dir("saves")
	dir.open("user://")
	if !dir.dir_exists("user://saves"):
		dir.make_dir("user://saves/")
	dir.open("user://saves/")
	dir.list_dir_begin()

	while true:
		var file: String = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if not (".res" in file or ".tres" in file):
				files.append(file)

	files.sort()
	dir.list_dir_end()
	return files


func noise_float_lerp(a: float) -> float:
	var result = range_lerp(a * 1, NOISE_A, NOISE_B, 0, 1)
	return result


func random_array_range(bounds: Array) -> int:
	return randi() % (bounds[1] - bounds[0] + 1) + bounds[0]
func random_int_range(a: int, b: int) -> int:
	return randi() % (b - a + 1) + a
