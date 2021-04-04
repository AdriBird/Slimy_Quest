extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_blob()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
onready var item = preload("res://Props/Mana/Blob.tscn")
func spawn_blob():
	for cell in $tile_blob.get_used_cells():
		var id = $tile_blob.get_cellv(cell)
		var type = $tile_blob.tile_set.tile_get_name(id)
		if type in ['blue_blob']:
			var pos = $tile_blob.map_to_world(cell)
			var c = item.instance()
			c.init(type, pos + $tile_blob.cell_size / 2)
			add_child(c)
