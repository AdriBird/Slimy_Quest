extends Entity




#-----------------------Signaux----------------------------------------------------------



#-----------------------Variables----------------------------------------------------------



var no_inputs

#-----------------------Motions variables-------------------------------------------------------

#Vitesse constante
const SPEED = 400
# Maximum d'incrémentation
var max_accel = 30
# incrémentation actuelle
var accel = 0
# vitesse actuelle

# vitesse min pour bounce
var max_slide_speed = 599

# montée en bounce
var bounce_power = 600
# montée en jump

var wall_bounce_val = 800

var on_wall = false




onready var timer_bounce = get_node("timers/timer_bounce")
#var bounce_timer_verif = false


var my_rotation = 0
func _ready():
	# damages to other entities
	power = 0
	has_health_bar = true
	max_speed = 700
	my_rotation = 0
	bottom_pos = get_node("bottom_pos").position
	state = IDLE
	jump_state = NONE
	$tir.position.x = 110

#-----------------------States------------------------------------------------------------------
enum  {IDLE, JUMP, SHOOT, SLIDE, BOUNCE, BOUNCE_AIR, PAUSE, WALL, FALL, HURT}
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
	dirx = int(right) - int(left)
	right = Input.is_action_pressed("right")
	left = Input.is_action_pressed("left")
	up = Input.is_action_pressed("up")
	down = Input.is_action_pressed("down")
	space = Input.is_action_pressed("jump")
	just_space = Input.is_action_just_pressed("jump")
	#NULL INPUTS
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
	#Check si on se déplace
	if state == IDLE and vel.x != 0 and on_wall == false and cycle == 'none':
		change_state(SLIDE)
	#Condition de Bounce
	if state == SLIDE and Input.is_action_pressed("bounce") :
		change_state(BOUNCE)
	#Condition d'inactivité
	if state == BOUNCE and not Input.is_action_pressed("bounce"):
		change_state(SLIDE)
	if state in [SLIDE, BOUNCE] and vel.x == 0 and no_inputs and is_on_floor() and cycle == 'none':
		change_state(IDLE)
	#Condition de Saut
	if state in [IDLE, SLIDE] and is_on_floor() and Input.is_action_just_pressed("jump") and cycle == "none":
		change_state(JUMP)
	if state in [IDLE, SLIDE] and not is_on_floor() and cycle == 'none' and vel.y > 0:
		change_state(FALL)
	# Phase intermédiare Durant Bounce
	if state == BOUNCE and !is_on_floor() and cycle == "none":
		change_state(BOUNCE_AIR)
	#  Retour sur bounce Bounce
	if state == BOUNCE_AIR and is_on_floor() and Input.is_action_pressed("bounce") and cycle == "none" :
		change_state(BOUNCE)
	# Atterissage
	if state == BOUNCE_AIR and is_on_floor() and !Input.is_action_pressed("bounce") and cycle == "none":
		change_state(SLIDE)
	#check le déplacement sur le sol
	if cycle == "none" and int(right) + int(left) == 1 and is_on_floor() and state != BOUNCE:
		change_state(SLIDE)
	if on_wall and not is_on_floor():
		change_cycle("wall_jump")
		change_state(WALL)
	# roost de FALL
	if state == FALL and is_on_floor():
		change_state(SLIDE)
	# phase de take damage:
	if state == HURT:
		if is_on_floor():
			vel.x = lerp(vel.x, 0, 0.05)
		else:
			vel.x = lerp(vel.x, 0, 0.5)



