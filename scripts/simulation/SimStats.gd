class_name SimStats
extends Resource


const FILE_PATH: String = "BotSim"
const MAP_VARS_STR: String = " map_vars"

export var genotypes: Array
export var map_vars: Resource = null
export var restart_count: int = 1


func auto_write_data(bots: Array, file_name: String = "_backup") -> int:
	genotypes = get_genotypes_by_array(bots)
	return auto_save()
#	return save(file_name)


func write_data(file_name: String, bots: Dictionary) -> int:
	var _genotypes = get_genotypes_by_dictionary(bots)
	return save(file_name)


func auto_save() -> int:
	var save_name = Variables.save_name
	
	var dir = Directory.new()
	dir.open("user://saves/")
	if !dir.dir_exists(save_name):
		dir.make_dir(save_name)
	dir.open("user://saves/%s/" % [save_name])
	dir.make_dir("%d" % [restart_count])
	
	var file_path = "user://saves/%s/%d/sim_stats.tres" % [save_name, restart_count]
	var map_vars_file_path = "user://saves/%s/%d/map_vars.tres" % [save_name, restart_count]

	var result = ResourceSaver.save(file_path, self)
	var result1 = ResourceSaver.save(map_vars_file_path, map_vars)
	
	restart_count += 1
	return result


func save(file_name: String = "_backup") -> int:
	var dir = Directory.new()
	dir.open("user://saves/")
	dir.make_dir(file_name)
	
	var file_path = "user://saves/%s/%s.tres" % [file_name, file_name]
	var map_vars_file_path = "user://saves/%s/%s%s.tres" % [file_name, file_name, MAP_VARS_STR]

	var result = ResourceSaver.save(file_path, self)
	var result1 = ResourceSaver.save(map_vars_file_path, map_vars)
	return result
#	if result != OK:
#		return "can't save result to %s file path" % file_path
#	return "successfull load load"


func auto_read() -> int:
#	if file_name == "autosave 17:3:54 map_vars":
	var save_name = Variables.save_name
	var restarts = Tools.get_save_restarts()
	print(restarts)
	var restart = str(restarts[restarts.size() - 1])
	var load1 = str("user://saves/%s/%s/sim_stats.tres" % [save_name, restart])
	var load2 = str("user://saves/%s/%s/map_vars.tres" % [save_name, restart])
	var readed = load(load1)
	var readed1 = load(load2)
	
	if not readed or not readed1:
		return ERR_FILE_NOT_FOUND
#		return "Can't load %s resource" % file_name
	
	genotypes = readed.genotypes
	restart_count = readed.restart_count + 1
	var script = load("res://resources/map/MapVars.gd")
	map_vars = readed1
	map_vars.set_script(script)
#	return "successfull load file"
	return OK


func read(file_name: String = "_backup") -> int:
#	if file_name == "autosave 17:3:54 map_vars":
	var load1 = str("user://saves/%s/%s.tres" % [file_name, file_name])
	var load2 = str("user://saves/%s/%s%s.tres" % [file_name, file_name, MAP_VARS_STR])
	var readed = load(load1)
	var readed1 = load(load2)
	
	if not readed or not readed1:
		return ERR_FILE_NOT_FOUND
#		return "Can't load %s resource" % file_name
	
	genotypes = readed.genotypes
	var script = load("res://resources/map/MapVars.gd")
	map_vars = readed1
	map_vars.set_script(script)
#	return "successfull load file"
	return OK


func get_genotypes_by_array(bots: Array) -> Array:
	var _genotypes = Array()
	for bot in bots:
		_genotypes.append(bot.genotype.duplicate())
	return _genotypes


func get_genotypes_by_dictionary(bots: Dictionary) -> Array:
	var _genotypes = Array()
	for bot in bots:
		_genotypes.append(bot.genotype.duplicate())
	return _genotypes
