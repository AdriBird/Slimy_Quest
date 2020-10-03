extends Enemy

class_name Mob, "res://Sprites/Icons/Mob_object_icon.png"


enum {NEUTRAL, SPOT, ATTACK, DAMAGE}
var state

func attack():
	.attack()

func neutral():
	.neutral()

func spot():
	.spot()

func pattern():
	match state:
		NEUTRAL:
			neutral()
		SPOT:
			spot()
		ATTACK:
			attack()


var hit_lag
onready var timer_hit_lag = get_node("Timer_hit_lag")



func _process(delta):
	pattern()


