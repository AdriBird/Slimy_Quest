extends Area2D

var texture = {'blue_blob'  : "res://Sprites/Items/water_drop.png"}

var _type

signal blob_touch

func init(type, pos):
	_type = type
	$Sprite.texture = load(texture[type])
	position = pos

func _on_Blob_body_entered(body):
	if body.is_in_group("Player"):
		self.connect("blob_touch", body, "blob_touched")
		emit_signal("blob_touch")
		queue_free()
#		var mana_end = Global.mana + 10
#		while Global.mana != mana_end:
#			Global.mana = lerp(Global.mana, mana_end, 1)
#		Global.mana_power = 30
#		Global.mana_verif = true
#		Global.mana_tween_verif = true
#		body.nb_blob += 1

