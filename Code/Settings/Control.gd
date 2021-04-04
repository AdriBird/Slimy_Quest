extends Control

var can_change_key = false
var action_string
# liste des actions pouvant etre modifiées
enum ACTIONS {jump, right, left,shoot}



func _ready():
	_set_keys()
func _set_keys():
	for j in ACTIONS:
		get_node("Panel/ScrollContainer/VBoxContainer/" + str(j) + "/Button").set_pressed(false)
		if !InputMap.get_action_list(j).empty():
			get_node("Panel/ScrollContainer/VBoxContainer/" + str(j) + "/Button").set_text(InputMap.get_action_list(j)[0].as_text())
		else:
			get_node("Panel/ScrollContainer/VBoxContainer/" + str(j) + "/Button").set_text("No Button!")  




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Button_b_change_key(action_to_change):
	_mark_button(action_to_change)
	pass # Replace with function body.

func _mark_button(string):
	can_change_key = true
	action_string = string
	
	for j in ACTIONS:
		if j != string:
			get_node("Panel/ScrollContainer/VBoxContainer/" + str(j) + "/Button").set_pressed(false)


func _input(event):
	if event is InputEventKey: 
		if can_change_key:
			_change_key(event)
			can_change_key = false


func _change_key(new_key):
	#Delete key of pressed button
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	
	#Check if new key was assigned somewhere
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
			
	#Add new Key
	InputMap.action_add_event(action_string, new_key)
	
	_set_keys()

func _on_Button_retour_pressed():
	get_tree().change_scene("res://GI/Panels_scenes/Game_Menu.tscn")
	pass # Replace with function body.
