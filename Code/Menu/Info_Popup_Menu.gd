extends PopupMenu





func _on_Game_Menu_Info_signal():
	self.show()
	$AnimationPlayer.play("Apparition")

