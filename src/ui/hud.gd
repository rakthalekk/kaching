class_name HUD
extends Control

# Reference to the player. As a child of the player, this is assigned by the player's ready function
var player: Player

var last_active_heart = 5
var total_hearts = 5


func _ready():
	($Hearts/Heart6 as Heart).break_heart()
	($Hearts/Heart7 as Heart).break_heart()

var penny_timer : Timer
var dime_timer : Timer
var quarter_timer : Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_cooldown_bars():
	if penny_timer.is_stopped():
		$CooldownBars/PennyBar.visible = false
	else:
		$CooldownBars/PennyBar.visible = true
		$CooldownBars/PennyBar.value = (1 - penny_timer.time_left/penny_timer.wait_time) * 100
	
	if dime_timer.is_stopped():
		$CooldownBars/DimeBar.visible = false
	else:
		$CooldownBars/DimeBar.visible = true
		$CooldownBars/DimeBar.value = (1 - dime_timer.time_left/dime_timer.wait_time) * 100
	
	if quarter_timer.is_stopped():
		$CooldownBars/QuarterBar.visible = false
	else:
		$CooldownBars/QuarterBar.visible = true
		$CooldownBars/QuarterBar.value = (1 - quarter_timer.time_left/quarter_timer.wait_time) * 100


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
	if heart:
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
