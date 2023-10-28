class_name Enemy
extends Actor

var chase = false
var player = null

@export var damage := 1
@export var knockback_force := 200


# Reference to penny bullet instance that player can instantiate
const DOLLAR_FRAGMENT = preload("res://src/dollar_fragment.tscn")

func _physics_process(delta):
	if chase && !dead:
		direction = (player.position - position).normalized()
	else:
		direction = Vector2.ZERO
	
	handle_movement(delta)


func _on_detection_body_entered(body):
	if body is Player:
		player = body
		chase = true


func die():
	if !dead:
		$AnimationPlayer.play("die")
		dead = true
		await $AnimationPlayer.animation_finished
		
		var dollar = DOLLAR_FRAGMENT.instantiate()
		dollar.global_position = global_position
		get_parent().add_child(dollar)
		
		super()


func _on_detection_body_exited(body):
	player = null
	chase = false


func _on_hitbox_body_entered(body):
	if body is Player and !knockback:
		body.yowch(damage)
		body.take_knockback(global_position, knockback_force)
