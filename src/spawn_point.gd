extends Node2D

const ENEMY = preload("res://src/actors/enemy.tscn")

const OFFSCREEN_PLUSALITTLE = 175
const OFFSCREEN_PLUSSOMEMORE = 275

var curr_enemy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(get_tree().get_first_node_in_group("player")):
		return
	var player := get_tree().get_first_node_in_group("player") as Player
	var player_pos = player.position
	if curr_enemy == null and (player_pos - position).length() > OFFSCREEN_PLUSALITTLE and (player_pos - position).length() < OFFSCREEN_PLUSSOMEMORE:
		curr_enemy = ENEMY.instantiate()
		curr_enemy.position = position
		get_parent().add_child(curr_enemy)
	if curr_enemy != null and (player_pos - curr_enemy.position).length() >= OFFSCREEN_PLUSSOMEMORE:
		curr_enemy.queue_free()
