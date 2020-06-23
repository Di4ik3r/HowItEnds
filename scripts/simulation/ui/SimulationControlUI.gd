extends MarginContainer



signal stop_pressed
signal normal_pressed
signal fast_pressed


var follow_bot: Bot = null
var bots: Array = []
var fps = null
var font = preload("res://resources/fonts/load_font.tres")

onready var BotInfo = $VBoxContainer/BotInfoContainer
onready var EnergyCount = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer/EnergyCount
onready var FoodEated = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer2/FoodEated
onready var BotsEated = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer3/BotsEated
onready var BotHolder = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BotHolder
onready var Time = $VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer/Time
onready var Generation = $VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer2/Generation


func _ready():
	clear_holder()
	hide_bot_info()
	pass


func _process(_delta):
	update_info()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		hide_bot_info()
	
	if Input.is_action_pressed("stop_sim"):
		emit_signal("stop_pressed")
	if Input.is_action_pressed("play_sim"):
		emit_signal("normal_pressed")
	if Input.is_action_pressed("fast_sim"):
		emit_signal("fast_pressed")


func _on_ButtonFast_pressed():
	emit_signal("fast_pressed")


func _on_ButtonNormal_pressed():
	emit_signal("normal_pressed")


func _on_ButtonStop_pressed():
	emit_signal("stop_pressed")


func hide_bot_info() -> void:
	BotInfo.visible = false
func show_bot_info() -> void:
	BotInfo.visible = true


func _on_FirstPerson_bot_raycasted(bot: Bot):
	if !bot:
		return
	
	follow_bot = bot
	follow_bot.connect("died", self, "delink_bot")
	
	show_bot_info()
	update_info()


func update_info() -> void:
	if follow_bot:
		if is_instance_valid(follow_bot):
			EnergyCount.text = str(follow_bot.energy)
			FoodEated.text = str(follow_bot.food_eated)
			BotsEated.text = str(follow_bot.bots_eated)


func delink_bot() -> void:
	hide_bot_info()
	follow_bot = null



func update_bots(_bots: Array) -> void:
	clear_holder()
	bots = _bots
	for bot in bots:
		var button: Button = Button.new()
		button.text = str(bot.id)
#		button.set("custom_fonts/font", font)
		button.connect("pressed", self, "handle_click", [bot.id])
		BotHolder.add_child(button)


func clear_holder() -> void:
	for child in BotHolder.get_children():
		if !(child is Label):
			BotHolder.remove_child(child)
			child.queue_free()


func handle_click(id: int) -> void:
	for bot in bots:
		if int(bot.id) == id:
			fps.select_bot(bot)
			return


func set_time(time: int) -> void:
	var minutes = floor(time / 60)
	var seconds = time - (minutes * 60)
	Time.text = "%02d:%02d" % [minutes, seconds]


func set_generation(generation: int) -> void:
	Generation.text = str(generation)


func _on_ButtonBack_pressed():
	SceneSwitcher.goto_scene(SceneSwitcher.SCENES.MainMenu)


func _on_ButtonSave_pressed():
	
	pass
