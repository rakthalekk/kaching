class_name Actor
extends CharacterBody2D

@export var speed = 100
@export var max_health = 3
@export var knockback_friction = 400

var knockback = false

# Current direction of the player
var direction: Vector2
var knockback_velocity: Vector2

@onready var health = max_health
@onready var invuln_timer = Timer.new()
@onready var hurtbox = get_node("Hurtbox") as Hurtbox

var dead = false


func _ready():
	add_child(invuln_timer)
	invuln_timer.one_shot = true
	invuln_timer.connect("timeout", reenable_hurtbox)


func yowch(damage: int, iframe_time = 0.1):
	health -= damage
	if health <= 0:
		die()
	
	invuln_timer.start(0.1)
	disable_hurtbox()


func handle_movement(delta):
	if knockback_velocity.length() < 100:
		# Calculates velocity and applies it
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	if knockback:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * knockback_friction)
		if knockback_velocity.length() <= 0:
			knockback = false
	
	move_and_slide()


func die():
	queue_free()


func reenable_hurtbox():
	hurtbox.set_deferred("monitorable", true)
	hurtbox.set_deferred("monitoring", true)


func disable_hurtbox():
	hurtbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)


func take_knockback(origin: Vector2, knockback_force: int):
	knockback = true
	var kb_direction = (global_position - origin).normalized()
	knockback_velocity = kb_direction * knockback_force
	velocity = knockback_velocity


func take_dir_knockback(dir: Vector2, force: int):
	knockback = true
	knockback_velocity = dir * force
	velocity = knockback_velocity
