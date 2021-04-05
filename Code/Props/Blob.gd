extends RigidBody2D

var texture = {'blue_blob'  : "res://Sprites/Items/water_drop.png"}

var _type

signal blob_touch
onready var st_scale = $Sprite.get_scale()
func _process(delta):
	anim()

var anim = false

func anim():
	$Particles2D.rotation = -PI/2 -self.rotation
	self.show()
	if anim == false:
		anim = true
		$Tween.interpolate_property($Sprite, "scale", st_scale, Vector2(0.08,st_scale.y), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		yield(get_tree().create_timer(1), "timeout")
		$Tween.interpolate_property($Sprite, "scale", Vector2(0.08,st_scale.y), st_scale, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		yield(get_tree().create_timer(1), "timeout")
		anim = false




func init(type, pos):
	_type = type
	$Sprite.texture = load(texture[type])
	position = pos





func _on_Area2D_body_entered(body):
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
