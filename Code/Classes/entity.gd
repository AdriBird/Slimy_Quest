extends KinematicBody2D

class_name Entity

signal update_health_bar

const GRAVITY = 3000

export (int) var health = 100

var dirx 
var vel = Vector2()

const UP = Vector2(0, -1)


var jump_speed = 2000
var weight = 1
var speed = 0
var max_speed = 250
export (int) var power = 10


enum {NEUTRAL, SPOT, ATTACK, DAMAGE, DEATH}
var state

var has_health_bar = false

func take_damage(damage):
	if damage == 0:
		return
	# take damage timer and animation
	health -= damage
	if has_health_bar :
		print(self.name)
		# applicable to player and bosses, which have health_bar
		if self.is_in_group("enemy"):
			self.connect("update_health_bar", $life_bar,"_on_update_health_bar")
		else:
			self.connect("update_health_bar", $GUI/life_bar,"_on_update_health_bar")
		emit_signal("update_health_bar", health)
	if health <= 0:
		death()
	$hurtbox/CollisionShape2D.set_deferred("disabled", true)
	for i in range(4):
		self.hide()
		yield(get_tree().create_timer(0.2), "timeout")
		self.show()
		yield(get_tree().create_timer(0.2), "timeout")
	$hurtbox/CollisionShape2D.set_deferred("disabled", false)



func knock_back(body):
	if body.power == 0:
		return
	vel = Vector2(0,0)
	vel.y = -700
	vel.x += ((self.position.x - body.position.x) / abs((self.position.x - body.position.x)))* 300

func death():
	state = DEATH
	self.power = 0
	$anim.play("death")
	yield($anim, "animation_finished")
	queue_free()








