extends Area2D

func _ready():
	self.scale.x = get_parent().rect_size.x/get_parent().rect_min_size.x
	self.scale.y = get_parent().rect_size.y/get_parent().rect_min_size.y
	self.position =(get_parent().rect_size -get_parent().rect_min_size)