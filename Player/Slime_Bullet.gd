extends KinematicBody2D
var speed = 1000
var vel = Vector2()
const gravity = 1000
var tuto 
var power = 20
var state 

func _ready():
	state = "shooted"
	vel.y = -500
	tuto = get_parent()


func start(gpos,pos, dir):
	$Timer.set_wait_time(2)
	$Timer.start()
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	position.y = gpos.y - pos.y
	position.x = gpos.x + pos.x * dir
	vel = Vector2(speed * dir, 0)
	if dir == -1:
		$Sprite.flip_h = false
		$Particles2D2.rotation_degrees = -90 
		$Particles2D2.position.x = -84
	elif dir == 1:
		$Sprite.flip_h = true
		$Particles2D2.rotation_degrees = 90
		$Particles2D2.position.x = 84
#	$bullet_anim.play("shoot")


signal bullet_despawned
signal bullet_hit
func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		state = "collision"
		print(collision.collider.name)
		$anim.play("splash")
		$CollisionShape2D.disabled = true
		vel = Vector2(0, 0)
		if collision.collider.is_in_group("enemy"):
			$CollisionShape2D.disabled = true
			collision.collider.take_damage(20)
			vel = Vector2(0, 0)
#			$bullet_anim.play("splash")
#			yield ($bullet_anim, "animation_finished")
			yield($anim, "animation_finished")
			auto_destruction()
		yield($anim, "animation_finished")
		self.connect("bullet_despawned", get_tree(), "blob_bullet")
		emit_signal("bullet_despawned", position)
		"""self.connect("bullet_hit", collision.collider, "on_bullet_hit")
		emit_signal("bullet_hit", self)"""
		auto_destruction()
	if state == "shooted":
		vel.y += (gravity * delta * 1.5)

func auto_destruction():
	vel = Vector2(0,0)
	$Particles2D.hide()
	$Particles2D2.hide()
	$Sprite2.hide()
	$anim.play("particules")
	yield($anim, "animation_finished")
	queue_free()

func _on_Timer_timeout():
	queue_free()
