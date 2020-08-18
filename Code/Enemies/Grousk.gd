extends Mob



func _ready():
	has_health_bar = true
	health = 50
	state = NEUTRAL
	speed = 20
	dirx = 1
	$RayCast2D.enabled = true
	#$enemy_anim.play("walk")







func neutral():
	if is_on_wall():
		dirx *= -1
		$RayCast2D.position.x *= -1
	$enemy_anim.play("walk")
	if dirx == 1 :
		#$RayCast2D.scale.x *= -1
		vel.x = min(vel.x + speed, max_speed)
		$Sprite.flip_h = false
	elif dirx == -1 :
		#$RayCast2D.scale.x *= -1
		vel.x = max(vel.x - speed, -max_speed)
		$Sprite.flip_h = true



func attack():
	pass

var turn = false


func _physics_process(delta):
	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, UP)



