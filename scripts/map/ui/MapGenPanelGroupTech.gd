extends MarginContainer

signal length_changed(value)
signal width_changed(value)
signal seed_changed(value)

export(NodePath) var NoiseSpinBoxPath

onready var NoiseSpinBox = get_node(NoiseSpinBoxPath)
#onready var NoiseSpinBox: SpinBox = $MarginContainer/VBoxContainer/NoiseParmUI/MarginContainer/VBoxContainer/SpinBox as SpinBox

func _on_length_value_changed(value: int) -> void:
	emit_signal("length_changed", value)
func _on_width_value_changed(value: int) -> void:
	emit_signal("width_changed", value)
func _on_seed_value_changed(value: int) -> void:
	emit_signal("seed_changed", value)

func set_noise_seed(value: int) -> void:
	NoiseSpinBox.value = value
