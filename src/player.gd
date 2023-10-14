class_name Player
extends CharacterBody2D

var direction: Vector2

@export var speed = 500

var coins := 0

func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	# Calculates velocity and applies it to player
	velocity = direction * speed
	move_and_slide()


func add_coin():
	coins += 1
	print(coins)
