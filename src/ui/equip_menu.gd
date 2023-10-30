class_name EquipMenu
extends Control


# Reference to the player. As a child of the player, this is assigned by the player's ready function
var player: Player

const MOD_TILE = preload("res://src/ui/equip_mod_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_test_button_pressed():
	print("pass") # Replace with function body.


func populate_player_data():
	# get the ammo counts from player
	%PennyCount.text = str(player.pennies)
	%NickelCount.text = str(player.nickels)
	%DimeCount.text = str(player.dimes)
	%QuarterCount.text = str(player.quarters)
	
	# get mod data from player "inventory"
	#
	#for mod in player.get_mods_or_something():
	#	var mods = preload("res://src/equip_mod_tile.tscn")
	#	%PennyModList.add_child(mods)
	pass
