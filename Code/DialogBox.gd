extends Control
signal end_dialog

var type_dialog = ""
var d 
var dialog_index = 0
var finished = false


func _process(delta):
	$end_indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("clic_droit") or Input.is_action_just_pressed("clic_gauche"):
		load_dialog(d)

func load_dialog(dialog):
	d = dialog
	Global.dialog = true
	if dialog_index < d.size():
		$RichTextLabel.bbcode_text = d[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 1, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		emit_signal("end_dialog")
		Global.dialog = false
		queue_free()
	dialog_index += 1

func _on_Tween_tween_completed(object, key):
	pass





