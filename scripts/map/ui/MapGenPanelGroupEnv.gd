extends MarginContainer

signal forest_comparison_chanded(value)
signal forest_percent_chanded(value)
signal forest_period_chanded(value)

export(NodePath) var ForestComparisonPath
export(NodePath) var ForestPercentPath
export(NodePath) var ForestPeriodPath

onready var ForestComparison: HSlider = get_node(ForestComparisonPath) as HSlider
onready var ForestPercent: HSlider = get_node(ForestPercentPath) as HSlider
onready var ForestPeriod: HSlider = get_node(ForestPeriodPath) as HSlider

#onready var ForestComparison: HSlider = $MarginContainer/VBoxContainer/ForestComparisonUI/MarginContainer/VBoxContainer/HSlider as HSlider
#onready var ForestPercent: HSlider = $MarginContainer/VBoxContainer/ForestPercentUI/MarginContainer/VBoxContainer/HSlider as HSlider
#onready var ForestPeriod: HSlider = $MarginContainer/VBoxContainer/ForestPeriodUI/MarginContainer/VBoxContainer/HSlider as HSlider


func _on_forest_comparison_value_changed(value: float) -> void:
	emit_signal("forest_comparison_chanded", value)
func _on_forest_percent_value_changed(value: float) -> void:
	emit_signal("forest_percent_chanded", value)
func _on_forest_period_value_changed(value: float) -> void:
	emit_signal("forest_period_chanded", value)

func set_forest_comparison(value: float) -> void:
	ForestComparison.value = value
func set_forest_percent(value: float) -> void:
	ForestPercent.value = value
func set_forest_period(value: int) -> void:
	ForestPeriod.value = value
