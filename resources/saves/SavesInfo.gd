class_name SavesInfo
extends Resource


export var last_save_name = "" setget _set_last_save_name


func auto_read() -> int:
	var load1 = "user://saves/saves_info.tres"
	var readed = load(load1)
	
	
	if not readed:
		return ERR_FILE_NOT_FOUND
	
#	print("tyt")
	
	last_save_name = readed.last_save_name
#	return "successfull load file"
	return OK


func auto_save() -> int:
	if !Variables:
		return ERR_BUSY
	
	last_save_name = Variables.save_name
	
	var dir = Directory.new()
	dir.open("user://")
	if !dir.dir_exists("saves"):
		dir.make_dir("saves")
	dir.open("user://saves/")
	
	var file_path = "user://saves/saves_info.tres"

	var result = ResourceSaver.save(file_path, self)
	
	return result


func _set_last_save_name(value: String) -> void:
	last_save_name = value
