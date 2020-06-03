extends Control



var MainMenu = null
var font = preload("res://resources/fonts/load_font.tres")

onready var ButtonHolder = $MarginContainer/VBoxContainer/MarginContainer2/ScrollContainer/ButtonHolder


func _ready():
	clear_holder()
	pass


func handle_click(save: String) -> void:
	MainMenu.load_save(save)


func load_saves(saves: Array) -> void:
	for save in saves:
		var button: Button = Button.new()
		button.text = str(save)
		
		button.set("custom_fonts/font", font)
		button.connect("pressed", self, "handle_click", [save])
		ButtonHolder.add_child(button)


func clear_holder() -> void:
	for child in ButtonHolder.get_children():
		ButtonHolder.remove_child(child)
		child.queue_free()


func _on_ButtonBack_pressed():
	MainMenu.return_camera()
	MainMenu.ItemLoad.enable()
