extends TextureProgress

export var void_hurt = 0
export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2

onready var life = 100


func _ready():
	value = life
	tint_progress = healthy_color
	pass 


func _on_Slime_hurt():
	life -= void_hurt
	value = life
	if life < max_value * danger_zone:
		tint_progress = danger_color
	elif life < max_value * caution_zone:
		tint_progress = caution_color
	else:
		tint_progress = healthy_color
