extends Particles2D

var player 

func _ready():
	player = get_parent().get_node("Sprite")
	pass 


func _on_Slime_ground_particles():
	print("particles")
	self.position = Vector2(player.position.x, player.position.y + 55)
	self.emitting = true
