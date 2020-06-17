extends Control



var ip_get = "%s/creatures/5eccfc9c703b2e2ed4656fb4" % [Variables.IP]
var ip_post = "%s/creatures"

onready var HTTPRequester: = $HTTPRequest as HTTPRequest
onready var ResultLabel: = $MarginContainer/VBoxContainer/ResultLabel as RichTextLabel

func _ready():
	
	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	ResultLabel.text = "%s\n%s\n%s\n%s\n%s\n" % [result, response_code, headers, "here goes info:", 
	body.get_string_from_ascii()]
	for res in body.decompress(1):
		ResultLabel.text += "%s\n" % res
	
	pass # Replace with function body.


func _on_ButtonGet_pressed():
	HTTPRequester.request(ip_get)
	pass # Replace with function body.


func _on_ButtonPost_pressed():
	var use_ssl = false
	var data: Dictionary = {
		"genotype": [54, 34, 34, 12, 5],
		"type": randi() % 1,
		"name": "syka",
		"user": "5eccfc9c703b2e2ed4656fb4",
	}
	var query = JSON.print(data)
	var headers = ["Content-Type: application/json"]
	HTTPRequester.request(, headers, use_ssl, HTTPClient.METHOD_POST, query)
