extends Camera2D

export (int) var pos = 50
var player
func _ready():
	player = get_parent()
	self.zoom = Vector2(2,2)
"""
func _input(event):
	if event.is_action("dezoom"):
		self.zoom += Vector2(0.1,0.1)
	if event.is_action("zoom"):
		self.zoom += Vector2(-0.1,-0.1)
"""

func _process(delta):
	position.y = player.scale.y * pos
