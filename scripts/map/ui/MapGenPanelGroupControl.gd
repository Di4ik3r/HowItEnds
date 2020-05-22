extends MarginContainer

signal back_button_pressed
signal randomize_button_pressed
signal start_button_pressed
signal generate_button_pressed

export(NodePath) var AutoLoadCBPath
export(NodePath) var ButtonGeneratePath

onready var AutoLoadCB: CheckButton = get_node(AutoLoadCBPath) as CheckButton
onready var ButtonGenerate: Button = get_node(ButtonGeneratePath) as Button

func _ready() -> void:
	ButtonGenerate.disabled = AutoLoadCB.pressed

func _on_ButtonBack_pressed():
	emit_signal("back_button_pressed")
func _on_ButtonRandomize_pressed():
	emit_signal("randomize_button_pressed")
func _on_ButtonStart_pressed():
	emit_signal("start_button_pressed")
func _on_ButtonGenerate_pressed():
	emit_signal("generate_button_pressed")
func _on_AutoLoadCheckButton_toggled(button_pressed):
	ButtonGenerate.disabled = button_pressed
