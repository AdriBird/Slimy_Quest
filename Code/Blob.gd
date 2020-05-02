extends Area2D

var texture = {'blue_blob'  : "res://Sprites/Items/water_drop.png"}

var _type

func init(type, pos):
	_type = type
	$Sprite.texture = load(texture[type])
	position = pos

func _on_Blob_body_entered(body):
	if body.is_in_group("Player"):
		Global.score += 1
		queue_free()
