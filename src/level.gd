extends Node2D

@onready var player = $Player
@onready var follow_camera = $FollowCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	follow_camera.position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		follow_camera.position = lerp(follow_camera.position, player.position, delta * 5)


func _on_win_area_body_entered(body):
	if body is Player:
		body.win()
