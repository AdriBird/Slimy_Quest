extends KinematicBody2D

onready var timer_hit_lag = get_node("Timer_hit_lag")
var vel = Vector2()
var speed = 150
var dirx = -1
onready var life = 100
var hit_lag = 1

signal hurt

func _ready():
	$RayCast2D.enabled = true
	$enemy_anim.play("walk")


func _physics_process(delta):
	if is_on_wall() or $RayCast2D.is_colliding() == false:
		dirx *= -1
		
	vel.x = 0
	movement()
	move_and_slide(vel)
	
func movement():
	if dirx == 1 and hit_lag == 1:
		$RayCast2D.scale.x *= -1
		$RayCast2D.position.x *= -1
		vel.x += speed * hit_lag
		$Sprite.flip_h = false
		$enemy_anim.play("walk")
	elif dirx == -1 and hit_lag == 1:
		$RayCast2D.scale.x *= -1
		$RayCast2D.position.x *= -1
		vel.x -= speed * hit_lag
		$Sprite.flip_h = true
		$enemy_anim.play("walk")
	else:
		$enemy_anim.play("hit")


func hit(damage):
#	dirx = 0
	$CollisionShape2D.disabled = true
	timer_hit_lag.set_wait_time(0.5)
	timer_hit_lag.start()
	hit_lag = 0
	life -= damage
	$CollisionShape2D.disabled = false
	emit_signal("hurt", life)
	if life <= 0:
		queue_free()



func _on_Timer_hit_lag_timeout():
	hit_lag = 1
#	dirx = int($Sprite.flip_h)
	timer_hit_lag.stop()
	
	
	
	