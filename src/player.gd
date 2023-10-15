class_name Player
extends CharacterBody2D

var direction: Vector2

@export var speed = 300

# at 10 coins for now for testing purposes
var pennies := 10
var nickels := 0
var dimes := 0
var quarters := 0

var bullet = preload("res://src/bullet.tscn")

@onready var hud = $UI/HUD as HUD

func _ready():
	hud.player = self
	hud.update_coins()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	# Calculates velocity and applies it to player
	velocity = direction * speed
	move_and_slide()


func add_coin():
	pennies += 1
	hud.update_coins()


func _process(delta):
	# Checks if we have clicked and if we got coins
	if Input.is_action_pressed("click") and pennies > 0 and $ShootCooldown.time_left == 0:
		pennies -= 1
		hud.update_coins()
		var shoot_vector = get_global_mouse_position() - position
		var to_shoot = bullet.instantiate()
		to_shoot.direction = shoot_vector.normalized()
		to_shoot.position = self.position
		get_parent().add_child(to_shoot)
		$ShootCooldown.start()

