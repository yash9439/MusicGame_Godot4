extends CanvasLayer

class_name UI

@onready var points_label = $MarginContainer/PointsLabel
@onready var resume_game_button = $MarginContainer/GameOverBox/Panel/MarginContainer/RestartButton
@onready var floatingName = $Label
@onready var floatingSwara = $Label2
@onready var floatingBar = $ProgressBar 
@onready var game_over_box = $MarginContainer/GameOverBox
@onready var game_over_box2 = $MarginContainer/GameOverBox2

@onready var PanelPause : Panel = $%Panel
@onready var PanelInstruction : Panel = $%Panel2
@onready var contentPause : VBoxContainer = $%Content
@onready var contentInstruction : VBoxContainer = $%Content2

func _ready():
	PanelPause.hide()
	contentPause.hide()
	contentInstruction.hide()
	points_label.text = "%d" % 0
	update_display()

func update_points(points: int):
	points_label.text = "%d" % points

func on_game_over():
	game_over_box.visible = true
	resume_game_button.grab_focus()

func on_game_win():
	MainMenu.Level += 1
	$MarginContainer/GameOverBox2/Panel/MarginContainer/Button2.text = "Level : " + str(MainMenu.Level) 
	game_over_box2.visible = true


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_button_pressed():
	if get_tree().paused:
		PanelPause.hide()
		contentPause.hide()
		get_tree().paused = false
	PanelPause.show()
	contentPause.show()
	get_tree().paused = true
#	PauseMenu.open_pause_menu()
	pass # Replace with function body.
	
func _input(event):
	if event.as_text() == "Enter":
		_on_button_pressed()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
	pass # Replace with function body.



func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.
 

func _on_back_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://addons/EasyMenus/Nodes/menu_template_manager.tscn")
	pass # Replace with function body.


func _on_resume_game_button_pressed():
	get_tree().paused = false
	PanelPause.hide()
	contentPause.hide()
	pass # Replace with function body.


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/options_menu.tscn")
	pass # Replace with function body.

func _on_button_3_pressed():
	get_tree().quit()

func update_display():
	"""
	examples:
	name = soham yash harshit
	swaras = sgm,ss,grsd.
	
	display names and swaras only for current and next name
	"""
	var names = MainMenu.text_list
	var swaras = MainMenu.swaras_list
	var k = MainMenu.n_swaras_pressed

	print(k)
	
	# names = ["soham", "yash", "harshit"]
	# swaras = ["s","g","m",",","s","s",",","g","r","s","d",","]

	# remove old swaras and names till "," is found
	var names_done = 0
	var last_comma = 0
	for i in range(k):
		if swaras[i] == ",":
			names_done += 1
			last_comma = i+1
	names = names.slice(names_done)
	swaras = swaras.slice(last_comma)
	k-=last_comma

	# keep only current and next name
	names = names.slice(0, 2)
	var comma_count = 0
	for i in range(1,len(swaras)):
		if swaras[i] == ",":
			swaras[i] = " "
			comma_count += 1
		if comma_count == 2:
			swaras = swaras.slice(0, i)
			break
		
			
	var bbcode = ""
	# pressed swaras
	for i in range(k):
		bbcode += "[color=orange]" + swaras[i] + "[/color]"
	# next swara
	if k<len(swaras):
		bbcode += "[color=green]" + swaras[k] + "[/color]"
	# remaining swaras
	for i in range(k+1, len(swaras)):
		bbcode += "[color=black]" + swaras[i] + "[/color]"

	var n_names_left = len(MainMenu.text_list)-names_done-2
	if n_names_left > 0:
		bbcode += " ...%d" % n_names_left
		
	bbcode = "[b]"+bbcode+"[/b]"
	# print("%d" % k)
	# print(" ".join(names))
	# print(" ".join(swaras))
	# print(bbcode)

	floatingSwara.text = bbcode
	floatingName.text = "[b]" + " ".join(names) + "[/b]"
	floatingBar.value = 100*MainMenu.n_swaras_pressed/len(MainMenu.swaras_list)


func _on_quit_button_2_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main2.tscn")
	pass # Replace with function body.


func _on_quit_button_3_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/options_menu.tscn")
	pass # Replace with function body.


func _on_button_new_pressed():
#	if get_tree().paused:
#		PanelInstruction.hide()
#		contentInstruction.hide()
#		get_tree().paused = false
	PanelInstruction.show()
	contentInstruction.show()
	get_tree().paused = true
#	PauseMenu.open_pause_menu()
	pass


func _on_button_back_pressed():
	PanelInstruction.hide()
	contentInstruction.hide()
	get_tree().paused = false
	pass
