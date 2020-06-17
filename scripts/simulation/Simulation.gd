extends Spatial


export(NodePath) var MapPath
export(NodePath) var CircleCameraPath

var resource: MapExport = null setget _set_resource
var resource1: Resource = null
var bot_manager = BotManager.new()
var map_manager = MapManager.new()

var timestamp = Variables.timestamp
var time_restart = 1

onready var FoodManager = $FoodManager
onready var Map = get_node(MapPath)
onready var TimerRestart: = $TimerRestart as Timer
#onready var CircleCamera = get_node(CircleCameraPath)



func _ready():
	_link_signals()


func load_start():
	FoodManager.start_spawn()
	pass


func start() -> void:
	FoodManager.start_spawn()
	bot_manager.start_spawn()
	TimerRestart.start()
	pass


func restart() -> void:
	FoodManager.clear_food()
	FoodManager.start_spawn()
	
#	var stamp = "%02d:%02d:%02d" % [timestamp.hour, timestamp.minute, timestamp.second]
	Tools.sim_stats.auto_write_data(bot_manager.bots_buff, Variables.save_name)
	bot_manager.restart()
	
	TimerRestart.stop()
	print("time: ", time_restart)
	
	time_restart = 1
	TimerRestart.start()
	


func _set_resource(value: MapExport) -> void:
	resource = value
	Map.resource = resource
#	CircleCamera.update(resource)
	
	map_manager.map_pos = Map.map_pos
	map_manager.map_type = Map.map_type
	map_manager.map_export = resource
	
#	bot_manager.map_pos = Map.map_pos
#	bot_manager.map_type = Map.map_type
#	bot_manager.map_export = resource
	bot_manager.FoodManager = FoodManager
	bot_manager.map_manager = map_manager
	bot_manager.init_map_bots()
	bot_manager.bot_holder = get_node("BotHolder")
	
#	FoodManager.map_pos = Map.map_pos
	FoodManager.map_manager = map_manager
	var amount = resource.a_side * resource.b_side
	amount *= 0.001
	FoodManager.time = 1 / amount
	
	map_manager.map_bots = bot_manager.map_bots
	map_manager.FoodManager = FoodManager
	
	Tools.sim_stats.map_vars = resource1
	
	if Tools.sim_stats.info.size() > 0:
		load_start()
	start()


func _on_BotTimer_timeout():
	bot_manager.cycle()


func _on_TestBotUI_eat_bot_pressed():
	bot_manager.bots[0]._eat_bot()
func _on_TestBotUI_eat_pressed():
	bot_manager.bots[0]._eat()
func _on_TestBotUI_move_pressed():
	bot_manager.bots[0]._move()
func _on_TestBotUI_reproduce_pressed():
	bot_manager.bots[0]._reproduce()
func _on_TestBotUI_rotate_e_pressed():
	bot_manager.bots[0]._rotate_e()
func _on_TestBotUI_rotate_en_pressed():
	bot_manager.bots[0]._rotate_en()
func _on_TestBotUI_rotate_es_pressed():
	bot_manager.bots[0]._rotate_es()
func _on_TestBotUI_rotate_n_pressed():
	bot_manager.bots[0]._rotate_n()
func _on_TestBotUI_rotate_s_pressed():
	bot_manager.bots[0]._rotate_s()
func _on_TestBotUI_rotate_w_pressed():
	bot_manager.bots[0]._rotate_w()
func _on_TestBotUI_rotate_wn_pressed():
	bot_manager.bots[0]._rotate_wn()
func _on_TestBotUI_rotate_ws_pressed():
	bot_manager.bots[0]._rotate_ws()
func _on_TestBotUI_sense_pressed():
	bot_manager.bots[0]._sense()
func _on_TestBotUI_skip_10_pressed():
	bot_manager.bots[0]._skip10()
func _on_TestBotUI_skip_1_pressed():
	bot_manager.bots[0]._skip1()
func _on_TestBotUI_skip_2_pressed():
	bot_manager.bots[0]._skip2()
func _on_TestBotUI_skip_3_pressed():
	bot_manager.bots[0]._skip3()
func _on_TestBotUI_skip_4_pressed():
	bot_manager.bots[0]._skip4()
func _on_TestBotUI_skip_5_pressed():
	bot_manager.bots[0]._skip5()
func _on_TestBotUI_skip_6_pressed():
	bot_manager.bots[0]._skip6()
func _on_TestBotUI_skip_7_pressed():
	bot_manager.bots[0]._skip7()
func _on_TestBotUI_skip_8_pressed():
	bot_manager.bots[0]._skip8()
func _on_TestBotUI_skip_9_pressed():
	bot_manager.bots[0]._skip9()
func _on_TestBotUI_stay_pressed():
	bot_manager.bots[0]._stay()
func _on_TestBotUI_spawn_bot_pressed():
	bot_manager.spawn_bot()


func _on_BotSpawnTimer_timeout():
#	for i in range(0, 150):
#		bot_manager.spawn_bot()
	pass


func _on_TestBotUI_spawn_food_pressed():
	FoodManager.spawn_food()


func _link_signals() -> void:
	bot_manager.connect("bots_died", self, "restart")


func _on_TimerRestart_timeout():
	time_restart += 1
