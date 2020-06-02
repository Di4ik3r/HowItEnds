extends Spatial


onready var Options = $Options
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


func _ready():
	load_last_save()
	pass # Replace with function body.


func load_last_save() -> void:
	var saves = Tools.get_all_saves()
#	print(saves)
	if saves.size() > 0:
		var save = saves[saves.size() - 1]
		Variables.save_name = save
		var result = Tools.sim_stats.auto_read()
		if result == OK:
			MapGen.mapVars = Tools.sim_stats.map_vars



func _on_ItemPlay_pressed():
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



func _on_ItemLoad_pressed():
	ItemLoad.disable()
	OptionsCamera.current = false
	
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
	TransitionCamera.target = OptionsCamera.get_path()
	Options.visible = true
	
	TransitionCamera.current = true
	TransitionCamera.enabled = true
	
	MapGenCamera.current = false
	MapGenUI.visible = false
	
	ItemPlay.enable()
