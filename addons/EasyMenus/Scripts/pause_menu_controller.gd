extends Control
signal resume
signal back_to_main_pressed

@onready var contentPause : VBoxContainer = $%Content
@onready var options_menu : Control = $%OptionsMenu
@onready var resume_game_button: Button = $%ResumeGameButton
	
func open_pause_menu():
	#Stops game and shows pause menu
	get_tree().paused = true
	contentPause.show()
	resume_game_button.grab_focus()

func close_pause_menu():
	get_tree().paused = false
	contentPause.hide()
	emit_signal("resume")

func _on_resume_game_button_pressed():
	close_pause_menu()


func _on_options_button_pressed():
	contentPause.hide()
	options_menu.show()
	options_menu.on_open()


func _on_options_menu_close():
	options_menu.hide()
	contentPause.show()
	resume_game_button.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_to_menu_button_pressed():
	close_pause_menu()
	get_tree().paused = false
#	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
	emit_signal("back_to_main_pressed")

#
#func _input(event):
#	if (event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")):
#		accept_event()
#		close_pause_menu()


func _on_quit_button_2_pressed():
	get_tree().change_scene_to_file("res://main2.tscn")
	pass # Replace with function body.
