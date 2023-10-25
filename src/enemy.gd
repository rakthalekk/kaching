class_name Enemy
extends CharacterBody2D

var speed = 40 #Higher = slower
var chase = false
var player = null

func _physics_process(delta):
	if chase:
		position += (player.position - position)/speed

func _on_detection_body_entered(body):
	if body is Player:
		player = body
		chase = true

#func _on_detection_body_exited(body):
	#player = null
	#chase = false
