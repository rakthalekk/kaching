class_name ModButton
extends TextureButton

var modification : Modification
var menu : VendingMenu


func set_mod(mod: Modification):
	modification = mod
	$NameText.text = modification.name
	tooltip_text = modification.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	menu.update_mod_info(self)


func disable():
	disabled = true
	modulate = Color.RED
