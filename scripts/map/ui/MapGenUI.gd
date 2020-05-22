extends MarginContainer

signal length_changed(value)
signal width_changed(value)
signal seed_changed(value)
signal forest_comparison_changed(value)
signal forest_percent_changed(value)
signal forest_perioad_changed(value)

signal back_button_pressed
signal randomize_button_pressed
signal start_button_pressed
signal generate_button_pressed

export(NodePath) var TechPanelPath
export(NodePath) var ControlPanelPath
export(NodePath) var EnvPanelPath

onready var TechPanel = get_node(TechPanelPath)
onready var ControlPanel = get_node(ControlPanelPath)
onready var EnvPanel = get_node(EnvPanelPath)

func _on_length_changed(value: int) -> void:
	emit_signal("length_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("length changed to %d" % value)
func _on_width_changed(value: int) -> void:
	emit_signal("width_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("width changed to %d" % value)
func _on_seed_changed(value: int) -> void:
	emit_signal("seed_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("seed changed to %d" % value)

func _on_forest_comparison_chanded(value: float) -> void:
	emit_signal("forest_comparison_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("forest comparison changed to %f" % value)
func _on_forest_percent_chanded(value: float) -> void:
	emit_signal("forest_percent_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("forest percent changed to %f" % value)
func _on_forest_period_chanded(value: float) -> void:
	emit_signal("forest_perioad_changed", value, ControlPanel.AutoLoadCB.pressed)
#	print("forest period changed to %f" % value)

func _on_MapGenPanelGroup_back_button_pressed():
	emit_signal("back_button_pressed")
func _on_MapGenPanelGroup_randomize_button_pressed():
	emit_signal("randomize_button_pressed")
func _on_MapGenPanelGroup_start_button_pressed():
	emit_signal("start_button_pressed")
func _on_MapGenPanelGroup_generate_button_pressed():
	emit_signal("generate_button_pressed")

func _on_refresh_ui(values) -> void:
	TechPanel.set_noise_seed(values.noise_seed)
	EnvPanel.set_forest_comparison(values.forest_comparison)
	EnvPanel.set_forest_percent(values.forest_percent)
	EnvPanel.set_forest_period(values.forest_period)


