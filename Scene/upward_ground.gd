extends Node2D

class_name upper_ground

signal bird_on_top

var speed = -150
var swaras = ['p', 'n', 'p', 'n', 'p', 'm', 'm', 'p', 'm', 'p', 'm', 'g']

#var lower_ground_scene = preload("res://Scene/ground.tscn")

@onready var sprite1 = $ground1/Sprite2D
@onready var sprite2 = $ground2/Sprite2D
@onready var ground = $"../Ground"

func _ready():
	sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()
	ground.bird_crashed.connect(_on_bird_crash)

func _process(delta):
	sprite1.global_position.x += speed * delta
	sprite2.global_position.x += speed * delta
	
	# If Sprite1 has completely left the screen, move it to the right of Sprite2
	if sprite1.global_position.x < -sprite1.texture.get_width():
		sprite1.global_position.x = sprite2.global_position.x + sprite2.texture.get_width()

	# If Sprite2 has completely left the screen, move it to the right of Sprite1
	if sprite2.global_position.x < -sprite2.texture.get_width():
		sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func _on_ground_1_body_entered(body):
	bird_on_top.emit()
	(body as Bird).upward_stop()

func stop():
	speed = 0

func _on_bird_crash():
	speed = 0
