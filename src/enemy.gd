class_name Enemy
extends Actor

var chase = false
var player = null

var anim_suffix = ""

@export var damage := 1
@export var knockback_force := 200

@export var cheeked_up : Texture

@onready var hurtbox = $Hurtbox as Hurtbox

# Reference to penny bullet instance that player can instantiate
const DOLLAR_FRAGMENT = preload("res://src/dollar_fragment.tscn")


func _ready():
	if randf() < 0.1:
		$Sprite.texture = cheeked_up
	
	hurtbox.actor = self


func _physics_process(delta):
	if chase && !dead:
		direction = (player.position - position).normalized()
	else:
		direction = Vector2.ZERO
	
	if direction.x > 0:
		$Sprite.flip_h = true
	elif direction.x < 0:
		$Sprite.flip_h = false
	
	if direction.y > 0:
		anim_suffix = ""
	elif direction.y < 0:
		anim_suffix = "_back"
	
	if dead:
		$AnimationPlayer.play("die" + anim_suffix)
	elif knockback:
		$AnimationPlayer.play("hurt" + anim_suffix)
	else:
		$AnimationPlayer.play("run" + anim_suffix)
	
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


func _on_hitbox_area_entered(area):
	if area is Hurtbox and !knockback:
		var body = area.actor
		body.yowch(damage)
		body.take_knockback(global_position, knockback_force)
