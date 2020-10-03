extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 500
var speed
func _process(delta):
	if Input.is_action_pressed("right"):
		speed = SPEED
	else:
		speed = -SPEED
	move_and_slide(Vector2(speed, 0))
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