func change_state(new_state):
	state = new_state
	match state:
		# ne se répéte pas
		IDLE:
			my_rotation = 0
			if timer_idle_verif == true:
				time_idle.set_wait_time(2)
				time_idle.start()
				timer_idle_verif = false
		JUMP:
			# montée
			max_speed = 1000
			cycle = "jump"
			jump_state = PRE_JUMPING
		SLIDE:
			max_speed = 450
			$AnimatedSprite/anim_move.play("slide")
			my_rotation = 0
		BOUNCE:
			max_speed = 700
			$AnimatedSprite/anim_move.play("slide")  #Start Bounce animation $AnimationPlayer.start("bounce")
			my_rotation = 0
		BOUNCE_AIR:
			pass     #Start bounce_air animation 
		SHOOT: 
			$AnimatedSprite/anim_move.play("slide") # en attendant l'anim de tir
			pass    #Start Shoot animation $AnimationPlayer.start("shoot
		FALL:
			max_speed = 700
		WALL:
			$AnimatedSprite.play("slide")
			max_speed = 700
		HURT:
			vel.x = 0
			yield(get_tree().create_timer(1), "timeout")
			change_state(SLIDE)


# fonction delta
func cycles():
	match cycle:
		"jump":
			match jump_state:
				# appuye, le temps change selon la durré de l'animation
				PRE_JUMPING:
					change_state(JUMP)
					my_rotation = 0
					$AnimatedSprite/anim_move.play("jump_start_ground")
					# si l'on cancel le saut
					if Input.is_action_just_released("jump"):
						jump_state = NONE    
						$AnimatedSprite/anim_move.play("slide")
					# Quand l'anim se termine:
					yield($AnimatedSprite/anim_move, "animation_finished")
					# si le saut_ui est toujours appuyé
					if Input.is_action_pressed("jump") and is_on_floor():
						jump_state =  JUMPING
						vel.y = -jump_speed
					else:
						$AnimatedSprite/anim_move.play("slide")
						jump_state = NONE
						jump_type = "none"
						if cycle == "jump":
							cycle = "none"
						# Sortie
						if is_on_floor():
							change_state(SLIDE)
						elif on_wall:
							change_state(WALL)
						else:
							change_state(FALL)
				# Saut en montée
				JUMPING:
					if abs(vel.x) > 100 :
						jump_type = "horizontal"
					else: 
						jump_type = "vertical"
					if first_anim == 0:
						first_anim = 1
						yield(get_tree().create_timer(0.1), "timeout")
						$AnimatedSprite/anim_move.play("jump_start_air")
					if Input.is_action_just_released("jump"):
						if vel.y < -100:
							vel.y /= 2
					if vel.y > -1000 :
						jump_state = MID_JUMP
					#$AnimatedSprite/anim_move.play("jump_middle")
					#$AnimatedSprite.rotation_degrees = 0
					#yield($AnimatedSprite/anim_move, "animation_finished")
					#$AnimatedSprite/anim_move.play("jump_end_air")
				MID_JUMP:
					$AnimatedSprite/anim_move.play("jump_middle")
					if vel.y > 1000 :
						jump_state = DOWN
					if is_on_floor():
						jump_state = ROOST
				DOWN:
					$AnimatedSprite/anim_move.play("jump_end_air")
					if is_on_floor():
						jump_state = ROOST
				ROOST:
					# A RENDRE FACULTATIF
					my_rotation = 0
					$AnimatedSprite/anim_move.play("jump_end_ground")
					
					#$AnimatedSprite.rotation_degrees = 0
					if no_inputs:
						yield($AnimatedSprite/anim_move, "animation_finished")
						change_state(SLIDE)
					else:
						change_state(SLIDE)
					change_cycle("none")
		"wall_jump":
			if left and "D" in wall_detected and speed > 0:
				speed = -200
			elif right and "G" in wall_detected and speed < 0:
				speed = 200
			#EXIT DOORS:
			if not on_wall:
				if is_on_floor():
					change_state(SLIDE)
					cycle = "none"
				else:
					change_state(FALL)
					cycle = "none"

func change_cycle(new_cycle):
	cycle = new_cycle
	jump_type = "none"
	jump_state = NONE
	first_anim = 0


# JUMP CYCLE VAR
enum {NONE, PRE_JUMPING, JUMPING, MID_JUMP, DOWN, ROOST}
var jump_state
var first_anim = 0
var jump_type = "none"



# WALL JUMP CYCLE








#-----------------------Physic Process----------------------------------------------------------



func _process(delta):
	pass




func update_score():
	$GUI/score.text = str(Global.mana)

