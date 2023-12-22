extends Node


enum GameState {IDLE, RUNNING, ENDED}

var game_state

@onready var pipe_spawner = $"../PipeSpawner" as PipeSpawner
@onready var bird = get_node("../Bird") as Bird
@onready var game_manager = $"."
@onready var fade = $"../Fade" as Fade
@onready var ui = $"../UI" as UI


var points = 0
var prev_point = 0

func _ready():
	game_state = GameState.IDLE	
	bird.game_started.connect(on_game_started)
	pipe_spawner.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(point_scored)
	pipe_spawner.check_if_point_increasedd.connect(check_if_point_increased)
	pipe_spawner.game_won.connect(game_won_screen)

func on_game_started():
	game_state = GameState.RUNNING
	pipe_spawner.start_spawning_pipes()

func end_game():
	if fade != null: 
		fade.play()
	bird.kill()
	pipe_spawner.stop();
	ui.on_game_over()

func point_scored():
	points += 1
	ui.update_points(points)
	ui.update_display()
	
func check_if_point_increased():
	if prev_point == points - 1:
		prev_point = points
		return
	else:
		end_game()
		
func game_won_screen():
	print("hi")
	if fade != null: 
		fade.play()
	bird.kill_won()
	pipe_spawner.stop();
	ui.on_game_win()
