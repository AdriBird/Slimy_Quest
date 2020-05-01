extends Area2D




func _on_Blob_body_entered(body):
	if body.is_in_group("Player"):
		print("c'est toi le chat!")
		Global.score += 1
		queue_free()
