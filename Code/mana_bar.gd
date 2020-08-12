extends TextureProgress
onready var mana = 0


func _process(delta):
	value = mana
	mana = Global.mana