extends TextureProgress


export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2




func _ready():
	value = 100
	tint_progress = healthy_color
	pass 





func _on_Slime_update_health_bar(health):
	value = health
	if health < max_value * danger_zone:
		tint_progress = danger_color
	elif health < max_value * caution_zone:
		tint_progress = caution_color
	else:
		tint_progress = healthy_color
	pass # Replace with function body.
