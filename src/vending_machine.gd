extends StaticBody2D

var player_in_range = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range && Input.is_action_just_pressed("interact"):
		# Go into menu scene
		print("amonguss")




func _on_interactable_area_body_entered(body):
	if body is Player:
		player_in_range = true
		



func _on_interactable_area_body_exited(body):
	if body is Player:
		player_in_range = false


# idk how to grab player, this could just be a function in player but how would I call it
func return_coins(player: Player, change: int):
	# First chdck for how many quarters to give out
	while change >= 70:
		# Add quarter to player
		player.quarters += 1
		change -= 25
	while change >= 35:
		player.dimes += 1
		change -= 10
	if change >= 25:
		player.nickels += 1
		change -= 5
	while change > 0:
		player.pennies += 1
		change -= 1
