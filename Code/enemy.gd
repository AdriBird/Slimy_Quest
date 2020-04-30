extends KinematicBody2D

onready var timer_value = get_node("Timer_move")
onready var timer_hit_lag = get_node("Timer_hit_lag")
var vel = Vector2()
var speed = 300
var dirx = -1
onready var life = 100
var hit_lag = 1

func _ready():
	position = Vector2(2000, 1510)
	timer_value.set_wait_time(4)
	timer_value.start()


func _physics_process(delta):
	vel.x = 0
	movement()
	move_and_slide(vel)
	
func movement():
	if dirx == 1:
		vel.x += speed * hit_lag
		$Sprite.flip_h = true
		$enemy_anim.play("move")
	elif dirx == -1:
		vel.x -= speed * hit_lag
		$Sprite.flip_h = false
		$enemy_anim.play("move")
	else:
		$enemy_anim.play("iddle")

func hit(damage):
	$CollisionShape2D.disabled = true
	timer_hit_lag.set_wait_time(0.5)
	timer_hit_lag.start()
	hit_lag = 0
	life -= damage
	$CollisionShape2D.disabled = false
	if life <= 0:
		queue_free()

func _on_Timer_timeout():
	dirx *= -1
	pass 


func _on_Timer_hit_lag_timeout():
	hit_lag = 1