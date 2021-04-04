extends Node


# Signaux / Scènes à instancier
var dialog_scene = preload("res://GI/dialog.tscn")
var button_list = []
signal Info_signal
signal Settings_signal

func _ready():
	Global.dialog = false
	get_node("Quit_button").show()
	get_node("Info_button").show()
	get_node("Settings_button").show()
	get_node("Play_button").show()
	get_node("Play_button").set_disabled(false)

# HOVER COLORS
func _process(delta):
	if Global.dialog:
		get_node("Info_button").hide()
		get_node("Settings_button").hide()
		get_node("Play_button").hide()
		get_node("Quit_button").hide()
		get_node("Play_button").set_disabled(true)
	else: 
		get_node("Quit_button").show()
		get_node("Info_button").show()
		get_node("Settings_button").show()
		get_node("Play_button").show()
		get_node("Play_button").set_disabled(false)
	if $Play_button.is_hovered():
		$Play_button/Label.add_color_override("font_color", Color(0,0.5,1))
	else:
		$Play_button/Label.add_color_override("font_color", Color(1,1,1))
	if $Settings_button.is_hovered():
		$Settings_button/Label.add_color_override("font_color", Color(0.3,1,0.4))
	else:
		$Settings_button/Label.add_color_override("font_color", Color(1,1,1))
	if $Info_button.is_hovered():
		$Info_button/Label.add_color_override("font_color", Color(0,0.5,1))
	else:
		$Info_button/Label.add_color_override("font_color", Color(1,1,1))
	if $Quit_button.is_hovered():
		$Quit_button/Label.add_color_override("font_color", Color(1,0.3,0))
	else:
		$Quit_button/Label.add_color_override("font_color", Color(1,1,1))



# Signaux 
func _on_Play_button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Zone1/level1/level1.tscn")


func _on_Info_button_pressed():
	var info_dialog = dialog_scene.instance()
	# appel de la dialog box
	var dialog = [
		'Salut à toi et merci d\'avoir essayé le jeu Slimy Quest!',
		'Il n\'y a pour l\'instant aucune aide de disponible,',
		'Bon jeu!'
	]
	info_dialog.load_dialog(dialog)
	add_child(info_dialog)
	no_buttons()
	pass


# relance le menu
func _on_Close_Button_pressed():
	get_node("Info_Popup_Menu").hide()
	get_node("Settings_Popup_Menu").hide()
	get_node("Info_button").show()
	get_node("Settings_button").show()
	get_node("Play_button").set_disabled(false)
	pass # Replace with function body.


func _on_Settings_button_pressed():
	get_tree().change_scene("res://GI/Panels_scenes/Settings_Scene.tscn")
	var info_dialog = dialog_scene.instance()
	var dialog = [
		'Pas d\'option pour l\'instant',
		'Va juste tester le jeu!']
	info_dialog.load_dialog(dialog)
	add_child(info_dialog)
	no_buttons()


func no_buttons():
	get_node("Info_button").hide()
	get_node("Settings_button").hide()
	get_node("Quit_button").hide()
	get_node("Play_button").hide()
	get_node("Play_button").set_disabled(true)

func _on_my_signal():
	# Fonction qui se lance en fin de dialog
	get_tree().change_scene("res://Scenes/Panels_scenes/Settings_Scene.tscn")


func _on_Test_button_pressed():
	get_tree().change_scene("res://test/Test_scene.tscn")


func _on_Quit_button_pressed():
	get_tree().quit()
