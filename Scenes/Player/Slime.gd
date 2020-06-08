extends KinematicBody2D




#-----------------------Signaux----------------------------------------------------------

signal hurt

#-----------------------Variables----------------------------------------------------------


var vel = Vector2()
const GRAVITY = 3000
const UP = Vector2(0, -1)
var no_inputs

#-----------------------Motions variables-------------------------------------------------------


var speed = 80
var max_speed = 500

var jump_speed = 1500
var wall_bounce_val = 800
var can_wall_jump = false

#---------------------Shoot variables----------------------------------------------------------
onready var time_shoot = get_node("timer_shoot")
var can_shoot = false
var bullet = preload("res://Scenes/Player/Slime_Bullet.tscn")
var direction_tir = 1



var time = true




#-----------------------States------------------------------------------------------------------
enum  {IDLE, JUMP, SHOOT, SLIDE, BOUNCE, PAUSE, DAMAGE, WALL}
var state
onready var time_idle = get_node("idle_timer")
var timer_idle_verif = true

func state_loop():
	# pause
	if not Global.dialog:
		motion_loop()
		shoot()
	else:
		vel.x = 0
	if state == IDLE and vel.x != 0:
		change_state(BOUNCE)
	if state in [SLIDE, BOUNCE] and vel.x == 0 and no_inputs and is_on_floor():
		change_state(IDLE)
	if state in [IDLE, SLIDE, BOUNCE] and !is_on_floor():
		change_state(JUMP)
	if state == JUMP and is_on_floor():
		change_state(IDLE)



func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			if timer_idle_verif == true:
				time_idle.set_wait_time(2)
				time_idle.start()
				timer_idle_verif = false
		JUMP:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move")
			    #Start Jump animation $AnimationPlayer.start("jump")
		SLIDE:
			$AnimationPlayer.play("move")
		BOUNCE:
			print("bouncy baby")
			$AnimationPlayer.play("move")    #Start Bounce animation $AnimationPlayer.start("bounce")
		SHOOT:
			pass    #Start Shoot animation $AnimationPlayer.start("shoot")



#-----------------------Physic Process----------------------------------------------------------
func _ready():
	bottom_pos = get_node("bottom_pos").position
	state = IDLE
	pass 


func _process(delta):
	state_loop()
	update_size()
	update_score()
	# tué par le vide, à rendre plus propre
	if self.position.y >= 2000:
		hurt()
	# Menu pause
	if Input.is_action_pressed("pause"):
		var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
		add_child(pause)
	# anti_imprécision:
	if vel.x > -0.05 and vel.x < 0.05:
		vel.x = 0




func update_score():
	$GUI/score.text = str(Global.score)


func _physics_process(delta):
#	animation_loop()
	particles_loop()
	state_loop()
	if can_wall_jump and vel.y >= 0:
		vel.y += (GRAVITY/14 * delta)
	else:
		vel.y += (GRAVITY * delta)
	vel = move_and_slide(vel, UP)


func shoot():
	var shoot = Input.is_action_pressed("shoot")
	if shoot and time or can_shoot and time == true:
		var b = bullet.instance()
		b.start($tir.global_position, direction_tir)
		get_parent().add_child(b)
		time = false
		time_shoot.set_wait_time(1)
		time_shoot.start()

func motion_loop():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var space = Input.is_action_pressed("jump")
	var just_space = Input.is_action_just_pressed("jump")
	if int(right)+ int(left) + int(up) + int(down)+ int(space) + int(just_space) == 0:                                
		no_inputs = true
	else:
		no_inputs = false
	var dirx = int(right) - int(left)
	if dirx == 1 and not is_on_wall():     #se déplace à droite
#		$AnimationPlayer.play("move")
		$Sprite.flip_h = false
		direction_tir = 1
		$tir.position.x = 110
		if state == BOUNCE and not space and vel.x != 0:                #commence à sautiller si state = BOUNCE
			vel.y = -500
			speed = 100
		vel.x = min(vel.x + speed, max_speed)
		if state != BOUNCE:
			speed = 80
	if dirx == -1 and not is_on_wall():     #se déplace à gauche 
#		$AnimationPlayer.play("move")
		$Sprite.flip_h = true
		direction_tir = -1
		$tir.position.x = -110
		if state == BOUNCE and not space and vel.x != 0:                #commence à sautiller si state = BOUNCE
			vel.y = -500
			speed = 100
		vel.x = max(vel.x - speed, -max_speed)
		if state != BOUNCE:
			speed = 80
	if dirx == 0:                           #afk
		vel.x = lerp(vel.x, 0 ,0.15)
	if just_space and can_wall_jump and dirx != 0:
		vel.y = -jump_speed
		if $Sprite.flip_h == true:
			vel.x = wall_bounce_val
		if $Sprite.flip_h == false:
			vel.x = -wall_bounce_val
	if just_space and is_on_floor() :
		vel.y = -jump_speed
	if Input.is_action_just_released("ui_accept"):
		if vel.y < -100:
			vel.y /= 2

#-----------------------Blob------------------------------------------------------------------
var nb_blob = 0

func update_size():
	var pos = position
	var x = 0.05
	if scale != Vector2(1+x*nb_blob,1+x*nb_blob):
		scale = Vector2(1+x*nb_blob,1+x*nb_blob)
		position.y += -20





func hurt():
	self.vel.y = 0
	self.position = get_parent().get_node("Spawn").position
	emit_signal("hurt")


func _on_pause_pressed():
	var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
	add_child(pause)
	


func _on_timer_shoot_timeout():
	time = true




#--------------------Detections---------------------------------------------------------






# Walls
func _on_Wall_radar_body_entered(body):
	if body.is_in_group("wall"):
		can_wall_jump = true
func _on_Wall_radar_body_exited(body):
	if body.is_in_group("wall"):
		can_wall_jump = false






func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group("water"):
		hurt()
	pass 


#---------------------Particules and animations--------------------------------------------
# particles
var shot_particles = false
var particules = preload("res://Scenes/Instancing_effects/Particules.tscn")
var bottom_pos

func particles_loop():
	# ground particles
	if shot_particles == true and is_on_floor():
		var p = particules.instance()
		p.emit("roost", self.position , bottom_pos)
		get_parent().add_child(p)
		shot_particles = false
	if is_on_floor() == false:
		shot_particles = true







# animation

func animation_loop():
	# idle
	if vel.x and vel.y == 0 and not Input.is_action_just_pressed("left") and not Input.is_action_just_pressed("right"):
		if timer_idle_verif == true:
			time_idle.set_wait_time(2)
			time_idle.start()
			timer_idle_verif = false
		pass

func _on_idle_timer_timeout():
	if state == IDLE and vel.x == 0 and no_inputs and is_on_floor():
		$AnimationPlayer.play("idle")
		timer_idle_verif = true
