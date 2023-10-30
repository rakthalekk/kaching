class_name PennyShotgun
extends Attack


func set_direction(dir: Vector2):
	$PennyBullet.speed = speed
	$PennyBullet2.speed = speed
	$PennyBullet3.speed = speed
	$PennyBullet4.speed = speed
	$PennyBullet5.speed = speed
	$PennyBullet.set_direction(dir.rotated(deg_to_rad(randf_range(-10, 10))))
	$PennyBullet2.set_direction(dir.rotated(deg_to_rad(randf_range(-10, 10))))
	$PennyBullet3.set_direction(dir.rotated(deg_to_rad(randf_range(-10, 10))))
	$PennyBullet4.set_direction(dir.rotated(deg_to_rad(randf_range(-10, 10))))
	$PennyBullet5.set_direction(dir.rotated(deg_to_rad(randf_range(-10, 10))))

