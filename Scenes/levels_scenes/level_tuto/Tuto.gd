extends Node2D
var dialog_scene = preload("res://Scenes/Instancing_effects/dialog.tscn")


func _ready():
	$tile_blob.hide()
	Global.mana = 0
	spawn_blob()
	
	


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

onready var item = preload("res://Scenes/Objets/Blob.tscn")
func spawn_blob():
	for cell in $tile_blob.get_used_cells():
		var id = $tile_blob.get_cellv(cell)
		var type = $tile_blob.tile_set.tile_get_name(id)
		if type in ['blue_blob']:
			var pos = $tile_blob.map_to_world(cell)
			var c = item.instance()
			c.init(type, pos + $tile_blob.cell_size / 2)
			add_child(c)

