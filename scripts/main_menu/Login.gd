extends Control




onready var Login = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Login
onready var Password = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Password
onready var http = $HTTPRequest
onready var Dialog = $AcceptDialog


func _ready():
	pass


func _on_LinkButton_pressed():
	OS.shell_open("%s/register" % Variables.IP_REG)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	Dialog.popup()
	if response_code == 404:
		Dialog.popup()
		pass
	
#	ResultLabel.text = "%s\n%s\n%s\n%s\n%s\n" % [result, response_code, headers, "here goes info:", 
#	body.get_string_from_ascii()]
	var data = body.get_string_from_ascii()


func send(ip, data) -> void:
	var use_ssl = false
#	var data: Dictionary = {
#		"genotype": [54, 34, 34, 12, 5],
#		"type": randi() % 1,
#		"name": "syka",
#		"user": "5eccfc9c703b2e2ed4656fb4",
#	}
	var query = JSON.print(data)
	var headers = ["Content-Type: application/json"]
	http.request(ip, headers, use_ssl, HTTPClient.METHOD_POST, query)


func _on_Button_pressed():
	var login = Login.text
	var password = Password.text
	Login.text = ""
	Password.text = ""
	
	send("%s/game-login" % Variables.IP, {
		"email": login,
		"password": password,
	})
