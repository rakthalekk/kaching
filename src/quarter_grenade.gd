class_name QuarterGrenade
extends Attack

@export var slow_distance := 50
@export var friction := 950

# 300, 20, 400, 1, 3, 1

var current_friction = friction
var goal_distance: int
var distance_traveled: int

var timeout = false
var begin_slow = false


func _ready():
	var mouse_pos = get_global_mouse_position()
	direction = global_position.direction_to(mouse_pos)
	velocity = direction * speed
	
	goal_distance = global_position.distance_to(mouse_pos)
	
	if goal_distance < slow_distance:
		friction *= slow_distance * 1.0 / goal_distance
	
	super()


func set_direction(dir: Vector2):
	pass


func _physics_process(delta):
	check_bounce()
	
	if distance_traveled > goal_distance - slow_distance:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = direction * speed
	
	# note: move_and_slide accepts a PRE-delta velocity, so no need to multiply it
	move_and_slide()
	
	distance_traveled += (velocity * delta).length()


func destroy_self():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	$ExplosionRadius/CollisionShape2D.disabled = false
	$ExplosionRadius.visible = true
	$ExplosionRadius/ExplosionTimer.start()
	await $ExplosionRadius/ExplosionTimer.timeout
	super()


func _on_explosion_radius_area_entered(area):
	if area is Hurtbox:
		var body = area.actor
		body.yowch(damage)
		body.take_knockback(global_position, knockback_force)
