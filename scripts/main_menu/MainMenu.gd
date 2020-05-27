extends Spatial


onready var Options = $Options
onready var ItemPlay = $Options/ItemPlay
onready var ItemExit = $Options/ItemExit
onready var TransitionCamera = $Options/TransitionCamera
onready var OptionsCamera = $Options/OptionsCamera

onready var TransitionCameraTimer: Timer = $Options/TransitionCamera/Timer as Timer
onready var MapGenCamera: InterpolatedCamera = $MapGenerating/InterpolatedCamera as InterpolatedCamera
onready var MapGenUI = $MapGenerating/MapGeneratingUI


func _ready():
	pass # Replace with function body.
	
func _on_ItemPlay_pressed():
	ItemPlay.disable()
	OptionsCamera.current = false
	
	TransitionCamera.target = MapGenCamera.get_path()
	TransitionCamera.current = true
	TransitionCamera.enabled = true
	TransitionCameraTimer.start()
#	TransitionCamera.target =FpsGameCamera.get_path()
#	TransitionCamera.current = true
#	TransitionCamera.enabled = true
#	TransitionCameraTimer.start()
#	FpsGameCamera.target = FpsGameCamera.get_path()
#	FpsGameCamera.current = true
#	FpsGameCamera.enabled = true
	
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
