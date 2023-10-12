extends CharacterBody2D

var direction: Vector2

@export var speed = 500

func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	# Calculates velocity and applies it to player
	velocity = direction * speed
	move_and_slide()
