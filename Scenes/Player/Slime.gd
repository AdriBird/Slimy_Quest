extends KinematicBody2D




#-----------------------Signaux----------------------------------------------------------

signal hurt

#-----------------------Variables----------------------------------------------------------


var vel = Vector2()
const GRAVITY = 3000
const UP = Vector2(0, -1)
var no_inputs

#-----------------------Motions variables-------------------------------------------------------


var speed = 50
var max_slide_speed = 449
var max_speed = 450
var bounce_power = 600

var jump_speed = 1500
var wall_bounce_val = 600
var on_wall = false

onready var timer_bounce = get_node("timers/timer_bounce")
#var bounce_timer_verif = false
#var time_timer_bounce = true






#-----------------------States------------------------------------------------------------------
enum  {IDLE, JUMP, SHOOT, SLIDE, BOUNCE, BOUNCE_AIR, PAUSE, DAMAGE, WALL}
var state
var cycle = "none"
#-----------------------INPUTS------------------------------------------------------------------

var right = Input.is_action_pressed("right")
var left = Input.is_action_pressed("left")
var up = Input.is_action_pressed("up")
var down = Input.is_action_pressed("down")
var space = Input.is_action_pressed("jump")
var just_space = Input.is_action_just_pressed("jump")

func input_update():
	right = Input.is_action_pressed("right")
	left = Input.is_action_pressed("left")
	up = Input.is_action_pressed("up")
	down = Input.is_action_pressed("down")
	space = Input.is_action_pressed("jump")
	just_space = Input.is_action_just_pressed("jump")
	if int(right)+ int(left) + int(up) + int(down)+ int(space) + int(just_space) == 0:                                
		no_inputs = true
	else:
		no_inputs = false


#---------------------Shoot variables----------------------------------------------------------
onready var time_shoot = get_node("timers/timer_shoot")
var can_shoot = false
var bullet = preload("res://Scenes/Player/Slime_Bullet.tscn")
var direction_tir = 1


var time = true #shoot





onready var time_idle = get_node("timers/idle_timer")
var timer_idle_verif = true



func state_loop():
	
	
	# pause
	# empecher le mouvement en fade in/ dialog
	if not Global.dialog:
		motion_loop()
		shoot()
	else:
		vel.x = 0
	#Check si on se déplace
	if state == IDLE and vel.x != 0 and on_wall == false:
		change_state(SLIDE)
	#Condition de Bounce
	if state == SLIDE and Input.is_action_pressed("bounce") :
		change_state(BOUNCE)
	#Condition d'inactivité
	if state in [SLIDE, BOUNCE] and vel.x == 0 and no_inputs and is_on_floor():
		change_state(IDLE)
	#Condition de Saut
	if state in [IDLE, SLIDE] and !is_on_floor():
		change_state(JUMP)
	# Phase intermédiare Durant Bounce
	if state == BOUNCE and !is_on_floor():
		change_state(BOUNCE_AIR)
	#  Retour sur bounce Bounce
	if state == BOUNCE_AIR and is_on_floor() and Input.is_action_pressed("bounce") :
		change_state(BOUNCE)
	# Atterissage
	if state == BOUNCE_AIR and is_on_floor() and !Input.is_action_pressed("bounce") :
		change_state(SLIDE)
		
	if cycle == "none" and int(right) + int(left) == 1 and is_on_floor() and state != BOUNCE:
		change_state(SLIDE)
		"""if not is_on_floor():
			#jump_state = PRE_JUMPING
			vel.y = 500
		pass
		if state == JUMP and is_on_floor() and cycle == "none":
		$AnimatedSprite/anim_move.play("jump_end_ground")
		#$AnimatedSprite.rotation_degrees = 0
		if no_inputs:
			yield($AnimatedSprite/anim_move, "animation_finished")
			change_state(SLIDE)
		else:
			change_state(SLIDE)"""

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimatedSprite.rotation_degrees = 0
			if timer_idle_verif == true:
				time_idle.set_wait_time(2)
				time_idle.start()
				timer_idle_verif = false
		JUMP:
			# montée
			if !is_on_floor() and vel.y <= 0:
				#$AnimatedSprite/anim_move.play("jump_start_air")
				pass
#			if is_on_floor():
#				$AnimatedSprite/anim_move.play("jump_end_ground")
			    #Start Jump animation $AnimationPlayer.start("jump")
		SLIDE:
			max_speed = 450
			$AnimatedSprite/anim_move.play("slide")
			$AnimatedSprite.rotation_degrees = 0
		BOUNCE:
			max_speed = 700
			$AnimatedSprite/anim_move.play("slide")  #Start Bounce animation $AnimationPlayer.start("bounce")
			$AnimatedSprite.rotation_degrees = 0
		BOUNCE_AIR:
			pass     #Start bounce_air animation 
		SHOOT: 
			$AnimatedSprite/anim_move.play("slide") # en attendant l'anim de tir
			pass    #Start Shoot animation $AnimationPlayer.start("shoot")


enum {NONE, PRE_JUMPING, JUMPING, MID_JUMP, FALL, ROOST}
var jump_state

