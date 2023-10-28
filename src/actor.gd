class_name Actor
extends CharacterBody2D

@export var speed = 100

@export var max_health = 3

var knockback = false

# Current direction of the player
var direction: Vector2

@onready var health = max_health

var dead = false

func yowch(damage: int):
	health -= damage
	if health <= 0:
		die()


func die():
	queue_free()


func backknock(body: Actor):
	knockback = true
	direction = (global_position - body.global_position).normalized()
	velocity = direction * speed
