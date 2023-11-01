class_name VendingMenu
extends Control

var selected_button : ModButton
var player : Player
var machine : VendingMachine


const MODIFICATION_BUTTON = preload("res://src/ui/modification_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	selected_button = null
	Global.vending_menu_open = true


func populate_mods(vending_machine: VendingMachine):
	var any_available = false
	machine = vending_machine
	for mod in machine.modifications:
		var mod_button = add_mod(ModificationDatabase.get_modification_by_name(mod))
		if !machine.mod_availability[mod]:
			mod_button.disable()
		else:
			any_available = true
	
	%ModName.text = ""
	%ModCost.text = ""
	%ModType.text = ""
	%ModInfo.text = "Select a modification to purchase." if any_available else "OUT OF STOCK"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a button that holds information of the modification
func add_mod(mod) -> ModButton:
	var modification_button = MODIFICATION_BUTTON.instantiate() as ModButton
	modification_button.menu = self
	modification_button.set_mod(mod)
	%ButtonContainer.add_child(modification_button)
	return modification_button


func update_mod_info(button: ModButton):
	var mod = button.modification as Modification
	selected_button = button
	%ModName.text = mod.display_name
	
	if mod is CoinModification:
		%ModType.text = Modification.COIN_TYPE.keys()[mod.coin_type]
	else:
		%ModType.text = "PLAYER BUFF"
	
	%ModificationImage.texture = mod.texture
	%ModCost.text = "Cost: $%.2f" % mod.cost
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
	var coins = player.return_coins(change * 100)
	player.add_modification(selected_button.modification)
	
	selected_button.disable()
	machine.mod_availability[selected_button.modification.name] = false
	
	%ModInfo.text = "Thank you for your purchase.\nYou received %d quarters, %d dimes, %d nickels, and %d pennies." % coins


func _on_exit_button_pressed():
	get_tree().paused = false
	Global.vending_menu_open = false
	queue_free()
