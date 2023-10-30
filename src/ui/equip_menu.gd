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
	for mod in %PennyModList.get_children():
		%PennyModList.remove_child(mod)
		mod.queue_free()
	
	for mod in %NickelModList.get_children():
		%NickelModList.remove_child(mod)
		mod.queue_free()
	
	for mod in %DimeModList.get_children():
		%DimeModList.remove_child(mod)
		mod.queue_free()
	
	for mod in %QuarterModList.get_children():
		%QuarterModList.remove_child(mod)
		mod.queue_free()
	
	# get the ammo counts from player
	%PennyCount.text = str(player.pennies)
	%NickelCount.text = str(player.nickels)
	%DimeCount.text = str(player.dimes)
	%QuarterCount.text = str(player.quarters)
	
	%HealthBar.value = player.health * 100.0 / player.max_health
	
	# get mod data from player "inventory"
	
	for mod in player.modifications:
		if mod is AttackModification:
			if mod.coin_type == Modification.COIN_TYPE.PENNY:
				%PennyModList.add_child(create_mod_tile(mod))
			elif mod.coin_type == Modification.COIN_TYPE.NICKEL:
				%NickelModList.add_child(create_mod_tile(mod))
			elif mod.coin_type == Modification.COIN_TYPE.DIME:
				%DimeModList.add_child(create_mod_tile(mod))
			elif mod.coin_type == Modification.COIN_TYPE.QUARTER:
				%QuarterModList.add_child(create_mod_tile(mod))


func create_mod_tile(mod: Modification) -> EquipModTile:
	var mod_tile = MOD_TILE.instantiate() as EquipModTile
	mod_tile.populate_mod(mod)
	return mod_tile
