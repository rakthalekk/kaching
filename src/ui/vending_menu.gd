class_name VendingMenu
extends Control

var selected_button : ModButton
var player : Player

@export var modifications : Array[String]


const MODIFICATION_BUTTON = preload("res://src/ui/modification_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	selected_button = null
	for mod in modifications:
		add_mod(ModificationDatabase.get_modification_by_name(mod))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a button that holds information of the modification
func add_mod(mod):
	var modification_button = MODIFICATION_BUTTON.instantiate() as ModButton
	modification_button.menu = self
	modification_button.set_mod(mod)
	%ButtonContainer.add_child(modification_button)


func update_mod_info(button: ModButton):
	var mod = button.modification as Modification
	selected_button = button
	%ModName.text = mod.name
	
	if mod is CoinModification:
		%ModType.text = Modification.COIN_TYPE.keys()[mod.coin_type]
	else:
		%ModType.text = "no type???"
	
	%ModificationImage.texture = mod.texture
	%Cost.text = "Cost: $%d" % mod.cost
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
	player.return_coins(change * 100)
	player.add_modification(selected_button.modification)
	
	selected_button.disable()


func _on_exit_button_pressed():
	get_tree().paused = false
	queue_free()
