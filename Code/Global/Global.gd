extends Node

var dialog
var score = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen