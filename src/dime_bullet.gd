class_name DimeBullet
extends CharacterBody2D

@export var speed = 300
@export var damage := 5

var direction: Vector2

var enemies_hit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			direction = direction.bounce(collision.get_normal())
			break
	
	# Move the bullet based on given direction and set speed
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout():
	queue_free()


func _on_hitbox_body_entered(body):
	if body is Enemy:
		body.yowch(3)
		enemies_hit += 1
	
	if enemies_hit == 3:
		queue_free()
