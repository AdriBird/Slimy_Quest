extends Node2D

func _ready():
	pass

func emit(x, pos, bottom_pos = Vector2(0,0)):
	if x == "roost":
		position.x = pos.x + bottom_pos.x+ 80
		position.y = pos.y + bottom_pos.y
		$Particles_ground1.emitting = true
		$Particles_ground1.emitting = true
		$Particles_ground1.emitting = true
