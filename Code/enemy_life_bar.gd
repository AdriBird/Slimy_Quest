extends TextureProgress

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.25

onready var life_life_bar = 100


func _ready():
	value = life_life_bar
	tint_progress = healthy_color
	self.hide()
	pass 




func _on_enemy_hurt(life):
	self.show()
	life_life_bar = life
	value = life_life_bar
	if life_life_bar < max_value * danger_zone:
		tint_progress = danger_color
	elif life_life_bar < max_value * caution_zone:
		tint_progress = caution_color
	else:
		tint_progress = healthy_color
