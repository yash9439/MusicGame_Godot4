extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored
signal check_if_point_increasedd
signal game_won

@onready var bird = get_node("../Bird") as Bird

var pipe_pair_scene1 = preload("res://Scene/pipe_pair1.tscn")
var pipe_pair_scene2 = preload("res://Scene/pipe_pair2.tscn")
var pipe_pair_scene3 = preload("res://Scene/pipe_pair3.tscn")

var swaras = ['p', 'n', 'p', 'n', 'p', 'm', 'm', 'p', 'm', 'p', 'm', 'g']
var swara = ['s', 'r', 'g', 'm', 'p', 'd', 'n']
var n_pipes_on_screen = 0
var length = swaras.size()
var first = false
var black = load("res://Assets/blackImage.jpg")
var yellow = load("res://Assets/YellowishWhite.png")
var white_swaras = ['g', 'd', 'n']
var prev_notenum = -1

@export var pipe_speed = -250 - (MainMenu.Level-1)*10
@export var pipe_speed_y = 5
@onready var spawn_timer = $SpawnTimer

func _ready():
#	print("WOW")
	var my_name_list = MainMenu.text_list
	var my_swara_list = MainMenu.swaras_list
	swaras = my_swara_list
	length = swaras.size()
	MainMenu.n_swaras_pressed = 0
	spawn_timer.timeout.connect(spawn_pipe)
	
func start_spawning_pipes():
	spawn_timer.start()

func set_textures(pipe, textures):
	var collision_shapes = [
		pipe.get_node("TopPipe/CollisionShape2D"),
		pipe.get_node("BottomPipe/CollisionShape2D")
	]
	var sprites = [
		pipe.get_node("TopPipe/CollisionShape2D/Pipe-green"),
		pipe.get_node("BottomPipe/CollisionShape2D/Pipe-green2")
	]
	for i in range(2):
		var collision_extents = collision_shapes[i].shape.extents
		sprites[i].texture = textures[i]
		# Calculate the scale factors to resize the sprite to match the collision shape's size
		var texture_size = sprites[i].texture.get_size()
		sprites[i].scale = Vector2(
			collision_extents.x * 2.0 / texture_size.x,  # Scale factor for width
			collision_extents.y * 2.0 / texture_size.y   # Scale factor for height
		)

func decorate_pipe(pipe, swara1, swara2, correct_swara = ''):
	var textures=[]
	var font = load("res://Assets/font/music.ttf") as FontFile
	for label_data in [[swara1,Vector2(0,-100)], [swara2,Vector2(0,350)]]:
		textures.append(yellow if label_data[0] in white_swaras else black)
		if label_data[0] == ',':
			var flag_image = Sprite2D.new()
			flag_image.texture = load("res://Assets/finish.png")
			flag_image.scale = Vector2(0.2, 0.2)
			flag_image.set_position(label_data[1])
			flag_image.position.y += 50
			pipe.add_child(flag_image)
			continue
		var label = Label.new()
		label.text = label_data[0]
		label.set_position(label_data[1])
		label.position.x -= 15
		label.position.y += 20
		label.modulate = Color.BLACK if label_data[0] in white_swaras else Color.WHITE
		if label_data[0] == correct_swara:
			label.modulate = Color.GREEN
		# change font
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 80)
		pipe.add_child(label)

#	set_textures(pipe, textures)

