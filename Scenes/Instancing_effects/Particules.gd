extends Node2D

func _ready():
	pass

func emit(x, pos):
	if x == "roost":
		self.position.x = pos.x + 100
		self.position.y = pos.y + 45
		$Particles_ground1.emitting = true
		$Particles_ground1.emitting = true
		$Particles_ground1.emitting = true
