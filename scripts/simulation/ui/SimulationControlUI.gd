extends MarginContainer



signal stop_pressed
signal normal_pressed
signal fast_pressed


var follow_bot: Bot = null
var bots: Array = []
var fps = null
var font = preload("res://resources/fonts/load_font.tres")
var style_normal = preload("res://resources/themes/button_general.tres")
var style_mutated = preload("res://resources/themes/button_mutated.tres")
var style_mutated_parent = preload("res://resources/themes/button_mutated_parent.tres")
#var custom_sorter = MyCustomSorter.new()

onready var BotInfo = $VBoxContainer/BotInfoContainer
onready var EnergyCount = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer/EnergyCount
onready var FoodEated = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer2/FoodEated
onready var BotsEated = $VBoxContainer/BotInfoContainer/PanelContainer/VBoxContainer/HBoxContainer3/BotsEated
onready var BotHolder = $VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BotHolder
onready var Time = $VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer/Time
onready var Generation = $VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer3/HBoxContainer/HBoxContainer2/Generation
onready var BotCount = $VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BotCount
onready var MutatedCount = $VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/MutatedCount
onready var FoodCount = $VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/FoodCount

onready var GenotypesHashCount = $VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/GenotypesHashCount
onready var GenotypesHashHolder = $VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/ScrollContainer/GenotypesHashHolder


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
	var mutated_count = 0
	var mutated_child_count = 0
	var genotypes_hash = []
	for bot in bots:
		var style
		match bot.type:
			Variables.BotType.A:
				style = style_normal
			Variables.BotType.B:
				style = style_mutated
				mutated_count += 1
			Variables.BotType.C:
				style = style_mutated_parent
				mutated_child_count += 1
		
		var button: Button = Button.new()
		button.text = "%d; %d" % [bot.id, bot.type]
		button.add_stylebox_override("normal", style)
#		button.set("custom_fonts/font", font)
		button.connect("pressed", self, "handle_click", [bot.id])
		
		BotHolder.add_child(button)
		
		var genotype_data = bot.hash_genotype()
		if !genotypes_hash.has(genotype_data):
			genotypes_hash.append(genotype_data)
	
#	genotypes_hash.sort_custom(MyCustomSorter, "sort_genotypes_hash")
	genotypes_hash.sort()
	
	for genotype_data in genotypes_hash:
		var button: Button = Button.new()
		button.text = "%d" % [genotype_data]
#		button.add_stylebox_override("normal", style)
#		button.set("custom_fonts/font", font)
#		button.connect("pressed", self, "handle_click", [bot.id])
		
		GenotypesHashHolder.add_child(button)
	
	BotCount.text = "%d" % [bots.size()]
	MutatedCount.text = "%d; %d" % [mutated_count, mutated_child_count]
	GenotypesHashCount.text = "%d" % [genotypes_hash.size()]


func clear_holder() -> void:
	for child in BotHolder.get_children():
		if !(child is Label):
			BotHolder.remove_child(child)
			child.queue_free()
	
	for child in GenotypesHashHolder.get_children():
		if !(child is Label):
			GenotypesHashHolder.remove_child(child)
			child.queue_free()


func handle_click(id: int) -> void:
	for bot in bots:
		if int(bot.id) == id:
			fps.select_bot(bot)
			return


func set_time(time: int) -> void:
	var minutes = floor(time / 60)
	var seconds = time - (minutes * 60)
	
	var result_time = "%02d:%02d" % [minutes, seconds]
	
	var actual_time = time * 0.01
	var actual_minutes = floor(actual_time / 60)
	var actual_seconds = actual_time - (actual_minutes * 60)
	
	var result_actual_time = "%02d:%02d" % [actual_minutes, actual_seconds]
	
	Time.text = "%s  (%s)" % [result_time, result_actual_time]


func set_generation(generation: int) -> void:
	Generation.text = str(generation)


func _on_ButtonBack_pressed():
	SceneSwitcher.goto_scene(SceneSwitcher.SCENES.MainMenu)


func _on_ButtonSave_pressed():
	
	pass


func _on_FoodManager_food_size_changed(food_amount):
	FoodCount.text = "%d" % [food_amount]


class MyCustomSorter:
	static func sort_genotypes_hash(a, b):
		return a.sum - b.sum
