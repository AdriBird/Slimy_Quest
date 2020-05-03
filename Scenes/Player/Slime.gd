extends KinematicBody2D




#-----------------------Signaux----------------------------------------------------------

signal hurt
#-----------------------Variables----------------------------------------------------------
var vel = Vector2()
const GRAVITY = 3000
const UP = Vector2(0, -1)

onready var time_shoot = get_node("timer_shoot")
onready var time_idle = get_node("idle_timer")
var timer_idle_verif = true
var shot_particles = false
var max_speed = 800
var speed = 80
var jump_speed = 1500
var time = true
var can_shoot = false
var bullet = preload("res://Scenes/Player/Slime_Bullet.tscn")
var particules = preload("res://Scenes/Instancing_effects/Particules.tscn")
var direction_tir = 1
var wall_bounce_val = 800
var can_wall_jump = false
var nb_blob = 0
var bottom_pos
#-----------------------Physic Process----------------------------------------------------------


func _ready():
	bottom_pos = get_node("bottom_pos").position
	pass #

func _process(delta):
	update_size()
	$GUI/score.text = str(Global.score)
	if self.position.y >= 2000:
		hurt()
	if Input.is_action_pressed("pause"):
		var pause = preload("res://Scenes/Instancing_effects/menu_pause.tscn").instance()
		add_child(pause)

func _physics_process(delta):
	print(position.y)
	if vel.x and vel.y == 0 and not Input.is_action_just_pressed("left") and not Input.is_action_just_pressed("right"):
		if timer_idle_verif == true:
			time_idle.set_wait_time(2)
			time_idle.start()
			timer_idle_verif = false
		
	if can_wall_jump and vel.y >= 0:
		vel.y += (GRAVITY/14 * delta)
	else:
		vel.y += (GRAVITY * delta)
	if not Global.dialog:
		motion_loop()
		shoot()
	if shot_particles == true and is_on_floor():
		var p = particules.instance()
		p.emit("roost", self.position , bottom_pos)
		get_parent().add_child(p)
		shot_particles = false
	if is_on_floor() == false:
		shot_particles = true
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
	var space = Input.is_action_pressed("ui_accept")
	var just_space = Input.is_action_just_pressed("ui_accept")
	var dirx = int(right) - int(left)
	if dirx == 1 and not is_on_wall():
		$AnimationPlayer.play("move")
		$Sprite.flip_h = false
		direction_tir = 1
		$tir.position.x = 110
		vel.x = min(vel.x + speed, max_speed)
	if dirx == -1 and not is_on_wall():
		$AnimationPlayer.play("move")
		$Sprite.flip_h = true
		direction_tir = -1
		$tir.position.x = -110
		vel.x = max(vel.x - speed, -max_speed)
	if dirx == 0:
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





func _on_Wall_radar_body_entered(body):
	if body.is_in_group("wall"):
		can_wall_jump = true
	pass


func _on_Wall_radar_body_exited(body):
	if body.is_in_group("wall"):
		can_wall_jump = false
	pass

#		get_parent().get_parent().get_node("Info_Popup_Menu").hide()
#		get_parent().get_parent().get_node("Settings_Popup_Menu").hide()
#		get_parent().get_parent().get_node("Info_button").show()
#		get_parent().get_parent().get_node("Settings_button").show()
#		get_parent().get_parent().get_node("Play_button").set_disabled(false)




func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group("water"):
		hurt()
	pass 


func _on_idle_timer_timeout():
	if vel.x and vel.y == 0:
		$AnimationPlayer.play("idle")
		timer_idle_verif = true
