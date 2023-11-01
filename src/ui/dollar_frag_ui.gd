class_name DollarFragUI
extends Sprite2D

@onready var anim_player = $AnimationPlayer

func collect_fragment():
	anim_player.play("remove_bill")

func complete_bill():
	anim_player.play("remove_bill")
	await anim_player.animation_finished
	
	if anim_player.current_animation == "remove_bill":
		anim_player.play("RESET")



func get_anim_player() -> AnimationPlayer:
	return anim_player
