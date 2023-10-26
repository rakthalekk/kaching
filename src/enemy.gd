class_name Enemy
extends Actor

var chase = false
var player = null


func _physics_process(delta):
	if chase && !dead:
		direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_detection_body_entered(body):
	if body is Player:
		player = body
		chase = true
		
func die():
	$AnimationPlayer.play("die")
	dead = true
	await $AnimationPlayer.animation_finished
	super()

func _on_detection_body_exited(body):
	player = null
	chase = false


func _on_hitbox_body_entered(body):
	if body is Player:
		body.yowch(1)
