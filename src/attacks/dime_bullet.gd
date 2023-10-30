class_name DimeBullet
extends Attack

var enemies_hit = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	check_bounce()
	move()


func _on_hitbox_area_entered(area):
	if area is Hurtbox:
		var body = area.actor
		body.yowch(damage + damage_modifier)
		body.take_knockback(global_position, knockback_force + knockback_modifier)
		enemies_hit += 1
	
	if enemies_hit == 3:
		queue_free()