var is_moving
func _physics_process(delta):
	cam()
	#animation_loop()
	# pause
	# empecher le mouvement en fade in/ dialog
	if vel == Vector2(0,0):
		is_moving = false
	else :
		is_moving = true
	if not Global.dialog:
		cycles()
		if state != HURT:
			motion_loop(delta)
			shoot()
			state_loop()
	elif state != HURT:
		vel.x = 0
	particles_loop()
	wall_update()
	if on_wall and vel.y >= 0:
		vel.y /= 2
	vel.y += (GRAVITY * delta)
	vel = move_and_slide(vel, UP)
	#--- ROTATION RADIANT
	if vel.y != 0 and vel.x != 0 and jump_state != NONE  and jump_type == "horizontal" and cycle == "jump" and jump_state != ROOST:
# warning-ignore:unused_variable
		var angle = atan(abs(float(vel.y))/abs(float(vel.x)))
		if vel.x < 0:
			if vel.y < 0:
				my_rotation = atan(abs(float(vel.y))/abs(float(vel.x)))
			else : 
				my_rotation = -atan(float(vel.y)/abs(float(vel.x)))
		elif vel.x > 0:
			if vel.y < 0:
				my_rotation = -atan(abs(float(vel.y))/abs(float(vel.x)))
			else : 
				my_rotation = atan(float(vel.y)/abs(float(vel.x)))
		if $AnimatedSprite.flip_h == false and vel.x < 0:
			$AnimatedSprite.flip_h = true
		elif $AnimatedSprite.flip_h and vel.x > 0:
			$AnimatedSprite.flip_h = false
	else:
		my_rotation = 0
	$CollisionPolygon2D2.rotation = my_rotation
	$AnimatedSprite.rotation= my_rotation
	update_score()
	input_update()
	# tué par le vide, à rendre plus propre
	if self.position.y >= 2000:
		take_damage(health)
	# Menu pause
	if Input.is_action_pressed("pause"):
		var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
		add_child(pause)
	# anti_imprécision:
	if vel.x > -0.05 and vel.x < 0.05:
		vel.x = 0


func shoot():
	var shoot = Input.is_action_pressed("shoot")
	if shoot and time or can_shoot and time == true:
		if Global.mana > 0:
			var b = bullet.instance()
			b.start($tir.global_position, direction_tir)
			get_parent().add_child(b)
			mana_lose()
			time = false
			time_shoot.set_wait_time(1)
			time_shoot.start()


func motion_loop(delta):
	# DROITE
	if dirx == 1 and not "D" in wall_detected:
		direction_tir = 1
		$tir.position.x = 110
		if state == BOUNCE and vel.x > max_slide_speed and is_on_floor():
			if space and is_on_floor():
				change_state(JUMP)
			elif not space and Input.is_action_pressed("bounce"):
				vel.y = -bounce_power
		if is_on_floor():
			accel = 30
		elif jump_type == "horizontal":
			if vel.y < 0:
				vel.y+= 30
			accel = 40
		elif jump_type == "vertical":
			accel = 20
		elif state == FALL or WALL:
			accel =  30
		if jump_type != "horizontal": 
			$AnimatedSprite.flip_h = false
	
	
	
	
	
	
	
	# GAUCHE
	if dirx == -1 and not "G" in wall_detected:
		direction_tir = -1
		$tir.position.x = -110
		if state == BOUNCE and vel.x < -max_slide_speed and is_on_floor():
			if space and is_on_floor():
				change_state(JUMP)
			elif not space and Input.is_action_pressed("bounce"):
				vel.y = -bounce_power
		if is_on_floor():
			accel = -30
		elif jump_type == "horizontal":
			if vel.y < 0:
				vel.y+= 30
			accel = -40
		elif jump_type == "vertical":
			accel = -20
		elif state == FALL or WALL:
			accel =  -30
		if jump_type != "horizontal":
			$AnimatedSprite.flip_h = true
	if speed != 0:
		if dirx == 0 or dirx != speed / abs(speed) :
			if is_on_floor() and state != HURT :
				accel = lerp(accel, 0, 0.5)
				speed = lerp(speed, 0, 0.5)
			if state in [FALL, JUMP]:
				accel = lerp(accel, 0, 0.05)
				speed = lerp(speed, 0, 0.05)
	speed += accel
	if is_on_floor():
		max_speed = 600
	else:
		max_speed = 800
	if not no_inputs:
		if speed > 0:
			vel.x = min(speed, max_speed)
		if speed < 0:
			vel.x = max(speed, -max_speed)
	
	
	# X == 0
	if no_inputs:                           #afk ou les 2 touches
		vel.x = lerp(vel.x, 0 ,0.5)
	
	# WALL JUMP
	if just_space and on_wall and dirx != 0:
		vel.y = -jump_speed * 0.8
		if $AnimatedSprite.flip_h == false:
			speed = -wall_bounce_val
		if $AnimatedSprite.flip_h == true:
			speed = wall_bounce_val



