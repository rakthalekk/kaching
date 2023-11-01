extends Node2D

const ENEMY = preload("res://src/actors/enemy.tscn")

const OFFSCREEN_PLUSALITTLE = 175

var curr_enemy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(get_tree().get_first_node_in_group("player")):
		return
	if curr_enemy == null and (get_tree().get_first_node_in_group("player").position - position).length() > OFFSCREEN_PLUSALITTLE:
		curr_enemy = ENEMY.instantiate()
		curr_enemy.position = position
		get_parent().add_child(curr_enemy)
