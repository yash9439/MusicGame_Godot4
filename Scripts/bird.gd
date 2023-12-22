extends CharacterBody2D

class_name Bird

signal game_started

#@export var gravity = 900.0
#@export var jump_force: int = -300
@onready var animation_player = $AnimationPlayer

#var max_speed = 400
#var rotation_speed = 2
var speed = 400 + (MainMenu.Level-1)*10

var is_started = false
var should_process_input = true
var go_down = false
var alive = true

var was_mouse_down = false
var jump_mouse = false
var acceleration = 8

func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")
#	bird.bird_crashed.connect("stop_falling")

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and !was_mouse_down:
			jump_mouse = true
		if event.is_pressed():
			was_mouse_down = true
		else:
			was_mouse_down = false

func _physics_process(delta):
	var jump = Input.is_action_just_pressed("jump") || jump_mouse

	var mechanics = "ours"

	if should_process_input:
		if jump:
			jump_mouse = false
			if !is_started: 
				animation_player.play("flap_wings")
				game_started.emit()
				is_started = true
				velocity.y = speed
			else:
				if mechanics == "ours":
					if go_down == true:
						velocity.y = speed
						go_down = false
					else:
						if velocity.y < 0:
							velocity.y = speed
						else:
							velocity.y = -1 * speed

		if mechanics == "flappy_bird":
			if Input.is_action_pressed("jump") || was_mouse_down:
				velocity.y = -speed
			else:
				velocity.y = speed

	if !is_started:
		return
		
	if alive == false && velocity.y != 0:
		velocity.y += acceleration
		
#	velocity.y += gravity * delta

#	if velocity.y > max_speed:
#		velocity.y = max_speed
	
	move_and_collide(velocity * delta)
	
#	rotate_bird()
	
	
#func jump():
#	velocity.y = jump_force
#	rotation = deg_to_rad(-30)

#func rotate_bird():
#	# Rotate downwards when falling
#	if velocity.y > 0 and rad_to_deg(rotation) < 90:
#		rotation += rotation_speed * deg_to_rad(1)
#	# Rotate upwards when rising
#	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
#		rotation -= rotation_speed * deg_to_rad(1)


func kill():
	if alive == true:
		should_process_input = false
		alive = false
		print("hihi")
		velocity.y = -301
		velocity.x = 0
		
func kill_won():
	if alive == true:
		should_process_input = false
		alive = false

func stop():
#	animation_player.stop()
#	gravity = 0
	if alive == true:
		print("hi")
		alive = false
		velocity.y = -301
		velocity.x = 0
	
func upward_stop(should_go_up):
#	animation_player.stop()
#	gravity = 0
	if alive == true:
		if should_go_up == true:
			go_down = velocity.y<=0
			print("harshit  ", go_down, velocity.y)
		velocity = Vector2.ZERO

func _on_upper_area_body_entered(body):
	if alive == true:	
		print("hi harshit upper")
		go_down = velocity.y<0
		velocity = Vector2.ZERO
		print(velocity)
	else:
		velocity.y = 1


func _on_lower_area_body_entered(body):
	if alive == true:	
		print("hi harshit")
		go_down = velocity.y<0
		velocity = Vector2.ZERO
		print(velocity)
	else:
		velocity.y = 0
		animation_player.stop()
