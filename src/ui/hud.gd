class_name HUD
extends Control

# Reference to the player. As a child of the player, this is assigned by the player's ready function
var player: Player

var last_active_heart = 5
var total_hearts = 5

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


func lose_heart():
	var heart = $Hearts.get_node("Heart" + str(last_active_heart)) as Heart
	heart.break_heart()
	last_active_heart -= 1


func gain_heart():
	if last_active_heart == total_hearts:
		return
	
	last_active_heart += 1
	var heart = $Hearts.get_node("Heart" + str(last_active_heart)) as Heart
	heart.regain_heart()


func upgrade_health():
	total_hearts += 1
	$Hearts.get_node("Heart" + str(total_hearts)).visible = true
	gain_heart()
