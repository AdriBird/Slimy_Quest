extends RigidBody2D

#Physic
var speed = 400
var jump_power = 5000
var can_jump
var state = [""]
# Inputs
var right = Input.is_action_pressed("right")
var left = Input.is_action_pressed("left")
var up = Input.is_action_pressed("up")
var down = Input.is_action_pressed("down")
var space = Input.is_action_pressed("ui_accept")

var acceleration = 10000
var top_move_speed = 1000
var top_jump_speed = 400
var directional_force = Vector2()
const DIRECTION = {
	ZERO = Vector2(),
	LEFT = Vector2(-1,0),
	RIGHT = Vector2(1,0),
	UP = Vector2(0,-1),
	DOWN = Vector2(0,1)
}

func _ready():
	pass
func _integrate_forces(state):
	#final_force
	var final_force = Vector2()
	# Not moving
	directional_force = DIRECTION.ZERO
	#apply force
	apply_force(state)
	# Get Movement Velocity
	final_force = state.linear_velocity + directional_force * acceleration
	# Empecher de dépasser la vitesse max
	if final_force.x > top_move_speed:
		final_force.x = top_move_speed
	elif final_force.x < -top_move_speed:
		final_force.x = -top_move_speed
	# Pareil pour la vitesse de saut max
	if final_force.y > top_jump_speed:
		final_force.y = top_jump_speed
	elif final_force.y < -top_jump_speed:
		final_force.y = -top_jump_speed
	#Add Force
	state.linear_velocity = final_force




func apply_force(state):
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	var space = Input.is_action_pressed("ui_accept")
	if left:
		directional_force += DIRECTION.LEFT
	if right:
		directional_force += DIRECTION.RIGHT
	if space:
		directional_force += DIRECTION.UP




"""
var slide_speed = 500
var max_slide_speed = 1200
var limits = 150
var list_actions = ["prepared to jump", "jump", "slide"]
var jump_height = -1000
var stick_begin = ["",""]
var stick_end = ["",""]
var timer = 0
var can_jump = false
var can_double_jump = false
var action = "nil"
var touch_action = "nil"
signal particle
signal hurt
var cam
var direction_tir = 1
var bullet = preload("res://Scenes/Slime_Bullet.tscn")
var time = true
var can_shoot = false
onready var time_shoot = get_node("Timer_shoot")

func _ready():
	cam = get_node("Camera2D")
	set_process_input(true)



var dragging = false

func _input(event):
	if event is InputEventMouseButton:
		if (event.button_index == BUTTON_LEFT and event.pressed):
			if event.position.x < limits or event.position.x > 750 - limits:
				touch_action = "slide"
				action = "prepared_to_foward" 
				timer = 0
		elif event.position.x < limits and action == "prepared_to_foward" and can_jump == true:
			$Sprite.flip_h = true
			direction_tir = -1
			$tir.position.x = -110
			action = list_actions[2]
			touch_action = list_actions[2]
			var max_timer = 1.2
			var max_power = 2.5
			var power = max(1, max_power/max_timer * min(max_timer, timer*2))
			self.linear_velocity.x = power*max(self.linear_velocity.x - slide_speed, -max_slide_speed)
			self.linear_velocity.y = power*max(self.linear_velocity.y - slide_speed, -max_slide_speed)
		elif event.position.x > 750 - limits and action == "prepared_to_foward" and can_jump == true:
			action = list_actions[2]
			touch_action = list_actions[2]
			$Sprite.flip_h = false
			direction_tir = 1
			$tir.position.x = 110
			var max_timer = 1.2
			var max_power = 2.5
			var power = max(1, max_power/max_timer * min(max_timer, timer*2))
			self.linear_velocity.x = power*min(self.linear_velocity.x + slide_speed, max_slide_speed)
			self.linear_velocity.y = power*max(self.linear_velocity.y - slide_speed, -max_slide_speed)
		if  (event.button_index == BUTTON_LEFT and event.pressed) and touch_action != "slide":
			action = list_actions[0]
			dragging = true
			stick_begin[0] = event.position.x
			stick_begin[1] = event.position.y
			timer = 0
		elif (event.button_index == BUTTON_LEFT and not event.pressed) and action == list_actions[0]:
			action = list_actions[1]
			dragging = false
			stick_end[0] = event.position.x
			stick_end[1] = event.position.y
			var max_timer = 1
			var max_power = 6
			var power = max(5, max_power/max_timer * min(max_timer, timer*2))
			var x
			if stick_begin[0] > stick_end[0]:
				x = calc_power(stick_begin[0], stick_end[0], power, "pos")
			else:
				x = calc_power(stick_begin[0], stick_end[0], power, "neg")
			var y
			if stick_begin[1] > stick_begin[1]:
				y = -calc_power(stick_begin[1], stick_end[1], power, "pos")
			else:
				y = calc_power(stick_begin[1], stick_end[1], power, "neg")
			if can_jump:
				self.linear_velocity += Vector2(x/4, y)
				can_double_jump = true
			elif can_double_jump:
				self.linear_velocity += Vector2(x/4, y)
				can_double_jump = false
		touch_action = "nil"

func calc_power(bg, end, power, signe):
	var diff 
	if signe == "pos":
		diff = min(bg - end, 300)
	if signe == "neg":
		diff = max(bg - end, -300)
	var resultat = power * diff
	return resultat
	
	

func _on_Control_mouse_enter():
	if(dragging):
		pass
func _process(delta): 
	if self.position.y >= 2000:
		action = "respawn"
		can_jump = false
		can_double_jump = false
		self.linear_velocity = Vector2(0, 0)
		self.position = get_parent().get_node("Spawn").position
		emit_signal("hurt")
		print("hurt")
	timer += delta

func _physics_process(delta):
	var shoot = Input.is_action_pressed("shoot")
	if shoot and time or can_shoot and time == true:
		var b = bullet.instance()
		b.start($tir.global_position, direction_tir)
		get_parent().add_child(b)
		time = false
		time_shoot.set_wait_time(1)
		time_shoot.start()

func _on_Area2D_body_entered(body):

	pass

"""
func _on_Roost_body_entered(body):
	if body.name != "Player":
		if self.linear_velocity.y > -1:
			 emit_signal("particle")
		can_jump = true
		#can_double_jump = false
	pass 


func _on_Roost_body_exited(body):
	can_jump = false
	#can_double_jump = true
	pass 

"""
func _on_Timer_shoot_timeout():
	time = true


func _on_pause_pressed():
	var pause = preload("res://Scenes/menu_pause.tscn").instance()
	add_child(pause)


func _on_attk_pressed():
	can_shoot = true
	time_shoot.set_wait_time(1)
	time_shoot.start()
	yield($Timer_shoot, "timeout")
	can_shoot = false
	
	
"""