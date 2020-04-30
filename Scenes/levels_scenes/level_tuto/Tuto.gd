extends Node2D
var dialog_scene = preload("res://Scenes/Instancing_effects/dialog.tscn")
func _ready():
	pass
	


func _on_end_flag_box_end():
	var info_dialog = dialog_scene.instance()
	var dialog = [
		'Salut à toi et merci d\'avoir essayé le jeu Slimy Quest!',
		'Ce n\'était que la version en dev',
		'Nous avons hate que tu participes au projet, si cela t\'intéresse!'
	]
	info_dialog.load_dialog(dialog)
	get_node("Slime/GUI").add_child(info_dialog)
	pass # Replace with function body.
