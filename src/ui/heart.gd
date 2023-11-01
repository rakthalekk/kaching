class_name Heart
extends Sprite2D


func break_heart():
	$AnimationPlayer.play("break")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("empty")



func regain_heart():
	$AnimationPlayer.play("full")
