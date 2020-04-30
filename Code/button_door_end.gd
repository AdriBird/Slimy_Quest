extends Area2D

signal sesame

func _ready():
	$button_anim.play("unpressed")


func _on_button_door_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("bullet"):
		emit_signal("sesame")
		$button_anim.play("pressed")
		yield($button_anim, "animation_finished")
		$button_anim.play("unpressed")
		yield($button_anim, "animation_finished")
		get_parent().queue_free()