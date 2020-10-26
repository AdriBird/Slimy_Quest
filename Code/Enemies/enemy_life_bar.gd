extends TextureProgress

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.25

 

var health

func _ready():
	health = get_parent().health
	max_value = health
	value = health
	tint_progress = healthy_color
	self.hide()
	pass 




func _on_update_health_bar(health):
	self.show()
	value = health
	if health < max_value * danger_zone:
		tint_progress = danger_color
	elif health < max_value * caution_zone:
		tint_progress = caution_color
	else:
		tint_progress = healthy_color


