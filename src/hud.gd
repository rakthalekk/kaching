class_name HUD
extends Control

# Reference to the player. As a child of the player, this is assigned by the player's ready function
var player: Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins():
	$Coins/Pennies.text = "P: %d" % player.pennies
	$Coins/Nickels.text = "N: %d" % player.nickels
	$Coins/Dimes.text = "D: %d" % player.dimes
	$Coins/Quarters.text = "Q: %d" % player.quarters


func update_dollar_fragments():
	$Coins/DollarFragments.text = "Dollar Fragments: %d" % player.dollar_fragments
