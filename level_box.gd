@tool
extends PanelContainer

signal level_selected

@export var locked = true:
	set = set_locked
@export var level_num = 1:
	set = set_level

@onready var lock = $MarginContainer/Lock
@onready var label = $Label
	
func set_locked(value):
	locked = value
	if not is_inside_tree():
		await ready
	lock.visible = value
	label.visible = not value

func set_level(value):
	level_num = value
	if not is_inside_tree():
		await ready
	label.text = str(level_num)


func _on_gui_input(event):
	if locked:
		return
	if event is InputEventMouseButton and event.pressed:
		level_selected.emit(level_num)
		MainMenu.Level = level_num 
		print("Clicked level ", level_num)
		get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")



func _on_mouse_entered():
	modulate = Color(0.8, 0.8, 0.8) 
	pass # Replace with function body.


func _on_mouse_exited():
	modulate = Color(1, 1, 1)
	pass # Replace with function body.

