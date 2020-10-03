extends Area2D

signal sesame

func _ready():
	get_parent().get_parent().get_node("arrow_pressed").hide()
	get_parent().get_parent().get_node("arrow_follow1").show()
	$button_anim.play("unpressed")


func _on_button_door_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("sesame")
		get_parent().get_parent().get_node("arrow_pressed").show()
		get_parent().get_parent().get_node("arrow_follow1").hide()
		$button_anim.play("pressed")
		yield($button_anim, "animation_finished")
		$button_anim.play("unpressed")
		yield($button_anim, "animation_finished")
		get_parent().queue_free()
