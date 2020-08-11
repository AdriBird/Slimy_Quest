extends KinematicBody2D

class_name Mob, "res://Sprites/Icons/Mob_object_icon.png"

const GRAVITY = 1200
var vel = Vector2()
var dirx = 0
var max_speed = 250
export (int) var health = 50 
export (int) var speed = 100
const UP = Vector2(0, -1)



func _ready():
	add_to_group("ennemi")
	randomize()




enum {NEUTRAL, SPOT, ATTACK, DAMAGE}
var state 

func attack():
	.attack()

func neutral():
	.neutral()

func spot():
	.spot()

func pattern():
	match state:
		NEUTRAL:
			neutral()
		SPOT:
			spot()
		ATTACK:
			attack()


var hit_lag
onready var timer_hit_lag = get_node("Timer_hit_lag")
func take_damage(damage):
#	dirx = 0
	$CollisionShape2D.disabled = true
	timer_hit_lag.set_wait_time(0.5)
	timer_hit_lag.start()
	hit_lag = 0
	health -= damage
	$CollisionShape2D.disabled = false
	emit_signal("hurt", health)
	if health <= 0:
		queue_free()


func _process(delta):
	pattern()


