class_name ModButton
extends TextureButton

var modification : Modification
var menu : VendingMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	tooltip_text = modification.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pressed():
	menu.update_mod_info(self, modification)
	pass # Replace with function body.