func jump_state():
	#print(cycle)
	if just_space and is_on_floor() and jump_state == NONE:
		jump_state = PRE_JUMPING
	match jump_state:
		NONE:
			if cycle == "jump":
				cycle = "none"
		PRE_JUMPING:
			cycle = "jump"
			$AnimatedSprite/anim_move.play("jump_start_ground")
			if Input.is_action_just_released("jump"):
				jump_state = NONE
				$AnimatedSprite/anim_move.play("slide")
			yield($AnimatedSprite/anim_move, "animation_finished")
			if Input.is_action_pressed("jump"):
				jump_state =  JUMPING
				vel.y = -jump_speed
		JUMPING:
			$AnimatedSprite/anim_move.play("slide")
			if Input.is_action_just_released("jump"):
				if vel.y < -100:
						vel.y /= 2
			if vel.y > -10 :
				jump_state = MID_JUMP
			#$AnimatedSprite/anim_move.play("jump_middle")
			#$AnimatedSprite.rotation_degrees = 0
			#yield($AnimatedSprite/anim_move, "animation_finished")
			#$AnimatedSprite/anim_move.play("jump_end_air")
		MID_JUMP:
			if vel.y < 10 :
				jump_state = FALL
		FALL:
			if is_on_floor():
				jump_state = ROOST
		ROOST:
			jump_state = NONE
			cycle = "none"





#-----------------------Physic Process----------------------------------------------------------
func _ready():
	$AnimatedSprite.rotation_degrees = 0
	$CollisionShape2D.rotation_degrees = 0
	#$AnimatedSprite.play("slide")
	bottom_pos = get_node("bottom_pos").position
	state = IDLE
	jump_state = NONE
	$tir.position.x = 110
	pass 


func _process(delta):
	#print($AnimatedSprite/anim_move.current_animation)
	state_loop()
	update_size()
	update_score()
	input_update()
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
	wall_update()
	jump_state()
	if on_wall and vel.y >= 0:
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
	
	
	# DROITE
	var dirx = int(right) - int(left)
	if dirx == 1 and not "D" in wall_detected:
		direction_tir = 1
		$tir.position.x = 110
		if state == BOUNCE and vel.x > max_slide_speed:
			if space and is_on_floor():
				change_state(JUMP)
				vel.y = -jump_speed
			if Input.is_action_just_released("jump"):
				if vel.y < -100:
					vel.y /= 2
			elif not space:
				vel.y = -bounce_power
		vel.x = min(vel.x + speed, max_speed)
		$AnimatedSprite.flip_h = false
	
	# GAUCHE
	if dirx == -1 and not "G" in wall_detected:
		direction_tir = -1
		$tir.position.x = -110
		if state == BOUNCE and vel.x < -max_slide_speed:
			if space and is_on_floor():
				change_state(JUMP)
				vel.y = -jump_speed
			if Input.is_action_just_released("jump"):
				if vel.y < -100:
					vel.y /= 2
			elif not space:
				vel.y = -bounce_power
		vel.x = max(vel.x - speed, -max_speed)
		$AnimatedSprite.flip_h = true
	
	# X == 0
	if dirx == 0:                           #afk ou les 2 touches
		vel.x = lerp(vel.x, 0 ,0.15)
	
	# WALL JUMP
	if just_space and on_wall and dirx != 0:
		vel.y = -jump_speed
		if $AnimatedSprite.flip_h == true:
			vel.x = wall_bounce_val
		if $AnimatedSprite.flip_h == false:
			vel.x = -wall_bounce_val



#-----------------------Blob------------------------------------------------------------------
var nb_blob = 0

func update_size():
	var pos = position
	var x = 0.05
	if scale != Vector2(1+x*nb_blob,1+x*nb_blob):
		scale = Vector2(1+x*nb_blob,1+x*nb_blob)
		position.y += -20




#hurt
func hurt():
	self.vel.y = 0
	#self.position = get_parent().get_node("Spawn").position
	emit_signal("hurt")

# pause
func _on_pause_pressed():
	var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
	add_child(pause)
	


func _on_timer_shoot_timeout():
	time = true




#--------------------Detections---------------------------------------------------------






# Walls
var wall_detected = []
func _on_Wall_radar_D_body_entered(body):
	if body.is_in_group("wall"):
		wall_detected.append("D")
func _on_Wall_radar_D_body_exited(body):
	if body.is_in_group("wall"):
		wall_detected.remove("D")
func _on_Wall_radar_G_body_entered(body):
	if body.is_in_group("wall"):
		wall_detected.append("G")
func _on_Wall_radar_G_body_exited(body):
	if body.is_in_group("wall"):
		wall_detected.remove("G")
func wall_update():
	if len(wall_detected) > 0:
		on_wall = true
	else:
		on_wall = false






# WATER
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
	if is_on_floor() and state == ROOST and shot_particles:
		var p = particules.instance()
		p.emit("roost", self.position , bottom_pos)
		get_parent().add_child(p)
		shot_particles = false
	if is_on_floor() == false:
		shot_particles = true







# animation

func animation_loop():
	# idle
	pass

func _on_idle_timer_timeout():
	if state == IDLE and vel.x == 0 and no_inputs and is_on_floor():
		#$AnimatedSprite/AnimationPlayer.play("idle")
		timer_idle_verif = true
