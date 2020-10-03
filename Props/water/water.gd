extends TextureRect

func _ready():
	call_deferred( "_set_collisions" )
func _set_collisions():
	print("adaptwater")
	$death_zone/collision.shape.extents = rect_size / 2.0
	$death_zone.position = rect_size / 2.0