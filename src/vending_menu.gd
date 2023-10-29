class_name VendingMenu
extends Control

var selected_button : ModButton

# Called when the node enters the scene tree for the first time.
func _ready():
	selected_button = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a button that holds information of the modification
func add_mod(mod):
	var modification_button = preload("res://src/modification_button.tscn").instantiate()
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
	# give player the selected modification here
	selected_button.disabled = true


func _on_exit_button_pressed():
	get_tree().paused = false
	queue_free()
