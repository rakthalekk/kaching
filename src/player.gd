class_name Player
extends CharacterBody2D

var direction: Vector2

@export var speed = 500

# at 10 coins for now for testing purposes
var coins := 10

var bullet = preload("res://src/bullet.tscn")

func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	# Calculates velocity and applies it to player
	velocity = direction * speed
	move_and_slide()


func add_coin():
	coins += 1
	print(coins)

func _process(delta):
	# Checks if we have clicked and if we got coins
	if Input.is_action_just_pressed("click") and coins > 0:
		coins -= 1
		var shoot_vector = get_global_mouse_position() - position
		var to_shoot = bullet.instantiate()
		to_shoot.direction = shoot_vector.normalized()
		to_shoot.position = self.position
		get_parent().add_child(to_shoot)
	pass

