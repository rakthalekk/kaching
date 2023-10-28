class_name QuarterGrenade
extends CharacterBody2D

@export var attack_data: AttackData
@export var slow_distance := 50
@export var friction := 950

var direction: Vector2
var current_friction = friction
var goal_distance: int
var distance_traveled: int

var timeout = false
var begin_slow = false

func _ready():
	var mouse_pos = get_global_mouse_position()
	direction = global_position.direction_to(mouse_pos)
	velocity = direction * attack_data.speed
	
	goal_distance = global_position.distance_to(mouse_pos)
	
	if goal_distance < slow_distance:
		friction *= slow_distance * 1.0 / goal_distance


func _physics_process(delta):
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			direction = direction.bounce(collision.get_normal())
			velocity = velocity.length() * direction
			break
	
	if distance_traveled > goal_distance - slow_distance:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = direction * attack_data.speed
	
	# note: move_and_slide accepts a PRE-delta velocity, so no need to multiply it
	move_and_slide()
	
	distance_traveled += (velocity * delta).length()


func _on_timer_timeout():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	$ExplosionRadius/CollisionShape2D.disabled = false
	$ExplosionRadius.visible = true
	$ExplosionRadius/ExplosionTimer.start()


func _on_explosion_timer_timeout():
	queue_free()


func _on_explosion_radius_body_entered(body):
	if body is Enemy:
		body.yowch(attack_data.damage)
		body.take_knockback(global_position, attack_data.knockback_force)
