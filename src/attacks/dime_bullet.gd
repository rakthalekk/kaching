class_name DimeBullet
extends Attack

var enemies_hit = 0

func _ready():
	super()
	$AudioStreamPlayer2D.stream = load("res://assets/Audio/Dime Bullet/dime-start.ogg")
	$AudioStreamPlayer2D.play()

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

func check_bounce():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			direction = direction.bounce(collision.get_normal())
			$AudioStreamPlayer2D.stream = load("res://assets/Audio/Dime Bullet/dime-plink-%d.ogg" % randi_range(1, 4))
			$AudioStreamPlayer2D.play()
			break
