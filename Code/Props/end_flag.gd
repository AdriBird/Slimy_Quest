extends Area2D
signal box_end


func _on_end_flag_body_entered(body):
	if body.is_in_group("Player"):
		print("win")
		emit_signal("box_end")
		queue_free()

