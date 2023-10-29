class_name Attack
extends CharacterBody2D

@export var speed: int
@export var damage: int
@export var knockback_force: int
@export var cost: int
@export var cooldown: float
@export var duration: float

var direction = Vector2.ZERO

@onready var active_timer = Timer.new()

func _ready():
	add_child(active_timer)
	active_timer.connect("timeout", destroy_self)
	active_timer.start(duration)


func move():
	# Move the bullet based on given direction and set speed
	velocity = direction * speed
	move_and_slide()


func set_direction(dir: Vector2):
	direction = dir


func destroy_self():
	queue_free()


func check_bounce():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			direction = direction.bounce(collision.get_normal())
			break
