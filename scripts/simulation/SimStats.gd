class_name SimStats
extends Resource

export var genotypes: Array

const FILE_PATH: String = "BotSim"

func auto_write_data(bots: Array) -> int:
	genotypes = get_genotypes_by_array(bots)
	return save()

func write_data(file_name: String, bots: Dictionary) -> int:
	var _genotypes = get_genotypes_by_dictionary(bots)
	return save(file_name)

func save(file_name: String = "_backup") -> int:
	var file_path = "user://%s.tres" % file_name
	var result = ResourceSaver.save(file_path, self)
	return result
#	if result != OK:
#		return "can't save result to %s file path" % file_path
#	return "successfull load load"

func read(file_name: String = "_backup") -> int:
	var readed = load("user://%s.tres" % file_name)
	if not readed:
		return ERR_FILE_NOT_FOUND
#		return "Can't load %s resource" % file_name
	
	genotypes = readed.genotypes
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
