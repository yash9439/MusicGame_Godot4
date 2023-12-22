extends Control
#signal start_game_pressed

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: Control = $%OptionsMenu
@onready var content: VBoxContainer = $%CanvasLayer

func _ready():
	start_game_button.grab_focus()
	content.show()
	options_menu.hide()
	pass


func quit():
	get_tree().quit()
	pass

func open_options():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/options_menu.tscn")
#	content.hide()
#	options_menu.show()
#	options_menu.on_open()
	pass

func close_options():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
	content.show()
	start_game_button.grab_focus()
	options_menu.hide()
	pass


func _on_start_game_button_pressed():
	content.hide()
	get_tree().change_scene_to_file("res://main2.tscn")
#	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
	pass

