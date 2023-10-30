class_name VendingMenu
extends Control

var selected_button : ModButton
var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent() as Player
	selected_button = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a button that holds information of the modification
func add_mod(mod):
	var modification_button = preload("res://src/ui/modification_button.tscn").instantiate()
	modification_button.modification = mod
	%ButtonContainer.add_child(modification_button)
	
func update_mod_info(button, mod):
	selected_button = button
	%ModName.text = mod.name
	%ModType.text = mod.type
	%ModificationImage.texture = mod.texture
	%Cost.text = "Cost: $" + mod.cost
	%ModInfo.text = mod.description



func _on_purchase_button_pressed():
	if selected_button == null:
		return
	if player.dollars < selected_button.modification.cost:
		# Maybe make some kind of invalid purchase type beat here
		return
	player.dollars -= ceil(selected_button.modification.cost)
	var change = ceil(selected_button.modification.cost) - selected_button.modification.cost
	# give player the selected modification here and change
	return_coins(change)
	selected_button.disabled = true

func return_coins(change: int):
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


func _on_exit_button_pressed():
	get_tree().paused = false
	queue_free()
