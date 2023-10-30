class_name HUD
extends Control

# Reference to the player. As a child of the player, this is assigned by the player's ready function
var player: Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_coins():
	$Coins/Pennies.text = str(player.pennies)
	$Coins/Nickels.text = str(player.nickels)
	$Coins/Dimes.text = str(player.dimes)
	$Coins/Quarters.text = str(player.quarters)


func update_dollar_fragments():
	$Dollars/DollarFragments.text = "Dollar Fragments: %d" % player.dollar_fragments
	$Dollars/Dollars.text = "Dollars: %d" % player.dollars
