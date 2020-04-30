extends KinematicBody2D
var speed = 1000
var vel = Vector2()

func start(pos, dir):
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	position = pos
	vel = Vector2(speed * dir, 0)
	if dir == -1:
		$Sprite.flip_h = false
		$Particles2D2.rotation_degrees = -90 
		$Particles2D2.position.x = -84
	else:
		$Sprite.flip_h = true
		$Particles2D2.rotation_degrees = 90
		$Particles2D2.position.x = 84
	$bullet_anim.play("shoot")
	
func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision :
		if collision.collider.has_method("hit"):
			$CollisionShape2D.disabled = true
			collision.collider.hit(20)
			vel = Vector2(0, 0)
			$bullet_anim.play("splash")
			yield ($bullet_anim, "animation_finished")
			$CollisionShape2D.disabled = false
			queue_free()
		queue_free()

