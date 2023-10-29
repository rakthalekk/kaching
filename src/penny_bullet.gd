class_name PennyBullet
extends Attack

var frames_since_init = 0

@onready var raycast = $Raycast as RayCast2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collider = raycast.get_collider()
	if raycast.is_colliding():
		$Line2D.add_point(to_local(raycast.get_collision_point()))
		raycast.enabled = false
		if collider is Hurtbox:
			var enemy = collider.actor
			enemy.yowch(damage)
			enemy.take_knockback(raycast.get_collision_point(), knockback_force)
	elif raycast.enabled && frames_since_init > 3:
		$Line2D.add_point(raycast.target_position)
		raycast.enabled = false
	
	frames_since_init += 1


func set_direction(dir: Vector2):
	await ready
	direction = dir
	raycast.target_position = direction * speed

