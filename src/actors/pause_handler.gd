extends Node


# Reference to the HUD
@onready var hud = get_parent().get_node("UI/HUD") as HUD
@onready var equip_menu = get_parent().get_node("UI/EquipMenu") as EquipMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("equip_menu"):
		equip_menu.visible = !equip_menu.visible
		hud.visible = !hud.visible
		get_tree().paused = !get_tree().paused
		equip_menu.populate_player_data()
