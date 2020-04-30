extends Node2D

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	get_node("Button/xx").text = str(score)


func _on_Button_pressed():
	score += 1
	pass # Replace with function body.
