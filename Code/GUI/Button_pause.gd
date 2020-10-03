extends Node



func _on_Button_resume_pressed():
	get_tree().paused = false
	


func _on_Button_restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	queue_free()

func _on_Button_quit_pressed():
	get_tree().quit()
	queue_free()