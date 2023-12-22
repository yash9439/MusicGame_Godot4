extends Node2D

class_name PipePair1

var speed = 0
var speed_y = 0

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

func _on_body_entered(body):
	bird_entered_incorrect.emit()
