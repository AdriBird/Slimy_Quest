extends Node

# warning-ignore:unused_class_variable
#---------------Global-variables------------------------------------------------------------
var dialog
var mana = 0
var mana_power = 10

func _process(delta):
	if Input.is_action_just_pressed("ui_full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen

