extends Node2D

class_name PipePair3

var speed = 0
var speed_y = 0
var swara_name = ','

signal bird_entered_correct
signal bird_entered_incorrect
signal check_if_point_increased

@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe

func set_speed(new_speed, new_speed_y):
	speed = new_speed
	speed_y = new_speed_y
	
func _process(delta):
	position.x += speed * delta
	top_pipe.position.y += speed_y * delta
	bottom_pipe.position.y -= speed_y * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_top_pipe_body_entered(body):
	bird_entered_incorrect.emit()


func _on_bottom_pipe_body_entered(body):
	bird_entered_correct.emit(swara_name, false, bottom_pipe)


func _on_check_if_swara_pressed_body_entered(body):
	check_if_point_increased.emit()
