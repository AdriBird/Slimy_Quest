extends StaticBody2D


func _ready():
	$door_anim.play("close_door")
	$col_door.disabled = false

func _on_button_door_sesame():
	$col_door.set_deferred("disabled", true)
	$door_anim.play("open_door")
