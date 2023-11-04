extends Node2D

const ENEMY = preload("res://src/actors/enemy.tscn")

const OFFSCREEN_PLUSALITTLE = 200
const OFFSCREEN_PLUSSOMEMORE = 300

var curr_enemy = null

@onready var respawn_timer = $RespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(get_tree().get_first_node_in_group("player")):
		return
	var player := get_tree().get_first_node_in_group("player") as Player
	var player_pos = player.global_position
	if respawn_timer.is_stopped() && curr_enemy == null and (player_pos - global_position).length() > OFFSCREEN_PLUSALITTLE and (player_pos - global_position).length() < OFFSCREEN_PLUSSOMEMORE:
		curr_enemy = ENEMY.instantiate()
		curr_enemy.global_position = global_position
		get_parent().add_child(curr_enemy)
		respawn_timer.start()
	if curr_enemy != null and (player_pos - curr_enemy.global_position).length() >= OFFSCREEN_PLUSSOMEMORE:
		curr_enemy.queue_free()
