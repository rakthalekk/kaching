class_name QuarterDisk
extends Attack

@export var friction = 0.0000000000001

func _physics_process(delta):
	check_bounce()
	speed -= friction * delta
	velocity = direction * speed
	
	# note: move_and_slide accepts a PRE-delta velocity, so no need to multiply it
	move_and_slide()


func _on_hitbox_body_entered(body):
	if body is Enemy:
		body.yowch(damage)
		
		body.take_dir_knockback(velocity.normalized(), knockback_force)

func destroy_self():
	$AnimationPlayer.play("fade before die")
	await $AnimationPlayer.animation_finished
	super()
