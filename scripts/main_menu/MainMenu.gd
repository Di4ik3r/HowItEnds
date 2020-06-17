extends Spatial


onready var Options = $Options
onready var ItemContinue = $Options/ItemContinue
onready var ItemPlay = $Options/ItemPlay
onready var ItemLoad = $Options/ItemLoad
onready var ItemExit = $Options/ItemExit
onready var TransitionCamera = $Options/TransitionCamera
onready var OptionsCamera = $Options/OptionsCamera

onready var TransitionCameraTimer: Timer = $Options/TransitionCamera/Timer as Timer
onready var MapGen: Spatial = $MapGenerating
onready var MapGenCamera: InterpolatedCamera = $MapGenerating/InterpolatedCamera as InterpolatedCamera
onready var MapGenUI = $MapGenerating/MapGeneratingUI

onready var PositionLoad = $Options/PositionLoad
onready var LoadPane = $Options/LoadPane

onready var PositionContinue = $PositionContinue
onready var TimerContinue = $PositionContinue/TimerContinue


func _ready():
	load_last_save()
	pass # Replace with function body.

func load_save(save: String) -> void:
	Variables.save_name = save
	var result = Tools.sim_stats.auto_read()
	if result == OK:
		MapGen.mapVars = Tools.sim_stats.map_vars


func load_last_save() -> void:
	var saves = Tools.get_all_saves()
	print(saves)
	if saves.size() > 0:
		var last_save = Tools.get_last_save()
		if last_save != "":
			print(last_save)
			load_save(last_save)
		else:
			var save = saves[saves.size() - 1]
			load_save(save)
#		Variables.save_name = save
#		var result = Tools.sim_stats.auto_read()
#		if result == OK:
#			MapGen.mapVars = Tools.sim_stats.map_vars
	
	LoadPane.gui.MainMenu = self
	LoadPane.gui.load_saves(saves)



func _on_ItemPlay_pressed():
	Variables.save_name = ""
	Tools.sim_stats.refresh()
	MapGen.mapVars = Tools.sim_stats.map_vars
	
	ItemPlay.disable()
	OptionsCamera.current = false
	
	TransitionCamera.target = MapGenCamera.get_path()
	TransitionCamera.current = true
	TransitionCamera.enabled = true
	TransitionCameraTimer.start()
#TransitionCamera.target =FpsGameCamera.get_path()
#TransitionCamera.current = true
#TransitionCamera.enabled = true
#TransitionCameraTimer.start()



func _on_ItemContinue_pressed():
	Tools.save_last_save()
	
	ItemContinue.disable()
	OptionsCamera.current = false
#
	TransitionCamera.target = PositionContinue.get_path()
	TransitionCamera.current = true
	TransitionCamera.enabled = true
	TimerContinue.start()


func _on_TimerContinue_timeout():
	var data = MapGen.mapGenerator.export_map()
	var map_export_resource = MapExport.new(data)
	SceneSwitcher.goto_scene(SceneSwitcher.SCENES.Simulation, map_export_resource, MapGen.mapVars)


func _on_ItemLoad_pressed():
	ItemLoad.disable()
	OptionsCamera.current = false
	
	PositionLoad.look_at(Vector3(-76.568, 31.873, -14.661), Vector3.UP)
	TransitionCamera.target = PositionLoad.get_path()
	TransitionCamera.current = true
	TransitionCamera.enabled = true


func _on_ItemExit_pressed():
	get_tree().quit()
#	ItemExit.disable()


func _on_Timer_timeout():
	Options.visible = false
	
#	TransitionCamera.current = false
#	TransitionCamera.enabled = true
	
#	MapGenCamera.current = true
#	MapGenCamera.enabled = true
	MapGenUI.visible = true


func _on_MapGenerating_map_back_button_pressed():
	return_camera()
	ItemPlay.enable()


func return_camera() -> void:
	TransitionCamera.target = OptionsCamera.get_path()
	Options.visible = true
	
	TransitionCamera.current = true
	TransitionCamera.enabled = true
	
	MapGenCamera.current = false
	MapGenUI.visible = false
