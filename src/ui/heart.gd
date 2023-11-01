class_name Heart
extends Sprite2D

@onready var anim_player = $AnimationPlayer

func break_heart():
	anim_player.play("break")
	await anim_player.animation_finished
	
	if anim_player.current_animation == "break":
		anim_player.play("empty")


func regain_heart():
	anim_player.play("full")


func get_anim_player() -> AnimationPlayer:
	return anim_player
