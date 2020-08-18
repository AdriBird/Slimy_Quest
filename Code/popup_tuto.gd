extends Popup



func _on_end_flag_popup_end():
	print("popup")
	self.show()
	get_tree().paused = true

func _on_Button_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game_Menu.tscn")
	queue_free()