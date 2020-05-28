extends Control


signal move_pressed
signal stay_pressed
signal eat_pressed
signal eat_bot_pressed
signal reproduce_pressed
signal sense_pressed
signal rotate_e_pressed
signal rotate_es_pressed
signal rotate_s_pressed
signal rotate_ws_pressed
signal rotate_w_pressed
signal rotate_wn_pressed
signal rotate_n_pressed
signal rotate_en_pressed
signal skip_1_pressed
signal skip_2_pressed
signal skip_3_pressed
signal skip_4_pressed
signal skip_5_pressed
signal skip_6_pressed
signal skip_7_pressed
signal skip_8_pressed
signal skip_9_pressed
signal skip_10_pressed

signal spawn_bot_pressed


func _on_ButtonMove_pressed():
	emit_signal("move_pressed")
func _on_ButtonStay_pressed():
	emit_signal("stay_pressed")
func _on_ButtonEat_pressed():
	emit_signal("eat_pressed")
func _on_ButtonEatBot_pressed():
	emit_signal("eat_bot_pressed")
func _on_ButtonReproduce_pressed():
	emit_signal("reproduce_pressed")
func _on_ButtonSense_pressed():
	emit_signal("sense_pressed")
func _on_ButtonRotateE_pressed():
	emit_signal("rotate_e_pressed")
func _on_ButtonRotateES_pressed():
	emit_signal("rotate_es_pressed")
func _on_ButtonRotateS_pressed():
	emit_signal("rotate_s_pressed")
func _on_ButtonRotateWS_pressed():
	emit_signal("rotate_ws_pressed")
func _on_ButtonRotateW_pressed():
	emit_signal("rotate_w_pressed")
func _on_ButtonRotateWN_pressed():
	emit_signal("rotate_wn_pressed")
func _on_ButtonRotateN_pressed():
	emit_signal("rotate_n_pressed")
func _on_ButtonRotateEN_pressed():
	emit_signal("rotate_en_pressed")
func _on_ButtonSkip1_pressed():
	emit_signal("skip_1_pressed")
func _on_ButtonSkip2_pressed():
	emit_signal("skip_2_pressed")
func _on_ButtonSkip3_pressed():
	emit_signal("skip_3_pressed")
func _on_ButtonSkip4_pressed():
	emit_signal("skip_4_pressed")
func _on_ButtonSkip5_pressed():
	emit_signal("skip_5_pressed")
func _on_ButtonSkip6_pressed():
	emit_signal("skip_6_pressed")
func _on_ButtonSkip7_pressed():
	emit_signal("skip_7_pressed")
func _on_ButtonSkip8_pressed():
	emit_signal("skip_8_pressed")
func _on_ButtonSkip9_pressed():
	emit_signal("skip_9_pressed")
func _on_ButtonSkip10_pressed():
	emit_signal("skip_10_pressed")
func _on_ButtonSpawnBot_pressed():
	emit_signal("spawn_bot_pressed")
