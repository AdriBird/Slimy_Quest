extends CanvasLayer

func _ready():
	get_tree().paused = true

func _process(delta):
	if Input.is_action_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
		queue_free()

func _on_Button_resume_pressed():
	get_tree().paused = false
	queue_free()

func _on_Button_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func _on_Button_quit_pressed():
	get_tree().quit()
	queue_free()

func _on_Button_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Game_Menu.tscn")
	queue_free()
