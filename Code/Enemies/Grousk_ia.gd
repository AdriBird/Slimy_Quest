extends Mob

onready var timer_distance = get_node("timer_distance")
onready var start_pos = self.position.x
onready var Player = get_parent().get_node("Player")

var dist = 700

func _ready():
	has_health_bar = true
	health = 50
	state = NEUTRAL
	speed = 20
	dirx = 1
	$RayCast2D.enabled = true
	#$enemy_anim.play("walk")




func neutral():
	if (self.position.x >= start_pos + dist and dirx == 1 or self.position.x <= start_pos and dirx == -1) and is_on_floor():
		dirx *= -1
#	timer_distance.set_wait_time(4)
#	timer_distance.start()
#	yield(timer_distance)
	if $Player_Detector.is_colliding() == true:
		print("oui")
		state = SPOT


func spot():
	max_speed = 400
	if Player.position.x >= self.position.x:
		dirx = 1
	if Player.position.x <= self.position.x:
		dirx = -1
	if $Player_Detector.is_colliding() == true and is_on_floor() and not Player.is_on_floor():
		vel.y -= jump_speed/2
	


func attack():
	pass

var turn = false


func _physics_process(delta):
	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, UP)
	if is_on_wall():
		dirx *= -1
		$RayCast2D.position.x *= -1
		
	$enemy_anim.play("walk")
	if dirx == 1 :
		#$RayCast2D.scale.x *= -1
		vel.x = min(vel.x + speed, max_speed)
		$Sprite.flip_h = false
		$Player_Detector.rotation_degrees = -90
		
	elif dirx == -1 :
		#$RayCast2D.scale.x *= -1
		vel.x = max(vel.x - speed, -max_speed)
		$Sprite.flip_h = true
		$Player_Detector.rotation_degrees = 90