#-----------------------Blob------------------------------------------------------------------
var nb_blob = 0
var mana_growth = 0.1

onready var mana_tween = $GUI/tween_mana
onready var size_tween = get_node("size_tween")
onready var mana_bar = $GUI/mana_bar
var ref = 0
func blob_touched():      #agrandissement du slime + ajout de mana (blob)
	if Global.mana < 100:
		# self
		size_tween.interpolate_property(self, "scale", get_scale(), get_scale() + Vector2(mana_growth, mana_growth), 0.7, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		size_tween.start()
		position.y -= 15
		# mana bar
		mana_tween.interpolate_property(mana_bar, "value", Global.mana, Global.mana + Global.mana_power, 0.7, Tween.TRANS_QUART, Tween.EASE_OUT)
		mana_tween.start()

func _on_hurtbox_body_entered(body):
	# ennemi
	if body is Enemy:
		change_cycle("none")
		change_state(HURT)
		take_damage(body.power)
		knock_back(body)

func mana_lose():        #rétrécissement du slime + retrait de mana (bullet)
	#self
	size_tween.interpolate_property(self, "scale", get_scale(), get_scale() - Vector2(mana_growth, mana_growth), 0.7, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	size_tween.start()
	#mana_bar
	mana_tween.interpolate_property(mana_bar, "value", Global.mana, Global.mana - Global.mana_power, 0.7, Tween.TRANS_QUART, Tween.EASE_OUT)
	mana_tween.start()







# pause
func _on_pause_pressed():
	var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
	add_child(pause)
	


func _on_timer_shoot_timeout():
	time = true




#--------------------Detections---------------------------------------------------------



func death():
	get_tree().reload_current_scene()





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
		take_damage(10)
	pass 

#--------------------Camera---------------------------------------------------
var cameraDownRelease
var cameraDown = 0
var timerOffset
var cameraShake
func cam():
	if is_moving == false:
		if Input.is_action_just_pressed("down"):
			timerOffset = 100
		if Input.is_action_pressed("down"):
			if timerOffset != 0:
				timerOffset -= 1
			elif cameraDown < 500:
				cameraDown = cameraDown *70 + 2
			
		if Input.is_action_just_released("down"):
			cameraDownRelease = true
			pass
		if cameraDownRelease == true:
			if cameraDown > 0:
				$Camera2D.smoothing_enabled = false
				cameraDown = cameraDown - 1200
			else:
				$Camera2D.smoothing_enabled = true
				cameraDown = 0
				cameraDownRelease = false
			pass
	else:
		if cameraDown > 0:
			$Camera2D.smoothing_enabled = false
			cameraDown = cameraDown - 1200
		else:
			$Camera2D.smoothing_enabled = true
			cameraDown = 0
	if Input.is_action_pressed("down"):
		$Camera2D.offset = Vector2(00, cameraDown)
	else:
		$Camera2D.offset = Vector2(00, cameraDown)
	"""
	if hitstun > 0:
		cameraShake = 30
	if cameraShake > 0:
		cameraShake -= 1
		$Camera2D.offset = Vector2(rand_range(-1.0, 1.0) * 10, rand_range(-1.0, 1.0) * 10)"""
	






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
		pass