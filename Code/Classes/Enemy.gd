extends Entity

class_name Enemy


func _ready():
	add_to_group("enemy")
	randomize()



func _on_hurtbox_body_entered(body):
	"""print(body.name)
	if body.is_in_group("Player_element"):
		take_damage(body.power)
		knock_back(body)"""

func on_bullet_hit(body):
	take_damage(body.power)
	knock_back(body)



