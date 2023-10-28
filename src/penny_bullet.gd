class_name PennyBullet
extends RayCast2D


@export var attack_data: AttackData

var direction = Vector2.ZERO

var frames_since_init = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collider = get_collider()
	if is_colliding():
		$Line2D.add_point(to_local(get_collision_point()))
		enabled = false
		if collider is Enemy:
			collider.yowch(attack_data.damage)
			collider.take_knockback(get_collision_point(), attack_data.knockback_force)
	elif enabled && frames_since_init > 3:
		print("no hit")
		$Line2D.add_point(target_position)
		enabled = false
	
	frames_since_init += 1


func set_direction(dir: Vector2):
	direction = dir
	target_position = direction * attack_data.speed


func _on_fade_timer_timeout():
	queue_free()

