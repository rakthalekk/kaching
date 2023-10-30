class_name DimeLaser
extends Attack

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_direction(dir: Vector2):
	await ready
	direction = dir
	$Line2D.add_point(direction * speed)
	%BeamShape.shape.b =  direction * speed
	
	


func _on_laser_hitbox_area_entered(area):
	if area is Hurtbox:
		var body = area.actor
		body.yowch(damage)
		body.take_dir_knockback(direction.normalized(), knockback_force)
