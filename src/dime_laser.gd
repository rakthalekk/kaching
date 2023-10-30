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
