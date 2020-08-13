extends KinematicBody2D

class_name Entity

signal update_health_bar

const GRAVITY = 2700

export (int) var health = 100

var dirx 
var vel = Vector2()

const UP = Vector2(0, -1)


var jump_speed = 1600

var speed = 0
var max_speed = 250
export (int) var power = 10


var has_health_bar = false
func take_damage(damage):
	if damage == 0:
		return
	$CollisionShape2D.disabled = true
	# take damage timer and animation
	health -= damage
	$CollisionShape2D.disabled = false
	if has_health_bar :
		# applicable to player and bosses, which have health_bar
		if self.is_in_group("enemy"):
			self.connect("update_health_bar", $life_bar,"_on_update_health_bar")
		else:
			self.connect("update_health_bar", $GUI/life_bar,"_on_update_health_bar")
		emit_signal("update_health_bar", health)
	if health <= 0:
		death()



func knock_back(body):
	if body.power == 0:
		return
	vel.y += -600
	vel.x += (self.position.x - body.position.x) / abs((self.position.x - body.position.x)) * 1000

func death():
	queue_free()







