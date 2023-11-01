class_name QuarterGrenade
extends Attack

@export var slow_distance := 50
@export var friction := 950

var current_friction = friction
var goal_distance: int
var distance_traveled: int

var timeout = false
var begin_slow = false


func _ready():
	var mouse_pos = get_global_mouse_position()
	direction = global_position.direction_to(mouse_pos)
	velocity = direction * (speed + speed_modifier)
	
	goal_distance = global_position.distance_to(mouse_pos)
	
	if goal_distance < slow_distance:
		friction *= slow_distance * 1.0 / goal_distance
	
	super()


func activate_timer():
	await ready
	active_timer.start(duration)


func set_direction(dir: Vector2):
	pass


func _physics_process(delta):
	check_bounce()
	
	if distance_traveled > goal_distance - slow_distance:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = direction * (speed + speed_modifier)
	
	# note: move_and_slide accepts a PRE-delta velocity, so no need to multiply it
	move_and_slide()
	
	distance_traveled += (velocity * delta).length()


func destroy_self():
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	$ExplosionRadius/CollisionShape2D.disabled = false
	$ExplosionRadius.visible = true
	$Sprite2D.hide()
	$ExplosionRadius/ExplosionTimer.start(0.5 + duration_modifier)
	
	$ExplosionRadius/Sprite2D.play("default")
	$Boom.play()
	
	await $ExplosionRadius/ExplosionTimer.timeout
	
	$ExplosionRadius/CollisionShape2D.disabled = true
	
	await $Boom.finished
	
	super()


func _on_explosion_radius_area_entered(area):
	if area is Hurtbox:
		var body = area.actor
		body.yowch(damage + damage_modifier)
		body.take_knockback(global_position, knockback_force + knockback_modifier)
