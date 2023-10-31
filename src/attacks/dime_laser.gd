class_name DimeLaser
extends Attack


func _ready():
	super()
	
	$Pivot/LaserStart.play("default")
	$Pivot/Laser.play("default")
	$Pivot/Laser2.play("default")
	
	$AudioStreamPlayer2D.stream = load("res://assets/Audio/Dime Bullet/dime-lazer.ogg")
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_direction(dir: Vector2):
	await ready
	direction = dir
	%BeamShape.shape.b =  direction * speed
	
	$Pivot.rotation_degrees = rad_to_deg(atan2(dir.y, dir.x))


func _on_laser_hitbox_area_entered(area):
	if area is Hurtbox:
		var body = area.actor
		body.yowch(damage)
		body.take_dir_knockback(direction.normalized(), knockback_force)
