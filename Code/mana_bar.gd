extends TextureProgress
onready var mana = 0


func _process(delta):
	value = mana
	mana = Global.mana
#		print("mana updated")
#		mana_tween.interpolate_property(self, "value", value, value + Global.mana_power, 2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
#		mana_tween.start()