extends Button
signal b_change_key
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	pass # Replace with function body.




func _on_Button_pressed():
	emit_signal("b_change_key", parent.name)
	pass # Replace with function body.