func spawn_pipe():
	# spawn_pipe_old()
	# return
	if n_pipes_on_screen == length:
		return

	var correct_swara = swaras[n_pipes_on_screen]

	# choose two random swaras other than the correct swara
	var swara1 = correct_swara
	var swara2 = correct_swara

	while swara1 == correct_swara:
		swara1 = swara[randi_range(0, swara.size() - 1)]
	
	while swara2 == correct_swara or swara2 == swara1:
		swara2 = swara[randi_range(0, swara.size() - 1)]
	
	# choose a random pipe
	var choosen_pipe = randi_range(1, 3)

	# what is this?
	if first == false:
		first = true
		choosen_pipe = 1

	# instantiate the pipe
	var pipe
	if choosen_pipe == 1:
		pipe = pipe_pair_scene1.instantiate() as PipePair1
		decorate_pipe(pipe, swara1, swara2)
	elif choosen_pipe == 2:
		pipe = pipe_pair_scene2.instantiate() as PipePair2
		decorate_pipe(pipe, correct_swara, swara2, correct_swara)
		pipe.swara_name = n_pipes_on_screen
		n_pipes_on_screen += 1
	elif choosen_pipe == 3:
		pipe = pipe_pair_scene3.instantiate() as PipePair3
		decorate_pipe(pipe, swara1, correct_swara, correct_swara)
		pipe.swara_name = n_pipes_on_screen
		n_pipes_on_screen += 1
	
	add_child(pipe)

	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	var half_height = viewport_rect.size.y / 2
	pipe.position.x = viewport_rect.end.x
	pipe.position.y = viewport_rect.size.y*0.35 - half_height
	
	pipe.bird_entered_incorrect.connect(on_bird_entered_incorrect)
	pipe.bird_entered_correct.connect(on_bird_entered_correct)
	pipe.check_if_point_increased.connect(check_if_point_increased)
	pipe_speed_y = randi_range(0, MainMenu.Level)
	if MainMenu.Level > 26:
		pipe_speed_y = randi_range(0, 26)
	pipe.set_speed(pipe_speed, pipe_speed_y)
	
func on_bird_entered_incorrect():
	bird.upward_stop(false)
	bird_crashed.emit()
	stop()
	
func on_bird_entered_correct(swara_name, upper_or_lower, pipe):
	if bird.alive == true:
		if MainMenu.n_swaras_pressed < len(swaras):
			var curr_swara = swaras[MainMenu.n_swaras_pressed]
			var prev_swara = swaras[MainMenu.n_swaras_pressed-1]
			if swara_name == MainMenu.n_swaras_pressed:
				bird.upward_stop(true)
				if curr_swara == ',':
					# play sfx
					var audio := AudioStreamPlayer.new()
					add_child(audio)
					audio.stream = load("res://Assets/sfx/level-completed.mp3")
					audio.play()
				else:
					play_swara(curr_swara)
				MainMenu.n_swaras_pressed += 1
				point_scored.emit()
				if MainMenu.n_swaras_pressed == length:
					game_won.emit()
				if upper_or_lower == true:
					bird.position.y -= 20
					pipe.position.y -= 20
				elif upper_or_lower == false:
					bird.position.y += 20
					pipe.position.y += 20
			else:
				bird.upward_stop(false)

func stop():
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair1):
		(pipe as PipePair1).speed = 0
		(pipe as PipePair1).speed_y = 0
	for pipe in get_children().filter(func (child): return child is PipePair2):
		(pipe as PipePair2).speed = 0
		(pipe as PipePair2).speed_y = 0
	for pipe in get_children().filter(func (child): return child is PipePair3):
		(pipe as PipePair3).speed = 0
		(pipe as PipePair3).speed_y = 0

func check_if_point_increased():
	check_if_point_increasedd.emit()
	
func play_swara(swara):
	if swara == '*':
		return
	
	var notes = "sRrGgmMpDdNn"
	var octave = 4
	var notenum = notes.find(swara) + octave * 12
	# print("prev: ", prev_notenum, " curr: ", notenum)

	if prev_notenum == -1:
		prev_notenum = octave * 12
	
	var delta = notenum - prev_notenum
	if delta > 5:
		notenum -= 12
	elif delta < -5:
		notenum += 12

	# make sure we have the audio file for this note
	if notenum < 28:
		notenum += 12
	elif notenum > 63:
		notenum -= 12
	
	prev_notenum = notenum

	var audio := AudioStreamPlayer.new()
	add_child(audio)
	var note_id: String = str(notenum)
	audio.stream = load("res://Assets/piano/"+note_id+".mp3")
	audio.play()
